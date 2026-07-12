import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/calendar_provider.dart';
import '../providers/event_provider.dart';
import '../models/event_model.dart';
import '../widgets/calendar_sidebar.dart';
import '../widgets/add_event_sheet.dart';
import '../widgets/bento_card.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final calendars = ref.watch(calendarProvider);
    final visibleIds =
        calendars.where((c) => c.isVisible).map((c) => c.id).toSet();
    final allEvents = ref.watch(eventProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cozy Planner',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w700,
              fontSize: 24,
            )),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.today_rounded),
            onPressed: () {
              setState(() {
                _focusedDay = DateTime.now();
                _selectedDay = DateTime.now();
              });
            },
          ),
        ],
      ),
      drawer: const CalendarSidebar(),
      body: Column(
        children: [
          // Calendar
          BentoCard(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() => _calendarFormat = format);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              eventLoader: (day) {
                return allEvents.where((e) {
                  return e.date.year == day.year &&
                      e.date.month == day.month &&
                      e.date.day == day.day &&
                      visibleIds.contains(e.calendarId);
                }).toList();
              },
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                todayDecoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                selectedDecoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                defaultTextStyle: TextStyle(
                  color: theme.colorScheme.onSurface,
                ),
                weekendTextStyle: TextStyle(
                  color: theme.colorScheme.secondary,
                ),
                markerDecoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                markersMaxCount: 4,
                markerSize: 6,
                markerMargin: const EdgeInsets.symmetric(horizontal: 1),
              ),
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: true,
                formatButtonDecoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.primary),
                  borderRadius: BorderRadius.circular(14),
                ),
                formatButtonTextStyle: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 13,
                ),
                titleTextStyle: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                leftChevronIcon: Icon(Icons.chevron_left_rounded,
                    color: theme.colorScheme.primary),
                rightChevronIcon: Icon(Icons.chevron_right_rounded,
                    color: theme.colorScheme.primary),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                weekendStyle: TextStyle(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.7),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  if (events.isEmpty) return null;
                  final eventList = events.cast<EventModel>();
                  return Positioned(
                    bottom: 4,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: eventList.take(4).map((e) {
                        // Find calendar color
                        final cal = calendars.where((c) => c.id == e.calendarId);
                        final dotColor = cal.isNotEmpty
                            ? Color(cal.first.colorValue)
                            : Color(e.colorValue);
                        return Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            color: dotColor,
                            shape: BoxShape.circle,
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ),

          // Selected day events
          Expanded(
            child: _buildSelectedDayEvents(theme, allEvents, visibleIds),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedDay != null) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => AddEventSheet(selectedDate: _selectedDay!),
            );
          }
        },
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }

  Widget _buildSelectedDayEvents(
      ThemeData theme, List<EventModel> allEvents, Set<String> visibleIds) {
    if (_selectedDay == null) {
      return const Center(child: Text('Select a day'));
    }

    final dayEvents = allEvents.where((e) {
      return e.date.year == _selectedDay!.year &&
          e.date.month == _selectedDay!.month &&
          e.date.day == _selectedDay!.day &&
          visibleIds.contains(e.calendarId);
    }).toList();

    if (dayEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_available_rounded,
                size: 48,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
            const SizedBox(height: 12),
            Text(
              'No events for this day',
              style: theme.textTheme.bodyLarge?.copyWith(
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.4)),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap + to add one!',
              style: theme.textTheme.bodySmall?.copyWith(
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.3)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
      itemCount: dayEvents.length,
      itemBuilder: (context, index) {
        final event = dayEvents[index];
        final calendars = ref.read(calendarProvider);
        final cal = calendars.where((c) => c.id == event.calendarId);
        final calName = cal.isNotEmpty ? cal.first.name : 'Unknown';

        return Dismissible(
          key: Key(event.id),
          direction: DismissDirection.endToStart,
          onDismissed: (_) {
            ref.read(eventProvider.notifier).deleteEvent(event.id);
          },
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.delete_rounded, color: Colors.red),
          ),
          child: BentoCard(
            padding: const EdgeInsets.all(16),
            border: Border.all(
              color: Color(event.colorValue).withValues(alpha: 0.3),
            ),
            child: Row(
              children: [
                // Color strip
                Container(
                  width: 4,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Color(event.colorValue),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 14),

                // Sticker icon
                if (event.stickerCodePoint != null) ...[
                  _buildStickerIcon(event.stickerCodePoint!, event.colorValue),
                  const SizedBox(width: 12),
                ],

                // Title & calendar
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: GoogleFonts.getFont(
                          event.fontFamily,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        calName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Color(event.colorValue),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStickerIcon(int codePoint, int colorValue) {
    final iconData = IconData(codePoint, fontFamily: 'MaterialIcons');
    return Icon(iconData, size: 28, color: Color(colorValue));
  }
}
