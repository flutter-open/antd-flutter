/// AntTreeSelect — antd React TreeSelect 的 Flutter 泛型实现
///
/// 直接消费用户模型 `T`，通过 [keyOf] / [labelOf] / [titleBuilder] /
/// [childrenOf] / [disabledOf] 读取数据，不再要求构造 `AntTreeSelectOption`。
///
/// ```dart
/// AntTreeSelect<Category>(
///   dataSource: categories,
///   keyOf: (c) => c.id,
///   labelOf: (c) => c.name,
///   childrenOf: (c) => c.children,
///   disabledOf: (c) => c.disabled,
///   onChange: (value) => print(value),
/// )
/// ```
///
/// 下拉弹层承载于 antd_flutter_ui 统一弹层基座 [AntPopupOverlay]：
/// 方向决策（下方放不下自动翻转上方）、滑动夹回、镂空遮挡（触发元素
/// 不误关）、fade+scale 出现动画均由基座统一承担；面板内容渲染不变。
library;

import 'dart:math' as math;

import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:antd_tree/src/tree_select/ant_tree_select_types.dart';
import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:material_ui/material_ui.dart';

export 'package:antd_tree/src/tree_select/ant_tree_select_types.dart';

// ============================================================
// AntTreeSelect
// ============================================================

/// 树选择组件（泛型数据源）。
///
/// 类似 Select 的下拉，但选项为树形结构。受控/非受控的“值”都是
/// [keyOf] 从用户模型提取的 key：单选为单个 key，多选为 `List<Object>`。
class AntTreeSelect<T> extends StatefulWidget {
  const AntTreeSelect({
    super.key,
    this.dataSource = const <Never>[],
    this.keyOf,
    this.labelOf,
    this.titleBuilder,
    this.childrenOf,
    this.disabledOf,
    this.value,
    this.defaultValue,
    this.onChange,
    this.placeholder,
    this.disabled = false,
    this.allowClear = false,
    this.treeDefaultExpandAll = false,
    this.multiple = false,
    this.size = AntTreeSelectSize.middle,
    this.height,
    this.width,
    this.dropdownHeight,
  });

  /// 树节点数据（用户模型）。
  final List<T> dataSource;

  /// 从数据项提取唯一 key；缺省使用 DFS 顺序索引。
  ///
  /// 强烈建议显式提供，缺省 key 在数据重排/折叠后可能变化。
  final AntTreeSelectKeyOf<T>? keyOf;

  /// 触发器展示用的纯文本标签；缺省 `item is String ? item : '$item'`。
  final AntTreeSelectLabelOf<T>? labelOf;

  /// 下拉行标题构建器；缺省 `Text(labelOf(item))`。
  final AntTreeSelectTitleBuilder<T>? titleBuilder;

  /// 读取子节点；缺省无子节点（扁平列表）。
  final AntTreeSelectChildrenOf<T>? childrenOf;

  /// 判断节点是否禁用。
  final AntTreeSelectDisabledOf<T>? disabledOf;

  /// 受控值（单选 key / 多选 `List<Object>`）。
  final Object? value;

  /// 非受控默认值。
  final Object? defaultValue;

  /// 值变化回调（单选 key / 多选 `List<Object>`）。
  final ValueChanged<Object?>? onChange;

  /// 占位文本。
  final String? placeholder;

  /// 是否禁用。
  final bool disabled;

  /// 是否显示清除按钮。
  final bool allowClear;

  /// 默认展开全部节点。
  final bool treeDefaultExpandAll;

  /// 多选模式。
  final bool multiple;

  /// 尺寸。
  final AntTreeSelectSize size;

  /// 触发器自定义高度（逻辑像素），设置后覆盖 [size] 对应高度。
  final double? height;

  /// 触发器自定义宽度（逻辑像素）。默认 null：宽度随内容自适应，
  /// 父级为紧约束（如 Expanded / 定宽容器）时随父级。
  final double? width;

  /// 下拉面板最大高度（逻辑像素）。默认 null：取 min(256, 视口高度一半)，
  /// 超出后面板内部滚动（SingleChildScrollView）。
  final double? dropdownHeight;

  @override
  State<AntTreeSelect<T>> createState() => _AntTreeSelectState<T>();
}

class _AntTreeSelectState<T> extends State<AntTreeSelect<T>>
    with PopupContentRefresher<AntTreeSelect<T>> {
  /// 触发元素 GlobalKey（弹层基座 AntPopupOverlay 定位/镂空遮挡用）。
  final GlobalKey _triggerKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _open = false;

  /// 当前主题（组件 context 下实时捕获，overlay builder 经字段重读；
  /// AntTheme 在页面内时 overlay 条目的 context 不可达该继承链）。
  AntThemeData _themeData = AntThemeData.light();

  /// 已展开的节点 key 集合。
  Set<Object> _expandedKeys = <Object>{};

  /// 单选内部值。
  Object? _internalValue;

  /// 多选内部值。
  List<Object> _internalMultiValue = <Object>[];

  /// 缺省 key 映射（keyOf 为空时按 DFS 顺序生成稳定 key）。
  final Map<T, Object> _defaultKeys = Map<T, Object>.identity();
  List<T>? _defaultKeysSource;
  int _defaultKeySeed = 0;

  Object? get _currentSingleValue {
    final value = widget.value;
    if (value != null && value is! List) return value;
    return _internalValue;
  }

  List<Object> get _currentMultiValue {
    final value = widget.value;
    if (value is List) return value.cast<Object>();
    return _internalMultiValue;
  }

  double get _height {
    switch (widget.size) {
      case AntTreeSelectSize.large:
        return 40;
      case AntTreeSelectSize.small:
        return 24;
      case AntTreeSelectSize.middle:
        return 32;
    }
  }

  List<T> _childrenOf(T item) {
    final childrenOf = widget.childrenOf;
    if (childrenOf == null) return const <Never>[];
    return childrenOf(item);
  }

  bool _disabledOf(T item) => widget.disabledOf?.call(item) ?? false;

  String _labelOf(T item) {
    final labelOf = widget.labelOf;
    if (labelOf != null) return labelOf(item);
    return item is String ? item : '$item';
  }

  Widget _titleOf(BuildContext context, T item) {
    final titleBuilder = widget.titleBuilder;
    if (titleBuilder != null) return titleBuilder(context, item);
    return Text(
      _labelOf(item),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Object _keyOf(T item) {
    final keyOf = widget.keyOf;
    if (keyOf != null) return keyOf(item);
    _ensureDefaultKeys();
    return _defaultKeys[item] ?? -1;
  }

  void _ensureDefaultKeys() {
    if (widget.keyOf != null) return;
    if (identical(_defaultKeysSource, widget.dataSource)) return;
    _defaultKeysSource = widget.dataSource;
    _defaultKeys.clear();
    _defaultKeySeed = 0;
    void walk(List<T> items) {
      for (final item in items) {
        _defaultKeys[item] = _defaultKeySeed++;
        walk(_childrenOf(item));
      }
    }

    walk(widget.dataSource);
  }

  @override
  void initState() {
    super.initState();
    _ensureDefaultKeys();
    final defaultValue = widget.defaultValue;
    if (defaultValue is List) {
      _internalMultiValue = defaultValue.cast<Object>().toList();
    } else if (defaultValue != null) {
      _internalValue = defaultValue;
    }
    if (widget.treeDefaultExpandAll) {
      _expandedKeys = _collectAllParentKeys(widget.dataSource);
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  /// 收集所有有子节点的节点 key（用于 expandAll）。
  Set<Object> _collectAllParentKeys(List<T> nodes) {
    final keys = <Object>{};
    for (final node in nodes) {
      final children = _childrenOf(node);
      if (children.isNotEmpty) {
        keys.add(_keyOf(node));
        keys.addAll(_collectAllParentKeys(children));
      }
    }
    return keys;
  }

  /// 遍历树查找节点。
  T? _findNode(Object? value, [List<T>? nodes]) {
    if (value == null) return null;
    final list = nodes ?? widget.dataSource;
    for (final node in list) {
      if (_keyOf(node) == value) return node;
      final found = _findNode(value, _childrenOf(node));
      if (found != null) return found;
    }
    return null;
  }

  /// 获取触发器显示文本。
  String get _displayText {
    if (widget.multiple) {
      final values = _currentMultiValue;
      if (values.isEmpty) return '';
      return values.map((value) {
        final node = _findNode(value);
        return node == null ? '$value' : _labelOf(node);
      }).join('、');
    }
    final value = _currentSingleValue;
    if (value == null) return '';
    final node = _findNode(value);
    return node == null ? '$value' : _labelOf(node);
  }

  @override
  void didUpdateWidget(covariant AntTreeSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(widget.dataSource, oldWidget.dataSource)) {
      _defaultKeysSource = null;
      _ensureDefaultKeys();
    }
    // treeDefaultExpandAll + dataSource 变化：展开键随新数据重算。
    if (widget.treeDefaultExpandAll &&
        !identical(widget.dataSource, oldWidget.dataSource)) {
      _expandedKeys = _collectAllParentKeys(widget.dataSource);
    }
    // 弹层打开时数据/值更新：原地重建面板。
    if (_open &&
        (!identical(widget.dataSource, oldWidget.dataSource) ||
            widget.value != oldWidget.value ||
            widget.treeDefaultExpandAll != oldWidget.treeDefaultExpandAll ||
            widget.multiple != oldWidget.multiple)) {
      _updateOverlay();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = AntTheme.of(context);
    if (theme != _themeData) {
      _themeData = theme;
      if (_open) _updateOverlay();
    }
  }

  void _showOverlay() {
    if (_open || widget.disabled) return;
    _themeData = AntTheme.of(context);
    _insertOverlay();
    if (mounted) setState(() => _open = true);
  }

  void _insertOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => _TreeSelectOverlay<T>(
        triggerKey: _triggerKey,
        themeData: _themeData,
        dataSource: widget.dataSource,
        keyOf: _keyOf,
        titleBuilder: (context, item) => _titleOf(context, item),
        childrenOf: _childrenOf,
        disabledOf: _disabledOf,
        labelOf: _labelOf,
        expandedKeys: _expandedKeys,
        selectedValue: widget.multiple ? null : _currentSingleValue,
        selectedMultiValues: widget.multiple ? _currentMultiValue : null,
        multiple: widget.multiple,
        onSelect: _onSelect,
        onToggleExpand: _onToggleExpand,
        onDismiss: _removeOverlay,
        dropdownHeight: widget.dropdownHeight,
      ),
    );
    popupContentEntry = _overlayEntry;
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    popupContentEntry = null;
    _overlayEntry = null;
    if (_open && mounted) setState(() => _open = false);
  }

  void _onToggleExpand(Object key) {
    setState(() {
      if (_expandedKeys.contains(key)) {
        _expandedKeys.remove(key);
      } else {
        _expandedKeys.add(key);
      }
    });
    _updateOverlay();
  }

  void _onSelect(T item) {
    if (_disabledOf(item)) return;
    final key = _keyOf(item);
    if (widget.multiple) {
      final values = List<Object>.from(_currentMultiValue);
      if (values.contains(key)) {
        values.remove(key);
      } else {
        values.add(key);
      }
      setState(() => _internalMultiValue = values);
      widget.onChange?.call(values);
      _updateOverlay();
    } else {
      setState(() => _internalValue = key);
      widget.onChange?.call(key);
      _removeOverlay();
    }
  }

  void _updateOverlay() {
    if (_overlayEntry != null) {
      refreshPopupContent();
    }
  }

  void _clear() {
    setState(() {
      if (widget.multiple) {
        _internalMultiValue = <Object>[];
      } else {
        _internalValue = null;
      }
    });
    widget.onChange?.call(widget.multiple ? <Object>[] : null);
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    _ensureDefaultKeys();
    final fontSize =
        widget.size == AntTreeSelectSize.small ? t.fontSizeSM : t.fontSize;
    final hasValue = widget.multiple
        ? _currentMultiValue.isNotEmpty
        : _currentSingleValue != null;
    final showClear = widget.allowClear && hasValue && !widget.disabled;

    return KeyedSubtree(
      key: _triggerKey,
      child: GestureDetector(
        onTap: widget.disabled ? null : (_open ? _removeOverlay : _showOverlay),
        child: Container(
          height: t.s(widget.height ?? _height),
          width: widget.width == null ? null : t.s(widget.width!),
          padding: EdgeInsets.symmetric(
            horizontal: t.s(widget.size == AntTreeSelectSize.small ? 7 : 12),
            vertical: t.s(widget.multiple ? 2 : 0),
          ),
          decoration: BoxDecoration(
            color: widget.disabled
                ? t.colorBgContainerDisabled
                : t.colorBgContainer,
            borderRadius: BorderRadius.circular(t.borderRadius),
            // 打开态光环：2px 无模糊实心外扩环（对齐 Input / antd web）。
            boxShadow:
                _open ? antFieldFocusRingOf(t, AntInputStatus.normal) : null,
          ),
          // 边框恒 1px 画在前景层，打开态取主色且不再让内容位移。
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(t.borderRadius),
            border: Border.all(
              color: antFieldBorderColorOf(
                t,
                AntInputStatus.normal,
                focused: _open,
              ),
              width: 1,
            ),
          ),
          // 宽度自适应内容（对齐 antd Select 触发器 inline-block 语义）。
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  _displayText.isNotEmpty
                      ? _displayText
                      : (widget.placeholder ?? ''),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: _displayText.isNotEmpty
                        ? (widget.disabled ? t.colorTextDisabled : t.colorText)
                        : t.colorTextPlaceholder,
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
                )
              else
                Padding(
                  padding: EdgeInsets.only(left: t.s(4)),
                  child: Icon(
                    _open ? AntIcons.upOutlined : AntIcons.downOutlined,
                    size: t.s(14),
                    color: t.colorTextQuaternary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// _TreeSelectOverlay — 树形下拉面板
// ============================================================

class _TreeSelectOverlay<T> extends StatelessWidget {
  const _TreeSelectOverlay({
    required this.triggerKey,
    required this.themeData,
    required this.dataSource,
    required this.keyOf,
    required this.titleBuilder,
    required this.childrenOf,
    required this.disabledOf,
    required this.labelOf,
    required this.expandedKeys,
    required this.selectedValue,
    required this.selectedMultiValues,
    required this.multiple,
    required this.onSelect,
    required this.onToggleExpand,
    required this.onDismiss,
    required this.dropdownHeight,
  });

  /// 触发元素 GlobalKey（弹层基座定位）。
  final GlobalKey triggerKey;
  final AntThemeData themeData;
  final List<T> dataSource;
  final Object Function(T item) keyOf;
  final Widget Function(BuildContext context, T item) titleBuilder;
  final List<T> Function(T item) childrenOf;
  final bool Function(T item) disabledOf;
  final String Function(T item) labelOf;
  final Set<Object> expandedKeys;
  final Object? selectedValue;
  final List<Object>? selectedMultiValues;
  final bool multiple;
  final ValueChanged<T> onSelect;
  final ValueChanged<Object> onToggleExpand;
  final VoidCallback onDismiss;

  /// 面板最大高度配置（透传自 AntTreeSelect.dropdownHeight）。
  final double? dropdownHeight;

  @override
  Widget build(BuildContext context) {
    final t = themeData;
    return AntPopupOverlay(
      targetKey: triggerKey,
      placement: AntPopupPlacement.bottom,
      arrow: false,
      gap: 4,
      onDismiss: onDismiss,
      child: _buildPanel(context, t),
    );
  }

  double _panelMaxHeight(BuildContext context, AntThemeData t) {
    if (dropdownHeight != null) return t.s(dropdownHeight!);
    final screenH = MediaQuery.sizeOf(context).height;
    return math.min(t.s(256), screenH / 2);
  }

  Widget _buildPanel(BuildContext context, AntThemeData t) {
    final triggerBox =
        triggerKey.currentContext?.findRenderObject() as RenderBox?;
    final triggerWidth = (triggerBox != null && triggerBox.hasSize)
        ? triggerBox.size.width
        : 0.0;
    final panelWidth = triggerWidth > t.s(160) ? triggerWidth : t.s(160);
    return Container(
      key: const Key('ant_tree_select_panel'),
      width: panelWidth,
      constraints: BoxConstraints(maxHeight: _panelMaxHeight(context, t)),
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
      child: SingleChildScrollView(
        child: _buildNodes(context, dataSource, 0, t),
      ),
    );
  }

  Widget _buildNodes(
    BuildContext context,
    List<T> nodes,
    int depth,
    AntThemeData t,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final node in nodes) _buildNode(context, node, depth, t),
      ],
    );
  }

  Widget _buildNode(BuildContext context, T node, int depth, AntThemeData t) {
    final key = keyOf(node);
    final children = childrenOf(node);
    final isExpanded = expandedKeys.contains(key);
    final isSelected = multiple
        ? (selectedMultiValues?.contains(key) ?? false)
        : selectedValue == key;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TreeNodeTile(
          title: titleBuilder(context, node),
          depth: depth,
          isLeaf: children.isEmpty,
          isExpanded: isExpanded,
          isSelected: isSelected,
          disabled: disabledOf(node),
          multiple: multiple,
          fontSize: t.fontSize,
          colorText: t.colorText,
          colorTextDisabled: t.colorTextDisabled,
          colorPrimary: t.colorPrimary,
          colorFillSecondary: t.colorFillSecondary,
          marginSM: t.marginSM,
          onTap: () => onSelect(node),
          onToggle: children.isEmpty ? null : () => onToggleExpand(key),
        ),
        if (children.isNotEmpty && isExpanded)
          _buildNodes(context, children, depth + 1, t),
      ],
    );
  }
}

// ============================================================
// _TreeNodeTile — 单个树节点条目
// ============================================================

class _TreeNodeTile extends StatefulWidget {
  const _TreeNodeTile({
    required this.title,
    required this.depth,
    required this.isLeaf,
    required this.isExpanded,
    required this.isSelected,
    required this.disabled,
    required this.multiple,
    required this.fontSize,
    required this.colorText,
    required this.colorTextDisabled,
    required this.colorPrimary,
    required this.colorFillSecondary,
    required this.marginSM,
    required this.onTap,
    this.onToggle,
  });

  final Widget title;
  final int depth;
  final bool isLeaf;
  final bool isExpanded;
  final bool isSelected;
  final bool disabled;
  final bool multiple;
  final double fontSize;
  final Color colorText;
  final Color colorTextDisabled;
  final Color colorPrimary;
  final Color colorFillSecondary;
  final double marginSM;
  final VoidCallback onTap;
  final VoidCallback? onToggle;

  @override
  State<_TreeNodeTile> createState() => _TreeNodeTileState();
}

class _TreeNodeTileState extends State<_TreeNodeTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final disabled = widget.disabled;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: disabled ? null : widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: theme.s(8), horizontal: theme.s(12)),
          color: disabled
              ? widget.colorFillSecondary.withValues(alpha: 0.3)
              : widget.isSelected
                  ? widget.colorPrimary.withValues(alpha: 0.06)
                  : _isHovered
                      ? widget.colorFillSecondary
                      : null,
          child: Row(
            children: [
              // 缩进
              SizedBox(width: widget.depth * theme.s(20)),
              // 展开/收起箭头
              if (widget.isLeaf)
                SizedBox(width: theme.s(16))
              else
                GestureDetector(
                  onTap: widget.onToggle,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.only(right: theme.s(4)),
                    child: Icon(
                      widget.isExpanded
                          ? AntIcons.downOutlined
                          : AntIcons.rightOutlined,
                      size: theme.s(14),
                      color: widget.colorTextDisabled,
                    ),
                  ),
                ),
              // 多选 checkbox
              if (widget.multiple)
                Padding(
                  padding: EdgeInsets.only(right: theme.s(6)),
                  child: Icon(
                    widget.isSelected
                        ? AntIcons.checkSquareFilled
                        : AntIcons.borderOutlined,
                    size: theme.s(14),
                    color: widget.isSelected
                        ? widget.colorPrimary
                        : widget.colorTextDisabled,
                  ),
                ),
              // 标题
              Expanded(
                child: DefaultTextStyle.merge(
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    color: disabled
                        ? widget.colorTextDisabled
                        : widget.isSelected
                            ? widget.colorPrimary
                            : widget.colorText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  child: widget.title,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
