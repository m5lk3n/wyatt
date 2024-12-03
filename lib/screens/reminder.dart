import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/models/reminder.dart';
import 'package:wyatt/widgets/appbar.dart';
import 'package:wyatt/widgets/address_loader.dart';
import 'package:wyatt/widgets/common.dart';
import 'package:wyatt/widgets/datetime_picker.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({
    super.key,
    this.reminder,
  });

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();

  final Reminder? reminder;
}

class _ReminderScreenState extends State<ReminderScreen> {
  final _msgController = TextEditingController();
  final _aliasController = TextEditingController();
  final _distanceController = TextEditingController();
  LocationData? _locationData;
  DateTime? _startDateTime;
  DateTime? _endDateTime;
  final bool _isProcessing = false; // TODO: use this

  @override
  void initState() {
    super.initState();

    _msgController.text =
        widget.reminder != null ? widget.reminder!.notificationMessage : '';

    _aliasController.text = widget.reminder?.locationAlias ?? '';

    _locationData = widget.reminder?.locationData;

    _startDateTime = widget.reminder?.notificationStartDateTime;
    _endDateTime = widget.reminder?.notificationEndDateTime;

    _distanceController.text = widget.reminder != null
        ? widget.reminder!.notificationDistance.toString()
        : Default.notificationDistance.toString();
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
      'Notification Distance',
      _distanceController,
      _isProcessing,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false, // avoid bottom overflow
      appBar: WyattAppBar(context, Screen.editReminder),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Common.space,
              Common.space,
              Common.space,
              0,
            ),
            child: TextField(
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Common.space,
              0,
              Common.space,
              0,
            ),
            child: TextField(
              enableSuggestions: false,
              autocorrect: false,
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
              Common.space,
              0,
              Common.space,
              0,
            ),
            child: AddressLoader(
              locationData: _locationData,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Common.space,
              Common.space,
              Common.space,
              0,
            ),
            child: DateTimePicker(
              label: 'Start Notification',
              hintText: 'Select start date & time',
              dateTime: _startDateTime,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Common.space,
              Common.space,
              Common.space,
              0,
            ),
            child: DateTimePicker(
              label: 'End Notification',
              hintText: 'Select end date & time',
              dateTime: _endDateTime,
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(
                Common.space,
                Common.space,
                Common.space,
                0,
              ),
              child: distanceField),
          Padding(
            padding: const EdgeInsets.all(Common.space),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                  ),
                  onPressed: null, // TODO: validate/implement
                  autofocus: true,
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
