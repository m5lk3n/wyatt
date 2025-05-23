import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:wyatt/log.dart';
import 'package:wyatt/widgets/datetime_helper.dart';

typedef DateTimeCallback = void Function(DateTime? dateTime);

// https://pub.dev/packages/flutter_datetime_picker_plus/example
class DateTimePicker extends StatefulWidget {
  const DateTimePicker({
    super.key,
    required this.label,
    required this.hintText,
    this.dateTime,
    required this.onDateTimeChange,
  });

  final String label;
  final String hintText;
  final DateTime?
      dateTime; // initial date time // TODO/FIXME: restore on LocationPicker back
  final DateTimeCallback onDateTimeChange;

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  final _dateTimeController = TextEditingController();
  DateTime? _currentDateTime;

  @override
  void initState() {
    super.initState();

    if (widget.dateTime != null) {
      _currentDateTime = widget.dateTime;
    }
  }

  @override
  void dispose() {
    _dateTimeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log.debug('dateTime: ${_currentDateTime ?? "unknown"}',
        name: '$runtimeType');

    if (_currentDateTime != null) {
      _dateTimeController.text = formatDateTime(
        Localizations.localeOf(context),
        _currentDateTime!,
      );
    }

    return TextField(
      onTap: () {
        pickDateTime();
      },
      readOnly: true,
      controller: _dateTimeController,
      decoration: InputDecoration(
        label: Text(widget.label),
        hintText: widget.hintText,
        prefixIcon: IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () {
              pickDateTime();
            }),
        suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _currentDateTime = null;
                _dateTimeController.clear();
                widget.onDateTimeChange(null);
              });
            }),
      ),
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
    );
  }

  // sets _currentDateTime as a side effect
  void pickDateTime() {
    final Locale userLocale = Localizations.localeOf(context);
    final dt = _currentDateTime ?? DateTime.now();

    picker.DatePicker.showDateTimePicker(
      context,
      theme: picker.DatePickerTheme(
        headerColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
        cancelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
        doneStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
        itemStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
      ),
      showTitleActions: true,
      minTime: DateTime(
        dt.year,
        dt.month,
        dt.day,
        dt.hour,
        dt.minute,
        dt.second,
      ),
      maxTime: DateTime(
        2100,
        12,
        31,
        23,
        59,
        59,
      ),
      onConfirm: (date) {
        log.debug('confirmed: $date', name: '$runtimeType');
        _currentDateTime = date;
        _dateTimeController.text =
            formatDateTime(userLocale, _currentDateTime!);
        widget.onDateTimeChange(_currentDateTime!);
      },
      currentTime: dt,
      locale: fromLanguageCode(userLocale),
    );
  }
}
