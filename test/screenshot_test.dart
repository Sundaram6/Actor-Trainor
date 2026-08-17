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
import 'package:the_instrument/screens/evening_load_screen.dart';
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
      'notificationEnabled': false,
      'notificationHour': 7,
      'notificationMinute': 0,
      'session_active': false,
    });
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

  testWidgets('Micro-Phase 27: Evening Load Scene Text View Mode', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Insert an active evening load
    await testDb.into(testDb.eveningLoads).insert(
      EveningLoadsCompanion(
        createdAt: drift.Value(DateTime.now()),
        title: const drift.Value('Hamlet — To Be Or Not To Be'),
        content: const drift.Value(
          'To be, or not to be, that is the question:\n'
          'Whether \'tis nobler in the mind to suffer\n'
          'The slings and arrows of outrageous fortune,\n'
          'Or to take arms against a sea of troubles\n'
          'And by opposing end them.\n\n'
          'To die—to sleep,\n'
          'No more; and by a sleep to say we end\n'
          'The heart-ache and the thousand natural shocks\n'
          'That flesh is heir to: \'tis a consummation\n'
          'Devoutly to be wish\'d.',
        ),
        isActive: const drift.Value(true),
      ),
    );

    final GlobalKey boundaryKey = GlobalKey();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(testDb),
        ],
        child: MaterialApp(
          title: appTitle,
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          home: RepaintBoundary(
            key: boundaryKey,
            child: const EveningLoadScreen(),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Verify ViewMode renders scene text and metadata
    expect(find.text('EVENING LOAD'), findsOneWidget);
    expect(find.text('Hamlet — To Be Or Not To Be'), findsOneWidget);
    expect(find.textContaining('Added today'), findsOneWidget);
    expect(find.textContaining('To be, or not to be'), findsOneWidget);
    expect(find.text('DONE'), findsOneWidget);

    // Capture screenshot of ViewMode
    await captureBoundary(tester, boundaryKey, 'evening_load_view_mode.png');

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 200));
  });
}
