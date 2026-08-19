import 'dart:async';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'core/constants.dart';
import 'core/theme.dart';
import 'screens/onboarding_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/routine_screen.dart';
import 'screens/session_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/today_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class TheInstrumentApp extends StatefulWidget {
  final bool showOnboarding;
  const TheInstrumentApp({super.key, this.showOnboarding = false});

  @override
  State<TheInstrumentApp> createState() => _TheInstrumentAppState();
}

class _TheInstrumentAppState extends State<TheInstrumentApp> {
  StreamSubscription? _widgetClickedSubscription;

  @override
  void initState() {
    super.initState();
    _checkWidgetLaunch();
  }

  void _checkWidgetLaunch() async {
    try {
      final uri = await HomeWidget.initiallyLaunchedFromHomeWidget();
      if (_isStartSessionUri(uri)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _navigateToSession();
        });
      }
      _widgetClickedSubscription = HomeWidget.widgetClicked.listen((uri) {
        if (_isStartSessionUri(uri)) {
          _navigateToSession();
        }
      });
    } catch (_) {}
  }

  bool _isStartSessionUri(Uri? uri) {
    if (uri == null) return false;
    return uri.host == 'startsession' || uri.path.contains('startsession') || uri.toString().contains('startsession');
  }

  void _navigateToSession() {
    rootNavigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => const SessionScreen()),
    );
  }

  @override
  void dispose() {
    _widgetClickedSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: rootNavigatorKey,
      title: appTitle,
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: widget.showOnboarding ? const OnboardingScreen() : const MainShellScreen(),
    );
  }
}

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = const [
      TodayScreen(),
      RoutineScreen(),
      ProgressScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: cardSurface,
        selectedItemColor: goldAccent,
        unselectedItemColor: secondaryText,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: tabToday,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: tabRoutine,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: tabProgress,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: tabSettings,
          ),
        ],
      ),
    );
  }
}
