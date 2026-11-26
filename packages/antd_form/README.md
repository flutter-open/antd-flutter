# antd_form - Form state, validation and layout for Ant Design Flutter

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_form/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_form/README_CN.md)

## Positioning & design

`antd_form` adds form state, validation and antd-mobile-style layout on top of [`antd_flutter_ui`](../antd_flutter_ui/README.md). `AntForm` owns the values, `AntFormItem` binds a single field, and `AntFormController` exposes values, errors, validation and reset. The package is deliberately small: two dependencies, no state-management library, and any widget can participate through a builder.

- **State lives in one controller.** `AntFormController` stores `name → value`, `name → error` and `name → rules`. Fields register themselves on mount and unregister on dispose, so rebuilding or partially removing a form does not leak values.
- **Controlled outside, uncontrolled inside.** Pass `controller` to operate the form from elsewhere; without one, `AntForm` creates and owns a controller. `initialValues` supplies defaults by field name.
- **Validation is data, not widgets.** Rules are plain `AntFormFieldRule` objects covering `required`, `pattern`, `min` / `max`, `minLength` / `maxLength`, `type` and a custom `validator`. The same rules work for inline validation and for programmatic `validate()`.
- **Per-field validation moment.** `AntFormValidateTrigger.onChange` validates while the user types; `onSubmit` validates only when the form is submitted.
- **Binding through a builder.** `AntFormItem<T>` passes an `AntFormField<T>` with `value`, `errorText` and `didChange`, so the package stays agnostic about the control you use and avoids a parallel `TextEditingController` lifecycle.
- **Layout belongs to the form.** `vertical`, `horizontal` (with `labelWidth`) and `inline` are form-level settings; items read them from the surrounding `AntForm` scope.
- **Spacing and hint colors are configurable.** `AntForm.itemMarginBottom` / `AntFormItem.marginBottom` override the default 16px bottom padding (items with `help` / `extra` text default to none), `hintColor` (form and item level) overrides the hint text color (`colorTextDescription` by default), and `labelColor` recolors the label.
- **No hidden submit button.** The form never renders actions. Choose where submit and reset live and call `AntForm.controllerOf(context)?.submit()` or your own controller reference.

## Installation

Requires Dart `>=3.0.0 <4.0.0` and Flutter `>=3.10.0`.

```yaml
dependencies:
  antd_form: ^1.0.0
  antd_flutter_ui: ^1.0.0
  antd_theme: ^1.0.0
  material_ui: ^1.11.0
```

`antd_flutter_ui` supplies the field widgets such as `AntInput`, `antd_theme` supplies `AntTheme` / `AntThemeData`, and `material_ui` provides `MaterialApp` and `Scaffold`.

## Quick start

A complete, runnable form:

```dart
import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_form/antd_form.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(const FormDemoApp());

class FormDemoApp extends StatelessWidget {
  const FormDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AntTheme(
      data: AntThemeData.light(),
      child: MaterialApp(
        theme: AntThemeData.light().toThemeData(),
        home: const FormDemoPage(),
      ),
    );
  }
}

class FormDemoPage extends StatelessWidget {
  const FormDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AntAppBar(title: const Text('Ant Form')),
      ),
      body: ListView(
        padding: EdgeInsets.all(theme.s(16)),
        children: [
          AntForm(
            initialValues: const {'username': 'antd'},
            onFinish: (values) {},
            onFinishFailed: (errors) {},
            children: [
              AntFormItem<String>(
                name: 'username',
                label: 'Username',
                required: true,
                rules: [
                  AntFormFieldRule.required(
                    message: 'Username is required',
                  ),
                  AntFormFieldRule(
                    minLength: 3,
                    maxLength: 12,
                    message: 'Use 3 to 12 characters',
                  ),
                ],
                builder: (field) => AntInput(
                  value: field.value ?? '',
                  placeholder: 'Enter username',
                  onChange: field.didChange,
                ),
              ),
              Builder(
                builder: (buttonContext) => AntButton(
                  type: AntButtonType.primary,
                  block: true,
                  onTap: () => AntForm.controllerOf(buttonContext)?.submit(),
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

`onFinish` receives the validated values; `onFinishFailed` receives the error map.

## API

[API reference](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_form/docs/api-index.md)

Import `package:antd_form/antd_form.dart` for the form widgets. The snippets use `AntInput`, `AntTheme` and Material widgets from the packages listed above.

### Tuning item spacing and hint colors

```dart
AntForm(
  itemMarginBottom: 24,        // form level: 24px below every item
  hintColor: Colors.grey,      // form level: help / extra text color
  children: [
    AntFormItem<String>(
      name: 'address',
      label: 'Legal representative address',
      hintColor: Colors.blueGrey, // item level wins
      marginBottom: 4,            // item level wins
      builder: (field) => AntInput(
        value: field.value as String?,
        onChange: field.didChange,
      ),
    ),
  ],
);
```

Without configuration the bottom spacing is the theme `margin` (16); as soon as an item renders `help` / `error` / `extra` text it defaults to zero, letting the text row provide the gap — the same rule as antd `.ant-form-item-with-help`.

### Field with a custom validator

Any widget can be a field; the builder receives the current value and `didChange`.

```dart
AntFormItem<String>(
  name: 'email',
  label: 'Email',
  required: true,
  rules: [
    AntFormFieldRule(
      validator: (value) {
        final text = value as String? ?? '';
        return text.contains(' ') ? 'Spaces are not allowed' : null;
      },
    ),
  ],
  builder: (field) => AntInput(
    value: field.value ?? '',
    onChange: field.didChange,
  ),
);
```

### Form with an external controller

```dart
final form = AntFormController();

AntForm(
  controller: form,
  layout: AntFormLayout.horizontal,
  labelWidth: 96,
  children: [/* AntFormItem widgets */],
);
```

### Validate and reset programmatically

```dart
Future<void> save(AntFormController form) async {
  final valid = await form.validate();
  if (!valid) {
    debugPrint('${form.getErrors()}');
    return;
  }
  debugPrint('${form.getValues()}');
  form.reset();
}
```

## Demo

- Live demo: https://flutter-open.github.io/antd-flutter/form/
- Found a bug or have a question? [Open an issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)

## Project structure

```text
packages/antd_form/
├── lib/
│   ├── antd_form.dart                # Public barrel
│   └── src/form/
│       ├── ant_form.dart             # AntForm, AntFormItem, AntFormField, AntFormController
│       └── ant_form_types.dart       # Layouts, triggers, rules, rule types
├── example/                          # Gallery app for manual verification
├── docs/api-index.md                 # Generated API index
├── test/ant_form_test.dart
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
