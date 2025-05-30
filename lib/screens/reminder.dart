import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/models/reminder.dart';
import 'package:wyatt/providers/reminders_provider.dart';
import 'package:wyatt/screens/screens_helper.dart';
import 'package:wyatt/widgets/appbar.dart';
import 'package:wyatt/widgets/address_loader.dart';
import 'package:wyatt/widgets/common.dart';
import 'package:wyatt/widgets/datetime_picker.dart';

class ReminderScreen extends ConsumerStatefulWidget {
  const ReminderScreen({
    super.key,
    this.reminder,
  });

  @override
  ConsumerState<ReminderScreen> createState() => _ReminderScreenState();

  final Reminder? reminder;
}

class _ReminderScreenState extends ConsumerState<ReminderScreen> {
  final _msgController = TextEditingController();
  final _aliasController = TextEditingController();
  final _distanceController = TextEditingController();
  LocationData? _locationData;
  DateTime? _startDateTime;
  DateTime? _endDateTime;
  bool _isProcessing = false;
  final _formKey = GlobalKey<FormState>();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    _msgController.text =
        widget.reminder != null ? widget.reminder!.notificationMessage : '';

    _aliasController.text = widget.reminder?.locationAlias ?? '';

    _locationData = widget.reminder?.locationData;

    _startDateTime = widget.reminder?.notificationStartDateTime;
    _endDateTime = widget.reminder?.notificationEndDateTime;

    if (widget.reminder != null) {
      _distanceController.text =
          widget.reminder!.notificationDistance.toString();
    } else {
      readDefaultNotificationDistance(ref, _distanceController);
    }
  }

  @override
  void dispose() {
    _msgController.dispose();
    _aliasController.dispose();
    _distanceController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget distanceField = createDistanceField(
      context,
      _distanceController,
      _isProcessing,
    );

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // goes along with SingleChildScrollView below to allow keyboard to slide up and not cover input fields (https://stackoverflow.com/questions/49207145/flutter-keyboard-over-textformfield)
      appBar: WyattAppBar(
          context: context,
          title: widget.reminder == null
              ? Screen.addReminder
              : Screen.editReminder),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Style.space,
                  Style.space,
                  Style.space,
                  0,
                ),
                child: TextFormField(
                  enableSuggestions: true,
                  // maxLines: 2,
                  autocorrect: true,
                  // causes keyboard to slide up: autofocus: true,
                  controller: _msgController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.message),
                    label: const Text("Notification Message *"),
                    hintText: "Enter a notification message",
                  ),
                  maxLength: 30,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                  validator: (value) {
                    return (value == null || value.trim().isEmpty)
                        ? 'Please enter a message'
                        : null; // success
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Style.space,
                  0,
                  Style.space,
                  0,
                ),
                child: TextFormField(
                  // although this has no validation, it is still handy to use a form field here to enable reset
                  enableSuggestions: true,
                  autocorrect: true,
                  // causes keyboard to slide up: autofocus: true,
                  controller: _aliasController,
                  decoration: InputDecoration(
                    prefixIcon: SizedBox(width: 24),
                    label: const Text("Location Alias"),
                    hintText: "Enter a location alias here",
                  ),
                  maxLength: 30,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Style.space,
                  0,
                  Style.space,
                  0,
                ),
                child: AddressLoader(
                  locationData: _locationData,
                  onLocationDataChange: (LocationData locationData) {
                    _locationData = locationData;
                  },
                ),
              ),
              ExpansionTile(
                title: Text(_isExpanded ? 'Less Options' : 'More Options'),
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                shape:
                    Border(), // remove the default border lines (https://stackoverflow.com/questions/62667990/how-to-remove-the-divider-lines-of-an-expansiontile-when-expanded-in-flutter)
                tilePadding:
                    EdgeInsets.fromLTRB(Style.space, 0, Style.space, 0),
                onExpansionChanged: (bool expanded) {
                  setState(() {
                    _isExpanded = expanded;
                  });
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Style.space,
                      Style.space,
                      Style.space,
                      0,
                    ),
                    child: DateTimePicker(
                      label: 'Start Notification',
                      hintText: 'Select start date & time',
                      dateTime: _startDateTime,
                      onDateTimeChange: (DateTime? dateTime) {
                        _startDateTime = dateTime;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Style.space,
                      Style.space,
                      Style.space,
                      0,
                    ),
                    child: DateTimePicker(
                      label: 'End Notification',
                      hintText: 'Select end date & time',
                      dateTime: _endDateTime,
                      onDateTimeChange: (DateTime? dateTime) {
                        _endDateTime = dateTime;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Style.space,
                      Style.space,
                      Style.space,
                      0,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [distanceField]),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(Style.space),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.secondary,
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                      ),
                      onPressed: _isProcessing
                          ? null
                          : () {
                              if (_save()) {
                                Navigator.pop(context);
                              }
                            },
                      autofocus: true,
                      child: Text('Save'),
                    ),
                    SizedBox(width: Style.space / 2),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.secondary,
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                      ),
                      onPressed: _isProcessing
                          ? null
                          : () => _formKey.currentState!.reset(),
                      autofocus: true,
                      child: Text('Reset'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _save() {
    FocusManager.instance.primaryFocus?.unfocus(); // dismiss keyboard

    final ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);
    scaffold.clearSnackBars();

    if (_locationData == null) {
      scaffold.showSnackBar(SnackBar(
          content: Text('Wait for the location to load, then try again.')));
      return false;
    }

    setState(() {
      _isProcessing = true;
    });

    if (_formKey.currentState!.validate()) {
      final reminder = _createReminder();
      if (_validateDateTime(reminder)) {
        String action = 'updated';
        if (widget.reminder == null) {
          action = 'added';
          ref.read(remindersNotifierProvider.notifier).add(reminder);
        } else {
          reminder.id = widget.reminder!.id;
          ref.read(remindersNotifierProvider.notifier).update(reminder);
        }
        scaffold.showSnackBar(SnackBar(
            content: Text(
                'Reminder $action. Please allow ~${Default.notificationFrequencyInMins} minutes for a notification to appear.')));

        return true;
      }
    }

    setState(() {
      _isProcessing = false;
    });

    return false;
  }

  bool _validateDateTime(Reminder reminder) {
    if (reminder.isDateTimeValid()) {
      return true;
    }

    final ThemeData themeData = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: themeData.colorScheme.error,
        content: Text('Start Notification must be before End Notification'),
      ),
    );

    return false;
  }

  Reminder _createReminder() {
    return Reminder(
      notificationMessage: _msgController.text.trim(),
      locationAlias: _aliasController.text.trim(),
      locationData: _locationData!,
      notificationStartDateTime: _startDateTime,
      notificationEndDateTime: _endDateTime,
      notificationDistance: int.parse(_distanceController.text),
    );
  }
}
