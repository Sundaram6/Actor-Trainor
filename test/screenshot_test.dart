import 'dart:io';
import 'dart:ui' as ui;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_instrument/app.dart';
import 'package:the_instrument/core/constants.dart';
import 'package:the_instrument/database/database.dart';
import 'package:the_instrument/providers/database_provider.dart';
import 'package:the_instrument/screens/progress_screen.dart';
import 'package:the_instrument/screens/session_completion_screen.dart';
import 'package:the_instrument/services/notification_service.dart';
import 'package:the_instrument/services/sound_service.dart';

Future<void> loadRealFonts() async {
  // Load Roboto font family
  final fontLoader = FontLoader('Roboto');
  final robotoFiles = [
    r'C:\Users\sundr\AppData\Local\flutter\bin\cache\artifacts\material_fonts\roboto-regular.ttf',
    r'C:\Users\sundr\AppData\Local\flutter\bin\cache\artifacts\material_fonts\roboto-bold.ttf',
    r'C:\Users\sundr\AppData\Local\flutter\bin\cache\artifacts\material_fonts\roboto-medium.ttf',
  ];
  for (final path in robotoFiles) {
    final file = File(path);
    if (file.existsSync()) {
      fontLoader.addFont(Future.value(ByteData.view(file.readAsBytesSync().buffer)));
    }
  }
  await fontLoader.load();

  // Load MaterialIcons font family
  final iconLoader = FontLoader('MaterialIcons');
  final iconFile = File(r'C:\Users\sundr\AppData\Local\flutter\bin\cache\artifacts\material_fonts\MaterialIcons-Regular.otf');
  final iconTtfFile = File(r'C:\Users\sundr\AppData\Local\flutter\engine\src\flutter\tools\font_subset\fixtures\MaterialIcons-Regular.ttf');
  if (iconFile.existsSync()) {
    iconLoader.addFont(Future.value(ByteData.view(iconFile.readAsBytesSync().buffer)));
    await iconLoader.load();
  } else if (iconTtfFile.existsSync()) {
    iconLoader.addFont(Future.value(ByteData.view(iconTtfFile.readAsBytesSync().buffer)));
    await iconLoader.load();
  }
}

void main() {
  late AppDatabase testDb;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
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

  testWidgets('Micro-Phase 21: Progress Tab Session History and Persistence Flow', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532); // iPhone 14/15 resolution
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final GlobalKey boundaryKey = GlobalKey();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(testDb),
        ],
        child: RepaintBoundary(
          key: boundaryKey,
          child: const TheInstrumentApp(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    final String artifactDir = r'C:\Users\sundr\.gemini\antigravity\brain\a9302ed1-deca-466c-a8e7-823182d27841';
    final Directory outDir = Directory(artifactDir);
    if (!outDir.existsSync()) {
      outDir.createSync(recursive: true);
    }

    Future<void> captureScreen(String fileName) async {
      await tester.runAsync(() async {
        final boundary = boundaryKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        final ui.Image image = await boundary.toImage(pixelRatio: 1.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        final file = File('$artifactDir/$fileName');
        await file.writeAsBytes(byteData!.buffer.asUint8List());
      });
    }

    // 1. Initial Dashboard (Not Started)
    expect(find.text('THE INSTRUMENT'), findsOneWidget);
    expect(find.text('Today'), findsNWidgets(2)); // Stat card + bottom nav label
    expect(find.text('Not started'), findsOneWidget);
    expect(find.text('MORNING ROUTINE: NOT STARTED'), findsOneWidget);
    expect(find.text('Streak'), findsOneWidget);
    expect(find.text('This Week'), findsOneWidget);

    // 2. Start Routine & Complete it
    await tester.tap(find.text('START ROUTINE'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Jump / Skip through to the last block
    for (int i = 0; i < kRoutineBlocks.length - 1; i++) {
      await tester.tap(find.byIcon(Icons.skip_next));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
    }

    // On Block 9, tap Check to complete
    expect(find.byIcon(Icons.check), findsOneWidget);
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify SessionCompletionScreen
    expect(find.byType(SessionCompletionScreen), findsOneWidget);
    expect(find.text('SESSION COMPLETE'), findsOneWidget);

    // Tap RETURN TO DASHBOARD
    await tester.tap(find.text('RETURN TO DASHBOARD'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // Verify Dashboard shows updated stats from Drift:
    // Today = Completed, Streak = 1, This Week = 1
    expect(find.text('Today'), findsNWidgets(2));
    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('MORNING ROUTINE: COMPLETED'), findsOneWidget);
    expect(find.text('Streak'), findsOneWidget);
    expect(find.text('1'), findsNWidgets(3)); // Streak "1", Week 1 badge "1", This Week "1"
    expect(find.text('This Week'), findsOneWidget);

    // Capture screenshot of Dashboard with updated stats
    await captureScreen('dashboard_stats_top.png');

    // 3. Navigate to Progress tab in BottomNavigationBar
    await tester.tap(find.byIcon(Icons.trending_up));
    await tester.pumpAndSettle();

    // Verify ProgressScreen renders session history list
    expect(find.byType(ProgressScreen), findsOneWidget);
    expect(find.text('PROGRESS'), findsOneWidget);
    expect(find.textContaining('9 blocks · 100 min'), findsOneWidget);

    // Capture screenshot of Progress screen
    await captureScreen('progress_screen.png');

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}
