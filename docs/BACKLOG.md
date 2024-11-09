# Backlog

## Settings Screen

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