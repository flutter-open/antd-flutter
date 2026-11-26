/// AntDatePicker — antd React DatePicker 的 Flutter 实现
///
/// API 与 antd React DatePicker 对齐：
/// - [value] / [defaultValue] — 受控/非受控日期
/// - [onChange] — 日期变化回调
/// - [allowClear] — 是否允许清除
/// - [placeholder] / [disabled] / [size]
/// - [format] — 显示格式（支持 `yyyy` / `MM` / `dd` / `HH` / `mm` / `ss` 等）
/// - [locale] — 国际化文案（周标签 / 年月标题 / 占位文案跟随语言）
library;

import 'ant_date_panel.dart';
import 'ant_date_picker_types.dart';
import '../locale/ant_date_format.dart';
import '../locale/ant_picker_locale.dart';
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
    this.format,
    this.locale,
    this.weekStartsOnMonday = false,
    this.showToday = true,
    this.autofocus = false,
    this.status = AntInputStatus.normal,
    this.disabledDate,
    this.minDate,
    this.maxDate,
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

  /// 占位文本（为空时取 [locale] 的日期占位文案）。
  final String? placeholder;

  /// 是否禁用。
  final bool disabled;

  /// 尺寸。
  final AntDatePickerSize size;

  /// 日期显示格式，如 `yyyy-MM-dd` / `MM/dd/yyyy` / `yyyy年MM月dd日`。
  ///
  /// 为空时取 [locale] 的默认格式（中文 `yyyy-MM-dd`、英文 `MM/dd/yyyy`）。
  final String? format;

  /// 国际化文案；为空时依次取 `AntPickerLocaleProvider`、App 语言、中文。
  final AntPickerLocale? locale;

  /// 周起始是否为周一（默认周日，与既有行为一致）。
  final bool weekStartsOnMonday;

  /// 面板是否显示「今天」快捷按钮。
  final bool showToday;

  /// 是否自动聚焦。
  final bool autofocus;

  /// 校验状态（error / warning 时边框与光环跟随主题校验色）。
  final AntInputStatus status;

  /// 日期是否不可选；返回 true 的日期不可点击（灰色显示）。
  ///
  /// 与 [minDate] / [maxDate] 同时生效。
  final bool Function(DateTime date)? disabledDate;

  /// 最小可选日期（含当天）。
  final DateTime? minDate;

  /// 最大可选日期（含当天）。
  final DateTime? maxDate;

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
    final locale = AntPickerLocale.resolve(context, widget.locale);
    _overlayEntry = OverlayEntry(
      builder: (context) => _DatePickerOverlay(
        fieldKey: _fieldKey,
        panelMonth: _panelMonth,
        selectedDate: _currentValue,
        themeData: theme,
        locale: locale,
        weekStartsOnMonday: widget.weekStartsOnMonday,
        showToday: widget.showToday,
        onPanelChange: (month) {
          if (!mounted) return;
          setState(() => _panelMonth = month);
          _overlayEntry?.markNeedsBuild();
        },
        disabledDate: _isDisabled,
        onSelect: (date) {
          if (_isDisabled(date)) return;
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

  /// 日期是否不可选（合并 [disabledDate] 与 [minDate] / [maxDate]）。
  bool _isDisabled(DateTime date) {
    final day = dateOnly(date);
    final min = widget.minDate;
    final max = widget.maxDate;
    if (min != null && day.isBefore(dateOnly(min))) return true;
    if (max != null && day.isAfter(dateOnly(max))) return true;
    return widget.disabledDate?.call(day) ?? false;
  }

  /// 按 [AntDatePicker.format]（为空时取 locale 默认格式）格式化日期。
  String _formatDate(DateTime date, AntPickerLocale locale) =>
      formatAntDate(date, widget.format ?? locale.effectiveDateFormat);

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
    final locale = AntPickerLocale.resolve(context, widget.locale);
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
                ? antFieldFocusRingOf(theme, widget.status)
                : null,
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(theme.borderRadius),
            border: Border.all(
              // 打开态主色边框（与 Input 聚焦语义一致），宽度恒定 1
              // ——此前用 controlOutline 当边框色 + 宽度 1→2 切换，
              // 既颜色发灰又引起加粗抖动
              color: widget.disabled
                  ? theme.colorBorderDisabled
                  : antFieldBorderColorOf(
                      theme,
                      widget.status,
                      focused: open,
                    ),
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
                        widget.placeholder ?? locale.effectiveDatePlaceholder,
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
                            Text(_formatDate(value, locale)),
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
    required this.locale,
    required this.weekStartsOnMonday,
    required this.showToday,
    required this.onPanelChange,
    required this.onSelect,
    required this.onDismiss,
    required this.disabledDate,
  });

  final GlobalKey fieldKey;
  final DateTime panelMonth;
  final DateTime? selectedDate;
  final AntThemeData themeData;
  final AntPickerLocale locale;
  final bool weekStartsOnMonday;
  final bool showToday;
  final ValueChanged<DateTime> onPanelChange;
  final ValueChanged<DateTime> onSelect;
  final VoidCallback onDismiss;
  final bool Function(DateTime date) disabledDate;

  @override
  Widget build(BuildContext context) {
    final theme = themeData;

    // 弹层基座：位置计算/边界翻转夹回/点击外部关闭统一走 AntPopupOverlay
    return AntPopupOverlay(
      targetKey: fieldKey,
      placement: AntPopupPlacement.bottomLeft,
      onDismiss: onDismiss,
      child: Container(
        width: theme.s(280),
        padding: EdgeInsets.all(theme.s(12)),
        decoration: antDatePanelDecoration(theme),
        child: AntDateMonthPanel(
          theme: theme,
          locale: locale,
          panelMonth: panelMonth,
          weekStartsOnMonday: weekStartsOnMonday,
          showToday: showToday,
          onPanelChange: onPanelChange,
          disabledDate: disabledDate,
          onToday: () {
            final today = dateOnly(DateTime.now());
            if (disabledDate(today)) return;
            onSelect(today);
          },
          cellBuilder: (context, data) => _DayCell(
            data: AntDateCellData(
              date: data.date,
              isToday: data.isToday,
              isDisabled: disabledDate(data.date),
              isSelected:
                  selectedDate != null && isSameDay(selectedDate!, data.date),
            ),
            theme: theme,
            onTap: () => onSelect(data.date),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// _DayCell — 日期单元格（单日期选择）
// ============================================================

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.data,
    required this.theme,
    required this.onTap,
  });

  final AntDateCellData data;
  final AntThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = theme;
    final selected = data.isSelected;
    final disabled = data.isDisabled;
    return Semantics(
      button: true,
      selected: selected,
      enabled: !disabled,
      child: GestureDetector(
        onTap: disabled ? null : onTap,
        child: Container(
          decoration: BoxDecoration(
            color: selected ? t.colorPrimary : Colors.transparent,
            borderRadius: BorderRadius.circular(t.borderRadius),
            border: data.isToday && !selected
                ? Border.all(color: t.colorPrimary, width: theme.s(1))
                : null,
          ),
          child: Center(
            child: Text(
              '${data.date.day}',
              style: TextStyle(
                fontSize: t.fontSizeSM,
                color: disabled
                    ? t.colorTextDisabled
                    : selected
                        ? Colors.white
                        : data.isToday
                            ? t.colorPrimary
                            : t.colorText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
