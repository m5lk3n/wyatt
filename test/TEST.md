# Testing

<details>
<summary>Why are there no automated tests?</summary>

There are many reasons for that:

- `<lame_excuse>`First, the usual, the obvious: Effort.`</lame_excuse>` Developing "decent" automated tests at this stage would probably take me at least one month of long evenings that I would rather spend on features and field tests.
- Given by the underlying OS implementation, notifications happen after ~15mins. Sometimes a notification is only triggered when there's "some sort of" interaction with the device. That begs the question how to come up with *meaningful* tests for something like this (not to forget, it's a hobby project).
- Experience is showing that each device (even from the same brand and family (I use Pixels), and on the same version level) exposes (small) differences in behavior or look & feel (just install a different launcher...).
- As a Flutter starter, I simply don't know (yet) how to mock certain behavior such as revoking permissions while the app is open, faking connectivity loss, swiping reminders left and right to delete them, and many more.
- Automated tests are no replacement for field tests (how do you automate a prepaid cell phone plan without data included but hotspot-connected?).
- Again, it's not a commercial app; it's one guy's learning project.
- At the end of the day, it's about the real deal - on a device, in real life.
- ...
</details>

<details>
<summary>How is Wyatt tested?</summary>

Manually, during development, and in the field on the following physical devices:

- Google Pixel 5 (Android 14)
- Google Pixel 6 (Android 15)
- Google Pixel 8 (Android 15)
- iPhone 6s Plus (?)

Reasons being:
- The performance of emulators on my [development machines](../README.md#get-started) would slow down the development cycle significantly
- Field tests can only be done on actual devices anyway
</details>
