# antd_flutter_ui - Ant Design Flutter 的基础组件层

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_flutter_ui/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_flutter_ui/README_CN.md)

## 定位与设计

`antd_flutter_ui` 是 Ant Design Flutter 体系的基础组件层。它提供主包与各个独立组件包共同依赖的通用组件，以及弹层定位、滚轮选择、快捷键、日历网格等共享引擎。它不是一套独立的设计系统，需要与 [`antd_theme`](../antd_theme/README.md) 配合使用，由后者提供 `AntThemeData`、设计令牌与缩放模型。

- **基础层，依赖方向固定。** 独立组件包 → `antd_flutter_ui` → `antd_theme` / `antd_tokens` / `antd_color` / `antd_icons_flutter`；独立组件包之间互不依赖。
- **两套上游风格，一套 API。** 桌面端组件对齐 Ant Design v6，移动端组件对齐 antd-mobile v5；选择依据是平台与布局数据，而不是全局编译开关。
- **泛型数据参数。** 数据驱动组件接收 `List<T>`，并通过 `keyOf`、`labelOf`、`labelBuilder`、`itemBuilder` 等访问器渲染，业务模型无需转换为组件专用选项对象。
- **统一尺寸体系。** 所有设计值都经过 `theme.s(...)`，由当前 `AntScale` 换算；组件不读取 `ScreenUtil`，也不硬编码像素值，改变一个缩放因子即可同时调整字号、控件高度、圆角与间距。
- **共享引擎集中在此。** 弹层定位、滚轮选择列、快捷键与日历网格在 `lib/src/engines/` 中实现一次，供独立组件包复用。
- **不接管应用外壳。** 本包不创建 `MaterialApp`；请自行用 `AntTheme` 包裹应用，它会同时注入 Ant 作用域与派生的 Flutter 主题，使 Material 组件自动获得 Ant 样式。

## 安装

需要 Dart `>=3.0.0 <4.0.0` 与 Flutter `>=3.10.0`。

```yaml
dependencies:
  antd_flutter_ui: ^1.0.0
  antd_theme: ^1.0.0
  material_ui: ^1.11.0
```

`antd_theme` 是直接依赖，因为需要向 `AntTheme` 传入 `AntThemeData`。`material_ui` 提供 `MaterialApp`、`Scaffold` 及示例中使用的组件再导出。

## 快速开始

以下应用完整且可直接运行：

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

只引入需要的组件，例如 `import 'package:antd_flutter_ui/antd_flutter_ui.dart' show AntButton, AntButtonType, AntInput;`。主题相关类型来自 `antd_theme`。

### 按钮

`AntButton` 使用 `onTap` 而不是 Material 的 `onPressed`，`child` 可以是任意组件。

```dart
AntButton(
  type: AntButtonType.primary,
  onTap: () {},
  child: const Text('Submit'),
);
```

### 输入框

提供 `value` 时为受控模式，使用 `defaultValue` 时为非受控模式。

```dart
AntInput(
  placeholder: 'Type something',
  onChange: (value) {},
);
```

### 选择器

`AntSelect` 支持单选 / 多选，多选超出 `maxTagCount` 的标签折叠为 `+N` 计数；`status` 让边框与光环跟随表单校验态。

```dart
AntSelect<String>(
  mode: AntSelectMode.multiple,
  options: const ['Hangzhou', 'Ningbo', 'Suzhou', 'Nanjing'],
  defaultValues: const ['Hangzhou', 'Ningbo', 'Suzhou', 'Nanjing'],
  maxTagCount: 2,                 // 只显示 2 个标签，其余显示 +2
  status: AntInputStatus.error,   // 校验失败时的红框 + 红环
);
```

### 主题

`AntTheme` 接收 `AntThemeData` 并派生 Flutter 主题。通过 `AntTheme.of(context)` 读取当前主题，用 `theme.s(...)` 换算设计值。

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

## 演示

- 在线演示：https://flutter-open.github.io/antd-flutter/
- 发现问题或有疑问？[提交 Issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)

## 项目结构

```text
packages/antd_flutter_ui/
├── lib/
│   ├── antd_flutter_ui.dart          # 公共出口（全部导出）
│   └── src/
│       ├── basic/                    # 按钮、排版、布局、栅格、间距、分割线、工具提示
│       ├── data_entry/               # 输入框、选择器、勾选、单选、开关、滑块、评分、上传
│       ├── display/                  # 头像、徽标、卡片、列表、气泡卡片族、统计、漫游
│       ├── feedback/                 # 警告、对话框、抽屉、消息、模态框、轻提示、进度
│       ├── navigation/               # 标签页族、菜单、面包屑、分页、步骤条、导航栏
│       ├── general/                  # 浮动按钮族
│       ├── misc/                     # App、ConfigProvider、固钉、边框光束
│       └── engines/                  # 弹层、滚轮选择、快捷键、日历网格
├── docs/api-index.md                 # 生成的 API 索引
├── test/                             # 组件与引擎测试
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
