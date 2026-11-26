<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntDateRangePicker

> 种类：类

```dart
class AntDateRangePicker
```

日期范围选择框 — 一次选择起止日期（可选时间）。

对齐 antd React `DatePicker.RangePicker`。

## 构造函数

### `AntDateRangePicker({super.key, this.value, this.defaultValue, this.onChange, this.allowClear = false, this.placeholderStart, this.placeholderEnd, this.separator, this.disabled = false, this.size = AntDatePickerSize.middle, this.format, this.locale, this.weekStartsOnMonday = false, this.showToday = true, this.showTime = false, this.timeFormat, this.autofocus = false, this.status = AntInputStatus.normal, this.disabledDate, this.minDate, this.maxDate, this.labelBuilder})`

创建日期范围选择框。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `AntDateRange?` | 可选 | — |
| `defaultValue` | `AntDateRange?` | 可选 | — |
| `onChange` | `ValueChanged<AntDateRange?>?` | 可选 | — |
| `allowClear` | `bool` | = false | — |
| `placeholderStart` | `String?` | 可选 | — |
| `placeholderEnd` | `String?` | 可选 | — |
| `separator` | `String?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `size` | `AntDatePickerSize` | = AntDatePickerSize.middle | — |
| `format` | `String?` | 可选 | — |
| `locale` | `AntPickerLocale?` | 可选 | — |
| `weekStartsOnMonday` | `bool` | = false | — |
| `showToday` | `bool` | = true | — |
| `showTime` | `bool` | = false | — |
| `timeFormat` | `String?` | 可选 | — |
| `autofocus` | `bool` | = false | — |
| `status` | `AntInputStatus` | = AntInputStatus.normal | — |
| `disabledDate` | `bool Function(DateTime date)?` | 可选 | — |
| `minDate` | `DateTime?` | 可选 | — |
| `maxDate` | `DateTime?` | 可选 | — |
| `labelBuilder` | `AntDateRangeLabelBuilder?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `allowClear` | `bool` | 是否允许清除 |
| `autofocus` | `bool` | 是否自动聚焦 |
| `defaultValue` | `AntDateRange?` | 非受控初始范围值 |
| `disabled` | `bool` | 是否禁用 |
| `disabledDate` | `bool Function(DateTime date)?` | 日期是否不可选 |
| `format` | `String?` | 日期显示格式 |
| `labelBuilder` | `AntDateRangeLabelBuilder?` | 触发器自定义渲染 |
| `locale` | `AntPickerLocale?` | 国际化文案 |
| `maxDate` | `DateTime?` | 可选日期上限（含） |
| `minDate` | `DateTime?` | 可选日期下限（含） |
| `onChange` | `ValueChanged<AntDateRange?>?` | 范围变化回调 |
| `placeholderEnd` | `String?` | 终点占位文本（为空时取 locale 的终点文案） |
| `placeholderStart` | `String?` | 起点占位文本（为空时取 locale 的起点文案） |
| `separator` | `String?` | 起止分隔符（为空时取 locale 的分隔符，默认 ~） |
| `showTime` | `bool` | 是否选择时间（相当于 antd showTime） |
| `showToday` | `bool` | 面板是否显示「今天」快捷按钮 |
| `size` | `AntDatePickerSize` | 尺寸 |
| `status` | `AntInputStatus` | 校验状态（error / warning 时边框与光环跟随主题校验色） |
| `timeFormat` | `String?` | 时间显示格式 |
| `value` | `AntDateRange?` | 受控范围值 |
| `weekStartsOnMonday` | `bool` | 周起始是否为周一（默认周日） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntDateRangePicker>` | — |

