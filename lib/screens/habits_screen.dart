import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/habit_provider.dart';
import '../widgets/habit_card.dart';
import '../widgets/habit_progress_ring.dart';
import '../widgets/add_habit_sheet.dart';
import '../widgets/bento_card.dart';

class HabitsScreen extends ConsumerWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final habits = ref.watch(habitProvider);
    final today = DateTime.now();
    final completionRate =
        ref.read(habitProvider.notifier).completionRateForDate(today);

    return Scaffold(
      appBar: AppBar(
        title: Text('Habits',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w700,
              fontSize: 24,
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Habit Tracker'),
                  content: const Text(
                      'Add habits you want to track daily. Tap the icon to mark a habit as complete. Build streaks by completing habits consistently!'),
                  actions: [
                    FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it!'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: habits.isEmpty
          ? _buildEmptyState(theme)
          : CustomScrollView(
              slivers: [
                // Progress ring header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: BentoCard(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text("Today's Progress",
                                        style: theme.textTheme.titleLarge),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatDate(today),
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.5),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${habits.where((h) => h.isCompletedOn(today)).length}/${habits.length} habits',
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              HabitProgressRing(progress: completionRate),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Habit list
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: HabitCard(
                            habit: habits[index],
                            date: today,
                          ),
                        );
                      },
                      childCount: habits.length,
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const AddHabitSheet(),
          );
        },
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.self_improvement_rounded,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            'No habits yet',
            style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to start building healthy routines!',
            style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }
}
