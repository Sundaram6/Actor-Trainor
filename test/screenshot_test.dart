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
import 'package:the_instrument/screens/session_completion_screen.dart';
import 'package:the_instrument/services/notification_service.dart';
import 'package:the_instrument/services/sound_service.dart';
import 'package:the_instrument/services/tts_service.dart';
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
      'voice_instructions_enabled': true,
      'notificationEnabled': false,
      'notificationHour': 7,
      'notificationMinute': 0,
      'session_active': false,
    });
    await loadRealFonts();
    SoundService.enabled = false;
    NotificationService.enabled = false;
  });

  setUp(() async {
    testDb = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await testDb.close();
  });

  testWidgets('Micro-Phase 37: Post-Session Journal on Completion Screen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final GlobalKey boundaryKey = GlobalKey();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(testDb),
          soundServiceProvider.overrideWithValue(NoopSoundService()),
          ttsServiceProvider.overrideWithValue(NoopTtsService()),
        ],
        child: MaterialApp(
          title: appTitle,
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          builder: (context, child) => RepaintBoundary(
            key: boundaryKey,
            child: child ?? const SizedBox(),
          ),
          home: const SessionCompletionScreen(
            totalMinutes: 98,
            blocksCompleted: 9,
            blockOutcomes: [
              'completed',
              'completed',
              'completed',
              'completed',
              'completed',
              'completed',
              'completed',
              'completed',
              'completed',
            ],
            intention: 'Breath support for Shakespeare monologue',
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Completion Screen elements
    expect(find.text('SESSION COMPLETE'), findsOneWidget);
    expect(find.text('"Breath support for Shakespeare monologue"'), findsOneWidget);
    expect(find.text('9 / ${kRoutineBlocks.length}'), findsOneWidget);
    expect(find.text('98 min'), findsOneWidget);
    expect(find.text('RETURN TO DASHBOARD'), findsOneWidget);

    // Enter journal notes
    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);
    await tester.enterText(
      textField,
      'Felt the rib expansion click today. Voice was open by Block 5.',
    );
    await tester.pump();

    // Capture screenshot of completion screen with journal text entered
    await captureBoundary(tester, boundaryKey, 'session_completion_journal.png');
  });
}
