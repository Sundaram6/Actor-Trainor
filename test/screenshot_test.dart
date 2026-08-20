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
import 'package:the_instrument/providers/progress_providers.dart';
import 'package:the_instrument/screens/onboarding_screen.dart';
import 'package:the_instrument/screens/progress_screen.dart';
import 'package:the_instrument/screens/session_completion_screen.dart';
import 'package:the_instrument/screens/session_screen.dart';
import 'package:the_instrument/services/notification_service.dart';
import 'package:the_instrument/services/sound_service.dart';
import 'package:the_instrument/widgets/skip_reason_bottom_sheet.dart';
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

  testWidgets('OnboardingScreen page 1 renders', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final GlobalKey rootKey = GlobalKey();

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
            key: rootKey,
            child: child ?? const SizedBox(),
          ),
          home: const OnboardingScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('The Method'), findsOneWidget);
    expect(find.text('NEXT'), findsOneWidget);
    expect(find.byIcon(Icons.theater_comedy_outlined), findsOneWidget);

    await captureBoundary(tester, rootKey, 'onboarding_screen_1.png');
  });

  testWidgets('StreakCalendar renders with active days', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final GlobalKey rootKey = GlobalKey();
    final now = DateTime.now();
    final activeDays = {
      DateTime(now.year, now.month, now.day).subtract(const Duration(days: 2)),
      DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1)),
      DateTime(now.year, now.month, now.day),
    };

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
            key: rootKey,
            child: child ?? const SizedBox(),
          ),
          home: Scaffold(
            backgroundColor: const Color(0xFF0A0A0A),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: StreakCalendar(activeDays: activeDays),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(StreakCalendar), findsOneWidget);
    expect(find.text('LAST 30 DAYS'), findsOneWidget);

    await captureBoundary(tester, rootKey, 'streak_calendar.png');
  });

  testWidgets('SessionScreen shows intention in AppBar', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final GlobalKey rootKey = GlobalKey();

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
            key: rootKey,
            child: child ?? const SizedBox(),
          ),
          home: const SessionScreen(initialIntention: 'To stay present under pressure'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('To stay present under pressure'), findsWidgets);
    expect(find.byIcon(Icons.brightness_5_outlined), findsOneWidget);

    await captureBoundary(tester, rootKey, 'session_intention_display.png');
  });

  testWidgets('WeeklyReportCard renders with data', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final GlobalKey rootKey = GlobalKey();

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
            key: rootKey,
            child: child ?? const SizedBox(),
          ),
          home: const Scaffold(
            backgroundColor: Color(0xFF0A0A0A),
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: WeeklyReportCard(
                  report: WeeklyReport(
                    sessionsCompleted: 5,
                    totalMinutes: 312,
                    completionRate: 0.78,
                    mostSkippedBlock: 'Character Embodiment',
                    mostSkippedCount: 3,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(WeeklyReportCard), findsOneWidget);
    expect(find.text('THIS WEEK'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('312'), findsOneWidget);
    expect(find.text('78%'), findsOneWidget);
    expect(find.text('Character Embodiment'), findsOneWidget);

    await captureBoundary(tester, rootKey, 'weekly_report_card.png');
  });

  testWidgets('SkipReasonBottomSheet renders correctly', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final GlobalKey rootKey = GlobalKey();

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
            key: rootKey,
            child: child ?? const SizedBox(),
          ),
          home: Builder(
            builder: (context) => Scaffold(
              backgroundColor: const Color(0xFF0A0A0A),
              body: Center(
                child: ElevatedButton(
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const SkipReasonBottomSheet(blockName: 'Emotional Preparation'),
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byType(SkipReasonBottomSheet), findsOneWidget);
    expect(find.text('Skip Emotional Preparation'), findsOneWidget);
    expect(find.text('CONFIRM SKIP'), findsOneWidget);
    expect(find.text('CANCEL'), findsOneWidget);

    await captureBoundary(tester, rootKey, 'skip_reason_bottom_sheet.png');
  });

  testWidgets('SessionCompletionScreen note field renders', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final GlobalKey rootKey = GlobalKey();

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
            key: rootKey,
            child: child ?? const SizedBox(),
          ),
          home: const SessionCompletionScreen(
            totalMinutes: 112,
            blocksCompleted: 9,
            intention: 'To stay grounded and responsive',
            sessionRecordId: 1,
            streak: 7,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('SAVE NOTE'), findsOneWidget);
    expect(find.text('SKIP'), findsOneWidget);
    expect(find.text('SESSION COMPLETE'), findsOneWidget);

    await captureBoundary(tester, rootKey, 'session_completion_note.png');
  });
}
