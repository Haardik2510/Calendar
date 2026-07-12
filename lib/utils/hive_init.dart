import 'package:hive_flutter/hive_flutter.dart';
import '../models/calendar_model.dart';
import '../models/event_model.dart';
import '../models/habit_model.dart';
import '../models/todo_model.dart';

class HiveInit {
  static Future<void> initialize() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(CalendarModelAdapter());
    Hive.registerAdapter(EventModelAdapter());
    Hive.registerAdapter(HabitModelAdapter());
    Hive.registerAdapter(TodoModelAdapter());

    // Open boxes
    await Hive.openBox<CalendarModel>('calendars');
    await Hive.openBox<EventModel>('events');
    await Hive.openBox<HabitModel>('habits');
    await Hive.openBox<TodoModel>('todos');
    await Hive.openBox('settings');
  }

  static Box<CalendarModel> get calendarsBox =>
      Hive.box<CalendarModel>('calendars');
  static Box<EventModel> get eventsBox => Hive.box<EventModel>('events');
  static Box<HabitModel> get habitsBox => Hive.box<HabitModel>('habits');
  static Box<TodoModel> get todosBox => Hive.box<TodoModel>('todos');
  static Box get settingsBox => Hive.box('settings');
}
