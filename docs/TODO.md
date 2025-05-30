# "Reversed, textual Kanban list"

## What is this?

Usually the basic order on a Kanban board is as follows: To do, doing, done
Below, I use a textual representation of a to-do list where I shift "doing" down so that everything above that virtual marker is considered "done" and "to do" what's below.

## Done

- [x] Ask user to provide a key (the Google Maps API key) and store it securely on the client: [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)

- [x] Splashcreen / Loading

- [x] Getting started (Set up Wyatt) (default if there's no key)
  - [x] Squared background color

- [ ] Home (default it there are no reminders)
  - [x] Intro text
    - ~~[ ] (?) Animate text (see `flutter_animate`)~~
    - [x] Getting Started button at the bottom
  - [ ] (?) Add help/info button right upper corner
  - [x] Left drawer with
      - [Home](https://api.flutter.dev/flutter/material/Icons/home-constant.html)
      - [Reminders](https://api.flutter.dev/flutter/material/Icons/location_on-constant.html) ([alternative icon](https://api.flutter.dev/flutter/material/Icons/pin_drop-constant.html))
      - [Settings](https://api.flutter.dev/flutter/material/Icons/settings-constant.html)
      - [About](https://api.flutter.dev/flutter/material/Icons/info-constant.html)

- [ ] Reminders
  - [x] Load reminders into an overview list (not a grid) ([exemplified fetch](https://docs.flutter.dev/cookbook/networking/fetch-data))
    - [x] Seed option
  - [ ] (?) Sort reminders overview by (due) date or by city name
  - [ ] Search reminders
  - [ ] (?) Filter reminders

  - [x] Manage reminders ~~(through dots menu)~~
    - [x] [Add a reminder](https://api.flutter.dev/flutter/material/Icons/add-constant.html)
      - [x] Evaluate and use a location picker:
            - [map_location_picker](https://pub.dev/packages/map_location_picker)
            - [Custom Map For Location Picker](https://community.flutterflow.io/c/community-custom-widgets/post/custom-map-for-location-picker-kPu8C7qdo1eSy0h)
            - [how to pick an address from map in flutter](https://stackoverflow.com/questions/69443353/how-to-pick-an-address-from-map-in-flutter)
    - [x] [Edit a reminder](https://api.flutter.dev/flutter/material/Icons/edit-constant.html)
    - [x] [Delete a reminder](https://api.flutter.dev/flutter/material/Icons/delete-constant.html)
    - [x] [Snooze/Turn off a reminder](https://api.flutter.dev/flutter/material/Icons/volume_off-constant.html) or [Suspend a reminder](https://api.flutter.dev/flutter/material/Icons/location_off-constant.html)
    - [x] [Activate/Turn on a reminder](https://api.flutter.dev/flutter/material/Icons/volume_up-constant.html) or [Hibernate a reminder](https://api.flutter.dev/flutter/material/Icons/location_on-constant.html)
    - [x] Add/Edit Reminder with `standard` (message and location) and expandable `advanced` (start/end, distance)
    - [x] Field validation

- [ ] Settings
  - [x] Save key
  - [ ] Choose Language
  - [ ] Choose Metric/Imperial units
  - [x] Default notification distance (500 m/y)
  - [x] Reset to factory settings
    - [x] Add delete key (and any other local data)
  - [x] Field validation

- [x] Check and indicate invalid key in appbar
- [x] Check and indicate missing permissions in appbar
  - [x] https://pub.dev/packages/permission_handler
- [x] Handle broken (Internet) connectivity

- [x] Implement [permission_handler](https://pub.dev/packages/permission_handler)

- [x] Implement Haversine (`flutter pub add haversine_distance`)

- [x] Logging, levels, see also [here](https://medium.com/@sunisha.guptan/cracking-the-code-debugging-magic-in-flutter-release-mode-f2e089a61f78)

- [ ] (?) Download my data

- [x] Implement notification
  - ~~[ ] (?)~~ ~~https://pub.dev/packages/awesome_notifications~~
  - [x] https://pub.dev/packages/flutter_local_notifications

- [x] Clarify minimal API key scope and document
- [x] Clarify permissions
  - See https://developer.android.com/develop/sensors-and-location/location/retrieve-current#permissions
  - See "Permissions" under https://github.com/Michael-M-aher/location_picker_flutter_map/tree/main?tab=readme-ov-file#setup
  - See [android.permission.INTERNET / com.apple.security.network.client](https://docs.flutter.dev/cookbook/networking/fetch-data)
- [x] Document permissions
  - See also [geofence_foreground_service](https://pub.dev/packages/geofence_foreground_service) package: ACCESS_FINE_LOCATION and ACCESS_COARSE_LOCATION on Android, Core Location on iOS
- [x] Document constraints
  - https://pub.dev/packages/flutter_background_service
    (Background service: *iOS... cannot be faster than 15 minutes and only alive about 15-30 seconds.*/)

- [x] Deploy to `wyatt.lttl.dev`
- [x] Generate `lttl.dev/wyatt/index.html`
  - [x] Finish initial content
  - [x] Adopt https://html5up.net/strongly-typed
  - [x] Use `git tag`s to generate changelog entries

- [x] Research and add a license

- [x] Ensure there's no EXIF data in image files

- [x] Clean up [README.md](README.md)

- [x] Clean up assets

- [x] Update screenshots

- [x] Outline [TEST.md](test/TEST.md)

- [x] Document logging

- [x] Enable vibrate for notification

- [x] Write up lessons learned and how-to(s) on Medium

- [x] Hint on Let's-get-started about permissions requests

- [x] Hint on successful reminder save about 15mins offset to (next) notification

- [x] Fix overflow in about dialog (iPhone 6s Plus)

- [x] Add clear key field option

- [x] Fix text center alignment on iOS

- [x] Document swapped buttons in permissions hint dialog

- [x] Document connectivity to "Default Uris" (see https://pub.dev/packages/internet_connection_checker_plus)

- [x] iOS flavor (v0.2.0)
  - [x] Fix iOS config
  - [x] Update iOS documentation
        [x] under "on iOS" in README
        [x] under wyatt.lttl.dev#permissions

## To-do

- [ ] Add an optional URL field 
- [ ] Search a location
- [ ] Add support for recurring schedules
- [ ] End date notification widget init value should be set to start date (if any)
- [ ] Add support to set time between notifications (currently hard-coded to 15mins (the minimum))
- [ ] DRY
- [ ] Recover from crash (e.g., by user revoking permissions during usage)
  - [ ] [Catcher 2](https://pub.dev/packages/catcher_2)
- [ ] Add to each StatefulWidget (?) ((reasoning)[https://stackoverflow.com/questions/49340116/setstate-called-after-dispose]):

      @override
      void setState(fn) {
        if(mounted) {
          super.setState(fn);
        }
      }

- [ ] Add `intl` (e.g. https://emiliodinen.medium.com/flutter-guide-to-use-internalization-and-localization-c8feedb46ac1)
  - [ ] Unify syntax ("Enter Distance in Meters" or "Enter distance in meters")
- [ ] TODOs
- [ ] Rename members to start with an underscore
- [ ] Adhere to conventions, like *widget constructors only use named arguments. Also by convention, the first argument is key, and the last argument is child, children, or the equivalent.*
- [ ] Automate builds further (`flutter build apk --obfuscate ...`)

## Open

- Instead of expired reminders only, color all currently not scheduled reminders differently?
- Consolidate Geolocator and LocationData?
- Cancel workmanager?
- Check if async is always needed
- How to use `._();` construct / how to implement singletons?
- How to reset non-FormFields?
- Use riverpod with families or providerscope?
- Are all StatefulWidgets needed?
  - "Stateful widgets are mutable and they update their data every time a `setState((){data;})` is called."
  - "Stateless widgets on the other hand are immutable, i.e they contain data that shouldn't change during runtime."
- Theme.of vs. Theme.of.copyWith?
- What if navigation back from Settings happens during saving?
- Suspend app, wake up?
- Recover from "panic"/exception (loss of connectivity in a tunnel?)
- Merge nearby reminders?
- Support landscape mode?