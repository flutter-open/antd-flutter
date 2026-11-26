<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntDatePicker

> 种类：类

```dart
class AntDatePicker
```

日期选择框 — 输入或选择日期。

对齐 antd React DatePicker 组件。

## 构造函数

### `AntDatePicker({super.key, this.value, this.defaultValue, this.onChange, this.allowClear = false, this.placeholder, this.disabled = false, this.size = AntDatePickerSize.middle, this.format, this.locale, this.weekStartsOnMonday = false, this.showToday = true, this.autofocus = false, this.labelBuilder})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `DateTime?` | 可选 | — |
| `defaultValue` | `DateTime?` | 可选 | — |
| `onChange` | `ValueChanged<DateTime?>?` | 可选 | — |
| `allowClear` | `bool` | = false | — |
| `placeholder` | `String?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `size` | `AntDatePickerSize` | = AntDatePickerSize.middle | — |
| `format` | `String?` | 可选 | — |
| `locale` | `AntPickerLocale?` | 可选 | — |
| `weekStartsOnMonday` | `bool` | = false | — |
| `showToday` | `bool` | = true | — |
| `autofocus` | `bool` | = false | — |
| `labelBuilder` | `Widget Function(BuildContext context, DateTime date)?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `allowClear` | `bool` | 是否允许清除 |
| `autofocus` | `bool` | 是否自动聚焦 |
| `defaultValue` | `DateTime?` | 非受控初始日期 |
| `disabled` | `bool` | 是否禁用 |
| `format` | `String?` | 日期显示格式，如 yyyy-MM-dd / MM/dd/yyyy / yyyy年MM月dd日 |
| `labelBuilder` | `Widget Function(BuildContext context, DateTime date)?` | 触发器日期自定义渲染 |
| `locale` | `AntPickerLocale?` | 国际化文案 |
| `onChange` | `ValueChanged<DateTime?>?` | 日期变化回调 |
| `placeholder` | `String?` | 占位文本（为空时取 locale 的日期占位文案） |
| `showToday` | `bool` | 面板是否显示「今天」快捷按钮 |
| `size` | `AntDatePickerSize` | 尺寸 |
| `value` | `DateTime?` | 受控日期值 |
| `weekStartsOnMonday` | `bool` | 周起始是否为周一（默认周日，与既有行为一致） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntDatePicker>` | — |

