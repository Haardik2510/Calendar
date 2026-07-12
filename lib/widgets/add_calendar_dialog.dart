import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calendar_provider.dart';
import '../utils/constants.dart';

class AddCalendarDialog extends ConsumerStatefulWidget {
  const AddCalendarDialog({super.key});

  @override
  ConsumerState<AddCalendarDialog> createState() => _AddCalendarDialogState();
}

class _AddCalendarDialogState extends ConsumerState<AddCalendarDialog> {
  final _nameController = TextEditingController();
  int _selectedColor = kDefaultCalendarColors[0];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.add_circle_rounded,
              color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          const Text('New Calendar'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Calendar name...',
              prefixIcon: Icon(Icons.edit_rounded),
            ),
            autofocus: true,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 20),
          Text('Color', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: kDefaultCalendarColors.map((colorVal) {
              final isSelected = colorVal == _selectedColor;
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = colorVal),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(colorVal),
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(
                            color: theme.colorScheme.onSurface,
                            width: 3,
                          )
                        : null,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Color(colorVal).withValues(alpha: 0.4),
                              blurRadius: 8,
                            )
                          ]
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 20)
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel',
              style: TextStyle(color: theme.colorScheme.onSurface)),
        ),
        FilledButton(
          onPressed: () {
            final name = _nameController.text.trim();
            if (name.isNotEmpty) {
              ref
                  .read(calendarProvider.notifier)
                  .addCalendar(name, _selectedColor);
              Navigator.pop(context);
            }
          },
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text('Create'),
        ),
      ],
    );
  }
}
