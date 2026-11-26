# antd_flutter_plus - Umbrella package for Ant Design Flutter

[English](https://github.com/flutter-open/antd-flutter/blob/master/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/README_CN.md)

`antd_flutter_plus` is the umbrella package of the Ant Design Flutter suite. One dependency brings in the design tokens, the theme engine, the icon font, the base component layer and 21 independently published packages, with a single version line to upgrade.

The suite is built for Flutter on mobile, desktop and web. Desktop styling follows **Ant Design v6**, mobile styling follows **antd-mobile v5**, and sizing flows through `AntScale` so the same widget tree adapts to phone, tablet and desktop windows. The umbrella package only aggregates and re-exports; each package under `packages/` remains usable on its own.

## Positioning and design trade-offs

- **One dependency, many packages.** `antd_flutter_plus` depends on and re-exports the whole suite, so an application can start with a single line in `pubspec.yaml` instead of wiring 21 packages by hand.
- **Aggregation, not duplication.** The umbrella contains no component implementations. It re-exports each package's public library and adds a small platform layer (`lib/src/platform/`). Fixes and features live in the owning package.
- **Standalone packages stay first-class.** Nothing in the suite requires the umbrella. Any package can be depended on directly, which keeps the dependency graph small for applications that need only one or two capabilities.
- **One version line.** All packages ship on the unified `1.0.0` line (`antd_icons_flutter` is the only patch release, `1.0.1`, for icon assets), and the umbrella constrains them with `^1.0.0` ranges. Upgrading the umbrella upgrades the suite together.
- **Layered dependencies.** Foundations (`antd_color`, `antd_tokens`, `antd_theme`, `antd_icons_flutter`) → base layer (`antd_flutter_ui`) → standalone feature packages. Feature packages never depend on each other.
- **Two style sources, one API.** Form-factor decides whether a widget follows antd v6 or antd-mobile v5; application code does not branch on platform for styling.
- **Tree shaking still applies.** Importing the umbrella does not force every package into the binary; unused Dart code is removed by the compiler. The trade-off is a larger dependency graph and longer `pub get`/analysis, not a larger release binary.

## Installation

Requires Dart `>=3.0.0 <4.0.0` and Flutter `>=3.10.0`.

```yaml
dependencies:
  antd_flutter_plus: ^1.0.0
  material_ui: ^1.11.0
```

`material_ui` is listed explicitly because the examples import `MaterialApp` and `Scaffold` from it.

## Quick start

```dart
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(const PlusDemoApp());

class PlusDemoApp extends StatelessWidget {
  const PlusDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AntTheme(
      data: AntThemeData.light(),
      child: MaterialApp(
        theme: AntThemeData.light().toThemeData(),
        home: const PlusDemoPage(),
      ),
    );
  }
}

class PlusDemoPage extends StatelessWidget {
  const PlusDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Scaffold(
      backgroundColor: theme.colorBgLayout,
      appBar: AntAppBar(title: const Text('Ant Design Flutter')),
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
            value: '',
            placeholder: 'Type something',
            onChange: (value) {},
          ),
          SizedBox(height: theme.s(12)),
          AntSwitch(
            defaultChecked: true,
            onChange: (checked) {},
          ),
        ],
      ),
    );
  }
}
```

> `AntTheme` must wrap the application (above `MaterialApp`). It injects the Ant scope and a derived Flutter `Theme`; `AntThemeData.light().toThemeData()` keeps Material widgets on the same tokens.

## Packages

The umbrella aggregates the following 21 packages. Paths are relative to the repository root.

### Foundations and base layer

| Package | What it provides | Path |
| --- | --- | --- |
| `antd_color` | Color model, palettes and color parsing | `packages/antd_color` |
| `antd_tokens` | Seed tokens, token algorithms, color maps and shadows | `packages/antd_tokens` |
| `antd_theme` | `AntThemeData`, `AntScale`/`AntTheme`, shadows, breakpoints and screen adaptation | `packages/antd_theme` |
| `antd_icons_flutter` | 850+ outlined/filled icon font, two-tone SVG support and `AntdIcon` | `packages/antd_icons_flutter` |
| `antd_flutter_ui` | Base component layer and shared engines (popup, wheel picker, hotkeys) | `packages/antd_flutter_ui` |

### Data entry and forms

| Package | What it provides | Path |
| --- | --- | --- |
| `antd_form` | `AntForm` / `AntFormItem` / `AntFormController` with declarative validation | `packages/antd_form` |
| `antd_picker` | Picker, date picker, time picker and cascader | `packages/antd_picker` |
| `antd_upload` | File upload list with progress, preview and removal | `packages/antd_upload` |
| `antd_keyboard` | Number keyboard, passcode input and virtual input | `packages/antd_keyboard` |
| `antd_calendar` | Calendar, calendar picker and picker view | `packages/antd_calendar` |

### Data display

| Package | What it provides | Path |
| --- | --- | --- |
| `antd_table` | Sorting, filtering, fixed columns, selection, expansion, tree data, pagination, summaries and grouped headers | `packages/antd_table` |
| `antd_tree` | Tree and tree-select with checkable nodes | `packages/antd_tree` |
| `antd_transfer` | Transfer list and tree transfer | `packages/antd_transfer` |
| `antd_carousel` | PageView carousel with autoplay, loop, dots, arrows, vertical mode and controller | `packages/antd_carousel` |
| `antd_masonry` | Greedy-column masonry layout and sliver variant | `packages/antd_masonry` |
| `antd_qrcode` | QR rendering with error levels, status overlays and center icon | `packages/antd_qrcode` |
| `antd_image_viewer` | Fullscreen image preview with zoom, pan and paging | `packages/antd_image_viewer` |

### Interaction and overlays

| Package | What it provides | Path |
| --- | --- | --- |
| `antd_refresh` | Pull-to-refresh gesture state machine and indicator | `packages/antd_refresh` |
| `antd_swipe_action` | Swipe action cells with configurable action buttons | `packages/antd_swipe_action` |
| `antd_splitter` | Resizable split panels with constraints | `packages/antd_splitter` |
| `antd_floating` | Floating panel and floating bubble | `packages/antd_floating` |

The umbrella also re-exports selected entry points that are convenient at application level: `AntDatePicker` / `AntTimePicker` / `AntDateRangePicker` / `AntDateTimeRangePicker` / `AntCascader` / `AntPickerLocale` from `antd_picker`, `AntPullToRefresh` from `antd_refresh`, `AntTable`, `AntForm`, and `AntSwipeAction`.

## Umbrella or standalone packages?

| Situation | Recommendation |
| --- | --- |
| Application uses several component families | Use `antd_flutter_plus` — one dependency, one version to upgrade |
| Prototype, demo or internal tool | Use `antd_flutter_plus` — fastest path from `pub get` to a running UI |
| Only one capability is needed (e.g. QR codes, a table) | Depend on that package directly and skip the rest |
| Sensitive to dependency graph, `pub get` time or package publishing constraints | Use standalone packages; add `antd_theme` and `antd_flutter_ui` only when the widgets need them |
| You already depend on individual packages | Keep them; the umbrella is additive, not a replacement |

Both paths share the same widgets and tokens, so migrating between them is a `pubspec.yaml` change plus import updates.

## Theme and scaling

```dart
AntTheme(
  data: AntThemeData.light(scale: const AntScale(1.1)),
  child: MaterialApp(
    theme: AntThemeData.light().toThemeData(),
    home: const HomePage(),
  ),
)
```

| API | Role |
| --- | --- |
| `AntThemeData.light()` / `.dark()` | Light or dark theme from the default seed |
| `AntThemeData.fromSeed(seed, isDark: ...)` | Theme from a custom `AntSeedToken` |
| `AntScale(factor)` | Fixed scale factor; `AntScale.none` equals `1.0` |
| `AntScale.auto(context)` | Factor from the shortest side (base 375, clamped 0.9–1.2); desktop returns `AntScale.none` |
| `AntTheme.of(context)` | Nearest `AntThemeData`, falling back to light |
| `theme.s(value)` | Design value × scale factor |

Size-related seed tokens are scaled once when `AntThemeData` is built; widgets call `theme.s(...)` for their own spacing and dimensions. Changing the factor in one place rescales typography, control heights, radii and spacing together — do not mix in `ScreenUtil` or hard-coded pixels.

## Example

The `example/` application is a gallery built with the umbrella package and `device_preview`. It has its own `pubspec.yaml`.

```bash
cd example
flutter pub get
flutter run -d chrome    # or: flutter run -d macos
```

## Demos

Every package ships an interactive web demo, built from its own `example/` app and deployed with the documentation site.

| Demo | URL | What it shows |
| --- | --- | --- |
| Umbrella gallery (all UI components) | https://flutter-open.github.io/antd-flutter/ | 101+ components |
| antd_icons_flutter | https://flutter-open.github.io/antd-flutter/icons/ | Icon gallery |
| antd_color | https://flutter-open.github.io/antd-flutter/color/ | Color palette |
| antd_tokens | https://flutter-open.github.io/antd-flutter/tokens/ | Design tokens |
| antd_theme | https://flutter-open.github.io/antd-flutter/theme/ | Theming and AntScale |
| antd_calendar | https://flutter-open.github.io/antd-flutter/calendar/ | Calendar and CalendarPicker |
| antd_form | https://flutter-open.github.io/antd-flutter/form/ | Form validation |
| antd_picker | https://flutter-open.github.io/antd-flutter/picker/ | Picker / Cascader / Date / Time |
| antd_upload | https://flutter-open.github.io/antd-flutter/upload/ | Upload |
| antd_transfer | https://flutter-open.github.io/antd-flutter/transfer/ | Transfer |
| antd_tree | https://flutter-open.github.io/antd-flutter/tree/ | Tree and TreeSelect |
| antd_table | https://flutter-open.github.io/antd-flutter/table/ | Table |
| antd_keyboard | https://flutter-open.github.io/antd-flutter/keyboard/ | Number / Passcode / Virtual keyboard |
| antd_qrcode | https://flutter-open.github.io/antd-flutter/qr_code/ | QR code |
| antd_refresh | https://flutter-open.github.io/antd-flutter/refresh/ | Pull to refresh |
| antd_splitter | https://flutter-open.github.io/antd-flutter/splitter/ | Splitter |
| antd_swipe_action | https://flutter-open.github.io/antd-flutter/swipe_action/ | Swipe action |
| antd_image_viewer | https://flutter-open.github.io/antd-flutter/image_viewer/ | Image viewer |
| antd_carousel | https://flutter-open.github.io/antd-flutter/carousel/ | Carousel |
| antd_masonry | https://flutter-open.github.io/antd-flutter/masonry/ | Masonry |
| antd_floating | https://flutter-open.github.io/antd-flutter/floating/ | Floating UI |

## Issues

- Bug reports and feature requests: [Open an issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)
- Documentation site: https://flutter-open.github.io/antd-flutter/

## Resources

| Resource | URL |
| --- | --- |
| Documentation site | https://flutter-open.github.io/antd-flutter/ |
| Icon gallery | https://flutter-open.github.io/antd-flutter/icons/ |
| Repository | https://github.com/flutter-open/antd-flutter |
| Issue tracker | https://github.com/flutter-open/antd-flutter/issues |

## Project structure

```text
antd-flutter/
├── lib/
│   ├── antd_flutter_plus.dart        # Umbrella barrel
│   └── (barrel only)                 # Re-exports packages; logic lives in antd_theme / antd_flutter_ui
├── packages/                         # 21 packages
│   ├── antd_color/
│   ├── antd_tokens/
│   ├── antd_theme/
│   ├── antd_icons_flutter/
│   ├── antd_flutter_ui/
│   ├── antd_form/
│   ├── antd_picker/
│   ├── antd_table/
│   └── ...
├── example/                          # Gallery application (web demo)
├── pubspec.yaml
└── README.md
```

## Versioning

The suite follows one version line: every package is released at `1.0.0` (`antd_icons_flutter` at `1.0.1` for an icon-asset patch), and the umbrella declares `^1.0.0` dependencies plus path overrides for the monorepo. Breaking changes to any package bump the suite together.

## License

MIT License. See [LICENSE](LICENSE).

## ☕ Buy Me a Coffee

If this project has been helpful to you, you are welcome to buy me a coffee. Thank you for your support!

| Alipay | WeChat |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="Alipay QR code" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="WeChat QR code" /> |
