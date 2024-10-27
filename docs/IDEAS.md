# Ideas

- time-based option
- *approaching*: when you're reaching LOC, then do this (e.g., scheduled road closure, make sure to take detour into consideration)
- *static*: when you stay [for DURATION] in this LOC, then do that
- *leaving*: when you've left LOC for DURATION, then do this (e.g., "after 10 days, remember to reconnect with your friends and family when you're away from home")

## Ideas for Naming

- "Locatolog": community provided and maintained catalog of entries

- "Locatory": gamified surprise feature: get random/hidden/secret entry from Locatolog

- "Locator" = app user

## Use cases

- When you're in a specific place/reaching a specific location [within/by a certain time(frame)], then do this. Examples:

  - When you're in San Francisco, visit the Coit Tower at night. => Coordinates, inside radius, check interval, notification
  - You know of a road closure scheduled between 9pm and 5am, then make sure to take detour when you're getting closer (leaving earlier is a different case). => Coordinates, (inside) radius, check interval, date/time [recurring], notification

- When you're staying [for a certain amount of time] in a specific place, then do that. Examples:

  - After 14 days away from home, remember to reconnect with your friends and family. => Coordinates, (outside) radius, check interval, timespan, notification
  - You've worked for 2 days in your home office, then don't forget to work from the office. => Coordinates, (inside) radius, check interval, timespan, notification

## User input

- Coordinates (in Decimal degrees (DD), e.g., 41.40338, 2.17403)
- Radius
- Check interval
- Notification message
- Notification interval
- [Time-base (optional)]
