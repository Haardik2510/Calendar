import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_item.dart';
import '../widgets/bento_card.dart';

class TodoScreen extends ConsumerStatefulWidget {
  const TodoScreen({super.key});

  @override
  ConsumerState<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends ConsumerState<TodoScreen> {
  final _addController = TextEditingController();
  bool _showAddField = false;

  @override
  void dispose() {
    _addController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final todos = ref.watch(todoProvider);
    final pendingCount = todos.where((t) => !t.isDone).length;
    final doneCount = todos.where((t) => t.isDone).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w700,
              fontSize: 24,
            )),
      ),
      body: Column(
        children: [
          // Summary card
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: BentoCard(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tasks Overview',
                            style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _StatChip(
                              label: 'Pending',
                              count: pendingCount,
                              color: theme.colorScheme.secondary,
                              theme: theme,
                            ),
                            const SizedBox(width: 12),
                            _StatChip(
                              label: 'Done',
                              count: doneCount,
                              color: theme.colorScheme.primary,
                              theme: theme,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Circular progress
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: todos.isEmpty
                              ? 0
                              : doneCount / todos.length,
                          strokeWidth: 6,
                          backgroundColor: theme.dividerColor,
                          color: theme.colorScheme.primary,
                          strokeCap: StrokeCap.round,
                        ),
                        Text(
                          todos.isEmpty
                              ? '0%'
                              : '${(doneCount / todos.length * 100).round()}%',
                          style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Add task field
          if (_showAddField)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _addController,
                      decoration: const InputDecoration(
                        hintText: 'What do you need to do?',
                        prefixIcon: Icon(Icons.add_task_rounded),
                      ),
                      autofocus: true,
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: _addTodo,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () =>
                        setState(() => _showAddField = false),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),

          // Todo list
          Expanded(
            child: todos.isEmpty
                ? _buildEmptyState(theme)
                : ReorderableListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                    proxyDecorator: (child, index, animation) {
                      return Material(
                        color: Colors.transparent,
                        elevation: 4,
                        borderRadius: BorderRadius.circular(20),
                        child: child,
                      );
                    },
                    itemCount: todos.length,
                    onReorderItem: (oldIndex, newIndex) {
                      ref
                          .read(todoProvider.notifier)
                          .reorder(oldIndex, newIndex);
                    },
                    itemBuilder: (context, index) {
                      return TodoItem(
                        key: ValueKey(todos[index].id),
                        todo: todos[index],
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() => _showAddField = !_showAddField);
          if (_showAddField) {
            _addController.clear();
          }
        },
        child: Icon(
            _showAddField ? Icons.close_rounded : Icons.add_rounded,
            size: 28),
      ),
    );
  }

  void _addTodo(String value) {
    final title = value.trim();
    if (title.isNotEmpty) {
      ref.read(todoProvider.notifier).addTodo(title);
      _addController.clear();
    }
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.checklist_rounded,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            'All clear!',
            style: theme.textTheme.headlineMedium?.copyWith(
                color:
                    theme.colorScheme.onSurface.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add a new task',
            style: theme.textTheme.bodyMedium?.copyWith(
                color:
                    theme.colorScheme.onSurface.withValues(alpha: 0.3)),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final ThemeData theme;

  const _StatChip({
    required this.label,
    required this.count,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$count',
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 16)),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: color.withValues(alpha: 0.7), fontSize: 12)),
        ],
      ),
    );
  }
}



