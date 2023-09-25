package com.example.news_app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class HomeScreenWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {

                // Open App on Widget Click
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )
                //Retrieve a PendingIntent that will start a new activity,
                //Note that the activity will be started outside of the context of an existing activity
                setOnClickPendingIntent(R.id.widget_root, pendingIntent)
                // setOnClickPendingIntent : Application A can pass a PendingIntent to application B in order
                // to allow application B to execute predefined actions on behalf of application A; regardless
                // of whether application A is still alive.
                val news = widgetData.getString("news", "News App")
                val imageUrl = widgetData.getString("image_url", "")

                var newsTitle = "$news"
                setTextViewText(R.id.tv_counter, newsTitle)

//                if (!imageUrl.isNullOrEmpty()) {
//                    // Load the image from the network and set it in the ImageView using Glide
//                    val imageView = RemoteViews(context.packageName, R.id.imageView)
//                    Glide.with(context).load(imageUrl).into(imageView)
//                }
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
//    private fun updateText(views: RemoteViews, context: Context) {
//        val newText = texts[currentIndex]
//        views.setTextViewText(R.id.tv_counter, newText)
//        currentIndex = (currentIndex + 1) % texts.size
//    }
}