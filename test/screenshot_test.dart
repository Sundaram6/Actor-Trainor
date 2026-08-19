import 'dart:io';
import 'dart:ui' as ui;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_instrument/core/constants.dart';
import 'package:the_instrument/core/theme.dart';
import 'package:the_instrument/database/database.dart';
import 'package:the_instrument/providers/database_provider.dart';
import 'package:the_instrument/screens/session_screen.dart';
import 'package:the_instrument/services/notification_service.dart';
import 'package:the_instrument/services/sound_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> loadRealFonts() async {
  final fontLoader = FontLoader('Roboto');
  final robotoFiles = [
    r'C:\Users\sundr\AppData\Local\flutter\bin\cache\artifacts\material_fonts\roboto-regular.ttf',
    r'C:\Users\sundr\AppData\Local\flutter\bin\cache\artifacts\material_fonts\roboto-bold.ttf',
    r'C:\Users\sundr\AppData\Local\flutter\bin\cache\artifacts\material_fonts\roboto-medium.ttf',
  ];

  for (final path in robotoFiles) {
    final file = File(path);
    if (file.existsSync()) {
      final bytes = file.readAsBytesSync();
      fontLoader.addFont(Future.value(ByteData.view(bytes.buffer)));
    }
  }
  await fontLoader.load();
}

Future<void> captureBoundary(WidgetTester tester, GlobalKey key, String fileName) async {
  const String artifactDir = r'C:\Users\sundr\.gemini\antigravity\brain\a9302ed1-deca-466c-a8e7-823182d27841';
  await tester.runAsync(() async {
    final context = key.currentContext;
    if (context == null) return;
    final boundary = context.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return;
    final ui.Image image = await boundary.toImage(pixelRatio: 1.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('$artifactDir/$fileName');
    await file.writeAsBytes(byteData!.buffer.asUint8List());
  });
}

void main() {
  late AppDatabase testDb;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({
      'soundEnabled': false,
      'haptics_enabled': true,
      'notificationEnabled': false,
      'notificationHour': 7,
      'notificationMinute': 0,
      'session_active': false,
    });
    await loadRealFonts();
    SoundService.enabled = false;
    NotificationService.enabled = false;
  });

  setUp(() {
    testDb = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await testDb.close();
  });

  testWidgets('Micro-Phase 32: Block Skip Confirmation Dialog', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final GlobalKey boundaryKey = GlobalKey();

    // Start on Block 2 (index 1: Physical Warm-up)
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(testDb),
          soundServiceProvider.overrideWithValue(NoopSoundService()),
        ],
        child: MaterialApp(
          title: appTitle,
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          builder: (context, child) => RepaintBoundary(
            key: boundaryKey,
            child: child ?? const SizedBox(),
          ),
          home: const SessionScreen(startBlockIndex: 1),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify session starts on Block 2: Physical Warm-up
    expect(find.text('BLOCK 2 OF ${kRoutineBlocks.length}'), findsOneWidget);
    expect(find.text('Physical Warm-up'), findsOneWidget);

    // Tap Skip Block button (fast_forward icon)
    final skipBlockBtn = find.byIcon(Icons.fast_forward);
    expect(skipBlockBtn, findsOneWidget);
    await tester.tap(skipBlockBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Skip Block confirmation dialog appears
    expect(find.text('Skip Block?'), findsOneWidget);
    expect(find.textContaining('You are about to skip Physical Warm-up'), findsOneWidget);
    expect(find.text('CANCEL'), findsOneWidget);
    expect(find.text('SKIP'), findsOneWidget);

    // Capture screenshot of the skip confirmation dialog
    await captureBoundary(tester, boundaryKey, 'session_skip_block_dialog.png');

    // Test Cancel button dismisses dialog without advancing
    await tester.tap(find.text('CANCEL'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Skip Block?'), findsNothing);
    expect(find.text('BLOCK 2 OF ${kRoutineBlocks.length}'), findsOneWidget);

    // Tap Skip Block button again and confirm with SKIP
    await tester.tap(skipBlockBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('SKIP'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify next block (Block 3: Memory Foundation) loads
    expect(find.text('BLOCK 3 OF ${kRoutineBlocks.length}'), findsOneWidget);
    expect(find.text('Memory Foundation'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 200));
  });
}
