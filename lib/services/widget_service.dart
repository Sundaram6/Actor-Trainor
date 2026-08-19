import 'package:home_widget/home_widget.dart';

class WidgetService {
  static const String _appGroupId = 'group.com.theinstrument.the_instrument';
  static const String _androidWidgetName = 'HomeWidgetProvider';

  static Future<void> init() async {
    try {
      await HomeWidget.setAppGroupId(_appGroupId);
    } catch (_) {}
  }

  static Future<void> update({required String status, required int streak}) async {
    try {
      await HomeWidget.saveWidgetData<String>('status', status);
      await HomeWidget.saveWidgetData<int>('streak', streak);
      await HomeWidget.updateWidget(
        name: _androidWidgetName,
        androidName: _androidWidgetName,
      );
    } catch (_) {}
  }
}
