<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSelect

> 种类：类

```dart
class AntSelect
```

选择器 — 下拉选择器，支持单选、多选与搜索。

对齐 antd React Select 组件。选项是任意类型 `T`，不要求用户构造
`AntSelectOption`；只有字符串选项时可直接 `AntSelect<String>(options: ['北京'])`。

## 构造函数

### `AntSelect({super.key, this.mode = AntSelectMode.single, this.value, this.defaultValue, this.values, this.defaultValues = const [], this.options = const [], this.labelOf, this.labelBuilder, this.itemBuilder, this.valueExtractor, this.disabledOf, this.searchTextOf, this.onChange, this.onChangeMultiple, this.showSearch = false, this.allowClear = false, this.placeholder, this.disabled = false, this.loading = false, this.size = AntSelectSize.middle, this.autofocus = false, this.status = AntInputStatus.normal, this.maxTagCount})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `mode` | `AntSelectMode` | = AntSelectMode.single | — |
| `value` | `T?` | 可选 | — |
| `defaultValue` | `T?` | 可选 | — |
| `values` | `List<T>?` | 可选 | — |
| `defaultValues` | `List<T>` | = const [] | — |
| `options` | `List<T>` | = const [] | — |
| `labelOf` | `String Function(T item)?` | 可选 | — |
| `labelBuilder` | `Widget Function(BuildContext context, T item)?` | 可选 | — |
| `itemBuilder` | `Widget Function(BuildContext context, T item, int index)?` | 可选 | — |
| `valueExtractor` | `Object Function(T item)?` | 可选 | — |
| `disabledOf` | `bool Function(T item)?` | 可选 | — |
| `searchTextOf` | `String Function(T item)?` | 可选 | — |
| `onChange` | `ValueChanged<T?>?` | 可选 | — |
| `onChangeMultiple` | `ValueChanged<List<T>>?` | 可选 | — |
| `showSearch` | `bool` | = false | — |
| `allowClear` | `bool` | = false | — |
| `placeholder` | `String?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `loading` | `bool` | = false | — |
| `size` | `AntSelectSize` | = AntSelectSize.middle | — |
| `autofocus` | `bool` | = false | — |
| `status` | `AntInputStatus` | = AntInputStatus.normal | — |
| `maxTagCount` | `int?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `allowClear` | `bool` | 是否允许清除 |
| `autofocus` | `bool` | 是否自动聚焦 |
| `defaultValue` | `T?` | 非受控初始值（单选） |
| `defaultValues` | `List<T>` | 非受控初始值（多选） |
| `disabled` | `bool` | 是否禁用 |
| `disabledOf` | `bool Function(T item)?` | 选项是否禁用 |
| `itemBuilder` | `Widget Function(BuildContext context, T item, int index)?` | 整项自定义渲染（保留下拉项内置的选中标记/多选勾选框），优先级高于 labelBuilder |
| `labelBuilder` | `Widget Function(BuildContext context, T item)?` | 选项的自定义渲染，用于下拉项、多选标签与单选已选值 |
| `labelOf` | `String Function(T item)?` | 选项的字符串 label 简写，用于标题文本与 showSearch 搜索匹配 |
| `loading` | `bool` | 是否加载中 |
| `maxTagCount` | `int?` | 多选模式下最多显示的标签数，超出部分折叠为 +N 计数标签 |
| `mode` | `AntSelectMode` | 选择模式 |
| `onChange` | `ValueChanged<T?>?` | 单选选中变化回调（清除时为 null） |
| `onChangeMultiple` | `ValueChanged<List<T>>?` | 多选选中变化回调 |
| `options` | `List<T>` | 选项列表（任意模型） |
| `placeholder` | `String?` | 占位文本 |
| `searchTextOf` | `String Function(T item)?` | 搜索匹配文本，缺省为 labelOf 的结果（再缺省为 item.toString()） |
| `showSearch` | `bool` | 是否可搜索 |
| `size` | `AntSelectSize` | 尺寸 |
| `status` | `AntInputStatus` | 校验状态（error / warning 时边框与光环跟随主题校验色） |
| `value` | `T?` | 受控选中值（单选） |
| `valueExtractor` | `Object Function(T item)?` | 选中值的身份提取（默认选项自身） |
| `values` | `List<T>?` | 受控选中值（多选） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntSelect<T>>` | — |

