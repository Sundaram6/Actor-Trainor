import 'dart:io';
import 'dart:ui' as ui;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_instrument/core/constants.dart';
import 'package:the_instrument/database/database.dart';
import 'package:the_instrument/providers/database_provider.dart';
import 'package:the_instrument/screens/session_screen.dart';
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

  testWidgets('Micro-Phase 18a: Continuity of Thought 3-Step Sequence screenshot', (WidgetTester tester) async {
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
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: RepaintBoundary(
            key: boundaryKey,
            child: const SessionScreen(startBlockIndex: 5), // Block 6 (0-indexed)
          ),
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

    // Verify Block 6 Step 1: Stream of Consciousness
    expect(find.text('SESSION'), findsOneWidget);
    expect(find.text('BLOCK 6 OF ${kRoutineBlocks.length}'), findsOneWidget);
    expect(find.text('Stream of Consciousness'), findsOneWidget);
    expect(find.text('STEP 1 OF 3'), findsOneWidget);
    expect(
      find.text('Speak every thought that crosses your mind. No censorship. No shaping for an audience. If you go blank, say "I am blank" until the next thought arrives. Do not judge the content. The goal is flow, not poetry.'),
      findsOneWidget,
    );
    expect(find.text('03:00'), findsOneWidget);
    expect(find.text('UP NEXT'), findsOneWidget);
    expect(find.text('Character Embodiment'), findsOneWidget);

    // Capture screenshot on Block 6, Step 1
    await captureScreen('session_continuity_step1.png');
  });
}
