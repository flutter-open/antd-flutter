<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntDateRange

> 种类：类

```dart
class AntDateRange
```

日期（时间）范围值。

起止时间按自然顺序存放：`start` 不晚于 `end`（构造时断言）。

```dart
final range = AntDateRange(
  start: DateTime(2024, 1, 15),
  end: DateTime(2024, 2, 20, 18, 30),
);
```

## 构造函数

### `AntDateRange({required this.start, required this.end})`

创建范围值；`end` 必须晚于或等于 `start`。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `start` | `DateTime` | 可选 | — |
| `end` | `DateTime` | 可选 | — |

### `AntDateRange.sorted(DateTime a, DateTime b)`

按自然顺序构造（自动把较早的日期放到 `start`）。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `a` | `DateTime` | 可选 | — |
| `b` | `DateTime` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `end` | `DateTime` | 终点（含） |
| `start` | `DateTime` | 起点（含） |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `duration` | `Duration` | 范围时长（end |
| `hashCode` | `int` | — |
| `isSingleDay` | `bool` | 是否为同一天（忽略时分秒） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `==` | `bool` | — |
| `copyWith` | `AntDateRange` | 复制并替换起止值 |
| `toString` | `String` | — |

