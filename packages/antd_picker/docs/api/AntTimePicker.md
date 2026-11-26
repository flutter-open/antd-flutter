<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTimePicker

> 种类：类

```dart
class AntTimePicker
```

时间选择框 — 输入或选择时间。

对齐 antd React TimePicker 组件。

## 构造函数

### `AntTimePicker({super.key, this.value, this.defaultValue, this.onChange, this.allowClear = false, this.placeholder, this.disabled = false, this.size = AntTimePickerSize.middle, this.hourStep = 1, this.minuteStep = 1, this.secondStep = 1, this.format, this.locale, this.autofocus = false, this.labelBuilder})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `TimeOfDay?` | 可选 | — |
| `defaultValue` | `TimeOfDay?` | 可选 | — |
| `onChange` | `ValueChanged<TimeOfDay?>?` | 可选 | — |
| `allowClear` | `bool` | = false | — |
| `placeholder` | `String?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `size` | `AntTimePickerSize` | = AntTimePickerSize.middle | — |
| `hourStep` | `int` | = 1 | — |
| `minuteStep` | `int` | = 1 | — |
| `secondStep` | `int` | = 1 | — |
| `format` | `String?` | 可选 | — |
| `locale` | `AntPickerLocale?` | 可选 | — |
| `autofocus` | `bool` | = false | — |
| `labelBuilder` | `Widget Function(BuildContext context, TimeOfDay time)?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `allowClear` | `bool` | 是否允许清除 |
| `autofocus` | `bool` | 是否自动聚焦 |
| `defaultValue` | `TimeOfDay?` | 非受控初始时间 |
| `disabled` | `bool` | 是否禁用 |
| `format` | `String?` | 时间显示格式（如 HH:mm:ss） |
| `hourStep` | `int` | 小时步长 |
| `labelBuilder` | `Widget Function(BuildContext context, TimeOfDay time)?` | 触发器时间自定义渲染 |
| `locale` | `AntPickerLocale?` | 国际化文案 |
| `minuteStep` | `int` | 分钟步长 |
| `onChange` | `ValueChanged<TimeOfDay?>?` | 时间变化回调 |
| `placeholder` | `String?` | 占位文本（为空时取 locale 的时间占位文案） |
| `secondStep` | `int` | 秒步长 |
| `size` | `AntTimePickerSize` | 尺寸 |
| `value` | `TimeOfDay?` | 受控时间值 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntTimePicker>` | — |

