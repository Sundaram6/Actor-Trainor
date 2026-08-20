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
import 'package:the_instrument/screens/settings_screen.dart';
import 'package:the_instrument/services/export_service.dart';
import 'package:the_instrument/services/import_service.dart';
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
      'soundEnabled': true,
      'haptics_enabled': true,
      'voice_instructions_enabled': true,
      'notificationEnabled': false,
      'notificationHour': 7,
      'notificationMinute': 0,
      'has_completed_onboarding': true,
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

  test('ImportService: imports sessions and skips duplicates', () async {
    final importService = ImportService(testDb);

    const jsonBackup = '''
{
  "app": "The Instrument",
  "exportedAt": "2026-08-20T14:00:00.000Z",
  "sessionCount": 2,
  "sessions": [
    {
      "date": "2026-08-19T09:30:00.000Z",
      "blocksCompleted": 9,
      "durationMinutes": 98,
      "intention": "Breath support and voice resonance",
      "notes": "Strong physical grounding throughout"
    },
    {
      "date": "2026-08-18T10:00:00.000Z",
      "blocksCompleted": 9,
      "durationMinutes": 98,
      "intention": "Shakespeare monologue pacing",
      "notes": "Text work flowed with ease"
    }
  ]
}
''';

    // First import: 2 imported, 0 skipped
    final res1 = await importService.importFromJsonString(jsonBackup);
    expect(res1.imported, 2);
    expect(res1.skipped, 0);
    expect(res1.isSuccess, true);
    expect(res1.message, 'Imported 2 sessions');

    final records = await testDb.allSessionRecords;
    expect(records.length, 2);

    // Second import with same backup: 0 imported, 2 skipped duplicates
    final res2 = await importService.importFromJsonString(jsonBackup);
    expect(res2.imported, 0);
    expect(res2.skipped, 2);
    expect(res2.message, 'Imported 0, skipped 2 duplicates');

    // Total records still 2
    final recordsAfter = await testDb.allSessionRecords;
    expect(recordsAfter.length, 2);
  });

  testWidgets('Micro-Phase 49: SettingsScreen Import Sessions row and success SnackBar', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final GlobalKey settingsKey = GlobalKey();

    // 1. Settings screen with Import Sessions tile
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(testDb),
          exportServiceProvider.overrideWithValue(ExportService(testDb)),
          importServiceProvider.overrideWithValue(ImportService(testDb)),
        ],
        child: MaterialApp(
          title: appTitle,
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          builder: (context, child) => RepaintBoundary(
            key: settingsKey,
            child: child ?? const SizedBox(),
          ),
          home: const SettingsScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Scroll to Data section
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();

    expect(find.text('Import Sessions'), findsOneWidget);
    expect(find.text('Restore from JSON backup'), findsOneWidget);

    await captureBoundary(tester, settingsKey, 'settings_import_sessions_row.png');

    // 2. Trigger SnackBar showing import confirmation
    final GlobalKey snackBarKey = GlobalKey();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(testDb),
          exportServiceProvider.overrideWithValue(ExportService(testDb)),
          importServiceProvider.overrideWithValue(ImportService(testDb)),
        ],
        child: MaterialApp(
          title: appTitle,
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          builder: (context, child) => RepaintBoundary(
            key: snackBarKey,
            child: child ?? const SizedBox(),
          ),
          home: Scaffold(
            backgroundColor: const Color(0xFF0D0D0D),
            body: Stack(
              children: const [
                SettingsScreen(),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    // Scroll down in Settings
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();

    // Show SnackBar
    final context = tester.element(find.byType(SettingsScreen));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Imported 2 sessions',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color(0xFF1B5E20),
        duration: Duration(seconds: 3),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Imported 2 sessions'), findsOneWidget);

    await captureBoundary(tester, snackBarKey, 'settings_import_success_snackbar.png');
  });
}
