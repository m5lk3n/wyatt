# Development-related

<details>
<summary>Initial Project Setup Steps</summary>

- [x] `flutter create --platforms android,ios --org dev.lttl wyatt`
- [x] `rm wyatt.iml`
- [x] `rm android/wyatt_android.iml`
- [x] `rm -rf .idea`
- [x] clean up `.gitignore`

- Copilot prompt to 
  - "Create a black and white logo showing a cowboy like an old wanted poster", download and save as 512x512 `assets/icon/icon.png`
  - "Create a brown leather background"
- [A Step-by-Step Guide to Adding Launcher Icons to Your Flutter App](https://nikhilsomansahu.medium.com/a-step-by-step-guide-to-adding-launcher-icons-to-your-flutter-app-98b5d7e3bb04)
</details>

<details>
<summary>Enhance Settings Screen with 'language' and 'system' (later)</summary>

```
  Padding(
    padding: const EdgeInsets.all(space),
    child: DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Language',
        labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
        suffixIcon: Tooltip(
          message: 'Another language is not yet available',
          child: Icon(Icons.info_outline),
        ),
      ),
      value: 'English',
      items: <String>['English', 'German'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  )),
        );
      }).toList(),
      onChanged: null, // disabled, TODO: implement
    ),
  ),
  Divider(
    indent: space,
    endIndent: space,
  ),
  Padding(
    padding: const EdgeInsets.fromLTRB(space, space, space, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'System',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                  title: Text('Metric'),
                  value: 'Metric',
                  groupValue: 'Metric',
                  onChanged: (context) {
                    /* TODO: implement */
                  }),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text('Imperial'),
                value: 'Imperial',
                groupValue: 'Metric',
                onChanged: (context) {/* TODO: implement */},
                secondary: Tooltip(
                  message: 'This choice is not yet supported',
                  child: Icon(Icons.info_outline),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  ),
  Divider(
    indent: space,
    endIndent: space,
  ),
```
</details>