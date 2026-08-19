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

class AndroidJsonShareSheetModalPreview extends StatelessWidget {
  final String jsonText;

  const AndroidJsonShareSheetModalPreview({
    super.key,
    required this.jsonText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x99000000),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: Container(color: const Color(0xFF0D0D0D)),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 480,
              decoration: const BoxDecoration(
                color: Color(0xFF1E2026),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 30,
                    offset: Offset(0, -10),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Title row
                  Row(
                    children: const [
                      Icon(Icons.download_outlined, color: Color(0xFFD4AF37), size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Export Session History',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.close, color: Colors.white54, size: 20),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // JSON Preview code box
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF121318),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF2C2F3B)),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          jsonText,
                          style: const TextStyle(
                            color: Color(0xFFD4AF37),
                            fontFamily: 'monospace',
                            fontSize: 11,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // App targets row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ShareTarget(icon: Icons.message, label: 'Messages', color: Colors.blue),
                      _ShareTarget(icon: Icons.chat, label: 'WhatsApp', color: Colors.green),
                      _ShareTarget(icon: Icons.copy, label: 'Copy JSON', color: const Color(0xFFD4AF37)),
                      _ShareTarget(icon: Icons.mail, label: 'Coach Email', color: Colors.orange),
                      _ShareTarget(icon: Icons.more_horiz, label: 'More', color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareTarget extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ShareTarget({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: BuildContext != null ? MainAxisSize.min : MainAxisSize.max,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2D3A),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF383C4D)),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
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

  testWidgets('Micro-Phase 47: Export Session History tile and JSON share sheet preview', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Insert sample session records for export preview
    await testDb.insertSessionRecord(SessionRecordsCompanion.insert(
      completedAt: DateTime(2026, 8, 19, 9, 30),
      blocksCompleted: 9,
      totalMinutes: 98,
      intention: const drift.Value('Breath support and voice resonance'),
      notes: const drift.Value('Strong physical grounding throughout'),
      blocksJson: const drift.Value('["completed","completed","completed","completed","completed","completed","completed","completed","completed"]'),
    ));
    await testDb.insertSessionRecord(SessionRecordsCompanion.insert(
      completedAt: DateTime(2026, 8, 18, 10, 0),
      blocksCompleted: 9,
      totalMinutes: 98,
      intention: const drift.Value('Shakespeare monologue pacing'),
      notes: const drift.Value('Text work flowed with ease'),
      blocksJson: const drift.Value('["completed","completed","completed","completed","completed","completed","completed","completed","completed"]'),
    ));

    final GlobalKey settingsKey = GlobalKey();

    // 1. Settings screen with Export Session History tile
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(testDb),
          exportServiceProvider.overrideWithValue(ExportService(testDb)),
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

    expect(find.text('Export Session History'), findsOneWidget);

    await captureBoundary(tester, settingsKey, 'settings_export_history_row.png');

    // 2. Native Share Sheet Preview showing exported formatted JSON
    final GlobalKey shareSheetKey = GlobalKey();
    final jsonOutput = await ExportService.generateJson(testDb);

    await tester.pumpWidget(
      MaterialApp(
        title: appTitle,
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        builder: (context, child) => RepaintBoundary(
          key: shareSheetKey,
          child: child ?? const SizedBox(),
        ),
        home: AndroidJsonShareSheetModalPreview(jsonText: jsonOutput),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Export Session History'), findsOneWidget);

    await captureBoundary(tester, shareSheetKey, 'settings_export_share_sheet.png');
  });
}
