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

class AndroidHomeScreenWidgetPreview extends StatelessWidget {
  final String status;
  final int streak;

  const AndroidHomeScreenWidgetPreview({
    super.key,
    required this.status,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F111A), // Home screen wallpaper
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top launcher header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '9:41',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: const [
                      Icon(Icons.wifi, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Icon(Icons.battery_full, color: Colors.white, size: 16),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 36),
              const Text(
                'Home',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              // 2x2 Widget Card matching updated widget_layout.xml
              Center(
                child: Container(
                  width: 220,
                  height: 130,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: status == 'COMPLETED'
                                  ? const Color(0xFFD4AF37)
                                  : (status == 'IN PROGRESS'
                                      ? const Color(0xFFE5A93C)
                                      : const Color(0xFF888888)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            status,
                            style: const TextStyle(
                              color: Color(0xFFD4AF37),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Streak: $streak',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'The Instrument',
                        style: TextStyle(
                          color: Colors.white30,
                          fontSize: 11,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              // Launcher bottom dock apps
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _LauncherAppIcon(icon: Icons.phone, label: 'Phone', color: Colors.green),
                  _LauncherAppIcon(icon: Icons.message, label: 'Messages', color: Colors.blue),
                  _LauncherAppIcon(icon: Icons.timer, label: 'Instrument', color: const Color(0xFFD4AF37)),
                  _LauncherAppIcon(icon: Icons.camera_alt, label: 'Camera', color: Colors.purple),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _LauncherAppIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _LauncherAppIcon({
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
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFF1E212B),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF2E3342)),
          ),
          child: Icon(icon, color: color, size: 26),
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

  testWidgets('Micro-Phase 43: Android Home Screen Widget IN PROGRESS & COMPLETED', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final GlobalKey inProgressKey = GlobalKey();

    // 1. IN PROGRESS widget preview
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
            key: inProgressKey,
            child: child ?? const SizedBox(),
          ),
          home: const AndroidHomeScreenWidgetPreview(
            status: 'IN PROGRESS',
            streak: 7,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('IN PROGRESS'), findsOneWidget);
    expect(find.text('Streak: 7'), findsOneWidget);

    await captureBoundary(tester, inProgressKey, 'home_screen_widget_in_progress.png');

    // 2. COMPLETED widget preview
    final GlobalKey completedKey = GlobalKey();

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
            key: completedKey,
            child: child ?? const SizedBox(),
          ),
          home: const AndroidHomeScreenWidgetPreview(
            status: 'COMPLETED',
            streak: 8,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('COMPLETED'), findsOneWidget);
    expect(find.text('Streak: 8'), findsOneWidget);

    await captureBoundary(tester, completedKey, 'home_screen_widget_completed.png');
  });
}
