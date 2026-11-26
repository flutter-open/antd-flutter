# antd_form - Ant Design Flutter 的表单状态、校验与布局

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_form/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_form/README_CN.md)

## 定位与设计

`antd_form` 在 [`antd_flutter_ui`](../antd_flutter_ui/README.md) 之上提供表单状态、校验与 antd-mobile 风格布局。`AntForm` 持有值，`AntFormItem` 绑定单个字段，`AntFormController` 对外提供值、错误、校验与重置能力。包刻意保持轻量：只依赖两个包，不引入状态管理库，任何组件都可以通过 builder 接入。

- **状态集中在一个控制器。** `AntFormController` 保存 `name → value`、`name → error` 与 `name → rules`。字段在挂载时注册、销毁时注销，表单重建或局部移除不会残留值。
- **外层受控，内层非受控。** 传入 `controller` 可从外部操作表单；未传入时 `AntForm` 自行创建并持有控制器。`initialValues` 按字段名提供默认值。
- **校验是数据，不是组件。** 规则是普通的 `AntFormFieldRule` 对象，支持 `required`、`pattern`、`min` / `max`、`minLength` / `maxLength`、`type` 和自定义 `validator`；同一组规则既用于即时校验，也用于 `validate()`。
- **每个字段可独立选择校验时机。** `AntFormValidateTrigger.onChange` 在输入时校验，`onSubmit` 仅在提交时校验。
- **通过 builder 绑定。** `AntFormItem<T>` 向 builder 传入 `AntFormField<T>`（`value`、`errorText`、`didChange`），因此包不关心你使用哪种控件，也无需额外维护 `TextEditingController` 生命周期。
- **布局属于表单。** `vertical`、`horizontal`（配合 `labelWidth`）和 `inline` 是表单级配置，字段从 `AntForm` 作用域读取。
- **间距与提示色可配。** `AntForm.itemMarginBottom` / `AntFormItem.marginBottom` 覆盖默认 16px 底部间距（带 `help` / `extra` 的字段默认不再额外留白），`hintColor`（表单级与字段级）覆盖提示文案颜色（默认 `colorTextDescription`），`labelColor` 覆盖标签颜色。
- **不内置提交按钮。** 表单不渲染操作区；提交与重置的位置由你决定，可调用 `AntForm.controllerOf(context)?.submit()` 或使用自己的控制器引用。

## 安装

需要 Dart `>=3.0.0 <4.0.0` 与 Flutter `>=3.10.0`。

```yaml
dependencies:
  antd_form: ^1.0.0
  antd_flutter_ui: ^1.0.0
  antd_theme: ^1.0.0
  material_ui: ^1.11.0
```

`antd_flutter_ui` 提供 `AntInput` 等字段组件，`antd_theme` 提供 `AntTheme` / `AntThemeData`，`material_ui` 提供 `MaterialApp` 与 `Scaffold`。

## 快速开始

以下表单完整且可直接运行：

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

`onFinish` 在校验通过后收到表单值，`onFinishFailed` 收到错误映射。

## API

[API reference](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_form/docs/api-index.md)

通过 `import 'package:antd_form/antd_form.dart';` 引入表单组件。以下片段使用上面列出的包提供的 `AntInput`、`AntTheme` 与 Material 组件。

### 调整字段间距与提示色

```dart
AntForm(
  itemMarginBottom: 24,        // 表单级：每个字段距下一行 24
  hintColor: Colors.grey,      // 表单级：help / extra 文案颜色
  children: [
    AntFormItem<String>(
      name: 'address',
      label: '法人身份证地址',
      hintColor: Colors.blueGrey, // 字段级优先
      marginBottom: 4,            // 字段级优先
      builder: (field) => AntInput(
        value: field.value as String?,
        onChange: field.didChange,
      ),
    ),
  ],
);
```

未配置时，字段底部间距取主题的 `margin`（16）；一旦字段出现 `help` / `error` / `extra` 文案，默认间距归零，由文案自身的行高充当间隔 —— 与 antd `.ant-form-item-with-help` 一致。

### 带自定义校验器的字段

任何组件都可以作为字段；builder 会收到当前值与 `didChange` 回调。

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

### 使用外部控制器的表单

```dart
final form = AntFormController();

AntForm(
  controller: form,
  layout: AntFormLayout.horizontal,
  labelWidth: 96,
  children: [/* AntFormItem 列表 */],
);
```

### 以代码触发校验与重置

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

## 演示

- 在线演示：https://flutter-open.github.io/antd-flutter/form/
- 发现问题或有疑问？[提交 Issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)

## 项目结构

```text
packages/antd_form/
├── lib/
│   ├── antd_form.dart                # 公共出口
│   └── src/form/
│       ├── ant_form.dart             # AntForm、AntFormItem、AntFormField、AntFormController
│       └── ant_form_types.dart       # 布局、校验时机、规则与规则类型
├── example/                          # 用于手动验证的示例应用
├── docs/api-index.md                 # 生成的 API 索引
├── test/ant_form_test.dart
├── CHANGELOG.md
├── README.md
├── README_CN.md
└── pubspec.yaml
```

## 许可证

MIT。详见仓库根目录的 [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE)。

## ☕ 请我喝咖啡

如果这个项目帮到了你，欢迎请我喝杯咖啡，感谢你的支持！

| 支付宝 | 微信 |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="支付宝收款码" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="微信收款码" /> |
