import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'services/notification_service.dart';
import 'services/widget_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await WidgetService.init();
  final prefs = await SharedPreferences.getInstance();
  final hasCompleted = prefs.getBool('has_completed_onboarding') ?? false;

  runApp(
    ProviderScope(
      child: TheInstrumentApp(showOnboarding: !hasCompleted),
    ),
  );
}
