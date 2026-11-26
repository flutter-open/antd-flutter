/// AntTimePicker — antd React TimePicker 的 Flutter 实现
///
/// API 与 antd React TimePicker 对齐：
/// - [value] / [defaultValue] — 受控/非受控时间
/// - [onChange] — 时间变化回调
/// - [allowClear] — 是否允许清除
/// - [placeholder] / [disabled] / [size] / [hourStep] / [minuteStep] / [secondStep]
/// - [format] / [locale] — 显示格式与国际化文案
///
/// ```dart
/// AntTimePicker(
///   defaultValue: TimeOfDay(hour: 10, minute: 30),
///   onChange: (time) => print(time),
/// )
/// ```
library;

import 'ant_time_picker_types.dart';
import '../locale/ant_date_format.dart';
import '../locale/ant_picker_locale.dart';
import 'ant_time_wheel.dart';
import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';

export 'ant_time_picker_types.dart';
import 'package:material_ui/material_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

// ============================================================
// AntTimePicker
// ============================================================

/// 时间选择框 — 输入或选择时间。
///
/// 对齐 antd React TimePicker 组件。
class AntTimePicker extends StatefulWidget {
  const AntTimePicker({
    super.key,
    this.value,
    this.defaultValue,
    this.onChange,
    this.allowClear = false,
    this.placeholder,
    this.disabled = false,
    this.size = AntTimePickerSize.middle,
    this.hourStep = 1,
    this.minuteStep = 1,
    this.secondStep = 1,
    this.format,
    this.locale,
    this.autofocus = false,
    this.labelBuilder,
  });

  /// 受控时间值。
  final TimeOfDay? value;

  /// 非受控初始时间。
  final TimeOfDay? defaultValue;

  /// 时间变化回调。
  final ValueChanged<TimeOfDay?>? onChange;

  /// 是否允许清除。
  final bool allowClear;

  /// 占位文本（为空时取 [locale] 的时间占位文案）。
  final String? placeholder;

  /// 是否禁用。
  final bool disabled;

  /// 尺寸。
  final AntTimePickerSize size;

  /// 小时步长。
  final int hourStep;

  /// 分钟步长。
  final int minuteStep;

  /// 秒步长。
  final int secondStep;

  /// 时间显示格式（如 `HH:mm:ss`）；为空时取 [locale] 的默认时间格式。
  final String? format;

  /// 国际化文案；为空时依次取 `AntPickerLocaleProvider`、App 语言、中文。
  final AntPickerLocale? locale;

  /// 是否自动聚焦。
  final bool autofocus;

  /// 触发器时间自定义渲染；为空时按 [format] 格式化显示。
  final Widget Function(BuildContext context, TimeOfDay time)? labelBuilder;

  @override
  State<AntTimePicker> createState() => _AntTimePickerState();
}

class _AntTimePickerState extends State<AntTimePicker> {
  final GlobalKey _fieldKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _internalOpen = false;
  TimeOfDay? _internalValue;

  bool get _currentOpen => _internalOpen;

  TimeOfDay? get _currentValue => widget.value ?? _internalValue;

  @override
  void initState() {
    super.initState();
    _internalValue = widget.defaultValue;
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
      builder: (context) => _TimePickerOverlay(
        fieldKey: _fieldKey,
        value: _currentValue,
        hourStep: widget.hourStep,
        minuteStep: widget.minuteStep,
        secondStep: widget.secondStep,
        themeData: theme,
        locale: locale,
        onSelect: (time) {
          _internalValue = time;
          widget.onChange?.call(time);
          if (mounted) {
            setState(() {});
            _overlayEntry?.markNeedsBuild();
          }
        },
        onConfirm: () => _setOpen(false),
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

  /// 触发器高度 — 取尺寸级对应的高度 token。
  double _controlHeight(AntThemeData theme) {
    switch (widget.size) {
      case AntTimePickerSize.large:
        return theme.controlHeightLG;
      case AntTimePickerSize.middle:
        return theme.controlHeight;
      case AntTimePickerSize.small:
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
    final timeFormat = widget.format ?? locale.effectiveTimeFormat;

    final showClear = widget.allowClear && value != null && !widget.disabled;

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
                AntIcons.clockCircleOutlined,
                size: theme.s(14),
                color: widget.disabled
                    ? theme.colorTextDisabled
                    : theme.colorTextSecondary,
              ),
              SizedBox(width: theme.s(8)),
              Expanded(
                child: value == null
                    ? Text(
                        widget.placeholder ?? locale.effectiveTimePlaceholder,
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
                              formatAntTimeOfDay(value, timeFormat),
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
// _TimePickerOverlay — 时间面板浮层
// ============================================================

class _TimePickerOverlay extends StatefulWidget {
  const _TimePickerOverlay({
    required this.fieldKey,
    required this.value,
    required this.hourStep,
    required this.minuteStep,
    required this.secondStep,
    required this.themeData,
    required this.locale,
    required this.onSelect,
    required this.onConfirm,
    required this.onDismiss,
  });

  final GlobalKey fieldKey;
  final TimeOfDay? value;
  final int hourStep;
  final int minuteStep;
  final int secondStep;
  final AntThemeData themeData;
  final AntPickerLocale locale;
  final ValueChanged<TimeOfDay> onSelect;
  final VoidCallback onConfirm;
  final VoidCallback onDismiss;

  @override
  State<_TimePickerOverlay> createState() => _TimePickerOverlayState();
}

class _TimePickerOverlayState extends State<_TimePickerOverlay> {
  late int _hour;
  late int _minute;
  late int _second;

  @override
  void initState() {
    super.initState();
    _hour = widget.value?.hour ?? 0;
    _minute = widget.value?.minute ?? 0;
    _second = 0;
  }

  void _notifyChange() {
    widget.onSelect(TimeOfDay(hour: _hour, minute: _minute));
  }

  List<int> _steps(int max, int step) {
    final values = <int>[];
    for (var v = 0; v < max; v += step <= 0 ? 1 : step) {
      values.add(v);
    }
    return values;
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.themeData;

    final hours = _steps(24, widget.hourStep);
    final minutes = _steps(60, widget.minuteStep);
    final seconds = _steps(60, widget.secondStep);

    // 弹层基座：位置计算/边界翻转夹回/点击外部关闭统一走 AntPopupOverlay
    return AntPopupOverlay(
      targetKey: widget.fieldKey,
      placement: AntPopupPlacement.bottomLeft,
      onDismiss: widget.onDismiss,
      child: Container(
        width: theme.s(280),
        padding: EdgeInsets.symmetric(
          horizontal: theme.s(8),
          vertical: theme.s(8),
        ),
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
            Row(
              children: [
                Expanded(
                  child: AntTimeWheel(
                    items:
                        hours.map((h) => h.toString().padLeft(2, '0')).toList(),
                    selectedIndex: hours.indexOf(
                      _hour.clamp(hours.first, hours.last),
                    ),
                    theme: theme,
                    onSelected: (index) {
                      setState(() => _hour = hours[index]);
                      _notifyChange();
                    },
                  ),
                ),
                _Separator(theme: theme),
                Expanded(
                  child: AntTimeWheel(
                    items: minutes
                        .map((m) => m.toString().padLeft(2, '0'))
                        .toList(),
                    selectedIndex: minutes.indexOf(
                      _minute.clamp(minutes.first, minutes.last),
                    ),
                    theme: theme,
                    onSelected: (index) {
                      setState(() => _minute = minutes[index]);
                      _notifyChange();
                    },
                  ),
                ),
                _Separator(theme: theme),
                Expanded(
                  child: AntTimeWheel(
                    items: seconds
                        .map((s) => s.toString().padLeft(2, '0'))
                        .toList(),
                    selectedIndex: seconds.indexOf(
                      _second.clamp(seconds.first, seconds.last),
                    ),
                    theme: theme,
                    onSelected: (index) {
                      setState(() => _second = seconds[index]);
                      _notifyChange();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: theme.s(8)),
            SizedBox(
              width: double.infinity,
              child: AntButton(
                type: AntButtonType.primary,
                block: true,
                onTap: widget.onConfirm,
                child: Text(
                  widget.locale.effectiveConfirmText,
                  style: TextStyle(fontSize: theme.fontSizeSM),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// _Separator — 时分秒冒号分隔
// ============================================================

class _Separator extends StatelessWidget {
  const _Separator({required this.theme});

  final AntThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.s(2)),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: theme.fontSizeLG,
          color: theme.colorTextSecondary,
        ),
      ),
    );
  }
}
