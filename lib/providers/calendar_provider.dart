import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/calendar_model.dart';
import '../utils/hive_init.dart';
import '../utils/constants.dart';

final calendarProvider =
    StateNotifierProvider<CalendarNotifier, List<CalendarModel>>((ref) {
  return CalendarNotifier();
});

class CalendarNotifier extends StateNotifier<List<CalendarModel>> {
  CalendarNotifier() : super([]) {
    _loadFromHive();
  }

  void _loadFromHive() {
    final box = HiveInit.calendarsBox;
    if (box.isEmpty) {
      // Add a default calendar
      final defaultCal = CalendarModel(
        id: const Uuid().v4(),
        name: 'Personal',
        colorValue: kDefaultCalendarColors[0],
      );
      box.put(defaultCal.id, defaultCal);
    }
    state = box.values.toList();
  }

  void addCalendar(String name, int colorValue) {
    final cal = CalendarModel(
      id: const Uuid().v4(),
      name: name,
      colorValue: colorValue,
    );
    HiveInit.calendarsBox.put(cal.id, cal);
    state = [...state, cal];
  }

  void deleteCalendar(String id) {
    HiveInit.calendarsBox.delete(id);
    state = state.where((c) => c.id != id).toList();
  }

  void toggleVisibility(String id) {
    final box = HiveInit.calendarsBox;
    final cal = box.get(id);
    if (cal != null) {
      cal.isVisible = !cal.isVisible;
      box.put(id, cal);
      state = box.values.toList();
    }
  }

  Set<String> get visibleCalendarIds =>
      state.where((c) => c.isVisible).map((c) => c.id).toSet();
}
