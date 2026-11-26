<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntFormItem

> 种类：类

```dart
class AntFormItem
```

表单字段组件，包裹单个表单控件并提供标签、校验与错误提示。

通过 `builder` 获取字段状态（值/错误），将表单控件与表单数据绑定：

```dart
AntFormItem<String>(
  name: 'username',
  label: '用户名',
  rules: [AntFormFieldRule.required(message: '请输入用户名')],
  builder: (field) => AntInput(
    value: field.value ?? '',
    onChanged: field.didChange,
  ),
)
```

## 构造函数

### `AntFormItem({super.key, this.name, this.label, this.rules, this.required, this.help, this.extra, this.initialValue, this.validateTrigger = AntFormValidateTrigger.onChange, this.marginBottom, this.hintColor, this.labelColor, required this.builder})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `name` | `String?` | 可选 | — |
| `label` | `String?` | 可选 | — |
| `rules` | `List<AntFormFieldRule>?` | 可选 | — |
| `required` | `bool?` | 可选 | — |
| `help` | `String?` | 可选 | — |
| `extra` | `String?` | 可选 | — |
| `initialValue` | `T?` | 可选 | — |
| `validateTrigger` | `AntFormValidateTrigger` | = AntFormValidateTrigger.onChange | — |
| `marginBottom` | `double?` | 可选 | — |
| `hintColor` | `Color?` | 可选 | — |
| `labelColor` | `Color?` | 可选 | — |
| `builder` | `Widget Function(AntFormField<T> field)` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `builder` | `Widget Function(AntFormField<T> field)` | 表单控件构建器 |
| `extra` | `String?` | 额外信息（显示在错误/帮助文案下方） |
| `help` | `String?` | 帮助文案（始终显示在控件下方） |
| `hintColor` | `Color?` | 该表单项帮助 / 额外说明文案颜色，优先于 AntForm.hintColor |
| `initialValue` | `T?` | 字段初始值 |
| `label` | `String?` | 标签文案 |
| `labelColor` | `Color?` | 该表单项标签文案颜色，优先于 AntForm.labelColor |
| `marginBottom` | `double?` | 该表单项的底部间距，优先于 AntForm.itemMarginBottom |
| `name` | `String?` | 字段名（注册到表单控制器的键） |
| `required` | `bool?` | 是否必填（为 true 时自动添加必填规则并显示星号） |
| `rules` | `List<AntFormFieldRule>?` | 校验规则列表 |
| `validateTrigger` | `AntFormValidateTrigger` | 校验触发时机 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntFormItem<T>>` | — |

