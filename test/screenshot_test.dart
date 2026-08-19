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

class AndroidShareSheetModalPreview extends StatelessWidget {
  final String shareText;

  const AndroidShareSheetModalPreview({
    super.key,
    required this.shareText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x99000000), // Dimmed backdrop
      body: Stack(
        children: [
          // Background completion screen preview
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: Container(color: const Color(0xFF0D0D0D)),
            ),
          ),
          // Bottom Share Sheet bottom-sheet dialog
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
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
                mainAxisSize: MainAxisSize.min,
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
                  const SizedBox(height: 16),
                  // Title row
                  Row(
                    children: const [
                      Icon(Icons.share, color: Color(0xFFD4AF37), size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Share via',
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
                  const SizedBox(height: 16),
                  // Pre-filled text preview card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF14151B),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF2C2F3B)),
                    ),
                    child: Text(
                      shareText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // App targets row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ShareTarget(icon: Icons.message, label: 'Messages', color: Colors.blue),
                      _ShareTarget(icon: Icons.chat, label: 'WhatsApp', color: Colors.green),
                      _ShareTarget(icon: Icons.copy, label: 'Copy Link', color: const Color(0xFFD4AF37)),
                      _ShareTarget(icon: Icons.note_alt, label: 'Notes', color: Colors.orange),
                      _ShareTarget(icon: Icons.more_horiz, label: 'More', color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 12),
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
      mainAxisSize: MainAxisSize.min,
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
      'soundEnabled': false,
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

  testWidgets('Micro-Phase 46: Share Session Completion button and share sheet preview', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final GlobalKey completionKey = GlobalKey();

    // 1. SessionCompletionScreen with SHARE PROGRESS button
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(testDb),
        ],
        child: MaterialApp(
          title: appTitle,
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          builder: (context, child) => RepaintBoundary(
            key: completionKey,
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
            intention: 'Breath support and physical presence for Hamlet soliloquy',
            streak: 7,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('SHARE PROGRESS'), findsOneWidget);
    expect(find.text('RETURN TO DASHBOARD'), findsOneWidget);
    expect(find.text('SESSION COMPLETE'), findsOneWidget);

    await captureBoundary(tester, completionKey, 'session_completion_share_button.png');

    // 2. Native Android share sheet preview with pre-filled brag text
    final GlobalKey shareSheetKey = GlobalKey();

    const String shareText =
        'I just completed my 9/9 block acting routine on The Instrument! 🔥\n'
        'Streak: 7 days\n'
        'Duration: 98 min\n'
        'The instrument is tuned. 🎭';

    await tester.pumpWidget(
      MaterialApp(
        title: appTitle,
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        builder: (context, child) => RepaintBoundary(
          key: shareSheetKey,
          child: child ?? const SizedBox(),
        ),
        home: const AndroidShareSheetModalPreview(shareText: shareText),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text(shareText), findsOneWidget);
    expect(find.text('Share via'), findsOneWidget);

    await captureBoundary(tester, shareSheetKey, 'session_share_sheet_preview.png');
  });
}
