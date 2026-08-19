package com.theinstrument.the_instrument

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class HomeWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_layout)
            views.setTextViewText(R.id.widget_status, widgetData.getString("status", "Not Started"))
            val streak = widgetData.getInt("streak", 0)
            views.setTextViewText(R.id.widget_streak, "Streak: $streak")
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
