import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:uuid/uuid.dart';
import '../models/todo_model.dart';
import '../utils/hive_init.dart';

final todoProvider =
    StateNotifierProvider<TodoNotifier, List<TodoModel>>((ref) {
  return TodoNotifier();
});

class TodoNotifier extends StateNotifier<List<TodoModel>> {
  TodoNotifier() : super([]) {
    _loadFromHive();
  }

  void _loadFromHive() {
    final todos = HiveInit.todosBox.values.toList();
    todos.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    state = todos;
  }

  void addTodo(String title) {
    final todo = TodoModel(
      id: const Uuid().v4(),
      title: title,
      sortOrder: state.length,
    );
    HiveInit.todosBox.put(todo.id, todo);
    state = [...state, todo];
    _syncWidget();
  }

  void deleteTodo(String id) {
    HiveInit.todosBox.delete(id);
    state = state.where((t) => t.id != id).toList();
    _syncWidget();
  }

  void toggleTodo(String id) {
    final box = HiveInit.todosBox;
    final todo = box.get(id);
    if (todo != null) {
      todo.isDone = !todo.isDone;
      box.put(id, todo);
      state = state.map((t) => t.id == id ? todo : t).toList();
      _syncWidget();
    }
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;
    final items = List<TodoModel>.from(state);
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);

    // Update sort orders
    for (int i = 0; i < items.length; i++) {
      items[i].sortOrder = i;
      HiveInit.todosBox.put(items[i].id, items[i]);
    }
    state = items;
    _syncWidget();
  }

  Future<void> _syncWidget() async {
    try {
      final topTodos = state.take(5).map((t) => t.toJson()).toList();
      await HomeWidget.saveWidgetData<String>(
          'todo_data', jsonEncode(topTodos));
      await HomeWidget.updateWidget(
        androidName: 'TodoWidgetProvider',
      );
    } catch (e) {
      debugPrint('Home widget sync failed: $e');
    }
  }
}
