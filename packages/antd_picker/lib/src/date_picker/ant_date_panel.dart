/// 日期月份面板（内部共享组件）。
///
/// `AntDatePicker`（单日期）与 `AntDateRangePicker`（范围）共用同一套面板：
/// - 年月导航 + 周表头（周标签来自 [AntPickerLocale]）；
/// - 固定 6×7 = 42 格网格：不同月份行数一致，翻月时面板高度不抖动；
/// - 单元格外观由 [cellBuilder] 决定（单日期高亮 / 范围色带）；
/// - 鼠标悬停经 [onHover] 上报（范围选择用悬停预览）。
library;

import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import '../locale/ant_picker_locale.dart';

/// 单元格状态，供 [AntDateMonthPanel.cellBuilder] 装饰。
class AntDateCellData {
  /// 创建单元格状态。
  const AntDateCellData({
    required this.date,
    required this.isToday,
    this.isSelected = false,
    this.isRangeStart = false,
    this.isRangeEnd = false,
    this.isInRange = false,
  });

  /// 该格对应日期（当天 00:00）。
  final DateTime date;

  /// 是否为今天。
  final bool isToday;

  /// 是否为选中日期（单日期模式）。
  final bool isSelected;

  /// 是否为范围起点。
  final bool isRangeStart;

  /// 是否为范围终点。
  final bool isRangeEnd;

  /// 是否落在范围中间（不含起终点）。
  final bool isInRange;

  /// 是否属于范围（含起终点）。
  bool get isInAnyRange => isRangeStart || isRangeEnd || isInRange;
}

/// 月份面板 — 年月导航 + 周表头 + 6×7 日期网格。
class AntDateMonthPanel extends StatelessWidget {
  /// 创建月份面板。
  const AntDateMonthPanel({
    super.key,
    required this.theme,
    required this.locale,
    required this.panelMonth,
    required this.onPanelChange,
    required this.cellBuilder,
    this.weekStartsOnMonday = false,
    this.onHover,
    this.showToday = true,
    this.onToday,
  });

  /// 主题数据。
  final AntThemeData theme;

  /// 国际化文案。
  final AntPickerLocale locale;

  /// 当前面板月份（该月任意一天）。
  final DateTime panelMonth;

  /// 翻月回调（传入目标月份第一天）。
  final ValueChanged<DateTime> onPanelChange;

  /// 单元格构造器。
  final Widget Function(BuildContext context, AntDateCellData data) cellBuilder;

  /// 周起始是否为周一（false 为周日，默认与既有行为一致）。
  final bool weekStartsOnMonday;

  /// 鼠标悬停日期上报（离开时传 null）。
  final ValueChanged<DateTime?>? onHover;

  /// 是否显示「今天」快捷按钮。
  final bool showToday;

  /// 「今天」按钮回调。
  final VoidCallback? onToday;

  @override
  Widget build(BuildContext context) {
    final year = panelMonth.year;
    final month = panelMonth.month;
    final firstDay = DateTime(year, month, 1);
    final leadingBlanks =
        weekStartsOnMonday ? firstDay.weekday - 1 : firstDay.weekday % 7;
    final today = DateTime.now();
    final cells = <Widget>[];

    for (var index = 0; index < 42; index++) {
      final dayOffset = index - leadingBlanks + 1;
      if (dayOffset < 1 || dayOffset > 31) {
        cells.add(const SizedBox.shrink());
        continue;
      }
      final date = DateTime(year, month, dayOffset);
      if (date.month != month) {
        cells.add(const SizedBox.shrink());
        continue;
      }
      final data = AntDateCellData(
        date: date,
        isToday: isSameDay(date, today),
      );
      final cell = cellBuilder(context, data);
      if (onHover == null) {
        cells.add(cell);
      } else {
        cells.add(
          MouseRegion(
            onEnter: (_) => onHover!(date),
            onExit: (_) => onHover!(null),
            child: cell,
          ),
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _PanelNavButton(
              icon: AntIcons.leftOutlined,
              theme: theme,
              semanticLabel: 'prev month',
              onTap: () => onPanelChange(DateTime(year, month - 1, 1)),
            ),
            Text(
              locale.monthTitle(year, month),
              style: TextStyle(
                fontSize: theme.fontSize,
                fontWeight: FontWeight.w600,
                color: theme.colorText,
              ),
            ),
            _PanelNavButton(
              icon: AntIcons.rightOutlined,
              theme: theme,
              semanticLabel: 'next month',
              onTap: () => onPanelChange(DateTime(year, month + 1, 1)),
            ),
          ],
        ),
        SizedBox(height: theme.s(8)),
        Row(
          children: locale
              .weekLabelsFor(weekStartsOnMonday: weekStartsOnMonday)
              .map(
                (label) => Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: theme.fontSizeSM,
                        color: theme.colorTextTertiary,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(height: theme.s(4)),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: theme.s(2),
            crossAxisSpacing: 0,
            childAspectRatio: 1,
          ),
          itemCount: cells.length,
          itemBuilder: (context, index) => cells[index],
        ),
        if (showToday)
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onToday,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: theme.s(4),
                  vertical: theme.s(4),
                ),
                child: Text(
                  locale.effectiveTodayText,
                  style: TextStyle(
                    fontSize: theme.fontSizeSM,
                    color: theme.colorPrimary,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// 面板弹层容器装饰（气泡底色/圆角/描边/阴影）。
BoxDecoration antDatePanelDecoration(AntThemeData theme) => BoxDecoration(
      color: theme.colorBgContainer,
      borderRadius: BorderRadius.circular(theme.borderRadiusLG),
      border: Border.all(color: theme.colorSplit),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );

/// 是否为同一天。
bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// 去掉时分秒。
DateTime dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

/// 合并日期与时间。
DateTime mergeDateAndTime(DateTime date, TimeOfDay time) =>
    DateTime(date.year, date.month, date.day, time.hour, time.minute);

/// 在 [start] 与 [end] 之间（取日期粒度）是否包含 [date]。
bool isBetweenDays(DateTime date, DateTime start, DateTime end) {
  final target = dateOnly(date);
  final from = dateOnly(start);
  final to = dateOnly(end);
  return !target.isBefore(from) && !target.isAfter(to);
}

// ============================================================
// _PanelNavButton — 月份导航按钮
// ============================================================

class _PanelNavButton extends StatelessWidget {
  const _PanelNavButton({
    required this.icon,
    required this.theme,
    required this.onTap,
    this.semanticLabel,
  });

  final IconData icon;
  final AntThemeData theme;
  final VoidCallback onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: theme.s(28),
          height: theme.s(28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(theme.borderRadius),
          ),
          child: Icon(
            icon,
            size: theme.s(18),
            color: theme.colorTextSecondary,
          ),
        ),
      ),
    );
  }
}
