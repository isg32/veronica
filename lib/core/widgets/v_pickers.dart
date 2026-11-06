import 'package:flutter/widgets.dart';

import '../../data/models/day_time.dart';
import '../format.dart';
import 'v_buttons.dart';
import 'v_glass.dart';
import 'v_wheel.dart';

/// Glass sheet with an hour/minute wheel. Returns null if dismissed.
Future<DayTime?> showTimePickerSheet(
  BuildContext context, {
  required String title,
  required DayTime initial,
  int minuteStep = 5,
}) {
  return showVSheet<DayTime>(
    context,
    title: title,
    builder: (context) => _TimePicker(initial: initial, minuteStep: minuteStep),
  );
}

class _TimePicker extends StatefulWidget {
  const _TimePicker({required this.initial, required this.minuteStep});

  final DayTime initial;
  final int minuteStep;

  @override
  State<_TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<_TimePicker> {
  late DayTime _value = widget.initial;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VTimeWheel(
          hour: _value.hour,
          minute: _value.minute,
          minuteStep: widget.minuteStep,
          onChanged: (h, m) => setState(() => _value = DayTime(h, m)),
        ),
        const SizedBox(height: 20),
        VButton.primary(
          'Done',
          onPressed: () => Navigator.of(context).pop(_value),
        ),
      ],
    );
  }
}

/// Glass sheet with a text field. Returns the trimmed text, or null.
Future<String?> showTextSheet(
  BuildContext context, {
  required String title,
  String initial = '',
  String placeholder = '',
  String action = 'Save',
}) {
  return showVSheet<String>(
    context,
    title: title,
    builder: (context) =>
        _TextPrompt(initial: initial, placeholder: placeholder, action: action),
  );
}

class _TextPrompt extends StatefulWidget {
  const _TextPrompt({
    required this.initial,
    required this.placeholder,
    required this.action,
  });

  final String initial;
  final String placeholder;
  final String action;

  @override
  State<_TextPrompt> createState() => _TextPromptState();
}

class _TextPromptState extends State<_TextPrompt> {
  late final TextEditingController _text = TextEditingController(
    text: widget.initial,
  );

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _text.text.trim();
    if (value.isNotEmpty) Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VTextField(
          controller: _text,
          placeholder: widget.placeholder,
          autofocus: true,
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: 14),
        VButton.primary(widget.action, onPressed: _submit),
      ],
    );
  }
}

/// Glass sheet with a Doto wheel of days starting at [from] (e.g. today).
/// Returns the chosen date (at midnight), or null if dismissed.
Future<DateTime?> showDatePickerSheet(
  BuildContext context, {
  required String title,
  required DateTime from,
  DateTime? initial,
  int days = 120,
}) {
  final start = DateTime(from.year, from.month, from.day);
  return showVSheet<DateTime>(
    context,
    title: title,
    builder: (context) => _DatePicker(
      start: start,
      initialOffset: initial == null
          ? 1
          : DateTime(
              initial.year,
              initial.month,
              initial.day,
            ).difference(start).inDays.clamp(0, days - 1),
      days: days,
    ),
  );
}

class _DatePicker extends StatefulWidget {
  const _DatePicker({
    required this.start,
    required this.initialOffset,
    required this.days,
  });

  final DateTime start;
  final int initialOffset;
  final int days;

  @override
  State<_DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<_DatePicker> {
  late int _offset = widget.initialOffset;

  DateTime _at(int offset) => DateTime(
    widget.start.year,
    widget.start.month,
    widget.start.day + offset,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VWheelFrame(
          child: VWheel(
            values: [for (var i = 0; i < widget.days; i++) i],
            selected: _offset,
            width: 260,
            format: (i) => switch (i) {
              0 => 'Today',
              1 => 'Tomorrow',
              _ => VFormat.shortDate(_at(i)),
            },
            onChanged: (i) => setState(() => _offset = i),
          ),
        ),
        const SizedBox(height: 20),
        VButton.primary(
          'Done',
          onPressed: () => Navigator.of(context).pop(_at(_offset)),
        ),
      ],
    );
  }
}
