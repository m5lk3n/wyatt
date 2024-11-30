import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:wyatt/widgets/datetime_helper.dart';

// https://pub.dev/packages/flutter_datetime_picker_plus/example
class DateTimePicker extends StatefulWidget {
  const DateTimePicker({
    super.key,
    required this.label,
    required this.hintText,
    this.dateTime,
  });

  final String label;
  final String hintText;
  final DateTime?
      dateTime; // input date time // TODO/FIXME: restore on LocationPicker back

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
      _dateTimeController.text = formatDateTime(
        Localizations.localeOf(context),
        _currentDateTime!,
      );
    }
  }

  @override
  void dispose() {
    _dateTimeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('dateTime: ${_currentDateTime ?? "unknown"}', name: 'DateTimePicker');

    return TextField(
      onTap: () {
        pickDateTime(context);
      },
      readOnly: true,
      controller: _dateTimeController,
      decoration: InputDecoration(
        label: Text(widget.label),
        hintText: widget.hintText,
        suffixIcon: IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () {
              pickDateTime(context);
            }),
      ),
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
    );
  }

  // sets _currentDateTime as a side effect
  void pickDateTime(BuildContext context) {
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
        log('confirmed: $date', name: 'DateTimePicker');
        _currentDateTime = date;
        _dateTimeController.text =
            formatDateTime(userLocale, _currentDateTime!);
      },
      currentTime: dt,
      locale: fromLanguageCode(userLocale),
    );
  }
}
