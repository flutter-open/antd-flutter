/// AntDateRangePicker — antd React DatePicker.RangePicker 的 Flutter 实现
///
/// API 对齐 antd `DatePicker.RangePicker`：
/// - [value] / [defaultValue] — 受控/非受控日期范围（[AntDateRange]）
/// - [onChange] — 范围变化回调
/// - [allowClear] — 是否允许清除
/// - [placeholderStart] / [placeholderEnd] / [separator] — 占位与分隔符
/// - [format] / [locale] — 显示格式与国际化
/// - [showTime] — 是否选择时间（antd `RangePicker showTime` 语义：
///   选完日期后需点确定才提交，时间由开始/结束两组滚轮选择）
///
/// ```dart
/// AntDateRangePicker(
///   defaultValue: AntDateRange(
///     start: DateTime(2024, 1, 15),
///     end: DateTime(2024, 1, 20),
///   ),
///   onChange: (range) => print(range),
/// )
/// ```
library;

import 'ant_date_panel.dart';
import 'ant_date_picker_types.dart';
import 'ant_date_range_types.dart';
import '../locale/ant_date_format.dart';
import '../locale/ant_picker_locale.dart';
import '../time_picker/ant_time_wheel.dart';
import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

export 'ant_date_range_types.dart';

// ============================================================
// AntDateRangePicker
// ============================================================

/// 日期范围选择框 — 一次选择起止日期（可选时间）。
///
/// 对齐 antd React `DatePicker.RangePicker`。
class AntDateRangePicker extends StatefulWidget {
  /// 创建日期范围选择框。
  const AntDateRangePicker({
    super.key,
    this.value,
    this.defaultValue,
    this.onChange,
    this.allowClear = false,
    this.placeholderStart,
    this.placeholderEnd,
    this.separator,
    this.disabled = false,
    this.size = AntDatePickerSize.middle,
    this.format,
    this.locale,
    this.weekStartsOnMonday = false,
    this.showToday = true,
    this.showTime = false,
    this.timeFormat,
    this.autofocus = false,
    this.minDate,
    this.maxDate,
    this.labelBuilder,
  });

  /// 受控范围值。
  final AntDateRange? value;

  /// 非受控初始范围值。
  final AntDateRange? defaultValue;

  /// 范围变化回调。
  final ValueChanged<AntDateRange?>? onChange;

  /// 是否允许清除。
  final bool allowClear;

  /// 起点占位文本（为空时取 [locale] 的起点文案）。
  final String? placeholderStart;

  /// 终点占位文本（为空时取 [locale] 的终点文案）。
  final String? placeholderEnd;

  /// 起止分隔符（为空时取 [locale] 的分隔符，默认 `~`）。
  final String? separator;

  /// 是否禁用。
  final bool disabled;

  /// 尺寸。
  final AntDatePickerSize size;

  /// 日期显示格式；为空时取 [locale] 的默认格式。
  final String? format;

  /// 国际化文案；为空时依次取 `AntPickerLocaleProvider`、App 语言、中文。
  final AntPickerLocale? locale;

  /// 周起始是否为周一（默认周日）。
  final bool weekStartsOnMonday;

  /// 面板是否显示「今天」快捷按钮。
  final bool showToday;

  /// 是否选择时间（相当于 antd `showTime`）。
  final bool showTime;

  /// 时间显示格式；为空时取 [locale] 的默认时间格式（`HH:mm`）。
  final String? timeFormat;

  /// 是否自动聚焦。
  final bool autofocus;

  /// 可选日期下限（含）。
  final DateTime? minDate;

  /// 可选日期上限（含）。
  final DateTime? maxDate;

  /// 触发器自定义渲染；为空时按 [format] / [separator] 拼装起止文案。
  final AntDateRangeLabelBuilder? labelBuilder;

  @override
  State<AntDateRangePicker> createState() => _AntDateRangePickerState();
}

class _AntDateRangePickerState extends State<AntDateRangePicker> {
  final GlobalKey _fieldKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _internalOpen = false;
  AntDateRange? _internalValue;
  late DateTime _panelMonth;

  bool get _currentOpen => _internalOpen;

  AntDateRange? get _currentValue => widget.value ?? _internalValue;

  @override
  void initState() {
    super.initState();
    _internalValue = widget.defaultValue;
    _panelMonth = _currentValue?.start ?? DateTime.now();
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _setOpen(bool value) {
    if (!mounted) return;
    setState(() => _internalOpen = value);
    if (value) {
      _panelMonth = _currentValue?.start ?? DateTime.now();
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
      builder: (context) => _DateRangeOverlay(
        fieldKey: _fieldKey,
        initialRange: _currentValue,
        panelMonth: _panelMonth,
        themeData: theme,
        locale: locale,
        format: widget.format,
        timeFormat: widget.timeFormat,
        weekStartsOnMonday: widget.weekStartsOnMonday,
        showToday: widget.showToday,
        showTime: widget.showTime,
        minDate: widget.minDate,
        maxDate: widget.maxDate,
        onPanelChange: (month) {
          if (!mounted) return;
          setState(() => _panelMonth = month);
          _overlayEntry?.markNeedsBuild();
        },
        onCommit: _commitRange,
        onDismiss: () => _setOpen(false),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void _commitRange(AntDateRange range) {
    _internalValue = range;
    widget.onChange?.call(range);
    _setOpen(false);
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

  /// 触发器高度 — 取尺寸级对应的高度 token。
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

    final dateFormat = widget.format ?? locale.effectiveDateFormat;
    final timeFormat = widget.timeFormat ?? locale.effectiveTimeFormat;
    final separator = widget.separator ?? locale.effectiveRangeSeparator;

    String label(DateTime date) {
      final dateText = formatAntDate(date, dateFormat);
      if (!widget.showTime) return dateText;
      return '$dateText ${formatAntTimeOfDay(TimeOfDay.fromDateTime(date), timeFormat)}';
    }

    final placeholder =
        '${widget.placeholderStart ?? locale.effectiveRangeStartPlaceholder} '
        '$separator '
        '${widget.placeholderEnd ?? locale.effectiveRangeEndPlaceholder}';

    return GestureDetector(
      onTap: widget.disabled ? null : () => _setOpen(!open),
      child: CompositedTransformTarget(
        link: _layerLink,
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
                        placeholder,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                            Text(
                              '${label(value.start)} $separator '
                              '${label(value.end)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
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
// AntDateTimeRangePicker — showTime 默认开启的便捷子类
// ============================================================

/// 日期时间范围选择框 — [AntDateRangePicker] 且 `showTime` 默认为 `true`。
///
/// 对应 antd `DatePicker.RangePicker showTime`：
///
/// ```dart
/// AntDateTimeRangePicker(
///   showTime: true, // 可省略，默认即 true
///   onChange: (range) => print(range),
/// )
/// ```
class AntDateTimeRangePicker extends AntDateRangePicker {
  /// 创建日期时间范围选择框。
  const AntDateTimeRangePicker({
    super.key,
    super.value,
    super.defaultValue,
    super.onChange,
    super.allowClear,
    super.placeholderStart,
    super.placeholderEnd,
    super.separator,
    super.disabled,
    super.size,
    super.format,
    super.locale,
    super.weekStartsOnMonday,
    super.showToday,
    super.showTime = true,
    super.timeFormat,
    super.autofocus,
    super.minDate,
    super.maxDate,
    super.labelBuilder,
  });
}

// ============================================================
// _DateRangeOverlay — 范围日历浮层
// ============================================================

class _DateRangeOverlay extends StatefulWidget {
  const _DateRangeOverlay({
    required this.fieldKey,
    required this.initialRange,
    required this.panelMonth,
    required this.themeData,
    required this.locale,
    required this.format,
    required this.timeFormat,
    required this.weekStartsOnMonday,
    required this.showToday,
    required this.showTime,
    required this.minDate,
    required this.maxDate,
    required this.onPanelChange,
    required this.onCommit,
    required this.onDismiss,
  });

  final GlobalKey fieldKey;
  final AntDateRange? initialRange;
  final DateTime panelMonth;
  final AntThemeData themeData;
  final AntPickerLocale locale;
  final String? format;
  final String? timeFormat;
  final bool weekStartsOnMonday;
  final bool showToday;
  final bool showTime;
  final DateTime? minDate;
  final DateTime? maxDate;
  final ValueChanged<DateTime> onPanelChange;
  final ValueChanged<AntDateRange> onCommit;
  final VoidCallback onDismiss;

  @override
  State<_DateRangeOverlay> createState() => _DateRangeOverlayState();
}

class _DateRangeOverlayState extends State<_DateRangeOverlay> {
  DateTime? _start;
  DateTime? _end;
  DateTime? _hover;

  TimeOfDay _startTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 23, minute: 59);

  @override
  void initState() {
    super.initState();
    final range = widget.initialRange;
    if (range != null) {
      _start = dateOnly(range.start);
      _end = dateOnly(range.end);
      _startTime = TimeOfDay.fromDateTime(range.start);
      _endTime = TimeOfDay.fromDateTime(range.end);
    }
  }

  bool get _awaitingEnd => _start != null && _end == null;

  bool get _hasCompleteRange => _start != null && _end != null;

  bool _isDisabled(DateTime date) {
    final min = widget.minDate;
    final max = widget.maxDate;
    if (min != null && dateOnly(date).isBefore(dateOnly(min))) return true;
    if (max != null && dateOnly(date).isAfter(dateOnly(max))) return true;
    return false;
  }

  void _handleDateTap(DateTime date) {
    if (_isDisabled(date)) return;
    if (_start == null || _hasCompleteRange) {
      setState(() {
        _start = date;
        _end = null;
        _hover = null;
        _startTime = const TimeOfDay(hour: 0, minute: 0);
        _endTime = const TimeOfDay(hour: 23, minute: 59);
      });
      return;
    }
    // 第二次点击：补齐终点（自动保证 start <= end）
    final first = _start!;
    final begin = date.isBefore(first) ? date : first;
    final finish = date.isBefore(first) ? first : date;
    setState(() {
      _start = begin;
      _end = finish;
      _hover = null;
    });
    if (!widget.showTime) {
      widget.onCommit(AntDateRange(start: begin, end: finish));
    }
  }

  void _handleTodayTap() {
    final today = dateOnly(DateTime.now());
    if (_isDisabled(today)) return;
    _handleDateTap(today);
  }

  void _commit() {
    if (!_hasCompleteRange) return;
    var startAt = mergeDateAndTime(_start!, _startTime);
    var endAt = mergeDateAndTime(_end!, _endTime);
    if (endAt.isBefore(startAt)) {
      // 同一天且起止时分倒序：交换时分，保持 end >= start
      startAt = mergeDateAndTime(_start!, _endTime);
      endAt = mergeDateAndTime(_end!, _startTime);
    }
    widget.onCommit(AntDateRange(start: startAt, end: endAt));
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.themeData;
    final locale = widget.locale;
    final dateFormat = widget.format ?? locale.effectiveDateFormat;

    final previewEnd = _end ?? (_awaitingEnd ? _hover : null);

    return AntPopupOverlay(
      targetKey: widget.fieldKey,
      placement: AntPopupPlacement.bottomLeft,
      onDismiss: widget.onDismiss,
      child: Container(
        width: theme.s(widget.showTime ? 320 : 300),
        padding: EdgeInsets.all(theme.s(12)),
        decoration: antDatePanelDecoration(theme),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AntDateMonthPanel(
              theme: theme,
              locale: locale,
              panelMonth: widget.panelMonth,
              weekStartsOnMonday: widget.weekStartsOnMonday,
              showToday: widget.showToday,
              onPanelChange: widget.onPanelChange,
              onToday: _handleTodayTap,
              onHover: (date) {
                if (!_awaitingEnd) return;
                setState(() => _hover = date);
              },
              cellBuilder: (context, data) {
                final start = _start;
                final canPaintRange = start != null && previewEnd != null;
                final isStart = start != null && isSameDay(start, data.date);
                final isEnd = canPaintRange && isSameDay(previewEnd, data.date);
                final inRange = canPaintRange &&
                    isBetweenDays(data.date, start, previewEnd) &&
                    !isStart &&
                    !isEnd;
                return _RangeDayCell(
                  data: AntDateCellData(
                    date: data.date,
                    isToday: data.isToday,
                    isRangeStart: isStart,
                    isRangeEnd: isEnd,
                    isInRange: inRange,
                  ),
                  theme: theme,
                  disabled: _isDisabled(data.date),
                  onTap: () => _handleDateTap(data.date),
                );
              },
            ),
            if (widget.showTime) ...[
              SizedBox(height: theme.s(8)),
              Divider(color: theme.colorSplit, height: theme.s(1)),
              SizedBox(height: theme.s(8)),
              Row(
                children: [
                  Expanded(
                    child: _TimeGroup(
                      theme: theme,
                      label: _start == null
                          ? locale.effectiveRangeStartPlaceholder
                          : formatAntDate(_start!, dateFormat),
                      time: _startTime,
                      enabled: _start != null,
                      onChanged: (time) => setState(() => _startTime = time),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: theme.s(8)),
                    child: Text(
                      locale.effectiveRangeSeparator,
                      style: TextStyle(
                        fontSize: theme.fontSize,
                        color: theme.colorTextSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _TimeGroup(
                      theme: theme,
                      label: _end == null
                          ? locale.effectiveRangeEndPlaceholder
                          : formatAntDate(_end!, dateFormat),
                      time: _endTime,
                      enabled: _end != null,
                      onChanged: (time) => setState(() => _endTime = time),
                    ),
                  ),
                ],
              ),
              SizedBox(height: theme.s(8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: widget.onDismiss,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: theme.s(12),
                        vertical: theme.s(6),
                      ),
                      child: Text(
                        locale.effectiveCancelText,
                        style: TextStyle(
                          fontSize: theme.fontSize,
                          color: theme.colorTextSecondary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: theme.s(8)),
                  AntButton(
                    type: AntButtonType.primary,
                    size: AntButtonSize.small,
                    onTap: _hasCompleteRange ? _commit : null,
                    child: Text(
                      locale.effectiveConfirmText,
                      style: TextStyle(fontSize: theme.fontSizeSM),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================
// _TimeGroup — 单侧时间（日期标签 + 时/分滚轮）
// ============================================================

class _TimeGroup extends StatelessWidget {
  const _TimeGroup({
    required this.theme,
    required this.label,
    required this.time,
    required this.enabled,
    required this.onChanged,
  });

  final AntThemeData theme;
  final String label;
  final TimeOfDay time;
  final bool enabled;
  final ValueChanged<TimeOfDay> onChanged;

  @override
  Widget build(BuildContext context) {
    final hours =
        List<String>.generate(24, (h) => h.toString().padLeft(2, '0'));
    final minutes =
        List<String>.generate(60, (m) => m.toString().padLeft(2, '0'));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: theme.fontSizeSM,
            color:
                enabled ? theme.colorTextSecondary : theme.colorTextPlaceholder,
          ),
        ),
        SizedBox(height: theme.s(4)),
        Row(
          children: [
            Expanded(
              child: AntTimeWheel(
                items: hours,
                selectedIndex: time.hour,
                theme: theme,
                height: 110,
                itemExtent: 30,
                enabled: enabled,
                onSelected: (index) =>
                    onChanged(TimeOfDay(hour: index, minute: time.minute)),
              ),
            ),
            Text(
              ':',
              style: TextStyle(
                fontSize: theme.fontSize,
                color: theme.colorTextSecondary,
              ),
            ),
            Expanded(
              child: AntTimeWheel(
                items: minutes,
                selectedIndex: time.minute,
                theme: theme,
                height: 110,
                itemExtent: 30,
                enabled: enabled,
                onSelected: (index) =>
                    onChanged(TimeOfDay(hour: time.hour, minute: index)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================
// _RangeDayCell — 日期单元格（范围选择）
// ============================================================

class _RangeDayCell extends StatelessWidget {
  const _RangeDayCell({
    required this.data,
    required this.theme,
    required this.disabled,
    required this.onTap,
  });

  final AntDateCellData data;
  final AntThemeData theme;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = theme;
    final endpoint = data.isRangeStart || data.isRangeEnd;
    final inRange = data.isInRange;

    final Color background;
    if (endpoint) {
      background = t.colorPrimary;
    } else if (inRange) {
      background = t.colorPrimaryBg;
    } else {
      background = Colors.transparent;
    }

    final Color textColor;
    if (disabled) {
      textColor = t.colorTextDisabled;
    } else if (endpoint) {
      textColor = Colors.white;
    } else if (inRange) {
      textColor = t.colorPrimary;
    } else if (data.isToday) {
      textColor = t.colorPrimary;
    } else {
      textColor = t.colorText;
    }

    return Semantics(
      button: true,
      selected: endpoint,
      enabled: !disabled,
      child: GestureDetector(
        onTap: disabled ? null : onTap,
        child: Container(
          decoration: BoxDecoration(
            color: background,
            borderRadius:
                endpoint ? BorderRadius.circular(t.borderRadius) : null,
            border: data.isToday && !endpoint && !inRange
                ? Border.all(color: t.colorPrimary, width: theme.s(1))
                : null,
          ),
          child: Center(
            child: Text(
              '${data.date.day}',
              style: TextStyle(fontSize: t.fontSizeSM, color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
