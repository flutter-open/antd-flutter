<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# antFieldFocusRingOf

> 种类：函数

```dart
List<BoxShadow> antFieldFocusRingOf(AntThemeData t, AntInputStatus status)
```

焦点光环 — antd web 为「无模糊的实心外扩环」（`box-shadow: 0 0 0 2px
outline`），不是模糊辉光；外扩不参与布局，因此不引起内容位移。

## 参数

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `t` | `AntThemeData` | 可选 | — |
| `status` | `AntInputStatus` | 可选 | — |

返回 `List<BoxShadow>`。

