/// AntSelect — antd React Select 的 Flutter 实现
///
/// 数据源为 `List<T>`：用户模型直接作为选项，通过 [labelOf] / [labelBuilder]
/// 渲染文本，通过 [valueExtractor] 提取用于匹配/去重的业务键。
///
/// ```dart
/// AntSelect<User>(
///   options: users,
///   value: selected,
///   labelOf: (user) => user.name,
///   valueExtractor: (user) => user.id,
///   onChange: (user) => setState(() => selected = user),
/// )
/// ```
library;

import 'dart:math' as math;

import 'package:antd_flutter_ui/src/engines/popup_engine.dart';
import '../../feedback/loading/ant_loading.dart';
import 'package:antd_flutter_ui/src/engines/popup_overlay.dart';
import 'package:antd_flutter_ui/src/data_entry/select/ant_select_types.dart';
import 'package:antd_flutter_ui/src/data_entry/input/ant_field_surface.dart';
import 'package:antd_theme/antd_theme.dart';

export 'package:antd_flutter_ui/src/data_entry/select/ant_select_types.dart';
import 'package:material_ui/material_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

// ============================================================
// AntSelect
// ============================================================

/// 选择器 — 下拉选择器，支持单选、多选与搜索。
///
/// 对齐 antd React Select 组件。选项是任意类型 [T]，不要求用户构造
/// [AntSelectOption]；只有字符串选项时可直接 `AntSelect<String>(options: ['北京'])`。
class AntSelect<T> extends StatefulWidget {
  const AntSelect({
    super.key,
    this.mode = AntSelectMode.single,
    this.value,
    this.defaultValue,
    this.values,
    this.defaultValues = const [],
    this.options = const [],
    this.labelOf,
    this.labelBuilder,
    this.itemBuilder,
    this.valueExtractor,
    this.disabledOf,
    this.searchTextOf,
    this.onChange,
    this.onChangeMultiple,
    this.showSearch = false,
    this.allowClear = false,
    this.placeholder,
    this.disabled = false,
    this.loading = false,
    this.size = AntSelectSize.middle,
    this.autofocus = false,
  })  : assert(
          mode == AntSelectMode.single || value == null,
          'AntSelect 多选模式请用 values 传值（value 仅用于单选）',
        ),
        assert(
          mode == AntSelectMode.multiple || values == null,
          'AntSelect 单选模式请用 value 传值（values 仅用于多选）',
        );

  /// 选择模式。
  final AntSelectMode mode;

  /// 受控选中值（单选）。
  final T? value;

  /// 非受控初始值（单选）。
  final T? defaultValue;

  /// 受控选中值（多选）。
  final List<T>? values;

  /// 非受控初始值（多选）。
  final List<T> defaultValues;

  /// 选项列表（任意模型）。
  final List<T> options;

  /// 选项的字符串 label 简写，用于标题文本与 [showSearch] 搜索匹配。
  ///
  /// 提供 [labelBuilder] 时仅用于搜索匹配；未提供时作为默认文本。
  final String Function(T item)? labelOf;

  /// 选项的自定义渲染，用于下拉项、多选标签与单选已选值。
  final Widget Function(BuildContext context, T item)? labelBuilder;

  /// 整项自定义渲染（保留下拉项内置的选中标记/多选勾选框），优先级高于
  /// [labelBuilder]。index 为该选项在 [options] 中的下标。
  final Widget Function(BuildContext context, T item, int index)? itemBuilder;

  /// 选中值的身份提取（默认选项自身）。
  ///
  /// 受控值 [value]/[values] 可能来自业务侧的任意实例，在选项列表中按此键
  /// 匹配；多选去重与取消选择也按此键比较。
  final Object Function(T item)? valueExtractor;

  /// 选项是否禁用。
  final bool Function(T item)? disabledOf;

  /// 搜索匹配文本，缺省为 [labelOf] 的结果（再缺省为 `item.toString()`）。
  ///
  /// 自定义模型请显式提供，否则搜索只能匹配模型的 toString。
  final String Function(T item)? searchTextOf;

  /// 单选选中变化回调（清除时为 null）。
  final ValueChanged<T?>? onChange;

  /// 多选选中变化回调。
  final ValueChanged<List<T>>? onChangeMultiple;

  /// 是否可搜索。
  final bool showSearch;

  /// 是否允许清除。
  final bool allowClear;

  /// 占位文本。
  final String? placeholder;

  /// 是否禁用。
  final bool disabled;

  /// 是否加载中。
  final bool loading;

  /// 尺寸。
  final AntSelectSize size;

  /// 是否自动聚焦。
  final bool autofocus;

  @override
  State<AntSelect<T>> createState() => _AntSelectState<T>();
}

class _AntSelectState<T> extends State<AntSelect<T>>
    with PopupContentRefresher<AntSelect<T>> {
  /// 触发元素 GlobalKey（弹层基座 AntPopupOverlay 定位/镂空遮挡用）。
  final GlobalKey _fieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _internalOpen = false;
  T? _internalValue;
  List<T> _internalValues = <T>[];
  String _searchText = '';

  bool get _isMultiple => widget.mode == AntSelectMode.multiple;

  bool get _currentOpen => _internalOpen;

  T? get _currentValue => widget.value ?? _internalValue;

  List<T> get _currentValues => widget.values ?? _internalValues;

  /// 选中值身份键（用于受控值匹配、多选去重）。
  Object? _keyOf(T item) => widget.valueExtractor?.call(item) ?? item;

  bool _isSame(T a, T b) => _keyOf(a) == _keyOf(b);

  /// 选项的字符串 label（搜索/默认文本）。
  String _labelTextOf(T item) =>
      widget.labelOf?.call(item) ?? widget.searchTextOf?.call(item) ?? '$item';

  String _searchTextOf(T item) =>
      widget.searchTextOf?.call(item) ?? _labelTextOf(item);

  /// labelBuilder 优先，回退到字符串 label，命中目标 TextStyle。
  Widget _renderLabel(BuildContext context, T item, {TextStyle? style}) {
    final builder = widget.labelBuilder;
    final label = builder != null
        ? builder(context, item)
        : Text(widget.labelOf?.call(item) ?? '$item');
    return style == null
        ? label
        : DefaultTextStyle.merge(style: style, child: label);
  }

  @override
  void initState() {
    super.initState();
    _internalValue = widget.defaultValue;
    _internalValues = List<T>.of(widget.defaultValues);
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
      if (!value) _searchText = '';
    });
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
    _overlayEntry = OverlayEntry(
      builder: (context) => _SelectOverlay<T>(
        fieldKey: _fieldKey,
        options: widget.options,
        isMultiple: _isMultiple,
        selectedKeys: _selectedKeys,
        searchText: _searchText,
        showSearch: widget.showSearch,
        loading: widget.loading,
        themeData: theme,
        labelBuilder: (context, item) => _renderLabel(context, item),
        searchTextOf: _searchTextOf,
        keyOf: _keyOf,
        enabledOf: (item) => !(widget.disabledOf?.call(item) ?? false),
        itemBuilder: widget.itemBuilder,
        onSearch: (text) {
          if (!mounted) return;
          setState(() => _searchText = text);
          // 搜索输入在事件期触发（非 build 期），原地重建可即时生效；
          // 不走 PopupContentRefresher 的帧末延迟——会慢一帧丢输入反馈。
          _overlayEntry?.markNeedsBuild();
        },
        onSelect: _handleSelect,
        onDismiss: () => _setOpen(false),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
    // 登记到 PopupContentRefresher：多选勾选等面板内容变化时经
    // refreshPopupContent 原地重建（builder 闭包重读 State 最新值）；
    // 不登记则 markNeedsBuild 永不触发，面板选中态停留旧值。
    popupContentEntry = _overlayEntry;
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    popupContentEntry = null;
    _overlayEntry = null;
  }

  Set<Object?> get _selectedKeys => _isMultiple
      ? _currentValues.map(_keyOf).toSet()
      : {if (_currentValue != null) _keyOf(_currentValue as T)};

  void _handleSelect(T optionValue, bool selected) {
    if (_isMultiple) {
      final list = List<T>.of(_currentValues);
      if (selected) {
        if (!list.any((e) => _isSame(e, optionValue))) list.add(optionValue);
      } else {
        list.removeWhere((e) => _isSame(e, optionValue));
      }
      _internalValues = list;
      widget.onChangeMultiple?.call(List<T>.of(list));
    } else {
      _internalValue = optionValue;
      widget.onChange?.call(optionValue);
      _setOpen(false);
    }
    if (mounted) {
      setState(() {});
      refreshPopupContent();
    }
  }

  void _handleClear() {
    if (_isMultiple) {
      _internalValues = <T>[];
      widget.onChangeMultiple?.call(<T>[]);
    } else {
      _internalValue = null;
      widget.onChange?.call(null);
    }
    if (mounted) setState(() {});
  }

  double get _controlHeight {
    switch (widget.size) {
      case AntSelectSize.large:
        return 40;
      case AntSelectSize.middle:
        return 32;
      case AntSelectSize.small:
        return 24;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final height = theme.s(_controlHeight);
    final open = _currentOpen;

    final selectedLabels = <Widget>[];
    if (_isMultiple) {
      for (final v in _currentValues) {
        selectedLabels.add(
          _Tag(
            label: _renderLabel(
              context,
              v,
              style: TextStyle(
                fontSize: theme.fontSizeSM,
                color:
                    widget.disabled ? theme.colorTextDisabled : theme.colorText,
              ),
            ),
            theme: theme,
            disabled: widget.disabled,
            onClear: widget.allowClear && !widget.disabled
                ? () => _handleSelect(v, false)
                : null,
          ),
        );
      }
    } else {
      final v = _currentValue;
      if (v != null) {
        selectedLabels.add(
          Flexible(
            child: _renderLabel(
              context,
              v,
              style: TextStyle(
                fontSize: theme.fontSize,
                color: theme.colorText,
              ),
            ),
          ),
        );
      }
    }

    final hasValue =
        _isMultiple ? _currentValues.isNotEmpty : _currentValue != null;

    final showClear = widget.allowClear && hasValue && !widget.disabled;

    Widget content = Container(
      key: _fieldKey,
      constraints: BoxConstraints(minHeight: height),
      padding: EdgeInsets.symmetric(
        horizontal: theme.marginSM,
        vertical: _isMultiple && selectedLabels.length > 1 ? theme.s(4) : 0,
      ),
      decoration: BoxDecoration(
        color: widget.disabled
            ? theme.colorBgContainerDisabled
            : theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        // 打开态光环：antd 是 2px 无模糊的实心外扩环，不是把边框换成半透明色。
        boxShadow: open && !widget.disabled
            ? antFieldFocusRingOf(theme, AntInputStatus.normal)
            : null,
      ),
      // 边框画在前景层：不参与布局，打开态不再让内容位移 1px；
      // 打开态取主色 1px（对齐 antd `.ant-select-focused`）。
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.borderRadius),
        border: Border.all(
          color: antFieldBorderColorOf(
            theme,
            AntInputStatus.normal,
            focused: open && !widget.disabled,
          ),
          width: theme.s(1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: selectedLabels.isEmpty
                ? Text(
                    widget.placeholder ?? '请选择',
                    style: TextStyle(
                      fontSize: theme.fontSize,
                      color: theme.colorTextPlaceholder,
                    ),
                  )
                : _isMultiple
                    ? Wrap(
                        spacing: theme.s(4),
                        runSpacing: theme.s(4),
                        children: selectedLabels,
                      )
                    : Row(children: selectedLabels),
          ),
          if (showClear) ...[
            SizedBox(width: theme.s(4)),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _handleClear,
              child: Icon(
                AntIcons.closeCircleFilled,
                size: theme.s(14),
                color: theme.colorTextPlaceholder,
              ),
            ),
          ] else if (widget.loading)
            Padding(
              padding: EdgeInsets.only(left: theme.s(4)),
              child: AntLoading(
                size: theme.s(14),
                color: theme.colorPrimary,
              ),
            )
          else
            Padding(
              padding: EdgeInsets.only(left: theme.s(4)),
              child: AnimatedRotation(
                turns: open ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  AntIcons.downOutlined,
                  size: theme.s(14),
                  color: widget.disabled
                      ? theme.colorTextDisabled
                      : theme.colorTextSecondary,
                ),
              ),
            ),
        ],
      ),
    );

    return GestureDetector(
      onTap: widget.disabled ? null : () => _setOpen(!open),
      child: content,
    );
  }
}

// ============================================================
// _Tag — 多选标签
// ============================================================

class _Tag extends StatelessWidget {
  const _Tag({
    required this.label,
    required this.theme,
    required this.disabled,
    this.onClear,
  });

  /// 已按目标样式渲染的标签内容。
  final Widget label;
  final AntThemeData theme;
  final bool disabled;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: theme.s(6), vertical: theme.s(2)),
      decoration: BoxDecoration(
        color: theme.colorFillSecondary,
        borderRadius: BorderRadius.circular(theme.borderRadiusSM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          label,
          if (onClear != null) ...[
            SizedBox(width: theme.s(2)),
            GestureDetector(
              onTap: onClear,
              child: Icon(
                AntIcons.closeOutlined,
                size: theme.s(10),
                color: theme.colorTextTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================
// _SelectOverlay — 下拉浮层
// ============================================================

class _SelectOverlay<T> extends StatelessWidget {
  const _SelectOverlay({
    required this.fieldKey,
    required this.options,
    required this.isMultiple,
    required this.selectedKeys,
    required this.searchText,
    required this.showSearch,
    required this.loading,
    required this.themeData,
    required this.labelBuilder,
    required this.searchTextOf,
    required this.keyOf,
    required this.enabledOf,
    required this.onSearch,
    required this.onSelect,
    required this.onDismiss,
    this.itemBuilder,
  });

  /// 触发元素 GlobalKey（弹层基座定位/镂空遮挡）。
  final GlobalKey fieldKey;
  final List<T> options;
  final bool isMultiple;
  final Set<Object?> selectedKeys;
  final String searchText;
  final bool showSearch;
  final bool loading;
  final AntThemeData themeData;
  final Widget Function(BuildContext context, T item) labelBuilder;
  final String Function(T item) searchTextOf;
  final Object? Function(T item) keyOf;
  final bool Function(T item) enabledOf;
  final Widget Function(BuildContext context, T item, int index)? itemBuilder;
  final ValueChanged<String> onSearch;
  final void Function(T item, bool selected) onSelect;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = themeData;
    final mediaSize = MediaQuery.sizeOf(context);

    final filtered = searchText.isEmpty
        ? options
        : options
            .where(
              (o) => searchTextOf(o).toLowerCase().contains(
                    searchText.toLowerCase(),
                  ),
            )
            .toList();

    // 统一弹层基座：placement 首选下方，视口下方放不下自动翻转到上方；
    // 方向决策/滑动夹回/镂空遮挡/fade+scale 动画由基座承担（antd Select 无箭头）。
    return AntPopupOverlay(
      targetKey: fieldKey,
      placement: AntPopupPlacement.bottom,
      arrow: false,
      gap: 4,
      onDismiss: onDismiss,
      child: _buildPanel(context, theme, mediaSize, filtered),
    );
  }

  /// 下拉面板：宽度对齐触发元素（不小于 120，基座 Stack 为宽松约束需定宽），
  /// 高度上限 min(256, 视口一半)，超出面板内滚动。
  Widget _buildPanel(
    BuildContext context,
    AntThemeData theme,
    Size mediaSize,
    List<T> filtered,
  ) {
    final fieldBox = fieldKey.currentContext?.findRenderObject() as RenderBox?;
    final fieldWidth =
        (fieldBox != null && fieldBox.hasSize) ? fieldBox.size.width : 0.0;
    return Container(
      key: const Key('ant_select_panel'),
      width: math.max(fieldWidth, 120),
      constraints: BoxConstraints(
        maxHeight: math.min(256, mediaSize.height * 0.5),
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
          if (showSearch)
            Padding(
              padding: EdgeInsets.all(theme.s(8)),
              child: TextField(
                autofocus: true,
                style: TextStyle(
                  fontSize: theme.fontSize,
                  color: theme.colorText,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: theme.s(8),
                    vertical: theme.s(6),
                  ),
                  hintText: '搜索',
                  hintStyle: TextStyle(
                    fontSize: theme.fontSizeSM,
                    color: theme.colorTextPlaceholder,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(theme.borderRadius),
                    borderSide: BorderSide(color: theme.colorBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(theme.borderRadius),
                    borderSide: BorderSide(
                      color: theme.colorPrimary,
                      width: theme.s(1.5),
                    ),
                  ),
                ),
                onChanged: onSearch,
              ),
            ),
          if (loading)
            Padding(
              padding: EdgeInsets.all(theme.s(24)),
              child: AntLoading(
                size: theme.s(20),
                color: theme.colorPrimary,
              ),
            )
          else if (filtered.isEmpty)
            Padding(
              padding: EdgeInsets.all(theme.s(24)),
              child: Text(
                '暂无数据',
                style: TextStyle(
                  fontSize: theme.fontSize,
                  color: theme.colorTextDisabled,
                ),
              ),
            )
          else
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: theme.s(4)),
                children: [
                  for (var i = 0; i < filtered.length; i++)
                    _OptionItem<T>(
                      option: filtered[i],
                      index: i,
                      selected: _isSelected(filtered[i]),
                      isMultiple: isMultiple,
                      theme: theme,
                      labelBuilder: labelBuilder,
                      itemBuilder: itemBuilder,
                      onTap: enabledOf(filtered[i])
                          ? () =>
                              onSelect(filtered[i], !_isSelected(filtered[i]))
                          : null,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  bool _isSelected(T item) => selectedKeys.contains(keyOf(item));
}

// ============================================================
// _OptionItem — 选项行
// ============================================================

class _OptionItem<T> extends StatelessWidget {
  const _OptionItem({
    required this.option,
    required this.index,
    required this.selected,
    required this.isMultiple,
    required this.theme,
    required this.labelBuilder,
    required this.onTap,
    this.itemBuilder,
  });

  final T option;
  final int index;
  final bool selected;
  final bool isMultiple;
  final AntThemeData theme;
  final Widget Function(BuildContext context, T item) labelBuilder;
  final Widget Function(BuildContext context, T item, int index)? itemBuilder;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = theme;
    final disabled = onTap == null;
    final textColor = disabled
        ? t.colorTextDisabled
        : selected
            ? t.colorPrimary
            : t.colorText;

    final label = itemBuilder?.call(context, option, index) ??
        labelBuilder(context, option);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: theme.s(12), vertical: theme.s(6)),
        child: Row(
          children: [
            if (isMultiple)
              Padding(
                padding: EdgeInsets.only(right: theme.s(8)),
                child: Icon(
                  selected
                      ? AntIcons.checkSquareFilled
                      : AntIcons.borderOutlined,
                  size: theme.s(16),
                  color: selected && !disabled ? t.colorPrimary : t.colorBorder,
                ),
              ),
            Expanded(
              child: itemBuilder != null
                  ? label
                  : DefaultTextStyle.merge(
                      style: TextStyle(
                        fontSize: t.fontSize,
                        color: textColor,
                      ),
                      child: label,
                    ),
            ),
            if (!isMultiple && selected)
              Icon(
                AntIcons.checkOutlined,
                size: theme.s(14),
                color: t.colorPrimary,
              ),
          ],
        ),
      ),
    );
  }
}
