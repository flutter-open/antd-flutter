<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntPopoverOverlayStyle

> 种类：类

```dart
class AntPopoverOverlayStyle
```

气泡浮层自定义样式。

对齐 antd React Popover 的 styles.overlay，可覆盖默认的
背景色、边框、圆角与阴影。

## 构造函数

### `AntPopoverOverlayStyle({this.backgroundColor, this.borderRadius, this.border, this.boxShadow, this.padding, this.width, this.minWidth, this.maxWidth})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `backgroundColor` | `Color?` | 可选 | — |
| `borderRadius` | `BorderRadius?` | 可选 | — |
| `border` | `Border?` | 可选 | — |
| `boxShadow` | `List<BoxShadow>?` | 可选 | — |
| `padding` | `EdgeInsetsGeometry?` | 可选 | — |
| `width` | `double?` | 可选 | — |
| `minWidth` | `double?` | 可选 | — |
| `maxWidth` | `double?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `backgroundColor` | `Color?` | 浮层背景色（优先于 AntPopover.color 生效） |
| `border` | `Border?` | 浮层边框 |
| `borderRadius` | `BorderRadius?` | 浮层圆角 |
| `boxShadow` | `List<BoxShadow>?` | 浮层阴影 |
| `maxWidth` | `double?` | 浮层最大宽度（逻辑像素，按主题缩放） |
| `minWidth` | `double?` | 浮层最小宽度（逻辑像素，按主题缩放） |
| `padding` | `EdgeInsetsGeometry?` | 浮层内边距 |
| `width` | `double?` | 浮层固定宽度（逻辑像素，按主题缩放） |

