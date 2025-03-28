import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarSection extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const CalendarSection({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<CalendarSection> createState() => _CalendarSectionState();
}

class _CalendarSectionState extends State<CalendarSection> {
  late DateTime _focusedDate;

  @override
  void initState() {
    super.initState();
    _focusedDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Select a Date",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TableCalendar(
            focusedDay: _focusedDate,
            firstDay: DateTime(2020),
            lastDay: DateTime(2100),
            selectedDayPredicate: (day) => isSameDay(day, widget.selectedDate),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _focusedDate = focusedDay;
              });
              widget.onDateSelected(selectedDay);
            },
            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
