<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntPickerLocale

> 种类：类

```dart
class AntPickerLocale
```

日期/时间选择器国际化文案。

```dart
// 用内建预设
AntDatePicker(locale: AntPickerLocale.en, ...)

// 自定义个别文案（其余字段继承同语言预设）
AntDatePicker(
  locale: AntPickerLocale(languageCode: 'en', datePlaceholder: 'Pick a day'),
  ...
)
```

## 构造函数

### `AntPickerLocale({this.languageCode = 'zh', this.monthTitlePattern, this.weekLabels, this.datePlaceholder, this.timePlaceholder, this.rangeStartPlaceholder, this.rangeEndPlaceholder, this.rangeSeparator, this.confirmText, this.cancelText, this.todayText, this.defaultDateFormat, this.defaultTimeFormat, this.messages = const {}, AntPickerLocale? fallback})`

创建国际化配置（未提供的字段逐级回退 `fallback`、同语言预设、中文预设）。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `languageCode` | `String` | = 'zh' | — |
| `monthTitlePattern` | `String?` | 可选 | — |
| `weekLabels` | `List<String>?` | 可选 | — |
| `datePlaceholder` | `String?` | 可选 | — |
| `timePlaceholder` | `String?` | 可选 | — |
| `rangeStartPlaceholder` | `String?` | 可选 | — |
| `rangeEndPlaceholder` | `String?` | 可选 | — |
| `rangeSeparator` | `String?` | 可选 | — |
| `confirmText` | `String?` | 可选 | — |
| `cancelText` | `String?` | 可选 | — |
| `todayText` | `String?` | 可选 | — |
| `defaultDateFormat` | `String?` | 可选 | — |
| `defaultTimeFormat` | `String?` | 可选 | — |
| `messages` | `Map<String, String>` | = const {} | — |
| `fallback` | `AntPickerLocale?` | 可选 | — |

### `AntPickerLocale._raw({required this.languageCode, required this.monthTitlePattern, required this.weekLabels, required this.datePlaceholder, required this.timePlaceholder, required this.rangeStartPlaceholder, required this.rangeEndPlaceholder, required this.rangeSeparator, required this.confirmText, required this.cancelText, required this.todayText, required this.defaultDateFormat, required this.defaultTimeFormat})`

内建预设构造（全字段必填，作为回退终点）。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `languageCode` | `String` | 可选 | — |
| `monthTitlePattern` | `String?` | 可选 | — |
| `weekLabels` | `List<String>?` | 可选 | — |
| `datePlaceholder` | `String?` | 可选 | — |
| `timePlaceholder` | `String?` | 可选 | — |
| `rangeStartPlaceholder` | `String?` | 可选 | — |
| `rangeEndPlaceholder` | `String?` | 可选 | — |
| `rangeSeparator` | `String?` | 可选 | — |
| `confirmText` | `String?` | 可选 | — |
| `cancelText` | `String?` | 可选 | — |
| `todayText` | `String?` | 可选 | — |
| `defaultDateFormat` | `String?` | 可选 | — |
| `defaultTimeFormat` | `String?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_fallback` | `AntPickerLocale?` | 字段缺失时的一级回退预设（最终回退同语言预设 / 中文内置文案） |
| `cancelText` | `String?` | 取消按钮文案 |
| `confirmText` | `String?` | 确认按钮文案 |
| `datePlaceholder` | `String?` | 日期输入占位文案 |
| `defaultDateFormat` | `String?` | 默认日期显示格式（yyyy-MM-dd / MM/dd/yyyy / dd.MM.yyyy 等） |
| `defaultTimeFormat` | `String?` | 默认时间显示格式（HH:mm / HH:mm:ss） |
| `languageCode` | `String` | 语言码，如 zh、en、zh-CN |
| `messages` | `Map<String, String>` | 自定义文案扩展表（key → 文案），经 text 读取 |
| `monthTitlePattern` | `String?` | 年月标题模板，{year} / {month} 为占位符 |
| `rangeEndPlaceholder` | `String?` | 日期范围终点占位文案 |
| `rangeSeparator` | `String?` | 日期范围分隔符（默认 ~） |
| `rangeStartPlaceholder` | `String?` | 日期范围起点占位文案 |
| `timePlaceholder` | `String?` | 时间输入占位文案 |
| `todayText` | `String?` | 「今天」文案 |
| `weekLabels` | `List<String>?` | 周标签（自周一起始的 7 个标签 |
| `ar` | `AntPickerLocale` | 阿拉伯语预设 |
| `de` | `AntPickerLocale` | 德语预设 |
| `en` | `AntPickerLocale` | 英语预设 |
| `es` | `AntPickerLocale` | 西班牙语预设 |
| `fr` | `AntPickerLocale` | 法语预设 |
| `id` | `AntPickerLocale` | 印尼语预设 |
| `it` | `AntPickerLocale` | 意大利语预设 |
| `ja` | `AntPickerLocale` | 日语预设 |
| `ko` | `AntPickerLocale` | 韩语预设 |
| `pt` | `AntPickerLocale` | 葡萄牙语预设 |
| `ru` | `AntPickerLocale` | 俄语预设 |
| `th` | `AntPickerLocale` | 泰语预设 |
| `vi` | `AntPickerLocale` | 越南语预设 |
| `zh` | `AntPickerLocale` | 中文（简体）预设 — 默认 |
| `zhTw` | `AntPickerLocale` | 中文（繁体）预设 |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_preset` | `AntPickerLocale?` | 同语言的内建预设（供自定义实例逐字段继承） |
| `effectiveCancelText` | `String` | 生效的取消文案 |
| `effectiveConfirmText` | `String` | 生效的确认文案 |
| `effectiveDateFormat` | `String` | 生效的默认日期显示格式 |
| `effectiveDatePlaceholder` | `String` | 生效的日期占位文案 |
| `effectiveMonthTitlePattern` | `String` | 生效的月标题模板 |
| `effectiveRangeEndPlaceholder` | `String` | 生效的日期范围终点占位文案 |
| `effectiveRangeSeparator` | `String` | 生效的日期范围分隔符 |
| `effectiveRangeStartPlaceholder` | `String` | 生效的日期范围起点占位文案 |
| `effectiveTimeFormat` | `String` | 生效的默认时间显示格式 |
| `effectiveTimePlaceholder` | `String` | 生效的时间占位文案 |
| `effectiveTodayText` | `String` | 生效的「今天」文案 |
| `effectiveWeekLabels` | `List<String>` | 生效的周标签（自周一起始） |
| `hashCode` | `int` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `==` | `bool` | — |
| `monthTitle` | `String` | 头部年月标题（模板占位符替换） |
| `text` | `String` | 读取自定义扩展文案，key 不存在时返回 fallbackText（默认 key 本身） |
| `weekLabelsFor` | `List<String>` | 按周起始约定返回周标签序列（周日起始时把周一标签轮转到末位） |
| `_listEquals` | `bool` | — |
| `fromLanguageCode` | `AntPickerLocale` | 按语言码解析内建预设（大小写不敏感，支持 zhCN / zh-Hans 等写法） |
| `maybeOf` | `AntPickerLocale?` | 从组件树读取注入的 locale |
| `of` | `AntPickerLocale` | 从组件树读取注入的 locale |
| `resolve` | `AntPickerLocale` | 解析组件实际使用的 locale |

