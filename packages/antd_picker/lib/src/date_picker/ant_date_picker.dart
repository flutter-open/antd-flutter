/// AntDatePicker — antd React DatePicker 的 Flutter 实现
///
/// API 与 antd React DatePicker 对齐：
/// - [value] / [defaultValue] — 受控/非受控日期
/// - [onChange] — 日期变化回调
/// - [allowClear] — 是否允许清除
/// - [placeholder] / [disabled] / [size]
///
/// ```dart
/// AntDatePicker(
///   defaultValue: DateTime(2024, 1, 15),
///   onChange: (date) => print(date),
/// )
/// ```
library;

import 'ant_date_picker_types.dart';
import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';

export 'ant_date_picker_types.dart';
import 'package:material_ui/material_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

// ============================================================
// AntDatePicker
// ============================================================

/// 日期选择框 — 输入或选择日期。
///
/// 对齐 antd React DatePicker 组件。
class AntDatePicker extends StatefulWidget {
  const AntDatePicker({
    super.key,
    this.value,
    this.defaultValue,
    this.onChange,
    this.allowClear = false,
    this.placeholder,
    this.disabled = false,
    this.size = AntDatePickerSize.middle,
    this.format = 'yyyy-MM-dd',
    this.autofocus = false,
    this.labelBuilder,
  });

  /// 受控日期值。
  final DateTime? value;

  /// 非受控初始日期。
  final DateTime? defaultValue;

  /// 日期变化回调。
  final ValueChanged<DateTime?>? onChange;

  /// 是否允许清除。
  final bool allowClear;

  /// 占位文本。
  final String? placeholder;

  /// 是否禁用。
  final bool disabled;

  /// 尺寸。
  final AntDatePickerSize size;

  /// 日期显示格式（目前支持 yyyy-MM-dd）。
  final String format;

  /// 是否自动聚焦。
  final bool autofocus;

  /// 触发器日期自定义渲染；为空时按 [format] 格式化显示。
  final Widget Function(BuildContext context, DateTime date)? labelBuilder;

  @override
  State<AntDatePicker> createState() => _AntDatePickerState();
}

class _AntDatePickerState extends State<AntDatePicker> {
  final GlobalKey _fieldKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _internalOpen = false;
  DateTime? _internalValue;
  late DateTime _panelMonth;

  bool get _currentOpen => _internalOpen;

  DateTime? get _currentValue => widget.value ?? _internalValue;

  @override
  void initState() {
    super.initState();
    _internalValue = widget.defaultValue;
    _panelMonth = _currentValue ?? DateTime.now();
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _setOpen(bool value) {
    if (!mounted) return;
    setState(() {
      _internalOpen = value;
    });
    if (value) {
      _panelMonth = _currentValue ?? DateTime.now();
      _showOverlay();
    } else {
      _hideOverlay();
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    if (!mounted) return;
    final theme = AntTheme.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => _DatePickerOverlay(
        fieldKey: _fieldKey,
        panelMonth: _panelMonth,
        selectedDate: _currentValue,
        themeData: theme,
        onPanelChange: (month) {
          if (!mounted) return;
          setState(() => _panelMonth = month);
          _overlayEntry?.markNeedsBuild();
        },
        onSelect: (date) {
          _internalValue = date;
          widget.onChange?.call(date);
          _setOpen(false);
        },
        onDismiss: () => _setOpen(false),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _handleClear() {
    _internalValue = null;
    widget.onChange?.call(null);
    if (mounted) setState(() {});
  }

  String _formatDate(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  /// 触发器高度 — 取尺寸级对应的高度 token（不再硬编码 40/32/24，
  /// 主题自定义 controlHeight* 时同步生效）。
  double _controlHeight(AntThemeData theme) {
    switch (widget.size) {
      case AntDatePickerSize.large:
        return theme.controlHeightLG;
      case AntDatePickerSize.middle:
        return theme.controlHeight;
      case AntDatePickerSize.small:
        return theme.controlHeightSM;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final height = theme.s(_controlHeight(theme));
    final open = _currentOpen;
    final value = _currentValue;

    final showClear = widget.allowClear && value != null && !widget.disabled;

    return GestureDetector(
      onTap: widget.disabled ? null : () => _setOpen(!open),
      child: CompositedTransformTarget(
        link: _layerLink,
        // 装饰：底色/圆角 + 前景边框（不参与布局，打开态不产生内容位移）
        // + 焦点光环（antd 语义：无模糊的实心外扩环，非模糊辉光）
        child: AnimatedContainer(
          key: _fieldKey,
          height: height,
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(horizontal: theme.marginSM),
          decoration: BoxDecoration(
            color: widget.disabled
                ? theme.colorBgContainerDisabled
                : theme.colorBgContainer,
            borderRadius: BorderRadius.circular(theme.borderRadius),
            boxShadow: open && !widget.disabled
                ? [
                    BoxShadow(
                      color: theme.controlOutline,
                      spreadRadius: theme.controlOutlineWidth,
                    ),
                  ]
                : null,
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(theme.borderRadius),
            border: Border.all(
              // 打开态主色边框（与 Input 聚焦语义一致），宽度恒定 1
              // ——此前用 controlOutline 当边框色 + 宽度 1→2 切换，
              // 既颜色发灰又引起加粗抖动
              color: open && !widget.disabled
                  ? theme.colorPrimary
                  : theme.colorBorder,
              width: theme.s(1),
            ),
          ),
          child: Row(
            children: [
              Icon(
                AntIcons.calendarOutlined,
                size: theme.s(14),
                color: widget.disabled
                    ? theme.colorTextDisabled
                    : theme.colorTextSecondary,
              ),
              SizedBox(width: theme.s(8)),
              Expanded(
                child: value == null
                    ? Text(
                        widget.placeholder ?? '请选择日期',
                        style: TextStyle(
                          fontSize: theme.fontSize,
                          color: theme.colorTextPlaceholder,
                        ),
                      )
                    : DefaultTextStyle.merge(
                        style: TextStyle(
                          fontSize: theme.fontSize,
                          color: theme.colorText,
                        ),
                        child: widget.labelBuilder?.call(context, value) ??
                            Text(_formatDate(value)),
                      ),
              ),
              if (showClear)
                GestureDetector(
                  onTap: _handleClear,
                  child: Icon(
                    AntIcons.closeCircleFilled,
                    size: theme.s(14),
                    color: theme.colorTextPlaceholder,
                  ),
                )
              else
                Icon(
                  AntIcons.downOutlined,
                  size: theme.s(14),
                  color: widget.disabled
                      ? theme.colorTextDisabled
                      : theme.colorTextSecondary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// _DatePickerOverlay — 日历浮层
// ============================================================

class _DatePickerOverlay extends StatelessWidget {
  const _DatePickerOverlay({
    required this.fieldKey,
    required this.panelMonth,
    required this.selectedDate,
    required this.themeData,
    required this.onPanelChange,
    required this.onSelect,
    required this.onDismiss,
  });

  final GlobalKey fieldKey;
  final DateTime panelMonth;
  final DateTime? selectedDate;
  final AntThemeData themeData;
  final ValueChanged<DateTime> onPanelChange;
  final ValueChanged<DateTime> onSelect;
  final VoidCallback onDismiss;

  static const _weekdays = ['日', '一', '二', '三', '四', '五', '六'];

  @override
  Widget build(BuildContext context) {
    final theme = themeData;

    final year = panelMonth.year;
    final month = panelMonth.month;
    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final leadingBlanks = firstDay.weekday % 7;

    final today = DateTime.now();
    bool isToday(d) =>
        d.year == today.year && d.month == today.month && d.day == today.day;

    final dayCells = <Widget>[];
    for (var i = 0; i < leadingBlanks; i++) {
      dayCells.add(const SizedBox.shrink());
    }
    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      final selected = selectedDate != null &&
          selectedDate!.year == date.year &&
          selectedDate!.month == date.month &&
          selectedDate!.day == date.day;
      dayCells.add(
        _DayCell(
          day: day,
          selected: selected,
          isToday: isToday(date),
          theme: theme,
          onTap: () => onSelect(date),
        ),
      );
    }

    // 弹层基座：位置计算/边界翻转夹回/点击外部关闭统一走 AntPopupOverlay
    return AntPopupOverlay(
      targetKey: fieldKey,
      placement: AntPopupPlacement.bottomLeft,
      onDismiss: onDismiss,
      child: Container(
        width: theme.s(280),
        padding: EdgeInsets.all(theme.s(12)),
        decoration: BoxDecoration(
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
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 年月导航
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavButton(
                  icon: AntIcons.leftOutlined,
                  theme: theme,
                  onTap: () => onPanelChange(
                    DateTime(year, month - 1, 1),
                  ),
                ),
                Text(
                  '$year年$month月',
                  style: TextStyle(
                    fontSize: theme.fontSize,
                    fontWeight: FontWeight.w600,
                    color: theme.colorText,
                  ),
                ),
                _NavButton(
                  icon: AntIcons.rightOutlined,
                  theme: theme,
                  onTap: () => onPanelChange(
                    DateTime(year, month + 1, 1),
                  ),
                ),
              ],
            ),
            SizedBox(height: theme.s(8)),
            // 星期表头
            Row(
              children: _weekdays
                  .map(
                    (w) => Expanded(
                      child: Center(
                        child: Text(
                          w,
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
            // 日期网格
            GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: theme.s(2),
              crossAxisSpacing: theme.s(2),
              childAspectRatio: 1,
              children: dayCells,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// _DayCell — 日期单元格
// ============================================================

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.selected,
    required this.isToday,
    required this.theme,
    required this.onTap,
  });

  final int day;
  final bool selected;
  final bool isToday;
  final AntThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = theme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? t.colorPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(t.borderRadius),
          border: isToday && !selected
              ? Border.all(color: t.colorPrimary, width: theme.s(1))
              : null,
        ),
        child: Center(
          child: Text(
            '$day',
            style: TextStyle(
              fontSize: t.fontSizeSM,
              color: selected
                  ? Colors.white
                  : isToday
                      ? t.colorPrimary
                      : t.colorText,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// _NavButton — 月份导航按钮
// ============================================================

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.theme,
    required this.onTap,
  });

  final IconData icon;
  final AntThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    );
  }
}
