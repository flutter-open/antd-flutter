# antd_flutter_plus - Ant Design Flutter 伞包

[English](https://github.com/flutter-open/antd-flutter/blob/master/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/README_CN.md)

`antd_flutter_plus` 是 Ant Design Flutter 组件体系的伞包。引入一个依赖，即可获得设计变量、主题引擎、图标字体、基础组件层，以及 21 个独立发布的包，并且只需跟随一条版本线升级。

组件体系面向 Flutter 的移动端、桌面端和 Web。桌面样式对齐 **Ant Design v6**，移动样式对齐 **antd-mobile v5**，尺寸通过 `AntScale` 统一缩放，因此同一棵组件树可以适配手机、平板和桌面窗口。伞包只做聚合与再导出；`packages/` 下的每个包仍然可以独立使用。

## 定位与设计取舍

- **一个依赖，多个包。** `antd_flutter_plus` 依赖并再导出整个组件体系，应用只需在 `pubspec.yaml` 写一行，而不必手工接入 21 个包。
- **只聚合，不复制。** 伞包不包含组件实现，只再导出各包的公共库，并额外提供一小层平台适配（`lib/src/platform/`）。功能与修复都归属各自的包。
- **独立包仍是一等公民。** 组件体系不强制使用伞包。任何包都可以被直接依赖，只用一两个能力时依赖图更小。
- **统一版本线。** 所有包都发布在统一的 `1.0.0` 线上（`antd_icons_flutter` 因图标资源补丁为 `1.0.1`），伞包用 `^1.0.0` 约束；升级伞包即整体升级。
- **分层依赖。** 基础设施（`antd_color`、`antd_tokens`、`antd_theme`、`antd_icons_flutter`）→ 基础层（`antd_flutter_ui`）→ 独立功能包。功能包之间互不依赖。
- **两套样式来源，一套 API。** 由形态决定组件遵循 antd v6 还是 antd-mobile v5，业务代码不需要为样式判断平台。
- **仍然可以 tree shaking。** 引入伞包不会把全部包塞进产物，未使用的 Dart 代码会被编译器移除。代价是依赖图和 `pub get`/分析时间变大，而不是发布包体积变大。

## 安装

要求 Dart `>=3.0.0 <4.0.0`，Flutter `>=3.10.0`。

```yaml
dependencies:
  antd_flutter_plus: ^1.0.0
  material_ui: ^1.11.0
```

示例从 `material_ui` 导入 `MaterialApp` 和 `Scaffold`，因此需要显式声明。

## 快速开始

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

> `AntTheme` 必须包裹应用（位于 `MaterialApp` 之上），它注入 Ant 作用域和派生的 Flutter `Theme`；`AntThemeData.light().toThemeData()` 让 Material 组件使用同一套 token。

## 子包

伞包聚合以下 21 个包，路径相对于仓库根目录。

### 基础设施与基础层

| 包 | 提供内容 | 路径 |
| --- | --- | --- |
| `antd_color` | 颜色模型、色板与颜色解析 | `packages/antd_color` |
| `antd_tokens` | 种子变量、变量算法、颜色映射与阴影 | `packages/antd_tokens` |
| `antd_theme` | `AntThemeData`、`AntScale`/`AntTheme`、阴影、断点与屏幕适配 | `packages/antd_theme` |
| `antd_icons_flutter` | 850+ 线框/填充图标字体、双色 SVG 支持与 `AntdIcon` | `packages/antd_icons_flutter` |
| `antd_flutter_ui` | 基础组件层与公共引擎（弹层、滚轮、快捷键） | `packages/antd_flutter_ui` |

### 数据录入与表单

| 包 | 提供内容 | 路径 |
| --- | --- | --- |
| `antd_form` | `AntForm` / `AntFormItem` / `AntFormController` 与声明式校验 | `packages/antd_form` |
| `antd_picker` | 选择器、日期选择、时间选择与级联选择 | `packages/antd_picker` |
| `antd_upload` | 文件上传列表，含进度、预览与移除 | `packages/antd_upload` |
| `antd_keyboard` | 数字键盘、密码输入与虚拟输入 | `packages/antd_keyboard` |
| `antd_calendar` | 日历、日历选择器与选择视图 | `packages/antd_calendar` |

### 数据展示

| 包 | 提供内容 | 路径 |
| --- | --- | --- |
| `antd_table` | 排序、筛选、固定列、选择、展开、树形数据、分页、汇总与分组表头 | `packages/antd_table` |
| `antd_tree` | 支持勾选的树与树选择 | `packages/antd_tree` |
| `antd_transfer` | 穿梭框与树形穿梭框 | `packages/antd_transfer` |
| `antd_carousel` | 基于 PageView 的轮播，支持自动播放、循环、圆点、箭头、纵向模式与控制器 | `packages/antd_carousel` |
| `antd_masonry` | 贪心列瀑布流布局及 sliver 版本 | `packages/antd_masonry` |
| `antd_qrcode` | 二维码渲染，含纠错级别、状态遮罩与中心图标 | `packages/antd_qrcode` |
| `antd_image_viewer` | 全屏图片预览，支持缩放、平移与翻页 | `packages/antd_image_viewer` |

### 交互与浮层

| 包 | 提供内容 | 路径 |
| --- | --- | --- |
| `antd_refresh` | 下拉刷新手势状态机与指示器 | `packages/antd_refresh` |
| `antd_swipe_action` | 可配置操作按钮的滑动单元格 | `packages/antd_swipe_action` |
| `antd_splitter` | 带约束的可拖拽分栏面板 | `packages/antd_splitter` |
| `antd_floating` | 浮动面板与悬浮气泡 | `packages/antd_floating` |

伞包还再导出了若干应用层常用的入口：`antd_picker` 的 `AntDatePicker` / `AntTimePicker` / `AntDateRangePicker` / `AntDateTimeRangePicker` / `AntCascader` / `AntPickerLocale`、`antd_refresh` 的 `AntPullToRefresh`、`AntTable`、`AntForm`，以及 `AntSwipeAction`。

## 伞包还是独立包？

| 场景 | 建议 |
| --- | --- |
| 应用会用到多个组件族 | 使用 `antd_flutter_plus`：一个依赖，一条升级线 |
| 原型、演示或内部工具 | 使用 `antd_flutter_plus`：从 `pub get` 到可运行界面最快 |
| 只需要一个能力（如二维码、表格） | 直接依赖对应包，跳过其余包 |
| 对依赖图、`pub get` 时间或包发布有严格要求 | 使用独立包；组件需要时再补 `antd_theme` 和 `antd_flutter_ui` |
| 已经依赖了部分独立包 | 保持现状；伞包是增量，不是替换 |

两种方式使用同一套组件和 token，互相迁移只需要改 `pubspec.yaml` 和 import。

## 主题与缩放

```dart
AntTheme(
  data: AntThemeData.light(scale: const AntScale(1.1)),
  child: MaterialApp(
    theme: AntThemeData.light().toThemeData(),
    home: const HomePage(),
  ),
)
```

| API | 作用 |
| --- | --- |
| `AntThemeData.light()` / `.dark()` | 基于默认种子生成亮色/暗色主题 |
| `AntThemeData.fromSeed(seed, isDark: ...)` | 基于自定义 `AntSeedToken` 生成主题 |
| `AntScale(factor)` | 固定缩放因子；`AntScale.none` 等于 `1.0` |
| `AntScale.auto(context)` | 按短边推导因子（基准 375，限制在 0.9–1.2）；桌面端返回 `AntScale.none` |
| `AntTheme.of(context)` | 读取最近的 `AntThemeData`，找不到时回退亮色 |
| `theme.s(value)` | 设计值 × 缩放因子 |

与尺寸相关的种子变量在构建 `AntThemeData` 时一次性缩放；组件再用 `theme.s(...)` 处理自身的间距和尺寸。只改这一处因子，字号、控件高度、圆角和间距会一起变化——不要混用 `ScreenUtil` 或写死像素。

## 示例

`example/` 是使用伞包和 `device_preview` 构建的组件画廊，拥有独立的 `pubspec.yaml`。

```bash
cd example
flutter pub get
flutter run -d chrome    # 或：flutter run -d macos
```

## 演示

每个子包都提供可交互的 Web 演示，由各自的 `example/` 应用构建，随文档站一起部署。

| 演示 | 地址 | 内容 |
| --- | --- | --- |
| 伞包画廊（全部 UI 组件） | https://flutter-open.github.io/antd-flutter/ | 伞包画廊（全部 UI 组件） |
| 图标画廊 | https://flutter-open.github.io/antd-flutter/icons/ | 图标画廊 |
| 色板 | https://flutter-open.github.io/antd-flutter/color/ | 色板 |
| 设计变量 | https://flutter-open.github.io/antd-flutter/tokens/ | 设计变量 |
| 主题与 AntScale | https://flutter-open.github.io/antd-flutter/theme/ | 主题与 AntScale |
| 日历与日历选择器 | https://flutter-open.github.io/antd-flutter/calendar/ | 日历与日历选择器 |
| 表单校验 | https://flutter-open.github.io/antd-flutter/form/ | 表单校验 |
| 选择器 / 级联 / 日期 / 时间 | https://flutter-open.github.io/antd-flutter/picker/ | 选择器 / 级联 / 日期 / 时间 |
| 上传 | https://flutter-open.github.io/antd-flutter/upload/ | 上传 |
| 穿梭框 | https://flutter-open.github.io/antd-flutter/transfer/ | 穿梭框 |
| 树与树选择 | https://flutter-open.github.io/antd-flutter/tree/ | 树与树选择 |
| 表格 | https://flutter-open.github.io/antd-flutter/table/ | 表格 |
| 数字 / 密码 / 虚拟键盘 | https://flutter-open.github.io/antd-flutter/keyboard/ | 数字 / 密码 / 虚拟键盘 |
| 二维码 | https://flutter-open.github.io/antd-flutter/qr_code/ | 二维码 |
| 下拉刷新 | https://flutter-open.github.io/antd-flutter/refresh/ | 下拉刷新 |
| 分割面板 | https://flutter-open.github.io/antd-flutter/splitter/ | 分割面板 |
| 滑动操作 | https://flutter-open.github.io/antd-flutter/swipe_action/ | 滑动操作 |
| 图片预览 | https://flutter-open.github.io/antd-flutter/image_viewer/ | 图片预览 |
| 走马灯 | https://flutter-open.github.io/antd-flutter/carousel/ | 走马灯 |
| 瀑布流 | https://flutter-open.github.io/antd-flutter/masonry/ | 瀑布流 |
| 浮层 | https://flutter-open.github.io/antd-flutter/floating/ | 浮层 |

## 问题反馈

- Bug 与需求：[提交 Issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)
- 文档站：https://flutter-open.github.io/antd-flutter/

## 相关链接

| 资源 | 地址 |
| --- | --- |
| 文档站点 | https://flutter-open.github.io/antd-flutter/ |
| 图标画廊 | https://flutter-open.github.io/antd-flutter/icons/ |
| 仓库 | https://github.com/flutter-open/antd-flutter |
| 问题反馈 | https://github.com/flutter-open/antd-flutter/issues |

## 项目结构

```text
antd-flutter/
├── lib/
│   ├── antd_flutter_plus.dart        # 伞包导出
│   └── （仅 barrel）                  # 统一导出各子包；平台与工具逻辑在 antd_theme / antd_flutter_ui
├── packages/                         # 21 个包
│   ├── antd_color/
│   ├── antd_tokens/
│   ├── antd_theme/
│   ├── antd_icons_flutter/
│   ├── antd_flutter_ui/
│   ├── antd_form/
│   ├── antd_picker/
│   ├── antd_table/
│   └── ...
├── example/                          # 画廊应用（Web 演示）
├── pubspec.yaml
└── README.md
```

## 版本策略

组件体系遵循一条版本线：所有包发布 `1.0.0`（`antd_icons_flutter` 因图标资源补丁为 `1.0.1`），伞包声明 `^1.0.0` 依赖，并在 monorepo 内使用路径覆盖。任何一个包发生破坏性变更时，整套一起升版。

## License

MIT License，详见 [LICENSE](LICENSE)。

## ☕ 请我喝咖啡

如果这个项目帮到了你，欢迎请我喝杯咖啡，感谢你的支持！

| 支付宝 | 微信 |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="支付宝收款码" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="微信收款码" /> |
