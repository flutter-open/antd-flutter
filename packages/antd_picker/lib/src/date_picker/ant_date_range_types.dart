/// AntDateRangePicker 类型定义
library;

import 'package:material_ui/material_ui.dart';

/// 日期（时间）范围值。
///
/// 起止时间按自然顺序存放：`start` 不晚于 `end`（构造时断言）。
///
/// ```dart
/// final range = AntDateRange(
///   start: DateTime(2024, 1, 15),
///   end: DateTime(2024, 2, 20, 18, 30),
/// );
/// ```
class AntDateRange {
  /// 创建范围值；[end] 必须晚于或等于 [start]。
  AntDateRange({required this.start, required this.end})
      : assert(
          !end.isBefore(start),
          'AntDateRange: end 必须晚于或等于 start',
        );

  /// 按自然顺序构造（自动把较早的日期放到 [start]）。
  factory AntDateRange.sorted(DateTime a, DateTime b) => a.isBefore(b)
      ? AntDateRange(start: a, end: b)
      : AntDateRange(start: b, end: a);

  /// 起点（含）。
  final DateTime start;

  /// 终点（含）。
  final DateTime end;

  /// 范围时长（`end - start`）。
  Duration get duration => end.difference(start);

  /// 是否为同一天（忽略时分秒）。
  bool get isSingleDay =>
      start.year == end.year &&
      start.month == end.month &&
      start.day == end.day;

  /// 复制并替换起止值。
  AntDateRange copyWith({DateTime? start, DateTime? end}) => AntDateRange(
        start: start ?? this.start,
        end: end ?? this.end,
      );

  @override
  bool operator ==(Object other) =>
      other is AntDateRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'AntDateRange($start ~ $end)';
}

/// 范围触发器自定义渲染。
typedef AntDateRangeLabelBuilder = Widget Function(
  BuildContext context,
  AntDateRange range,
);
