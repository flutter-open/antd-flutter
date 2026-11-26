# antd_flutter_ui - Base component layer for Ant Design Flutter

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_flutter_ui/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_flutter_ui/README_CN.md)

## Positioning & design

`antd_flutter_ui` is the base component layer of the Ant Design Flutter suite. It provides the shared widgets that the umbrella package and every standalone component package build on, plus the shared engines behind popups, pickers and keyboard interaction. It is not a standalone design system: it works together with [`antd_theme`](../antd_theme/README.md), which owns `AntThemeData`, the design tokens and the scaling model.

- **Base layer with a fixed dependency direction.** Standalone packages → `antd_flutter_ui` → `antd_theme` / `antd_tokens` / `antd_color` / `antd_icons_flutter`. Standalone packages never depend on each other.
- **Two upstream styles, one API.** Desktop widgets follow Ant Design v6; mobile widgets follow antd-mobile v5. The choice is derived from platform and layout data, not from a global build flag.
- **Generic data parameters.** Data-driven widgets take `List<T>` plus accessors such as `keyOf`, `labelOf`, `labelBuilder` and `itemBuilder`, so business models do not need conversion into component-specific option objects.
- **One sizing system.** Design values go through `theme.s(...)`, which applies the active `AntScale`. Components never read `ScreenUtil` and never hard-code pixel values, so one scale factor rescales typography, control heights, radii and spacing together.
- **Shared engines live here.** Popup placement, wheel-picker columns, hotkeys and the calendar grid are implemented once under `lib/src/engines/` and reused by the standalone packages.
- **No application shell.** The package never creates a `MaterialApp`. Wrap your app in `AntTheme` yourself; it injects both the Ant scope and a derived Flutter theme, so Material widgets pick up Ant styling automatically.

## Installation

Requires Dart `>=3.0.0 <4.0.0` and Flutter `>=3.10.0`.

```yaml
dependencies:
  antd_flutter_ui: ^1.0.0
  antd_theme: ^1.0.0
  material_ui: ^1.11.0
```

`antd_theme` is a direct dependency because you pass `AntThemeData` to `AntTheme`. `material_ui` supplies `MaterialApp`, `Scaffold` and the widget re-exports used in the examples.

## Quick start

The following application is complete and runnable:

```dart
import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(const UiDemoApp());

class UiDemoApp extends StatelessWidget {
  const UiDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AntTheme(
      data: AntThemeData.light(),
      child: MaterialApp(
        theme: AntThemeData.light().toThemeData(),
        home: const UiDemoPage(),
      ),
    );
  }
}

class UiDemoPage extends StatelessWidget {
  const UiDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Scaffold(
      backgroundColor: theme.colorBgLayout,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AntAppBar(title: const Text('Ant Design Flutter')),
      ),
      body: ListView(
        padding: EdgeInsets.all(theme.s(16)),
        children: [
          AntButton(
            type: AntButtonType.primary,
            onTap: () {},
            child: const Text('Primary button'),
          ),
          SizedBox(height: theme.s(12)),
          AntInput(
            placeholder: 'Type something',
            onChange: (value) {},
          ),
        ],
      ),
    );
  }
}
```

## API

[API reference](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_flutter_ui/docs/api-index.md)

Import only the widgets you use, for example `import 'package:antd_flutter_ui/antd_flutter_ui.dart' show AntButton, AntButtonType, AntInput;`. Theme types come from `antd_theme`.

### Button

`AntButton` uses `onTap` rather than Material's `onPressed`, and accepts any child widget.

```dart
AntButton(
  type: AntButtonType.primary,
  onTap: () {},
  child: const Text('Submit'),
);
```

### Input

`AntInput` is controlled when `value` is supplied and uncontrolled when `defaultValue` is used.

```dart
AntInput(
  placeholder: 'Type something',
  onChange: (value) {},
);
```

### Select

`AntSelect` supports single and multiple modes; in multiple mode tags beyond `maxTagCount` collapse into a `+N` counter, and `status` forwards form validation state to the border and ring.

```dart
AntSelect<String>(
  mode: AntSelectMode.multiple,
  options: const ['Hangzhou', 'Ningbo', 'Suzhou', 'Nanjing'],
  defaultValues: const ['Hangzhou', 'Ningbo', 'Suzhou', 'Nanjing'],
  maxTagCount: 2,                 // two tags, the rest collapse into +2
  status: AntInputStatus.error,   // red border + red ring on validation errors
);
```

### Theme

`AntTheme` takes an `AntThemeData` and derives the Flutter theme from it. Read the active theme with `AntTheme.of(context)` and scale design values with `theme.s(...)`.

```dart
final data = AntThemeData.light(scale: const AntScale(1.15));

AntTheme(
  data: data,
  child: MaterialApp(
    theme: data.toThemeData(),
    home: const Scaffold(body: Text('Hello')),
  ),
);
```

## Demo

- Live demo: https://flutter-open.github.io/antd-flutter/
- Found a bug or have a question? [Open an issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)

## Project structure

```text
packages/antd_flutter_ui/
├── lib/
│   ├── antd_flutter_ui.dart          # Public barrel (all exports)
│   └── src/
│       ├── basic/                    # Button, typography, layout, grid, space, divider, tooltip
│       ├── data_entry/               # Input, select, checkbox, radio, switch, slider, rate, uploader
│       ├── display/                  # Avatar, badge, card, list, popover family, statistic, tour
│       ├── feedback/                 # Alert, dialog, drawer, message, modal, toast, progress
│       ├── navigation/               # Tabs family, menu, breadcrumb, pagination, steps, bars
│       ├── general/                  # FloatButton family
│       ├── misc/                     # App, ConfigProvider, Affix, BorderBeam
│       └── engines/                  # Popup, wheel picker, hotkeys, calendar grid
├── docs/api-index.md                 # Generated API index
├── test/                             # Widget and engine tests
├── CHANGELOG.md
├── README.md
├── README_CN.md
└── pubspec.yaml
```

## License

MIT. See the repository root [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE).

## ☕ Buy Me a Coffee

If this project has been helpful to you, you are welcome to buy me a coffee. Thank you for your support!

| Alipay | WeChat |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="Alipay QR code" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="WeChat QR code" /> |
