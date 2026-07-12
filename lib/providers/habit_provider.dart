import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/habit_model.dart';
import '../utils/hive_init.dart';

final habitProvider =
    StateNotifierProvider<HabitNotifier, List<HabitModel>>((ref) {
  return HabitNotifier();
});

class HabitNotifier extends StateNotifier<List<HabitModel>> {
  HabitNotifier() : super([]) {
    _loadFromHive();
  }

  void _loadFromHive() {
    state = HiveInit.habitsBox.values.toList();
  }

  void addHabit(String name, int iconCodePoint) {
    final habit = HabitModel(
      id: const Uuid().v4(),
      name: name,
      iconCodePoint: iconCodePoint,
    );
    HiveInit.habitsBox.put(habit.id, habit);
    state = [...state, habit];
  }

  void deleteHabit(String id) {
    HiveInit.habitsBox.delete(id);
    state = state.where((h) => h.id != id).toList();
  }

  void toggleHabitForDate(String id, DateTime date) {
    final box = HiveInit.habitsBox;
    final habit = box.get(id);
    if (habit != null) {
      habit.toggleDate(date);
      box.put(id, habit);
      state = box.values.toList();
    }
  }

  double completionRateForDate(DateTime date) {
    if (state.isEmpty) return 0;
    final completed = state.where((h) => h.isCompletedOn(date)).length;
    return completed / state.length;
  }
}
