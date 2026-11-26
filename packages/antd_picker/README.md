# antd_picker - Wheel pickers, cascader, and date/time pickers for Flutter

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_picker/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_picker/README_CN.md)

## Positioning & design

`antd_picker` groups the selection surfaces that share a modal bottom-sheet or overlay container: `AntPicker<T>` for one or more wheel columns, `AntCascader<T>` for hierarchical drill-down selection, and `AntDatePicker` / `AntTimePicker` for formatted date and time fields. All generic pickers read **your model `T`** through `dataSource`, `keyOf`, and `labelBuilder`; nothing is flattened into string labels.

Design rules:

- **Values are typed.** `AntPicker<T>` confirms a `List<T>` — one selected object per column — while cascaders report the selected path.
- **Wheels are data-driven.** A column is `AntPickerColumn<T>`; column count and item rendering are declarations.
- **The trigger is yours.** Pickers accept a `child` widget that opens the sheet, so any button, field, or card can be the entry point.
- **Date and time stay separate.** `AntDatePicker` works in `DateTime`, `AntTimePicker` in `TimeOfDay`, each with its own display `format` / step controls.
- **Ranges pick both ends in one panel.** `AntDateRangePicker` (and `AntDateTimeRangePicker` with `showTime`) selects a start and an end in a single calendar, with an in-panel time step.
- **Copy follows the app.** The whole family reads `AntPickerLocale` from an explicit `locale:` argument, an `AntPickerLocaleProvider`, or the app's `Localizations` language, falling back to Chinese.

## Installation

Requires Dart `>=3.0.0` and Flutter `>=3.10.0`.

```yaml
dependencies:
  antd_picker: ^1.0.0
```

Wrap the subtree in `AntTheme`; wheel highlight, sheet chrome, and field borders come from the design tokens:

```dart
AntTheme(
  data: AntThemeData.light(),
  child: MaterialApp(home: YourPage()),
)
```

## Quick start

```dart
import 'package:antd_picker/antd_picker.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

class Season {
  const Season(this.id, this.name);

  final int id;
  final String name;
}

const seasons = <Season>[
  Season(1, 'Spring'),
  Season(2, 'Summer'),
  Season(3, 'Autumn'),
  Season(4, 'Winter'),
];

void main() => runApp(
      AntTheme(
        data: AntThemeData.light(),
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: AntPicker<Season>(
                title: 'Season',
                columns: [
                  AntPickerColumn<Season>(
                    dataSource: seasons,
                    keyOf: (season) => season.id,
                    labelBuilder: (context, season) => Text(season.name),
                  ),
                ],
                onConfirm: (values) {
                  debugPrint('picked ${values.first.name}');
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text('Pick a season'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
```

Tapping the child opens the wheel sheet. Confirm reports the selected `Season` objects in column order, and cancel dismisses without a value.

## API

[API reference](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_picker/docs/api-index.md)

### 1. A two-column year/month picker

```dart
class MonthPicker extends StatefulWidget {
  const MonthPicker({super.key});

  @override
  State<MonthPicker> createState() => _MonthPickerState();
}

class _MonthPickerState extends State<MonthPicker> {
  int _year = 2025;
  int _month = 3;

  @override
  Widget build(BuildContext context) {
    return AntPicker<int>(
      title: 'Month',
      confirmText: 'OK',
      cancelText: 'Cancel',
      defaultValue: <int>[_year, _month],
      columns: [
        AntPickerColumn<int>(
          dataSource: List<int>.generate(10, (index) => 2021 + index),
          keyOf: (year) => year,
          labelBuilder: (context, year) => Text('$year'),
        ),
        AntPickerColumn<int>(
          dataSource: List<int>.generate(12, (index) => index + 1),
          keyOf: (month) => month,
          labelBuilder: (context, month) => Text('$month'),
        ),
      ],
      onConfirm: (values) => setState(() {
        _year = values[0];
        _month = values[1];
      }),
      child: Text('$_year-$_month'),
    );
  }
}
```

Each column confirms exactly one `T`, and the result keeps column order. `defaultValue` entries may be either `T` values or the keys returned by `keyOf`.

### 2. Cascading selection with a tree

```dart
class Region {
  const Region(this.code, this.name, {this.children = const <Region>[]});

  final String code;
  final String name;
  final List<Region> children;
}

const regions = <Region>[
  Region(
    'zj',
    'Zhejiang',
    children: [
      Region('hz', 'Hangzhou'),
      Region('nb', 'Ningbo'),
    ],
  ),
  Region(
    'js',
    'Jiangsu',
    children: [
      Region('nj', 'Nanjing'),
    ],
  ),
];

AntCascader<Region>(
  dataSource: regions,
  keyOf: (region) => region.code,
  childrenOf: (region) => region.children,
  labelBuilder: (context, region) => Text(region.name),
  placeholder: 'Select a region',
  allowClear: true,
  changeOnSelect: false,
  onChange: (path) => debugPrint(path.map((r) => r.name).join(' / ')),
)
```

The cascader drills through `childrenOf`; with `changeOnSelect: false` a parent tab only expands the next column, and the value is committed when a leaf is chosen. `AntCascaderView` renders the same columns inline when you need the panel without a popup.

### 3. Date and time fields

```dart
class DateTimeForm extends StatefulWidget {
  const DateTimeForm({super.key});

  @override
  State<DateTimeForm> createState() => _DateTimeFormState();
}

class _DateTimeFormState extends State<DateTimeForm> {
  DateTime? _date = DateTime(2025, 3, 18);
  TimeOfDay? _time = const TimeOfDay(hour: 9, minute: 30);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AntDatePicker(
          value: _date,
          format: 'yyyy-MM-dd',
          placeholder: 'Pick a date',
          onChange: (date) => setState(() => _date = date),
        ),
        const SizedBox(height: 12),
        AntTimePicker(
          value: _time,
          minuteStep: 5,
          placeholder: 'Pick a time',
          onChange: (time) => setState(() => _time = time),
        ),
      ],
    );
  }
}
```

Both fields open their own sheet and report `null` when cleared (`allowClear: true` enables the clear affordance). `minuteStep` / `hourStep` thin out the wheel options for coarse scheduling.

Validation state and selectable bounds can be handed to the field directly, without wrapping it:

```dart
AntDatePicker(
  value: _date,
  status: AntInputStatus.error,        // error / warning colors the border and ring
  minDate: DateTime(2025, 1, 1),       // inclusive lower bound
  maxDate: DateTime(2025, 12, 31),     // inclusive upper bound
  disabledDate: (date) => date.weekday != DateTime.monday, // custom rule
  onChange: (date) => setState(() => _date = date),
);
```

`status` is available on `AntDatePicker`, `AntTimePicker` and `AntDateRangePicker`; dates matched by `disabledDate` render grey and cannot be tapped, and the rule combines with `minDate` / `maxDate`.

### 4. Date ranges and localization

```dart
AntDateRangePicker(
  defaultValue: AntDateRange.sorted(DateTime(2025, 3, 1), DateTime(2025, 3, 10)),
  allowClear: true,
  onChange: (range) => setState(() => _range = range),
);

// Date-time range: showTime defaults to true on this subclass.
AntDateTimeRangePicker(
  value: _dateTimeRange,
  onChange: (range) => setState(() => _dateTimeRange = range),
);
```

- The first click sets the start, the second click sets the end; an end earlier than the start is normalized automatically. With `showTime` the range is committed only after the confirm button, and the time columns appear inside the same panel.
- `minDate` / `maxDate` disable out-of-range days, and `allowClear` resets the range to `null`.
- `disabledDate` disables individual days (weekdays only, for example) and `status` makes the trigger follow form validation state.
- Pass `locale: AntPickerLocale.zh` / `.en` / `.ja` (15 built-in presets) to pin a language, or wrap the tree once in `AntPickerLocaleProvider`; without either, the pickers follow the app's `Localizations` locale and fall back to Chinese.
- `format` / `timeFormat` accept antd patterns such as `yyyy-MM-dd`, `yyyy年M月d日`, `HH:mm` or `hh:mm a`, and override the locale defaults.

## Demo

- Live demo: https://flutter-open.github.io/antd-flutter/picker/
- Found a bug or have a question? [Open an issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)

## Project structure

```text
packages/antd_picker/
├── lib/
│   ├── antd_picker.dart                 # barrel export
│   └── src/
│       ├── picker/                      # wheel sheet and column model
│       ├── cascader/                    # cascading field and inline view
│       ├── date_picker/                 # date field, range picker, month panel
│       ├── locale/                      # AntPickerLocale presets + date formatting
│       └── time_picker/                 # TimeOfDay field + shared wheel
├── example/lib/main.dart                # runnable gallery
├── docs/api-index.md                    # generated API index
└── README.md
```

## License

MIT. See the repository [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE).

## ☕ Buy Me a Coffee

If this project has been helpful to you, you are welcome to buy me a coffee. Thank you for your support!

| Alipay | WeChat |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="Alipay QR code" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="WeChat QR code" /> |
