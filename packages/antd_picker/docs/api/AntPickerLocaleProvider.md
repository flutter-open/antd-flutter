<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntPickerLocaleProvider

> 种类：类

```dart
class AntPickerLocaleProvider
```

选择器国际化注入 — InheritedWidget，包裹一次全局生效。

```dart
AntPickerLocaleProvider(
  locale: AntPickerLocale.en,
  child: AntDatePicker(...),
)
```

## 构造函数

### `AntPickerLocaleProvider({super.key, required this.locale, required super.child})`

创建注入节点。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `locale` | `AntPickerLocale` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `locale` | `AntPickerLocale` | 注入的国际化配置 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `updateShouldNotify` | `bool` | — |

