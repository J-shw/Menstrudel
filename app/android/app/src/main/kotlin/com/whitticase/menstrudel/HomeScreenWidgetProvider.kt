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

            val title = widgetData.getString("widget_title", "Menstrudel")
            val message = widgetData.getString("widget_message", "No Message")

            views.setTextViewText(R.id.widget_title, title)
            views.setTextViewText(R.id.widget_message, message)

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