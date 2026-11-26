# antd_picker - Flutter 滚轮选择器、级联选择与日期时间选择

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_picker/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_picker/README_CN.md)

## 定位与设计

`antd_picker` 汇集共享模态底部弹层/浮层容器的选择类控件：`AntPicker<T>` 用于一列或多列滚轮，`AntCascader<T>` 用于层级下钻选择，`AntDatePicker` / `AntTimePicker` 用于带格式的日期与时间字段。所有泛型选择器都通过 `dataSource`、`keyOf`、`labelBuilder` 读取**你的模型 `T`**，不会把数据摊平成字符串标签。

设计原则：

- **值保持类型。** `AntPicker<T>` 确认的是 `List<T>`——每列一个选中对象；级联选择器回报选中的路径。
- **滚轮数据驱动。** 一列即一个 `AntPickerColumn<T>`，列数与选项渲染都是声明。
- **触发器由你提供。** 选择器接收 `child` 作为打开弹层的入口，任何按钮、输入框或卡片都可以触发。
- **日期与时间分离。** `AntDatePicker` 使用 `DateTime`，`AntTimePicker` 使用 `TimeOfDay`，各自带显示 `format` 与步长控制。
- **范围在一个面板内选完。** `AntDateRangePicker`（以及 `showTime` 版本的 `AntDateTimeRangePicker`）在同一个月历里选起点与终点，时间列也内嵌在同一面板。
- **文案跟随 App。** 全族组件按 显式 `locale:` 参数 → `AntPickerLocaleProvider` → App `Localizations` 语言的顺序取 `AntPickerLocale`，最终回退中文。

## 安装

要求 Dart `>=3.0.0`、Flutter `>=3.10.0`。

```yaml
dependencies:
  antd_picker: ^1.0.0
```

用 `AntTheme` 包裹子树；滚轮高亮、弹层外观与输入框边框均来自设计 token：

```dart
AntTheme(
  data: AntThemeData.light(),
  child: MaterialApp(home: YourPage()),
)
```

## 快速开始

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

点击 child 打开滚轮弹层。确认时按列顺序回报选中的 `Season` 对象，取消则不产生值。

## API

[API 参考](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_picker/docs/api-index.md)

### 1. 双列年月选择器

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

每列确认恰好一个 `T`，结果保持列顺序。`defaultValue` 的元素既可以是 `T` 值，也可以是 `keyOf` 返回的 key。

### 2. 用树结构做级联选择

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

级联选择器沿 `childrenOf` 逐级下钻；`changeOnSelect: false` 时点击父级只展开下一列，选中叶子才提交值。需要不弹层的内联面板时，用 `AntCascaderView` 渲染同样的列。

### 3. 日期与时间字段

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

两个字段各自打开弹层，清除时回报 `null`（`allowClear: true` 启用清除入口）。`minuteStep` / `hourStep` 可稀疏化滚轮选项，适合粗粒度排期。

表单校验态与可选范围都能直接下发到字段，不必自己包一层：

```dart
AntDatePicker(
  value: _date,
  status: AntInputStatus.error,        // error / warning 时边框与光环取校验色
  minDate: DateTime(2025, 1, 1),       // 可选下限（含）
  maxDate: DateTime(2025, 12, 31),     // 可选上限（含）
  disabledDate: (date) => date.weekday != DateTime.monday, // 自定义禁用规则
  onChange: (date) => setState(() => _date = date),
);
```

`status` 在 `AntDatePicker` / `AntTimePicker` / `AntDateRangePicker` 上都可用；`disabledDate` 命中的日期置灰且不可点击，与 `minDate` / `maxDate` 同时生效。

### 4. 日期范围与国际化

```dart
AntDateRangePicker(
  defaultValue: AntDateRange.sorted(DateTime(2025, 3, 1), DateTime(2025, 3, 10)),
  allowClear: true,
  onChange: (range) => setState(() => _range = range),
);

// 日期时间范围：该子类的 showTime 默认为 true。
AntDateTimeRangePicker(
  value: _dateTimeRange,
  onChange: (range) => setState(() => _dateTimeRange = range),
);
```

- 第一次点击设起点、第二次点击设终点；终点早于起点会自动归正。开启 `showTime` 时需点确定才提交，时分列与月历在同一面板内。
- `minDate` / `maxDate` 禁用范围外日期，`allowClear` 清除后回报 `null`。
- `disabledDate` 逐日禁用（如只允许工作日），`status` 让触发器跟随表单校验态着色。
- 传 `locale: AntPickerLocale.zh` / `.en` / `.ja`（内建 15 种语言预设）固定语言，或在外层包一次 `AntPickerLocaleProvider`；都不指定时跟随 App 的 `Localizations` 语言并回退中文。
- `format` / `timeFormat` 支持 antd 模板（`yyyy-MM-dd`、`yyyy年M月d日`、`HH:mm`、`hh:mm a`），优先于 locale 默认格式。

## 演示

- 在线演示：https://flutter-open.github.io/antd-flutter/picker/
- 发现问题或有疑问？[提交 Issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)

## 项目结构

```text
packages/antd_picker/
├── lib/
│   ├── antd_picker.dart                 # barrel 导出
│   └── src/
│       ├── picker/                      # 滚轮弹层与列模型
│       ├── cascader/                    # 级联字段与内联视图
│       ├── date_picker/                 # 日期字段、范围选择器、月面板
│       ├── locale/                      # AntPickerLocale 语言预设 + 日期格式化
│       └── time_picker/                 # TimeOfDay 字段 + 共享滚轮
├── example/lib/main.dart                # 可运行示例
├── docs/api-index.md                    # 生成的 API 索引
└── README.md
```

## License

MIT，详见仓库 [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE)。

## ☕ 请我喝咖啡

如果这个项目帮到了你，欢迎请我喝杯咖啡，感谢你的支持！

| 支付宝 | 微信 |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="支付宝收款码" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="微信收款码" /> |
