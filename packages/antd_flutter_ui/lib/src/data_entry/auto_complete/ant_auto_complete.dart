/// AntAutoComplete — antd React AutoComplete 的 Flutter 实现
///
/// API 与 antd React AutoComplete 对齐：
/// - [options] — 补全选项列表（任意模型 `List<T>`）
/// - [value] / [defaultValue] — 受控/非受控文本值
/// - [onChange] — 输入值变化回调
/// - [onSelect] — 选中选项回调（回传模型 `T`）
/// - [labelOf] / [valueOf] — 选项展示文案 / 回填文本
/// - [filterOption] — 是否根据输入过滤选项
/// - [allowClear] — 清除按钮
/// - [placeholder] / [disabled] / [size]
///
/// ```dart
/// AntAutoComplete<User>(
///   options: users,
///   labelOf: (u) => u.name,
///   valueOf: (u) => u.email,
///   onSelect: (u) => print(u.id),
/// )
/// ```
library;

import 'package:antd_flutter_ui/src/engines/popup_engine.dart';
import 'package:antd_flutter_ui/src/engines/popup_overlay.dart';
import 'package:antd_flutter_ui/src/data_entry/auto_complete/ant_auto_complete_types.dart';
import 'package:antd_flutter_ui/src/data_entry/input/ant_field_surface.dart';
import 'package:antd_flutter_ui/src/data_entry/input/ant_input_field.dart';
import 'package:antd_flutter_ui/src/data_entry/input/ant_input_types.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

export 'package:antd_flutter_ui/src/data_entry/auto_complete/ant_auto_complete_types.dart';

// ============================================================
// AntAutoComplete
// ============================================================

/// 自动补全输入组件。
///
/// 输入时展示匹配的选项下拉，选中后回填输入框。
class AntAutoComplete<T> extends StatefulWidget {
  const AntAutoComplete({
    super.key,
    this.options = const [],
    this.labelOf,
    this.valueOf,
    this.disabledOf,
    this.itemBuilder,
    this.value,
    this.defaultValue,
    this.onChange,
    this.onSelect,
    this.placeholder,
    this.disabled = false,
    this.allowClear = false,
    this.filterOption = true,
    this.size = AntAutoCompleteSize.middle,
    this.autofocus = false,
  });

  /// 补全选项列表（任意模型）。
  final List<T> options;

  /// 选项展示文案（下拉行文本 + 过滤匹配文本），缺省 `'$item'`。
  final String Function(T item)? labelOf;

  /// 选中后回填到输入框的文本，缺省与 [labelOf] 一致。
  final String Function(T item)? valueOf;

  /// 选项是否禁用。
  final bool Function(T item)? disabledOf;

  /// 整行下拉项自定义渲染（仍由组件负责点击与禁用态）。
  final Widget Function(BuildContext context, T item, int index)? itemBuilder;

  /// 受控值
  final String? value;

  /// 非受控默认值
  final String? defaultValue;

  /// 输入值变化回调
  final ValueChanged<String>? onChange;

  /// 选中选项回调（回传模型对象）。
  final ValueChanged<T>? onSelect;

  /// 占位文本
  final String? placeholder;

  /// 是否禁用
  final bool disabled;

  /// 是否显示清除按钮
  final bool allowClear;

  /// 是否根据输入过滤选项
  final bool filterOption;

  /// 尺寸
  final AntAutoCompleteSize size;

  /// 自动聚焦
  final bool autofocus;

  @override
  State<AntAutoComplete<T>> createState() => _AntAutoCompleteState<T>();
}

class _AntAutoCompleteState<T> extends State<AntAutoComplete<T>>
    with PopupContentRefresher<AntAutoComplete<T>> {
  /// 触发元素 GlobalKey（弹层基座 AntPopupOverlay 定位/镂空遮挡用；
  /// 镂空遮挡不遮触发输入框，弹层打开时输入框可继续输入）。
  final GlobalKey _triggerKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();
  late final TextEditingController _controller;
  OverlayEntry? _overlayEntry;
  bool _open = false;
  String? _internalValue;
  int? _highlightedIndex;

  /// 当前主题（组件 context 下捕获，overlay builder 经字段重读）。
  AntThemeData _themeData = AntThemeData.light();

  String get _currentValue => widget.value ?? _internalValue ?? '';

  /// 输入文字字号：桌面跟随 antd（14），移动端跟随 antd-mobile（17）。
  double _textSizeOf(AntThemeData t, AntInputSize size, bool isMobile) {
    final base = antFieldFontSizeOf(t, size);
    if (!isMobile) return base;
    switch (size) {
      case AntInputSize.small:
        return base + 2;
      case AntInputSize.middle:
        return base + 3;
      case AntInputSize.large:
        return base + 4;
    }
  }

  AntInputSize get _inputSize {
    switch (widget.size) {
      case AntAutoCompleteSize.large:
        return AntInputSize.large;
      case AntAutoCompleteSize.small:
        return AntInputSize.small;
      case AntAutoCompleteSize.middle:
        return AntInputSize.middle;
    }
  }

  @override
  void initState() {
    super.initState();
    _internalValue = widget.defaultValue;
    _controller = TextEditingController(text: _currentValue);
    if (widget.autofocus) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _focusNode.requestFocus());
    }
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant AntAutoComplete<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value ?? '';
      _controller.selection =
          TextSelection.collapsed(offset: _controller.text.length);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _overlayEntry?.remove();
    _overlayEntry = null;
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus && !widget.disabled) {
      _showOverlay();
    } else if (!_focusNode.hasFocus) {
      // 延迟关闭以允许点击选项
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_focusNode.hasFocus) _removeOverlay();
      });
    }
  }

  /// 键盘上下选择 + Enter 确认（弹层打开时生效）。
  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (!_open) return KeyEventResult.ignored;
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final options = _filteredOptions;
    if (options.isEmpty) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      setState(() {
        _highlightedIndex =
            ((_highlightedIndex ?? -1) + 1).clamp(0, options.length - 1);
      });
      refreshPopupContent();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      setState(() {
        _highlightedIndex = ((_highlightedIndex ?? options.length) - 1)
            .clamp(0, options.length - 1);
      });
      refreshPopupContent();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      final idx = _highlightedIndex;
      if (idx != null && idx >= 0 && idx < options.length) {
        _selectOption(options[idx]);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  /// 选项展示文案。
  String _labelOf(T item) => widget.labelOf?.call(item) ?? '$item';

  /// 选项回填文本。
  String _valueOf(T item) => widget.valueOf?.call(item) ?? _labelOf(item);

  /// 选项是否禁用。
  bool _disabledOf(T item) => widget.disabledOf?.call(item) ?? false;

  List<T> get _filteredOptions {
    if (!widget.filterOption || _currentValue.isEmpty) {
      return widget.options;
    }
    final query = _currentValue.toLowerCase();
    return widget.options
        .where((o) => _labelOf(o).toLowerCase().contains(query))
        .toList();
  }

  /// 弹层：承载层换为统一弹层基座 [AntPopupOverlay]（方向决策/边界翻转/
  /// 滑动夹回/镂空遮挡/fade+scale 动画）；镂空遮挡保证输入框可继续输入。
  void _showOverlay() {
    if (_open) return;
    _highlightedIndex = null;
    _themeData = AntTheme.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => _AutoCompleteOverlay<T>(
        triggerKey: _triggerKey,
        themeData: _themeData,
        options: _filteredOptions,
        highlightedIndex: _highlightedIndex,
        labelOf: _labelOf,
        disabledOf: _disabledOf,
        itemBuilder: widget.itemBuilder,
        onSelect: _selectOption,
        onDismiss: _dismiss,
      ),
    );
    popupContentEntry = _overlayEntry;
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
    setState(() => _open = true);
  }

  /// 点击弹层外关闭（清 highlight + 收起键盘焦点）。
  void _dismiss() {
    _highlightedIndex = null;
    if (_focusNode.hasFocus) _focusNode.unfocus();
    _removeOverlay();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    popupContentEntry = null;
    _overlayEntry = null;
    if (_open) setState(() => _open = false);
  }

  /// 输入联想内容变化：原地重建面板（PopupContentRefresher 统一沉淀方式，
  /// 不 remove+reinsert —— 避免动画重放闪烁与首帧估算尺寸跳位）。
  void _updateOverlay() {
    if (_overlayEntry != null) {
      refreshPopupContent();
    }
  }

  void _selectOption(T option) {
    if (_disabledOf(option)) return;
    final text = _valueOf(option);
    setState(() {
      _internalValue = text;
      _highlightedIndex = null;
    });
    _controller.text = text;
    _controller.selection = TextSelection.collapsed(offset: text.length);
    widget.onChange?.call(text);
    widget.onSelect?.call(option);
    _removeOverlay();
    _focusNode.unfocus();
  }

  void _onInputChanged(String text) {
    setState(() => _internalValue = text);
    widget.onChange?.call(text);
    if (!_open && _focusNode.hasFocus) {
      _showOverlay();
    } else {
      _highlightedIndex = null;
      _updateOverlay();
    }
  }

  void _clear() {
    setState(() => _internalValue = '');
    _controller.text = '';
    widget.onChange?.call('');
    _updateOverlay();
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final showClear =
        widget.allowClear && _currentValue.isNotEmpty && !widget.disabled;

    final inputSize = _inputSize;
    final fieldHeight = t.s(antFieldHeightOf(t, inputSize));
    final isMobile = MediaQuery.sizeOf(context).width < 768;
    final textSize = _textSizeOf(t, inputSize, isMobile);

    return Focus(
      onKeyEvent: _handleKeyEvent,
      child: Container(
        key: _triggerKey,
        height: fieldHeight,
        decoration: BoxDecoration(
          color:
              widget.disabled ? t.colorBgContainerDisabled : t.colorBgContainer,
          borderRadius: BorderRadius.circular(t.borderRadius),
          // 聚焦光环：2px 无模糊实心外扩环（对齐 Input / antd web）。
          boxShadow: _focusNode.hasFocus
              ? antFieldFocusRingOf(t, AntInputStatus.normal)
              : null,
        ),
        // 边框恒 1px 画在前景层，聚焦不再让内容位移。
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(t.borderRadius),
          border: Border.all(
            color: antFieldBorderColorOf(
              t,
              AntInputStatus.normal,
              focused: _focusNode.hasFocus,
            ),
            width: 1,
          ),
        ),
        // embedded 装饰器无固有偏移：marginSM+4 → 字形内缩 17.3，与 Input 家族
        // （standalone marginSM + 4.33 固有偏移）字形对齐，基座单点标准
        padding: EdgeInsets.symmetric(horizontal: t.marginSM + 4),
        child: Row(
          children: [
            Expanded(
              child: AntInputField(
                controller: _controller,
                focusNode: _focusNode,
                enabled: !widget.disabled,
                placeholder: widget.placeholder,
                size: inputSize,
                textSize: textSize,
                embeddedPadding: (fieldHeight - textSize) / 2,
                mode: AntInputFieldMode.embedded,
                onChanged: _onInputChanged,
              ),
            ),
            if (showClear)
              GestureDetector(
                onTap: _clear,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.only(left: t.s(4)),
                  child: Icon(
                    AntIcons.closeCircleFilled,
                    size: 14,
                    color: t.colorTextQuaternary,
                  ),
                ),
              )
            else if (_open)
              Padding(
                padding: EdgeInsets.only(left: t.s(4)),
                child: Icon(
                  AntIcons.upOutlined,
                  size: 14,
                  color: t.colorTextQuaternary,
                ),
              )
            else
              Padding(
                padding: EdgeInsets.only(left: t.s(4)),
                child: Icon(
                  AntIcons.searchOutlined,
                  size: 14,
                  color: t.colorTextQuaternary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// _AutoCompleteOverlay
// ============================================================

class _AutoCompleteOverlay<T> extends StatelessWidget {
  const _AutoCompleteOverlay({
    required this.triggerKey,
    required this.themeData,
    required this.options,
    required this.highlightedIndex,
    required this.labelOf,
    required this.disabledOf,
    required this.onSelect,
    required this.onDismiss,
    this.itemBuilder,
  });

  /// 触发元素 GlobalKey（弹层基座定位/镂空遮挡）。
  final GlobalKey triggerKey;
  final AntThemeData themeData;
  final List<T> options;
  final int? highlightedIndex;
  final String Function(T item) labelOf;
  final bool Function(T item) disabledOf;
  final Widget Function(BuildContext context, T item, int index)? itemBuilder;
  final ValueChanged<T> onSelect;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final t = themeData;

    // 统一弹层基座：placement 首选下方，视口下方放不下自动翻转上方；
    // 镂空遮挡不遮触发输入框——弹层打开时输入框可继续输入。
    return AntPopupOverlay(
      targetKey: triggerKey,
      placement: AntPopupPlacement.bottom,
      arrow: false,
      gap: 4,
      onDismiss: onDismiss,
      child: _buildPanel(t),
    );
  }

  /// 联想面板：宽度对齐触发元素（不小于 120），高度上限 256，超出内部滚动。
  Widget _buildPanel(AntThemeData t) {
    final triggerBox =
        triggerKey.currentContext?.findRenderObject() as RenderBox?;
    final triggerWidth = (triggerBox != null && triggerBox.hasSize)
        ? triggerBox.size.width
        : 0.0;

    if (options.isEmpty) {
      return Container(
        key: const Key('ant_auto_complete_panel'),
        width: triggerWidth > 120 ? triggerWidth : 120,
        padding: EdgeInsets.symmetric(vertical: t.s(8), horizontal: t.s(12)),
        decoration: BoxDecoration(
          color: t.colorBgContainer,
          borderRadius: BorderRadius.circular(t.borderRadiusLG),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          '无匹配项',
          style: TextStyle(fontSize: t.fontSizeSM, color: t.colorTextDisabled),
        ),
      );
    }

    return Container(
      key: const Key('ant_auto_complete_panel'),
      width: triggerWidth > 120 ? triggerWidth : 120,
      constraints: BoxConstraints(maxHeight: t.s(256)),
      decoration: BoxDecoration(
        color: t.colorBgContainer,
        borderRadius: BorderRadius.circular(t.borderRadiusLG),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          final isHighlighted = index == highlightedIndex;
          final disabled = disabledOf(option);
          return InkWell(
            onTap: disabled ? null : () => onSelect(option),
            child: itemBuilder != null
                ? itemBuilder!(context, option, index)
                : Container(
                    padding:
                        EdgeInsets.symmetric(vertical: t.s(8), horizontal: t.s(12)),
                    color: disabled
                        ? t.colorFillSecondary.withValues(alpha: 0.3)
                        : isHighlighted
                            ? t.colorFillSecondary
                            : null,
                    child: Text(
                      labelOf(option),
                      style: TextStyle(
                        fontSize: t.fontSize,
                        color: disabled ? t.colorTextDisabled : t.colorText,
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
