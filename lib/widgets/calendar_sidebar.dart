import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/calendar_model.dart';
import '../providers/calendar_provider.dart';
import '../providers/event_provider.dart';
import '../providers/theme_provider.dart';
import 'add_calendar_dialog.dart';

class CalendarSidebar extends ConsumerWidget {
  const CalendarSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendars = ref.watch(calendarProvider);
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeProvider);

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Row(
                children: [
                  Icon(Icons.calendar_month_rounded,
                      color: theme.colorScheme.primary, size: 28),
                  const SizedBox(width: 12),
                  Text('My Calendars',
                      style: theme.textTheme.headlineMedium),
                ],
              ),
            ),
            const Divider(indent: 24, endIndent: 24),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: calendars.length,
                itemBuilder: (context, index) {
                  final cal = calendars[index];
                  return _CalendarTile(calendar: cal);
                },
              ),
            ),
            const Divider(indent: 24, endIndent: 24),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: ListTile(
                leading: Icon(Icons.add_rounded,
                    color: theme.colorScheme.primary),
                title: Text('Add Calendar',
                    style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => const AddCalendarDialog(),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: ListTile(
                leading: Icon(
                  themeMode == ThemeMode.dark
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  color: theme.colorScheme.secondary,
                ),
                title: Text(
                  themeMode == ThemeMode.dark ? 'Light Mode' : 'Dark Mode',
                  style: theme.textTheme.titleMedium,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                onTap: () {
                  ref.read(themeModeProvider.notifier).toggle();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarTile extends ConsumerWidget {
  final CalendarModel calendar;

  const _CalendarTile({required this.calendar});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final color = Color(calendar.colorValue);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        leading: Checkbox(
          value: calendar.isVisible,
          activeColor: color,
          onChanged: (_) {
            ref
                .read(calendarProvider.notifier)
                .toggleVisibility(calendar.id);
          },
        ),
        title: Text(calendar.name, style: theme.textTheme.titleMedium),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.delete_outline_rounded,
                  size: 20, color: theme.colorScheme.error),
              onPressed: () {
                ref.read(eventProvider.notifier)
                    .deleteEventsForCalendar(calendar.id);
                ref
                    .read(calendarProvider.notifier)
                    .deleteCalendar(calendar.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
