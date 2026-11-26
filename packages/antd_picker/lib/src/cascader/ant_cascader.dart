/// AntCascader — antd React Cascader 的 Flutter 实现
///
/// API 与 antd React Cascader 对齐：
/// - [dataSource] — 级联选项树（直接使用使用者自己的模型 `T`）
/// - [keyOf] — 从模型取唯一标识
/// - [childrenOf] — 从模型取子节点（返回 null/空表示叶子）
/// - [labelBuilder] — 选项自定义渲染（缺省 `Text('$item')`）
/// - [disabledOf] — 选项禁用判断
/// - [value] / [defaultValue] — 受控/非受控值（元素可为 `T` 或 `keyOf` 返回的 key）
/// - [onChange] — 值变化回调，返回选中的 `List<T>`
/// - [changeOnSelect] — 允许选择任意层级
/// - [expandTrigger] — click / hover 展开子菜单
///
/// ```dart
/// AntCascader<Region>(
///   dataSource: regions,
///   keyOf: (r) => r.code,
///   childrenOf: (r) => r.children,
///   labelBuilder: (context, r) => Text(r.name),
///   onChange: (path) => print(path.map((r) => r.name)),
/// )
/// ```
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_cascader_types.dart';

export 'ant_cascader_types.dart';

// ============================================================
// AntCascader
// ============================================================

/// 级联选择组件。
///
/// 从一组关联层级数据中进行选择，如省/市/区。
class AntCascader<T> extends StatefulWidget {
  const AntCascader({
    super.key,
    required this.keyOf,
    this.dataSource = const [],
    this.childrenOf,
    this.labelBuilder,
    this.disabledOf,
    this.value,
    this.defaultValue,
    this.onChange,
    this.placeholder,
    this.disabled = false,
    this.allowClear = false,
    this.changeOnSelect = false,
    this.size = AntCascaderSize.middle,
    this.expandTrigger = AntCascaderExpandTrigger.click,
  });

  /// 级联选项树。
  final List<T> dataSource;

  /// 从模型取唯一标识。
  final AntCascaderKeyOf<T> keyOf;

  /// 从模型取子节点；为空表示所有选项都是叶子。
  final AntCascaderChildrenOf<T>? childrenOf;

  /// 选项自定义渲染；为空时回退为 `Text('$item')`。
  final AntCascaderLabelBuilder<T>? labelBuilder;

  /// 选项禁用判断。
  final AntCascaderDisabledOf<T>? disabledOf;

  /// 受控值（路径数组，元素可为 `T` 或 key）。
  final List<Object>? value;

  /// 非受控默认值（路径数组，元素可为 `T` 或 key）。
  final List<Object>? defaultValue;

  /// 值变化回调（返回选中的模型路径）。
  final ValueChanged<List<T>>? onChange;

  /// 占位文本。
  final String? placeholder;

  /// 是否禁用。
  final bool disabled;

  /// 是否显示清除按钮。
  final bool allowClear;

  /// 允许选择任意层级（否则仅叶子节点触发 onChange）。
  final bool changeOnSelect;

  /// 尺寸。
  final AntCascaderSize size;

  /// 次级菜单展开触发方式。
  final AntCascaderExpandTrigger expandTrigger;

  @override
  State<AntCascader<T>> createState() => _AntCascaderState<T>();
}

class _AntCascaderState<T> extends State<AntCascader<T>>
    with PopupContentRefresher<AntCascader<T>> {
  final GlobalKey _fieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _open = false;

  /// 当前展开的路径（选中项列表，用于面板高亮与展开）。
  List<T> _activePath = <T>[];

  /// 已确认选中的路径 keys（用于触发器显示）。
  List<Object>? _internalValue;

  List<Object> get _currentValue =>
      widget.value ?? _internalValue ?? <Object>[];

  double get _height {
    switch (widget.size) {
      case AntCascaderSize.large:
        return 40;
      case AntCascaderSize.small:
        return 24;
      case AntCascaderSize.middle:
        return 32;
    }
  }

  Object _keyOf(T item) => widget.keyOf(item);

  List<T>? _childrenOf(T item) => widget.childrenOf?.call(item);

  bool _isLeaf(T item) {
    final children = _childrenOf(item);
    return children == null || children.isEmpty;
  }

  bool _isDisabled(T item) => widget.disabledOf?.call(item) ?? false;

  bool _matches(T item, Object value) =>
      _keyOf(item) == value || identical(item, value) || item == value;

  @override
  void initState() {
    super.initState();
    _internalValue = widget.defaultValue;
    _syncActivePath();
  }

  @override
  void didUpdateWidget(covariant AntCascader<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != oldWidget.value) {
      _syncActivePath();
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  /// 根据当前值同步 _activePath。
  void _syncActivePath() {
    final path = _currentValue;
    if (path.isEmpty) {
      _activePath = <T>[];
      return;
    }
    _activePath = _findPathByValue(path) ?? <T>[];
  }

  /// 根据值路径查找模型路径。
  List<T>? _findPathByValue(List<Object> values) {
    List<T>? search(List<T> options, int depth) {
      if (depth >= values.length) return <T>[];
      for (final item in options) {
        if (_matches(item, values[depth])) {
          if (depth == values.length - 1) return <T>[item];
          final children = _childrenOf(item);
          final sub = children == null ? null : search(children, depth + 1);
          if (sub != null) return <T>[item, ...sub];
          return <T>[item];
        }
      }
      return null;
    }

    return search(widget.dataSource, 0);
  }

  /// 触发器显示的已确认路径。
  ///
  /// antd 语义：非 changeOnSelect 时点击非叶子节点只展开不回填——
  /// 触发框只反映已确认选择（onChange 触发过的值），不反映面板内
  /// 临时展开路径（_activePath 仅用于面板高亮/展开，不作显示来源）。
  List<T> get _displayPath {
    final path = _currentValue;
    if (path.isEmpty) return <T>[];
    return _findPathByValue(path) ?? <T>[];
  }

  Widget _labelFor(BuildContext context, T item) =>
      widget.labelBuilder?.call(context, item) ?? Text('$item');

  void _showOverlay() {
    if (_open || widget.disabled) return;
    final t = AntTheme.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => _CascaderOverlay<T>(
        fieldKey: _fieldKey,
        themeData: t,
        dataSource: widget.dataSource,
        activePath: _activePath,
        keyOf: _keyOf,
        childrenOf: _childrenOf,
        labelBuilder: widget.labelBuilder,
        isDisabled: _isDisabled,
        isLeaf: _isLeaf,
        expandTrigger: widget.expandTrigger,
        changeOnSelect: widget.changeOnSelect,
        onPathChange: _onPathChange,
        onConfirm: _onConfirm,
        onConfirmKeepOpen: _onConfirmKeepOpen,
        onDismiss: _removeOverlay,
      ),
    );
    popupContentEntry = _overlayEntry;
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _open = true);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    popupContentEntry = null;
    _overlayEntry = null;
    if (_open) setState(() => _open = false);
  }

  /// 面板中路径变化（高亮/展开子菜单）。
  void _onPathChange(List<T> path) {
    setState(() => _activePath = path);
    _updateOverlay();
  }

  /// 确认选择（点击叶子节点或 changeOnSelect 时点击任意节点）。
  void _onConfirm(List<T> path) {
    final values = path.map(_keyOf).toList();
    setState(() {
      _internalValue = values;
      _activePath = path;
    });
    widget.onChange?.call(List<T>.from(path));
    _removeOverlay();
  }

  /// 确认选择但保持面板打开（changeOnSelect 模式下点击非叶子节点）。
  void _onConfirmKeepOpen(List<T> path) {
    final values = path.map(_keyOf).toList();
    setState(() {
      _internalValue = values;
    });
    widget.onChange?.call(List<T>.from(path));
  }

  void _updateOverlay() {
    // 面板路径变化经基座 PopupContentRefresher 原地重建（markNeedsBuild），
    // 不 remove+insert —— 避免 AntPopupOverlay 重挂载重放出泡动画
    refreshPopupContent();
  }

  void _clear() {
    setState(() {
      _internalValue = <Object>[];
      _activePath = <T>[];
    });
    widget.onChange?.call(<T>[]);
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final fontSize =
        widget.size == AntCascaderSize.small ? t.fontSizeSM : t.fontSize;
    final showClear =
        widget.allowClear && _currentValue.isNotEmpty && !widget.disabled;

    return GestureDetector(
      key: _fieldKey,
      onTap: widget.disabled ? null : (_open ? _removeOverlay : _showOverlay),
      child: Container(
        height: t.s(_height),
        padding: EdgeInsets.symmetric(
          horizontal: t.s(widget.size == AntCascaderSize.small ? 7 : 12),
        ),
        decoration: BoxDecoration(
          color:
              widget.disabled ? t.colorBgContainerDisabled : t.colorBgContainer,
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
        child: Row(
          children: [
            Expanded(child: _buildFieldContent(context, t, fontSize)),
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
    );
  }

  Widget _buildFieldContent(
    BuildContext context,
    AntThemeData t,
    double fontSize,
  ) {
    final path = _displayPath;
    if (path.isEmpty) {
      return Text(
        widget.placeholder ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fontSize,
          color: t.colorTextPlaceholder,
        ),
      );
    }
    final color = widget.disabled ? t.colorTextDisabled : t.colorText;

    // 未提供 labelBuilder 时保持原先的纯文本显示。
    if (widget.labelBuilder == null) {
      return Text(
        path.map((item) => '$item').join(' / '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: fontSize, color: color),
      );
    }

    return DefaultTextStyle.merge(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: fontSize, color: color),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < path.length; i++) ...[
            if (i > 0) const Text(' / '),
            Flexible(child: _labelFor(context, path[i])),
          ],
        ],
      ),
    );
  }
}

// ============================================================
// _CascaderOverlay — 多列级联面板
// ============================================================

class _CascaderOverlay<T> extends StatelessWidget {
  const _CascaderOverlay({
    required this.fieldKey,
    required this.themeData,
    required this.dataSource,
    required this.activePath,
    required this.keyOf,
    required this.childrenOf,
    required this.labelBuilder,
    required this.isDisabled,
    required this.isLeaf,
    required this.expandTrigger,
    required this.changeOnSelect,
    required this.onPathChange,
    required this.onConfirm,
    required this.onConfirmKeepOpen,
    required this.onDismiss,
  });

  final GlobalKey fieldKey;
  final AntThemeData themeData;
  final List<T> dataSource;
  final List<T> activePath;
  final Object Function(T item) keyOf;
  final List<T>? Function(T item) childrenOf;
  final AntCascaderLabelBuilder<T>? labelBuilder;
  final bool Function(T item) isDisabled;
  final bool Function(T item) isLeaf;
  final AntCascaderExpandTrigger expandTrigger;
  final bool changeOnSelect;
  final ValueChanged<List<T>> onPathChange;
  final ValueChanged<List<T>> onConfirm;
  final ValueChanged<List<T>> onConfirmKeepOpen;
  final VoidCallback onDismiss;

  /// 构建面板列：根据 activePath 展开层级。
  List<List<T>> get _columns {
    final cols = <List<T>>[dataSource];
    for (final active in activePath) {
      final children = childrenOf(active);
      if (children != null && children.isNotEmpty) {
        cols.add(children);
      } else {
        break;
      }
    }
    return cols;
  }

  void _handleOptionTap(
    List<T> colOptions,
    int indexInCol,
    int colIndex,
  ) {
    final option = colOptions[indexInCol];
    if (isDisabled(option)) return;

    // 构建新路径：取 activePath 前 colIndex 项 + 当前选项
    final newPath = <T>[...activePath.take(colIndex), option];

    if (isLeaf(option)) {
      // 叶子节点 → 确认选择并关闭面板
      onConfirm(newPath);
    } else if (changeOnSelect) {
      // 非叶子 + changeOnSelect → 确认选择但保持面板打开，继续展开子菜单
      onConfirmKeepOpen(newPath);
      onPathChange(newPath);
    } else {
      // 非叶子 → 仅展开子菜单
      onPathChange(newPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = themeData;
    final cols = _columns;

    // 弹层基座：位置计算/边界翻转夹回/点击外部关闭统一走 AntPopupOverlay
    return AntPopupOverlay(
      targetKey: fieldKey,
      placement: AntPopupPlacement.bottomLeft,
      onDismiss: onDismiss,
      child: Material(
        color: Colors.transparent,
        child: Container(
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var colIndex = 0; colIndex < cols.length; colIndex++)
                _buildColumn(context, cols, colIndex, t),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColumn(
    BuildContext context,
    List<List<T>> cols,
    int colIndex,
    AntThemeData t,
  ) {
    final colOptions = cols[colIndex];
    final activeInCol =
        colIndex < activePath.length ? activePath[colIndex] : null;

    return Container(
      width: t.s(140),
      constraints: BoxConstraints(maxHeight: t.s(256)),
      decoration: BoxDecoration(
        border: Border(
          right: colIndex < cols.length - 1
              ? BorderSide(color: t.colorSplit, width: 1)
              : BorderSide.none,
        ),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: colOptions.length,
        itemBuilder: (context, index) {
          final option = colOptions[index];
          final isActive = activeInCol != null &&
              (keyOf(activeInCol) == keyOf(option) ||
                  identical(activeInCol, option));

          return _CascaderOptionTile(
            label: labelBuilder?.call(context, option) ?? Text('$option'),
            isActive: isActive,
            disabled: isDisabled(option),
            isLeaf: isLeaf(option),
            fontSize: t.fontSize,
            colorText: t.colorText,
            colorTextDisabled: t.colorTextDisabled,
            colorPrimary: t.colorPrimary,
            colorFillSecondary: t.colorFillSecondary,
            expandTrigger: expandTrigger,
            onTap: () => _handleOptionTap(colOptions, index, colIndex),
            onHover: isLeaf(option) ||
                    expandTrigger == AntCascaderExpandTrigger.click
                ? null
                : () => _handleOptionTap(colOptions, index, colIndex),
          );
        },
      ),
    );
  }
}

// ============================================================
// _CascaderOptionTile — 单个选项条目
// ============================================================

class _CascaderOptionTile extends StatefulWidget {
  const _CascaderOptionTile({
    required this.label,
    required this.isActive,
    required this.disabled,
    required this.isLeaf,
    required this.fontSize,
    required this.colorText,
    required this.colorTextDisabled,
    required this.colorPrimary,
    required this.colorFillSecondary,
    required this.expandTrigger,
    required this.onTap,
    this.onHover,
  });

  final Widget label;
  final bool isActive;
  final bool disabled;
  final bool isLeaf;
  final double fontSize;
  final Color colorText;
  final Color colorTextDisabled;
  final Color colorPrimary;
  final Color colorFillSecondary;
  final AntCascaderExpandTrigger expandTrigger;
  final VoidCallback onTap;
  final VoidCallback? onHover;

  @override
  State<_CascaderOptionTile> createState() => _CascaderOptionTileState();
}

class _CascaderOptionTileState extends State<_CascaderOptionTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final disabled = widget.disabled;
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        if (widget.onHover != null) widget.onHover!();
      },
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: disabled ? null : widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: t.s(8), horizontal: t.s(12)),
          color: disabled
              ? widget.colorFillSecondary.withValues(alpha: 0.3)
              : widget.isActive
                  ? widget.colorPrimary.withValues(alpha: 0.06)
                  : _isHovered
                      ? widget.colorFillSecondary
                      : null,
          child: Row(
            children: [
              Expanded(
                child: DefaultTextStyle.merge(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    color: disabled
                        ? widget.colorTextDisabled
                        : widget.isActive
                            ? widget.colorPrimary
                            : widget.colorText,
                  ),
                  child: widget.label,
                ),
              ),
              if (!widget.isLeaf)
                Icon(
                  AntIcons.rightOutlined,
                  size: t.s(14),
                  color: widget.colorTextDisabled,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
