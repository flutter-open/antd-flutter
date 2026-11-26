/// AntMentions — antd React Mentions 的 Flutter 实现
///
/// 在输入中提及某人或某物，输入 [prefix]（默认 '@'）触发选项弹出。
///
/// API 与 antd React Mentions 对齐：
/// - [options] — 提及选项列表（任意模型 `List<T>`）
/// - [labelOf] / [valueOf] — 选项展示文案 / 插入文本
/// - [value] / [defaultValue] — 受控/非受控文本值
/// - [onChange] — 文本变化回调
/// - [onSelect] — 选中提及项回调（回传模型 `T`）
/// - [prefix] — 触发字符（默认 '@'）
/// - [placeholder] / [disabled] / [allowClear] / [size]
/// - [maxRows] — 最大行数
///
/// ```dart
/// AntMentions<User>(
///   options: users,
///   labelOf: (u) => u.name,
///   valueOf: (u) => u.username,
///   onSelect: (u) => print(u.id),
///   onChange: (text) => print(text),
/// )
/// ```
library;

import 'package:antd_flutter_ui/src/engines/popup_engine.dart';
import 'package:antd_flutter_ui/src/engines/popup_overlay.dart';
import 'package:antd_flutter_ui/src/data_entry/mentions/ant_mentions_types.dart';
import 'package:antd_flutter_ui/src/data_entry/input/ant_field_surface.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

export 'package:antd_flutter_ui/src/data_entry/mentions/ant_mentions_types.dart';

// ============================================================
// AntMentions
// ============================================================

/// 提及组件。
///
/// 在文本输入中通过输入 '@' 等前缀触发选项列表。
class AntMentions<T> extends StatefulWidget {
  const AntMentions({
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
    this.prefix = '@',
    this.placeholder,
    this.disabled = false,
    this.allowClear = false,
    this.size = AntMentionsSize.middle,
    this.maxRows = 3,
  });

  /// 提及选项列表（任意模型）。
  final List<T> options;

  /// 选项展示文案（下拉行文本 + 过滤匹配文本），缺省 `'$item'`。
  final String Function(T item)? labelOf;

  /// 选中后插入到文本中的内容，缺省与 [labelOf] 一致。
  final String Function(T item)? valueOf;

  /// 选项是否禁用。
  final bool Function(T item)? disabledOf;

  /// 整行下拉项自定义渲染（点击与禁用态仍由组件负责）。
  final Widget Function(BuildContext context, T item, int index)? itemBuilder;

  /// 受控文本值
  final String? value;

  /// 非受控默认值
  final String? defaultValue;

  /// 文本变化回调
  final ValueChanged<String>? onChange;

  /// 选中提及项回调（回传模型对象）。
  final ValueChanged<T>? onSelect;

  /// 触发字符
  final String prefix;

  /// 占位文本
  final String? placeholder;

  /// 是否禁用
  final bool disabled;

  /// 是否显示清除按钮
  final bool allowClear;

  /// 尺寸
  final AntMentionsSize size;

  /// 最大行数
  final int maxRows;

  @override
  State<AntMentions<T>> createState() => _AntMentionsState<T>();
}

class _AntMentionsState<T> extends State<AntMentions<T>>
    with PopupContentRefresher<AntMentions<T>> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  /// 触发元素 GlobalKey（弹层基座 AntPopupOverlay 定位/镂空遮挡用；
  /// 镂空遮挡不遮触发输入框，弹层打开时可继续输入）。
  final GlobalKey _triggerKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _open = false;

  /// 当前主题（组件 context 下捕获，overlay builder 经字段重读）。
  AntThemeData _themeData = AntThemeData.light();

  /// 当前匹配到的搜索文本（'@' 后的文本）
  String _searchText = '';

  /// 当前 '@' 在文本中的位置
  int _prefixIndex = -1;

  String get _currentValue => widget.value ?? _controller.text;

  double get _height {
    switch (widget.size) {
      case AntMentionsSize.large:
        return 40;
      case AntMentionsSize.small:
        return 24;
      case AntMentionsSize.middle:
        return 32;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: widget.defaultValue ?? widget.value ?? '');
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChanged);
    _controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant AntMentions<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != oldWidget.value) {
      if (_controller.text != widget.value) {
        _controller.text = widget.value!;
        _controller.selection = TextSelection.collapsed(
          offset: _controller.text.length,
        );
      }
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _focusNode.removeListener(_onFocusChanged);
    _controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!mounted) return;
    // 聚焦/失焦都要重绘：边框与光环跟随 `_focusNode.hasFocus`，
    // 只处理失焦会让聚焦态永远画不出来（无主色边框、无光环）。
    setState(() {});
    if (!_focusNode.hasFocus) {
      _removeOverlay();
    }
  }

  void _onTextChanged() {
    if (widget.value == null) {
      // 非受控模式：通知 onChange
      widget.onChange?.call(_controller.text);
    }
    _detectMention();
  }

  /// 键盘上下选择 + Enter 确认（弹层打开时生效，同 AutoComplete 模式）。
  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (!_open) return KeyEventResult.ignored;
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final options =
        _filteredOptions.where((o) => !_disabledOf(o)).toList(growable: false);
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
        _onSelectOption(options[idx]);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  /// 当前键盘高亮索引（对应 [_filteredOptions] 中可选项的下标）。
  int? _highlightedIndex;

  /// 检测光标前是否有触发前缀，显示/隐藏选项面板
  void _detectMention() {
    if (widget.disabled || !mounted) return;
    final text = _controller.text;
    final cursorPos = _controller.selection.baseOffset;
    if (cursorPos < 0 || cursorPos > text.length) {
      _removeOverlay();
      return;
    }

    // 从光标位置向前查找最近的触发前缀
    final beforeCursor = text.substring(0, cursorPos);
    final prefixIndex = beforeCursor.lastIndexOf(widget.prefix);

    if (prefixIndex < 0) {
      _removeOverlay();
      return;
    }

    // 确保前缀后没有空格（空格视为提及结束）
    final searchText =
        beforeCursor.substring(prefixIndex + widget.prefix.length);
    if (searchText.contains(' ') || searchText.contains('\n')) {
      _removeOverlay();
      return;
    }

    _prefixIndex = prefixIndex;
    _searchText = searchText;
    _showOverlay();
  }

  /// 选项展示文案。
  String _labelOf(T item) => widget.labelOf?.call(item) ?? '$item';

  /// 选项插入文本。
  String _valueOf(T item) => widget.valueOf?.call(item) ?? _labelOf(item);

  /// 选项是否禁用。
  bool _disabledOf(T item) => widget.disabledOf?.call(item) ?? false;

  List<T> get _filteredOptions {
    final search = _searchText.toLowerCase();
    return widget.options.where((opt) {
      if (_disabledOf(opt)) return true; // 禁用项仍显示
      return _labelOf(opt).toLowerCase().contains(search);
    }).toList();
  }

  /// 弹层：承载层换为统一弹层基座 [AntPopupOverlay]（方向决策/边界翻转/
  /// 滑动夹回/镂空遮挡/fade+scale 动画）。
  void _showOverlay() {
    if (_open) {
      _updateOverlay();
      return;
    }
    _themeData = AntTheme.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => _MentionsOverlay<T>(
        triggerKey: _triggerKey,
        themeData: _themeData,
        options: _filteredOptions,
        labelOf: _labelOf,
        disabledOf: _disabledOf,
        itemBuilder: widget.itemBuilder,
        onSelect: _onSelectOption,
        onDismiss: _removeOverlay,
      ),
    );
    popupContentEntry = _overlayEntry;
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
    setState(() => _open = true);
  }

  /// 联想内容变化：原地重建面板（PopupContentRefresher 统一沉淀方式）。
  void _updateOverlay() {
    if (_overlayEntry != null) {
      refreshPopupContent();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    popupContentEntry = null;
    _overlayEntry = null;
    _prefixIndex = -1;
    _searchText = '';
    _highlightedIndex = null;
    if (_open && mounted) setState(() => _open = false);
  }

  void _onSelectOption(T option) {
    if (_disabledOf(option)) return;
    final text = _controller.text;
    final cursorPos = _controller.selection.baseOffset;
    final insertText = _valueOf(option);

    // 替换 '@searchText' 为 '@insertText '
    final newText =
        '${text.substring(0, _prefixIndex)}${widget.prefix}$insertText ${text.substring(cursorPos.clamp(0, text.length))}';

    _controller.text = newText;
    final newCursorPos =
        _prefixIndex + widget.prefix.length + insertText.length + 1;
    _controller.selection = TextSelection.collapsed(offset: newCursorPos);

    widget.onChange?.call(newText);
    widget.onSelect?.call(option);
    _removeOverlay();
    _focusNode.requestFocus();
    _highlightedIndex = null;
  }

  void _clear() {
    _controller.clear();
    widget.onChange?.call('');
    _removeOverlay();
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final fontSize =
        widget.size == AntMentionsSize.small ? t.fontSizeSM : t.fontSize;
    final showClear =
        widget.allowClear && _currentValue.isNotEmpty && !widget.disabled;
    final maxHeight = _height * widget.maxRows;

    return Focus(
      onKeyEvent: _handleKeyEvent,
      child: Container(
        key: _triggerKey,
        constraints: BoxConstraints(
          minHeight: t.s(_height),
          maxHeight: t.s(maxHeight),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: t.s((widget.size == AntMentionsSize.small ? 7 : 12)),
          vertical: t.s(4),
        ),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                enabled: !widget.disabled,
                maxLines: widget.maxRows,
                minLines: 1,
                style: TextStyle(
                  fontSize: t.s(fontSize),
                  color: widget.disabled ? t.colorTextDisabled : t.colorText,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  isCollapsed: true,
                  // 单一外层描边语义（antd web Mentions）：输入框自身无边框，
                  // enabled/focused/disabled 边框显式置 none——Material 主题的
                  // InputDecorationTheme.enabledBorder 优先级高于 border，
                  // 不显式覆盖会内层再画一圈描边形成双层边框。
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  // 填充/悬停/焦点局部填充显式置透明：Material 桥接主题
                  // filled:true + fillColor: colorBgContainer（白）会盖掉
                  // 外层容器的禁用灰底（colorBgContainerDisabled 由外层
                  // 容器按 enabled/disabled 切换），hoverColor/focusColor
                  // 防主题渗入产生局部填充高亮。
                  filled: true,
                  fillColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hintText: widget.placeholder,
                  hintStyle: TextStyle(
                    fontSize: t.s(fontSize),
                    color: t.colorTextPlaceholder,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: t.s(6)),
                ),
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
                    size: t.s(14),
                    color: t.colorTextQuaternary,
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
// _MentionsOverlay — 提及选项浮层
// ============================================================

class _MentionsOverlay<T> extends StatelessWidget {
  const _MentionsOverlay({
    required this.triggerKey,
    required this.themeData,
    required this.options,
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

  /// 提及面板：宽度对齐触发元素（不小于 200），高度上限 200。
  Widget _buildPanel(AntThemeData t) {
    final triggerBox =
        triggerKey.currentContext?.findRenderObject() as RenderBox?;
    final triggerWidth = (triggerBox != null && triggerBox.hasSize)
        ? triggerBox.size.width
        : 0.0;
    final panelWidth = triggerWidth > t.s(200) ? triggerWidth : t.s(200);

    return Container(
      key: const Key('ant_mentions_panel'),
      width: panelWidth,
      constraints: BoxConstraints(maxHeight: t.s(200)),
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
      child: options.isEmpty
          ? Padding(
              padding: EdgeInsets.all(t.s(12)),
              child: Text(
                '无匹配项',
                style: TextStyle(
                  fontSize: t.fontSizeSM,
                  color: t.colorTextQuaternary,
                ),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                return _MentionOptionTile(
                  label: labelOf(option),
                  disabled: disabledOf(option),
                  customChild: itemBuilder?.call(context, option, index),
                  fontSize: t.fontSize,
                  colorText: t.colorText,
                  colorTextDisabled: t.colorTextDisabled,
                  colorFillSecondary: t.colorFillSecondary,
                  onTap: () => onSelect(option),
                );
              },
            ),
    );
  }
}

// ============================================================
// _MentionOptionTile — 单个提及选项条目
// ============================================================

class _MentionOptionTile extends StatefulWidget {
  const _MentionOptionTile({
    required this.label,
    required this.disabled,
    required this.fontSize,
    required this.colorText,
    required this.colorTextDisabled,
    required this.colorFillSecondary,
    required this.onTap,
    this.customChild,
  });

  final String label;
  final bool disabled;
  final Widget? customChild;
  final double fontSize;
  final Color colorText;
  final Color colorTextDisabled;
  final Color colorFillSecondary;
  final VoidCallback onTap;

  @override
  State<_MentionOptionTile> createState() => _MentionOptionTileState();
}

class _MentionOptionTileState extends State<_MentionOptionTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final disabled = widget.disabled;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: disabled ? null : widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: t.s(8), horizontal: t.s(12)),
          color: disabled
              ? widget.colorFillSecondary.withValues(alpha: 0.3)
              : _isHovered
                  ? widget.colorFillSecondary
                  : null,
          child: widget.customChild ??
              Text(
                widget.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: t.s(widget.fontSize),
                  color: disabled ? widget.colorTextDisabled : widget.colorText,
                ),
              ),
        ),
      ),
    );
  }
}
