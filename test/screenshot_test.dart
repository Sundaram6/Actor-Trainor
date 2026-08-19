import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
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
import 'package:the_instrument/screens/settings_screen.dart';
import 'package:the_instrument/services/export_service.dart';
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

class MockExportService extends ExportService {
  MockExportService(super.db);

  @override
  Future<String?> exportAllData({Directory? targetDirectory}) async {
    return 'Downloads/the_instrument_backup_20260819_223000.json';
  }
}

void main() {
  late AppDatabase testDb;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({
      'soundEnabled': true,
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

  testWidgets('Micro-Phase 38: Export All Data to JSON', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Seed sample records
    await testDb.insertSessionRecord(SessionRecordsCompanion(
      completedAt: drift.Value(DateTime(2026, 8, 19, 9, 30)),
      blocksCompleted: const drift.Value(9),
      totalMinutes: const drift.Value(112),
      intention: const drift.Value('Breath support'),
      notes: const drift.Value('Rib expansion clicked today.'),
      blocksJson: const drift.Value('["completed","completed"]'),
    ));

    await testDb.insertEveningLoad(EveningLoadsCompanion(
      createdAt: drift.Value(DateTime(2026, 8, 18, 20, 0)),
      title: const drift.Value('Hamlet Scene 2'),
      content: const drift.Value('To be or not to be'),
      isActive: const drift.Value(true),
    ));

    final GlobalKey boundaryKey = GlobalKey();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(testDb),
          soundServiceProvider.overrideWithValue(NoopSoundService()),
          ttsServiceProvider.overrideWithValue(NoopTtsService()),
          exportServiceProvider.overrideWithValue(MockExportService(testDb)),
        ],
        child: MaterialApp(
          title: appTitle,
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          builder: (context, child) => RepaintBoundary(
            key: boundaryKey,
            child: child ?? const SizedBox(),
          ),
          home: const SettingsScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Export All Data tile exists
    expect(find.text('Export All Data'), findsOneWidget);
    expect(find.text('Save sessions & loads as JSON to Downloads'), findsOneWidget);

    // Tap Export All Data
    await tester.tap(find.text('Export All Data'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify success SnackBar is displayed
    expect(find.text('Saved to Downloads/the_instrument_backup_20260819_223000.json'), findsOneWidget);

    // Capture screenshot of Settings screen with Export All Data card and gold SnackBar
    await captureBoundary(tester, boundaryKey, 'settings_export_data_snackbar.png');
  });
}
