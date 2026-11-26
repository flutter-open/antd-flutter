/// 日期 / 时间格式化（选择器内部使用）。
///
/// 只实现 antd 常用格式符，避免引入 `intl` 依赖：
/// - `yyyy` / `yy`：四位 / 两位年份
/// - `M` / `MM`：月份（不补零 / 补零）
/// - `d` / `dd`：日（不补零 / 补零）
/// - `H` / `HH`：24 小时制（不补零 / 补零）
/// - `h` / `hh`：12 小时制（不补零 / 补零）
/// - `m` / `mm`：分钟
/// - `s` / `ss`：秒
/// - `a`：`AM` / `PM`
///
/// 其余字符原样输出（可用来夹带 `/`、`-`、`.`、`年`、`月`、`日` 等字面量）。
library;

import 'package:material_ui/material_ui.dart';

/// 按 [pattern] 格式化 [date]。
///
/// ```dart
/// formatAntDate(DateTime(2024, 1, 15), 'yyyy/MM/dd'); // 2024/01/15
/// formatAntDate(DateTime(2024, 1, 15), 'MM/dd/yyyy'); // 01/15/2024
/// ```
String formatAntDate(DateTime date, String pattern) {
  final out = StringBuffer();
  var i = 0;
  while (i < pattern.length) {
    final ch = pattern[i];
    final run = _runLength(pattern, i);
    switch (ch) {
      case 'y':
        // 4 位及以上输出完整年份，2 位输出两位年份
        out.write(
          run >= 4 ? _pad(date.year, 4) : _pad(date.year % 100, 2),
        );
      case 'M':
        out.write(run > 1 ? _pad(date.month, 2) : '${date.month}');
      case 'd':
        out.write(run > 1 ? _pad(date.day, 2) : '${date.day}');
      case 'H':
        out.write(run > 1 ? _pad(date.hour, 2) : '${date.hour}');
      case 'h':
        final hour12 = date.hour % 12 == 0 ? 12 : date.hour % 12;
        out.write(run > 1 ? _pad(hour12, 2) : '$hour12');
      case 'm':
        out.write(run > 1 ? _pad(date.minute, 2) : '${date.minute}');
      case 's':
        out.write(run > 1 ? _pad(date.second, 2) : '${date.second}');
      case 'a':
        out.write(date.hour < 12 ? 'AM' : 'PM');
      default:
        out.write(ch);
        i += 1;
        continue;
    }
    i += run;
  }
  return out.toString();
}

/// 按 [pattern] 格式化一天中的时间（只用到时分秒字段）。
String formatAntTimeOfDay(TimeOfDay time, String pattern) => formatAntDate(
      DateTime(2000, 1, 1, time.hour, time.minute),
      pattern,
    );

int _runLength(String pattern, int start) {
  var i = start;
  while (i < pattern.length && pattern[i] == pattern[start]) {
    i++;
  }
  return i - start;
}

String _pad(int value, int width) => value.toString().padLeft(width, '0');
