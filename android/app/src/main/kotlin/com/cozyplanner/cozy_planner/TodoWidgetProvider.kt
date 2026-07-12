package com.cozyplanner.cozy_planner

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import org.json.JSONArray

class TodoWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
            val todoDataJson = prefs.getString("todo_data", "[]") ?: "[]"

            val views = RemoteViews(context.packageName, R.layout.todo_widget)
            views.removeAllViews(R.id.todo_list_container)

            try {
                val jsonArray = JSONArray(todoDataJson)
                val count = minOf(jsonArray.length(), 5)

                if (count == 0) {
                    val emptyView = RemoteViews(context.packageName, R.layout.todo_widget_item)
                    emptyView.setTextViewText(R.id.todo_item_text, "No tasks yet ✨")
                    emptyView.setInt(R.id.todo_item_checkbox, "setBackgroundResource", 0)
                    views.addView(R.id.todo_list_container, emptyView)
                } else {
                    for (i in 0 until count) {
                        val todoObj = jsonArray.getJSONObject(i)
                        val title = todoObj.getString("title")
                        val isDone = todoObj.getBoolean("isDone")

                        val itemView = RemoteViews(context.packageName, R.layout.todo_widget_item)
                        itemView.setTextViewText(R.id.todo_item_text, title)

                        if (isDone) {
                            itemView.setInt(R.id.todo_item_checkbox, "setBackgroundResource", R.drawable.checkbox_checked)
                            itemView.setFloat(R.id.todo_item_text, "setAlpha", 0.4f)
                        } else {
                            itemView.setInt(R.id.todo_item_checkbox, "setBackgroundResource", R.drawable.checkbox_unchecked)
                            itemView.setFloat(R.id.todo_item_text, "setAlpha", 1.0f)
                        }

                        views.addView(R.id.todo_list_container, itemView)
                    }
                }
            } catch (e: Exception) {
                val errorView = RemoteViews(context.packageName, R.layout.todo_widget_item)
                errorView.setTextViewText(R.id.todo_item_text, "Open app to sync")
                views.addView(R.id.todo_list_container, errorView)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
