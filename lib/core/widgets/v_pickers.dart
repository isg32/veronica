import 'package:flutter/widgets.dart';

import '../../data/models/day_time.dart';
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
