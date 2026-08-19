import 'package:home_widget/home_widget.dart';

class WidgetService {
  static const String _androidWidgetName = 'HomeWidgetProvider';

  static Future<void> init() async {}

  static Future<void> update({
    required bool isCompleted,
    required int streak,
    bool? inProgress,
    bool showStartButton = false,
  }) async {
    try {
      final String status;
      if (inProgress == true) {
        status = 'IN PROGRESS';
      } else if (isCompleted) {
        status = 'COMPLETED';
      } else {
        status = 'NOT STARTED';
      }

      await HomeWidget.saveWidgetData<String>('status', status);
      await HomeWidget.saveWidgetData<int>('streak', streak);
      await HomeWidget.saveWidgetData<bool>('showStartButton', showStartButton);
      await HomeWidget.updateWidget(
        name: _androidWidgetName,
        androidName: _androidWidgetName,
      );
    } catch (_) {}
  }
}
