import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:clock/clock.dart';
import 'package:drift/drift.dart' as drift;
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
import 'package:the_instrument/screens/progress_screen.dart';
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

  setUp(() async {
    testDb = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await testDb.close();
  });

  testWidgets('Micro-Phase 34: Block-Level Progress Tracking Bars', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final now = DateTime(2026, 8, 19, 9, 30);
    final sampleOutcomes1 = [
      'completed',
      'skipped',
      'completed',
      'completed',
      'completed',
      'completed',
      'completed',
      'skipped',
      'completed',
    ];

    final sampleOutcomes2 = [
      'completed',
      'skipped',
      'completed',
      'pending',
      'pending',
      'pending',
      'pending',
      'pending',
      'pending',
    ];

    // Seed session records with blocksJson
    await testDb.insertSessionRecord(SessionRecordsCompanion(
      completedAt: drift.Value(now.subtract(const Duration(days: 1))),
      blocksCompleted: const drift.Value(2),
      totalMinutes: const drift.Value(25),
      blocksJson: drift.Value(jsonEncode(sampleOutcomes2)),
    ));

    await testDb.insertSessionRecord(SessionRecordsCompanion(
      completedAt: drift.Value(now),
      blocksCompleted: const drift.Value(7),
      totalMinutes: const drift.Value(85),
      blocksJson: drift.Value(jsonEncode(sampleOutcomes1)),
    ));

    final GlobalKey boundaryKey = GlobalKey();

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
          home: const ProgressScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Progress screen renders cards with 9-block bars
    expect(find.text('PROGRESS'), findsOneWidget);
    expect(find.text('9 blocks • 7 completed • 2 skipped'), findsOneWidget);
    expect(find.text('9 blocks • 2 completed • 1 skipped'), findsOneWidget);

    // Capture screenshot of Progress screen showing block-level completion bars
    await captureBoundary(tester, boundaryKey, 'progress_block_level_bars.png');

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 200));
  });
}
