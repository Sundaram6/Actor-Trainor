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

class TheInstrumentAdaptiveIcon extends StatelessWidget {
  final double size;
  final double borderRadius;

  const TheInstrumentAdaptiveIcon({
    super.key,
    this.size = 56.0,
    this.borderRadius = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: const Color(0xFF222222), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: size * 0.16,
          height: size * 0.52,
          decoration: BoxDecoration(
            color: const Color(0xFFD4AF37),
            borderRadius: BorderRadius.circular(size * 0.03),
          ),
        ),
      ),
    );
  }
}

class HomeScreenAppDrawerPreview extends StatelessWidget {
  const HomeScreenAppDrawerPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F18),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top status bar
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
              const SizedBox(height: 28),
              // Search apps bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E212D),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF2E3344)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.white54, size: 20),
                    SizedBox(width: 12),
                    Text(
                      'Search apps...',
                      style: TextStyle(color: Colors.white38, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              // App Grid 4x3 with childAspectRatio
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  childAspectRatio: 0.72,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 16,
                  children: [
                    _AppGridItem(
                      customIcon: const TheInstrumentAdaptiveIcon(size: 56),
                      label: 'Instrument',
                      isHighlighted: true,
                    ),
                    _AppGridItem(icon: Icons.camera_alt, label: 'Camera', color: Colors.purple),
                    _AppGridItem(icon: Icons.photo, label: 'Photos', color: Colors.redAccent),
                    _AppGridItem(icon: Icons.calendar_month, label: 'Calendar', color: Colors.blue),
                    _AppGridItem(icon: Icons.map, label: 'Maps', color: Colors.green),
                    _AppGridItem(icon: Icons.settings, label: 'Settings', color: Colors.grey),
                    _AppGridItem(icon: Icons.chat, label: 'Messages', color: Colors.lightBlue),
                    _AppGridItem(icon: Icons.mail, label: 'Email', color: Colors.amber),
                  ],
                ),
              ),
              // Bottom dock
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppGridItem extends StatelessWidget {
  final IconData? icon;
  final Widget? customIcon;
  final String label;
  final Color? color;
  final bool isHighlighted;

  const _AppGridItem({
    this.icon,
    this.customIcon,
    required this.label,
    this.color,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        customIcon ??
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF1E212D),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF2E3344)),
              ),
              child: Icon(icon, color: color ?? Colors.white, size: 28),
            ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isHighlighted ? const Color(0xFFD4AF37) : Colors.white70,
            fontSize: 11,
            fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class AppSwitcherPreview extends StatelessWidget {
  const AppSwitcherPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF08090E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            children: [
              // Top bar
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
              const SizedBox(height: 32),
              // App Switcher Card with Title Bar containing Adaptive Icon
              Expanded(
                child: Center(
                  child: Container(
                    width: 310,
                    height: 540,
                    decoration: BoxDecoration(
                      color: const Color(0xFF141419),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xFF2A2A35), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.7),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        // Task card title bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          color: const Color(0xFF1B1B22),
                          child: Row(
                            children: [
                              const TheInstrumentAdaptiveIcon(
                                size: 24,
                                borderRadius: 6,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'The Instrument',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.more_vert, color: Colors.white54, size: 18),
                            ],
                          ),
                        ),
                        // Task Card Mini Screen Content
                        Expanded(
                          child: Container(
                            color: const Color(0xFF0A0A0F),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'THE INSTRUMENT',
                                  style: TextStyle(
                                    color: Color(0xFFD4AF37),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    _MiniStat(label: 'Today', val: 'Not started'),
                                    const SizedBox(width: 6),
                                    _MiniStat(label: 'Streak', val: '7'),
                                    const SizedBox(width: 6),
                                    _MiniStat(label: 'This Week', val: '5'),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF141419),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: const Color(0xFF2A2A2A)),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD4AF37).withValues(alpha: 0.15),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Center(
                                          child: Text(
                                            '1',
                                            style: TextStyle(
                                              color: Color(0xFFD4AF37),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'Week 1 • Day 1',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '98 MINUTE ROUTINE',
                                            style: TextStyle(
                                              color: Colors.white38,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD4AF37),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'START ROUTINE',
                                      style: TextStyle(
                                        color: Color(0xFF0A0A0F),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Clear all button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E212D),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Text(
                  'Clear all',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String val;

  const _MiniStat({required this.label, required this.val});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 9)),
            const SizedBox(height: 2),
            Text(val, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
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

  testWidgets('Micro-Phase 45: Adaptive Launcher Icon & App Switcher', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final GlobalKey drawerKey = GlobalKey();

    // 1. Home screen / app drawer with adaptive launcher icon
    await tester.pumpWidget(
      MaterialApp(
        title: appTitle,
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        builder: (context, child) => RepaintBoundary(
          key: drawerKey,
          child: child ?? const SizedBox(),
        ),
        home: const HomeScreenAppDrawerPreview(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Instrument'), findsOneWidget);

    await captureBoundary(tester, drawerKey, 'launcher_icon_home_screen.png');

    // 2. App switcher / Recent apps view with adaptive icon in title bar
    final GlobalKey switcherKey = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        title: appTitle,
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        builder: (context, child) => RepaintBoundary(
          key: switcherKey,
          child: child ?? const SizedBox(),
        ),
        home: const AppSwitcherPreview(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('The Instrument'), findsOneWidget);

    await captureBoundary(tester, switcherKey, 'launcher_icon_app_switcher.png');
  });
}
