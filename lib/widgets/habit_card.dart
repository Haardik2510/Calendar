import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/habit_model.dart';
import '../providers/habit_provider.dart';
import 'bento_card.dart';

class HabitCard extends ConsumerWidget {
  final HabitModel habit;
  final DateTime date;

  const HabitCard({super.key, required this.habit, required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isCompleted = habit.isCompletedOn(date);
    final streak = habit.currentStreak;

    return BentoCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Completion toggle
          GestureDetector(
            onTap: () {
              ref
                  .read(habitProvider.notifier)
                  .toggleHabitForDate(habit.id, date);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isCompleted
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isCompleted
                      ? theme.colorScheme.primary
                      : theme.dividerColor,
                  width: 2,
                ),
                boxShadow: isCompleted
                    ? [
                        BoxShadow(
                          color: theme.colorScheme.primary
                              .withValues(alpha: 0.3),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
              child: _buildIcon(habit.iconCodePoint, isCompleted, theme),
            ),
          ),
          const SizedBox(width: 16),

          // Name & streak
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    decoration: isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    color: isCompleted
                        ? theme.colorScheme.onSurface.withValues(alpha: 0.4)
                        : null,
                  ),
                ),
                if (streak > 0) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.local_fire_department_rounded,
                          size: 16, color: theme.colorScheme.secondary),
                      const SizedBox(width: 4),
                      Text(
                        '$streak day streak',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Delete
          IconButton(
            icon: Icon(Icons.delete_outline_rounded,
                size: 20,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
            onPressed: () {
              ref.read(habitProvider.notifier).deleteHabit(habit.id);
            },
          ),
        ],
      ),
    );
  }

  static Widget _buildIcon(int codePoint, bool isCompleted, ThemeData theme) {
    final iconData = IconData(codePoint, fontFamily: 'MaterialIcons');
    return Icon(
      iconData,
      color: isCompleted
          ? Colors.white
          : theme.colorScheme.onSurface.withValues(alpha: 0.5),
      size: 24,
    );
  }
}
