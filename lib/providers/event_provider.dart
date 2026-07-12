import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/event_model.dart';
import '../utils/hive_init.dart';
import 'calendar_provider.dart';

final eventProvider =
    StateNotifierProvider<EventNotifier, List<EventModel>>((ref) {
  return EventNotifier();
});

/// Provides events filtered by currently visible calendars
final visibleEventsProvider = Provider<List<EventModel>>((ref) {
  final events = ref.watch(eventProvider);
  final calendars = ref.watch(calendarProvider);
  final visibleIds =
      calendars.where((c) => c.isVisible).map((c) => c.id).toSet();
  return events.where((e) => visibleIds.contains(e.calendarId)).toList();
});

class EventNotifier extends StateNotifier<List<EventModel>> {
  EventNotifier() : super([]) {
    _loadFromHive();
  }

  void _loadFromHive() {
    state = HiveInit.eventsBox.values.toList();
  }

  void addEvent({
    required String calendarId,
    required String title,
    required DateTime date,
    required int colorValue,
    String fontFamily = 'Outfit',
    int? stickerCodePoint,
  }) {
    final event = EventModel(
      id: const Uuid().v4(),
      calendarId: calendarId,
      title: title,
      date: date,
      colorValue: colorValue,
      fontFamily: fontFamily,
      stickerCodePoint: stickerCodePoint,
    );
    HiveInit.eventsBox.put(event.id, event);
    state = [...state, event];
  }

  void deleteEvent(String id) {
    HiveInit.eventsBox.delete(id);
    state = state.where((e) => e.id != id).toList();
  }

  void deleteEventsForCalendar(String calendarId) {
    final toDelete = state.where((e) => e.calendarId == calendarId).toList();
    for (final e in toDelete) {
      HiveInit.eventsBox.delete(e.id);
    }
    state = state.where((e) => e.calendarId != calendarId).toList();
  }

  List<EventModel> eventsForDay(DateTime day, Set<String> visibleCalendarIds) {
    return state.where((e) {
      return e.date.year == day.year &&
          e.date.month == day.month &&
          e.date.day == day.day &&
          visibleCalendarIds.contains(e.calendarId);
    }).toList();
  }
}
