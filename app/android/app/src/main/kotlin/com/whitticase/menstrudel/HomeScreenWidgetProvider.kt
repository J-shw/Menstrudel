package com.whitticase.menstrudel 

import android.appwidget.AppWidgetManager
import android.app.PendingIntent
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import es.antonborri.home_widget.HomeWidgetLaunchIntent

class HomeScreenWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout)

            val currentValue = widgetData.getInt("widget_current_value", 10)
            val maxValue = widgetData.getInt("widget_max_value", 28)
            val largeText = widgetData.getString("widget_large_text", "$currentValue")
            val smallText = widgetData.getString("widget_small_text", "days")

            views.setTextViewText(R.id.widget_large_text, largeText)
            views.setTextViewText(R.id.widget_small_text, smallText)

            val progress = (maxValue - currentValue).coerceIn(0, maxValue)
            
            views.setProgressBar(R.id.widget_progress_bar_track, maxValue, maxValue, false)
            views.setProgressBar(R.id.widget_progress_bar, maxValue, progress, false)

            val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java,
                Uri.parse("menstrudel://widget/home") 
            )
            
            views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)
            
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}