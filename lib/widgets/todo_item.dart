import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo_model.dart';
import '../providers/todo_provider.dart';

class TodoItem extends ConsumerWidget {
  final TodoModel todo;

  const TodoItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        leading: GestureDetector(
          onTap: () {
            ref.read(todoProvider.notifier).toggleTodo(todo.id);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: todo.isDone
                  ? theme.colorScheme.primary
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: todo.isDone
                    ? theme.colorScheme.primary
                    : theme.dividerColor,
                width: 2,
              ),
            ),
            child: todo.isDone
                ? const Icon(Icons.check_rounded,
                    color: Colors.white, size: 18)
                : null,
          ),
        ),
        title: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: theme.textTheme.titleMedium!.copyWith(
            decoration:
                todo.isDone ? TextDecoration.lineThrough : null,
            color: todo.isDone
                ? theme.colorScheme.onSurface.withValues(alpha: 0.35)
                : theme.colorScheme.onSurface,
          ),
          child: Text(todo.title),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.drag_handle_rounded,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
            const SizedBox(width: 4),
            IconButton(
              icon: Icon(Icons.delete_outline_rounded,
                  size: 20,
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.3)),
              onPressed: () {
                ref.read(todoProvider.notifier).deleteTodo(todo.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
