import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../models/calendar_model.dart';
import '../providers/calendar_provider.dart';
import '../providers/event_provider.dart';
import 'sticker_picker.dart';
import 'font_style_picker.dart';

class AddEventSheet extends ConsumerStatefulWidget {
  final DateTime selectedDate;

  const AddEventSheet({super.key, required this.selectedDate});

  @override
  ConsumerState<AddEventSheet> createState() => _AddEventSheetState();
}

class _AddEventSheetState extends ConsumerState<AddEventSheet> {
  final _titleController = TextEditingController();
  Color _selectedColor = const Color(0xFF8A9A86);
  String _selectedFont = 'Outfit';
  int? _selectedSticker;
  String? _selectedCalendarId;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final calendars = ref.watch(calendarProvider);

    if (_selectedCalendarId == null && calendars.isNotEmpty) {
      _selectedCalendarId = calendars.first.id;
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.bottomSheetTheme.backgroundColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title bar
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Row(
                  children: [
                    Icon(Icons.event_rounded,
                        color: theme.colorScheme.primary),
                    const SizedBox(width: 12),
                    Text('New Event',
                        style: theme.textTheme.headlineMedium),
                    const Spacer(),
                    Text(
                      '${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5)),
                    ),
                  ],
                ),
              ),
              const Divider(indent: 24, endIndent: 24),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    // Title
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: 'Event title...',
                        prefixIcon: Icon(Icons.title_rounded),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      autofocus: true,
                    ),
                    const SizedBox(height: 20),

                    // Calendar picker
                    Text('Calendar', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: calendars.map((cal) {
                        final isSelected = cal.id == _selectedCalendarId;
                        return _CalendarChip(
                          calendar: cal,
                          isSelected: isSelected,
                          onTap: () =>
                              setState(() => _selectedCalendarId = cal.id),
                          theme: theme,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Color picker
                    Text('Event Color', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _showColorPicker,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: theme.dividerColor),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: _selectedColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: _selectedColor
                                        .withValues(alpha: 0.3),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '#${_selectedColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
                              style: theme.textTheme.bodyLarge,
                            ),
                            const Spacer(),
                            Icon(Icons.colorize_rounded,
                                color: theme.colorScheme.primary),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Font picker
                    FontStylePicker(
                      selectedFamily: _selectedFont,
                      onSelected: (f) =>
                          setState(() => _selectedFont = f),
                    ),
                    const SizedBox(height: 24),

                    // Sticker picker
                    StickerPicker(
                      selectedCodePoint: _selectedSticker,
                      onSelected: (s) =>
                          setState(() => _selectedSticker = s),
                    ),
                    const SizedBox(height: 32),

                    // Submit button
                    SizedBox(
                      height: 56,
                      child: FilledButton(
                        onPressed: _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_rounded),
                            const SizedBox(width: 8),
                            Text('Add Event',
                                style: theme.textTheme.labelLarge),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick Event Color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _selectedColor,
            onColorChanged: (color) {
              setState(() => _selectedColor = color);
            },
            enableAlpha: false,
            hexInputBar: true,
            labelTypes: const [],
            pickerAreaBorderRadius: BorderRadius.circular(16),
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty || _selectedCalendarId == null) return;

    ref.read(eventProvider.notifier).addEvent(
          calendarId: _selectedCalendarId!,
          title: title,
          date: widget.selectedDate,
          colorValue: _selectedColor.toARGB32(),
          fontFamily: _selectedFont,
          stickerCodePoint: _selectedSticker,
        );

    Navigator.pop(context);
  }
}

class _CalendarChip extends StatelessWidget {
  final CalendarModel calendar;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;

  const _CalendarChip({
    required this.calendar,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(calendar.colorValue);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : theme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(calendar.name,
                style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}
