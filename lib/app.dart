import 'package:flutter/material.dart';
import 'core/constants.dart';
import 'core/theme.dart';
import 'screens/onboarding_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/routine_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/today_screen.dart';

class TheInstrumentApp extends StatelessWidget {
  final bool showOnboarding;
  const TheInstrumentApp({super.key, this.showOnboarding = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: showOnboarding ? const OnboardingScreen() : const MainShellScreen(),
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
