/// AntInput — antd Input 输入框的 Flutter 实现
///
/// API 与 antd React Input 对齐：
/// - [AntInput] — 基础输入框（prefix/suffix/addonBefore/addonAfter/allowClear/showCount）
/// - [AntInputTextArea] — 多行文本域（rows/autoSize）
/// - [AntInputPassword] — 密码框（visibilityToggle）
/// - [AntInputSearch] — 搜索框（enterButton/onSearch）
/// - [AntInputGroup] — 输入框组（compact）
library;

import 'package:antd_flutter_ui/src/data_entry/input/ant_input_field.dart';
import '../../feedback/loading/ant_loading.dart';
import 'package:antd_flutter_ui/src/data_entry/input/ant_input_types.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

// ============================================================
// 内部工具
// ============================================================

/// 根据状态获取边框色
Color _borderColorOf(AntThemeData t, AntInputStatus status, bool focused) {
  switch (status) {
    case AntInputStatus.error:
      return t.colorError;
    case AntInputStatus.warning:
      return t.colorWarning;
    case AntInputStatus.normal:
      return focused ? t.colorPrimary : t.colorBorder;
  }
}

/// 根据尺寸获取高度
double _heightOf(AntThemeData t, AntInputSize size) {
  switch (size) {
    case AntInputSize.large:
      return t.controlHeightLG;
    case AntInputSize.middle:
      return t.controlHeight;
    case AntInputSize.small:
      return t.controlHeightSM;
  }
}

/// 根据尺寸获取字号
double _fontSizeOf(AntThemeData t, AntInputSize size) {
  switch (size) {
    case AntInputSize.large:
      return t.fontSizeLG;
    case AntInputSize.middle:
      return t.fontSize;
    case AntInputSize.small:
      return t.fontSizeSM;
  }
}

// ============================================================
// AntInput
// ============================================================

/// 输入框 — 通过鼠标或键盘输入内容，是最基础的表单域包装。
///
/// 对齐 antd React Input 组件，支持前后缀、前后置标签、清除、字数统计、
/// 校验状态与三种尺寸。
///
/// ```dart
/// AntInput(
///   placeholder: '请输入',
///   onChange: (v) => print(v),
/// )
/// ```
class AntInput extends StatefulWidget {
  const AntInput({
    super.key,
    this.value,
    this.defaultValue,
    this.onChange,
    this.onPressEnter,
    this.disabled = false,
    this.size = AntInputSize.middle,
    this.prefix,
    this.suffix,
    this.addonBefore,
    this.addonAfter,
    this.allowClear = false,
    this.maxLength,
    this.showCount = false,
    this.status = AntInputStatus.normal,
    this.placeholder,
    this.readOnly = false,
    this.bordered = true,
    this.keyboardType,
    this.focusNode,
    this.controller,
    this.autofocus = false,
    this.obscureText = false,
    this.inputFormatters,
  });

  /// 受控值。
  final String? value;

  /// 非受控初始值。
  final String? defaultValue;

  /// 输入变化回调。
  final ValueChanged<String>? onChange;

  /// 按下回车回调。
  final VoidCallback? onPressEnter;

  /// 是否禁用。
  final bool disabled;

  /// 尺寸。
  final AntInputSize size;

  /// 前缀图标。
  final Widget? prefix;

  /// 后缀图标。
  final Widget? suffix;

  /// 前置标签。
  final Widget? addonBefore;

  /// 后置标签。
  final Widget? addonAfter;

  /// 是否显示清除按钮。
  final bool allowClear;

  /// 最大输入长度。
  final int? maxLength;

  /// 是否显示字数统计。
  final bool showCount;

  /// 校验状态。
  final AntInputStatus status;

  /// 占位文本。
  final String? placeholder;

  /// 是否只读。
  final bool readOnly;

  /// 是否显示边框。
  final bool bordered;

  /// 键盘类型。
  final TextInputType? keyboardType;

  /// 焦点节点。
  final FocusNode? focusNode;

  /// 文本控制器。
  final TextEditingController? controller;

  /// 是否自动聚焦。
  final bool autofocus;

  /// 是否隐藏文本（密码框用）。
  final bool obscureText;

  /// 输入格式化。
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<AntInput> createState() => _AntInputState();
}

class _AntInputState extends State<AntInput> {
  late TextEditingController _controller;
  bool _isControllerExternal = false;
  late FocusNode _focusNode;
  bool _hasValue = false;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _isControllerExternal = widget.controller != null;
    _controller = widget.controller ??
        TextEditingController(text: widget.value ?? widget.defaultValue ?? '');
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    _controller.addListener(_handleControllerChange);
    _hasValue = _controller.text.isNotEmpty;
    if (widget.autofocus) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _focusNode.requestFocus());
    }
  }

  @override
  void didUpdateWidget(AntInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != _controller.text) {
      _controller.text = widget.value!;
    }
    if (widget.controller != null && widget.controller != _controller) {
      _controller.removeListener(_handleControllerChange);
      _controller = widget.controller!;
      _controller.addListener(_handleControllerChange);
    }
    if (widget.focusNode != null && widget.focusNode != _focusNode) {
      _focusNode.removeListener(_handleFocusChange);
      _focusNode = widget.focusNode!;
      _focusNode.addListener(_handleFocusChange);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChange);
    _focusNode.removeListener(_handleFocusChange);
    if (!_isControllerExternal) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChange?.call('');
  }

  void _handleControllerChange() {
    final has = _controller.text.isNotEmpty;
    if (has != _hasValue) {
      setState(() => _hasValue = has);
    }
    widget.onChange?.call(_controller.text);
  }

  void _handleFocusChange() {
    final focused = _focusNode.hasFocus;
    if (focused != _focused) {
      setState(() => _focused = focused);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final height = _heightOf(t, widget.size);
    final fontSize = _fontSizeOf(t, widget.size);
    final iconSize = widget.size == AntInputSize.small ? t.s(12) : t.s(14);

    final inputField = _buildInputBody(t, height, fontSize, iconSize);

    // 无 addon 时直接返回主体
    if (widget.addonBefore == null && widget.addonAfter == null) {
      return _buildWithCount(t, inputField, height);
    }

    // 有 addon：addon 与输入区同处一个圆角容器（antd 规范），
    // 外层统一绘制边框/圆角/聚焦环，addon 灰底、与输入区以 1px 分隔线衔接
    final borderColor = widget.disabled
        ? t.colorBorder
        : _borderColorOf(t, widget.status, _focused);
    final addonRow = IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.addonBefore != null)
            _buildAddon(t, widget.addonBefore!, height, fontSize, true),
          Expanded(
            // 高度锁定/垂直居中由基座统一；水平内边距由外层负责（与 addon 分隔线衔接）
            child: Padding(
              // embedded 装饰器无固有偏移：marginSM+4 → 字形内缩 17.3 与
              // standalone（marginSM+4.33 固有）字形对齐
              padding: EdgeInsets.symmetric(horizontal: t.marginSM + 4),
              child: AntInputField(
                size: widget.size,
                controller: _controller,
                focusNode: _focusNode,
                enabled: !widget.disabled,
                readOnly: widget.readOnly,
                obscureText: widget.obscureText,
                maxLength: widget.maxLength,
                keyboardType: widget.keyboardType,
                inputFormatters: widget.inputFormatters,
                placeholder: widget.placeholder,
                status: widget.status,
                mode: AntInputFieldMode.embedded,
                autofocus: widget.autofocus,
                onChanged: (_) => widget.onChange?.call(_controller.text),
                onSubmitted: widget.onPressEnter == null
                    ? null
                    : (_) => widget.onPressEnter!(),
              ),
            ),
          ),
          if (widget.addonAfter != null)
            _buildAddon(t, widget.addonAfter!, height, fontSize, false),
        ],
      ),
    );
    final body = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: t.s(height),
      decoration: BoxDecoration(
        color:
            widget.disabled ? t.colorBgContainerDisabled : t.colorBgContainer,
        borderRadius: BorderRadius.circular(t.borderRadius),
        boxShadow: widget.bordered && _focused && !widget.disabled
            ? antFieldFocusRingOf(t, widget.status)
            : null,
      ),
      // 边框改由 foregroundDecoration 绘制：BoxDecoration 的 border 若挂在
      // decoration 上会被 Container 计入 padding（内容高度少 2px），与
      // IntrinsicHeight 强制的整行高度冲突，导致 addon 行被裁切、文字重心偏移。
      // 前景层绘制不参与布局，内容铺满整框（antd 聚焦时边框加粗也不抖）。
      foregroundDecoration: widget.bordered
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(t.borderRadius),
              border: Border.all(color: borderColor, width: t.s(1)),
            )
          : null,
      clipBehavior: Clip.antiAlias,
      child: addonRow,
    );
    return _buildWithCount(t, body, height);
  }

  /// 构建带字数统计的外层
  Widget _buildWithCount(AntThemeData t, Widget child, double height) {
    if (!widget.showCount || widget.maxLength == null) return child;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        Padding(
          padding: EdgeInsets.only(top: t.s(2)),
          child: Text(
            '${_controller.text.length} / ${widget.maxLength}',
            style: TextStyle(
              fontSize: t.fontSizeSM,
              color: t.colorTextTertiary,
            ),
          ),
        ),
      ],
    );
  }

  /// 构建输入框主体（边框/填充/hover/禁用态统一由 [AntInputField] 承载）
  Widget _buildInputBody(
    AntThemeData t,
    double height,
    double fontSize,
    double iconSize,
  ) {
    final suffixWidgets = <Widget>[
      if (widget.allowClear && _hasValue && !widget.disabled)
        GestureDetector(
          onTap: _clear,
          behavior: HitTestBehavior.opaque,
          child: Icon(
            AntIcons.closeCircleFilled,
            size: iconSize,
            color: t.colorTextQuaternary,
          ),
        ),
      if (widget.suffix != null) widget.suffix!,
    ];

    final field = AntInputField(
      size: widget.size,
      controller: _controller,
      focusNode: _focusNode,
      enabled: !widget.disabled,
      readOnly: widget.readOnly,
      obscureText: widget.obscureText,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      placeholder: widget.placeholder,
      prefix: widget.prefix == null
          ? null
          : IconTheme.merge(
              data: IconThemeData(size: iconSize, color: t.colorTextTertiary),
              child: widget.prefix!,
            ),
      suffix: suffixWidgets.isEmpty
          ? null
          : IconTheme.merge(
              data: IconThemeData(size: iconSize, color: t.colorTextTertiary),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < suffixWidgets.length; i++) ...[
                    if (i > 0) SizedBox(width: t.s(4)),
                    suffixWidgets[i],
                  ],
                ],
              ),
            ),
      status: widget.status,
      bordered: widget.bordered,
      autofocus: widget.autofocus,
      onChanged: (_) => widget.onChange?.call(_controller.text),
      onSubmitted:
          widget.onPressEnter == null ? null : (_) => widget.onPressEnter!(),
    );

    // 高度锁定与垂直居中由基座统一处理
    return field;
  }

  /// 构建前置/后置标签（灰底 + 内侧 1px 分隔线，边框由外层容器统一绘制）
  Widget _buildAddon(
    AntThemeData t,
    Widget child,
    double height,
    double fontSize,
    bool before,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: t.marginSM),
      decoration: BoxDecoration(
        color: t.colorFillQuaternary,
        border: Border(
          right: before
              ? BorderSide(color: t.colorBorder, width: t.s(1))
              : BorderSide.none,
          left: !before
              ? BorderSide(color: t.colorBorder, width: t.s(1))
              : BorderSide.none,
        ),
      ),
      alignment: Alignment.center,
      child: DefaultTextStyle(
        // height: 1.0 与输入区文字行盒一致（antd web 中 addon 与输入框共享
        // 同一行高）；否则 addon 按自然行高（含额外上下留白）居中，与输入
        // 文字的字形重心错开，表现为「文本未居中」
        style: TextStyle(
          fontSize: t.s(fontSize),
          height: 1.0,
          color: t.colorTextSecondary,
        ),
        child: child,
      ),
    );
  }
}

// ============================================================
// AntInputTextArea
// ============================================================

/// 文本域 — 多行输入。
///
/// 对齐 antd React Input.TextArea，支持 rows、autoSize、字数统计。
///
/// ```dart
/// AntInputTextArea(
///   rows: 4,
///   maxLength: 100,
///   showCount: true,
/// )
/// ```
class AntInputTextArea extends StatefulWidget {
  const AntInputTextArea({
    super.key,
    this.value,
    this.defaultValue,
    this.onChange,
    this.onPressEnter,
    this.disabled = false,
    this.placeholder,
    this.rows = 3,
    this.autoSize,
    this.maxLength,
    this.showCount = false,
    this.status = AntInputStatus.normal,
    this.readOnly = false,
    this.bordered = true,
    this.controller,
    this.focusNode,
    this.autofocus = false,
  });

  /// 受控值。
  final String? value;

  /// 非受控初始值。
  final String? defaultValue;

  /// 输入变化回调。
  final ValueChanged<String>? onChange;

  /// 按下回车回调。
  final VoidCallback? onPressEnter;

  /// 是否禁用。
  final bool disabled;

  /// 占位文本。
  final String? placeholder;

  /// 行数。
  final int rows;

  /// 自适应高度，true 为自动；也可指定 [min, max]。
  final dynamic autoSize;

  /// 最大输入长度。
  final int? maxLength;

  /// 是否显示字数统计。
  final bool showCount;

  /// 校验状态。
  final AntInputStatus status;

  /// 是否只读。
  final bool readOnly;

  /// 是否显示边框。
  final bool bordered;

  /// 文本控制器。
  final TextEditingController? controller;

  /// 焦点节点。
  final FocusNode? focusNode;

  /// 是否自动聚焦。
  final bool autofocus;

  @override
  State<AntInputTextArea> createState() => _AntInputTextAreaState();
}

class _AntInputTextAreaState extends State<AntInputTextArea> {
  late TextEditingController _controller;
  bool _isControllerExternal = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _isControllerExternal = widget.controller != null;
    _controller = widget.controller ??
        TextEditingController(text: widget.value ?? widget.defaultValue ?? '');
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    _controller.addListener(_handleControllerChange);
    if (widget.autofocus) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _focusNode.requestFocus());
    }
  }

  @override
  void didUpdateWidget(AntInputTextArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != _controller.text) {
      _controller.text = widget.value!;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChange);
    _focusNode.removeListener(_handleFocusChange);
    if (!_isControllerExternal) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {});
  }

  void _handleControllerChange() {
    setState(() {});
    widget.onChange?.call(_controller.text);
  }

  int? get _minLines {
    if (widget.autoSize == true) return 1;
    if (widget.autoSize is List && (widget.autoSize as List).isNotEmpty) {
      return (widget.autoSize as List).first as int? ?? 1;
    }
    return widget.rows;
  }

  int? get _maxLines {
    if (widget.autoSize == true) return null;
    if (widget.autoSize is List && (widget.autoSize as List).length >= 2) {
      return (widget.autoSize as List)[1] as int?;
    }
    return widget.rows;
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final minLines = _minLines ?? 1;
    final maxLines = _maxLines;

    final field = AntInputField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: !widget.disabled,
      readOnly: widget.readOnly,
      maxLength: widget.maxLength,
      status: widget.status,
      placeholder: widget.placeholder,
      minLines: minLines,
      maxLines: maxLines,
      autofocus: widget.autofocus,
      // 左右内边距由基座容器的 marginSM 统一承担（与单行形态一致），
      // 这里只覆盖垂直内边距，避免正文再缩进一个 marginSM
      contentPadding: EdgeInsets.symmetric(vertical: t.s(8)),
      onChanged: (_) => widget.onChange?.call(_controller.text),
      onSubmitted:
          widget.onPressEnter == null ? null : (_) => widget.onPressEnter!(),
    );

    final body = field;

    if (!widget.showCount || widget.maxLength == null) return body;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        body,
        Padding(
          padding: EdgeInsets.only(top: t.s(2)),
          child: Text(
            '${_controller.text.length} / ${widget.maxLength}',
            style: TextStyle(
              fontSize: t.fontSizeSM,
              color: t.colorTextTertiary,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// AntInputPassword
// ============================================================

/// 密码框 — 在输入框基础上切换明文/密文。
///
/// 对齐 antd React Input.Password，支持 visibilityToggle。
///
/// ```dart
/// AntInputPassword(placeholder: '请输入密码')
/// ```
class AntInputPassword extends StatefulWidget {
  const AntInputPassword({
    super.key,
    this.value,
    this.defaultValue,
    this.onChange,
    this.onPressEnter,
    this.disabled = false,
    this.placeholder,
    this.visibilityToggle = true,
    this.size = AntInputSize.middle,
    this.status = AntInputStatus.normal,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.prefix,
  });

  /// 受控值。
  final String? value;

  /// 非受控初始值。
  final String? defaultValue;

  /// 输入变化回调。
  final ValueChanged<String>? onChange;

  /// 按下回车回调。
  final VoidCallback? onPressEnter;

  /// 是否禁用。
  final bool disabled;

  /// 占位文本。
  final String? placeholder;

  /// 是否显示明文切换按钮。
  final bool visibilityToggle;

  /// 尺寸。
  final AntInputSize size;

  /// 校验状态。
  final AntInputStatus status;

  /// 文本控制器。
  final TextEditingController? controller;

  /// 焦点节点。
  final FocusNode? focusNode;

  /// 是否自动聚焦。
  final bool autofocus;

  /// 前缀图标。
  final Widget? prefix;

  @override
  State<AntInputPassword> createState() => _AntInputPasswordState();
}

class _AntInputPasswordState extends State<AntInputPassword> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final iconSize = widget.size == AntInputSize.small ? t.s(12) : t.s(14);

    return AntInput(
      value: widget.value,
      defaultValue: widget.defaultValue,
      onChange: widget.onChange,
      onPressEnter: widget.onPressEnter,
      disabled: widget.disabled,
      placeholder: widget.placeholder,
      size: widget.size,
      status: widget.status,
      controller: widget.controller,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      prefix: widget.prefix,
      obscureText: !_visible,
      suffix: widget.visibilityToggle
          ? GestureDetector(
              onTap: widget.disabled
                  ? null
                  : () => setState(() => _visible = !_visible),
              behavior: HitTestBehavior.opaque,
              child: Icon(
                _visible ? AntIcons.eyeOutlined : AntIcons.eyeInvisibleOutlined,
                size: iconSize,
                color: t.colorTextTertiary,
              ),
            )
          : null,
    );
  }
}

// ============================================================
// AntInputSearch
// ============================================================

/// 搜索框 — 带搜索按钮的输入框。
///
/// 对齐 antd React Input.Search，支持 enterButton、onSearch。
///
/// ```dart
/// AntInputSearch(
///   placeholder: '搜索',
///   onSearch: (v) => print(v),
/// )
/// ```
class AntInputSearch extends StatefulWidget {
  const AntInputSearch({
    super.key,
    this.value,
    this.defaultValue,
    this.onChange,
    this.onSearch,
    this.disabled = false,
    this.placeholder,
    this.enterButton = false,
    this.size = AntInputSize.middle,
    this.loading = false,
    this.controller,
    this.focusNode,
    this.autofocus = false,
  });

  /// 受控值。
  final String? value;

  /// 非受控初始值。
  final String? defaultValue;

  /// 输入变化回调。
  final ValueChanged<String>? onChange;

  /// 搜索回调（回车或点击搜索按钮触发）。
  final ValueChanged<String>? onSearch;

  /// 是否禁用。
  final bool disabled;

  /// 占位文本。
  final String? placeholder;

  /// 是否将搜索按钮替换为文字按钮（true 为"搜索"，或传入自定义文案）。
  final dynamic enterButton;

  /// 尺寸。
  final AntInputSize size;

  /// 是否加载中。
  final bool loading;

  /// 文本控制器。
  final TextEditingController? controller;

  /// 焦点节点。
  final FocusNode? focusNode;

  /// 是否自动聚焦。
  final bool autofocus;

  @override
  State<AntInputSearch> createState() => _AntInputSearchState();
}

class _AntInputSearchState extends State<AntInputSearch> {
  late TextEditingController _controller;
  bool _isControllerExternal = false;

  @override
  void initState() {
    super.initState();
    _isControllerExternal = widget.controller != null;
    _controller = widget.controller ??
        TextEditingController(text: widget.value ?? widget.defaultValue ?? '');
    _controller.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(AntInputSearch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != _controller.text) {
      _controller.text = widget.value!;
    }
  }

  @override
  void dispose() {
    if (!_isControllerExternal) _controller.dispose();
    super.dispose();
  }

  void _doSearch() {
    widget.onSearch?.call(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final height = _heightOf(t, widget.size);
    final fontSize = _fontSizeOf(t, widget.size);
    final iconSize = widget.size == AntInputSize.small ? t.s(12) : t.s(14);

    // 搜索按钮
    final isTextButton =
        widget.enterButton == true || (widget.enterButton is String);
    final buttonText =
        widget.enterButton is String ? widget.enterButton as String : '搜索';

    final searchButton = GestureDetector(
      onTap: widget.disabled ? null : _doSearch,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: t.s(height),
        padding: EdgeInsets.symmetric(horizontal: t.s(12)),
        decoration: BoxDecoration(
          color: t.colorPrimary,
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(t.borderRadius),
          ),
        ),
        alignment: Alignment.center,
        child: widget.loading
            ? AntLoading(
                size: iconSize,
                color: Colors.white,
              )
            : isTextButton
                ? Text(
                    buttonText,
                    style: TextStyle(
                      fontSize: t.s(fontSize),
                      color: Colors.white,
                    ),
                  )
                : Icon(
                    AntIcons.searchOutlined,
                    size: iconSize,
                    color: Colors.white,
                  ),
      ),
    );

    final input = AntInput(
      value: widget.value,
      defaultValue: widget.defaultValue,
      onChange: widget.onChange,
      disabled: widget.disabled,
      placeholder: widget.placeholder,
      size: widget.size,
      controller: _controller,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onPressEnter: _doSearch,
      suffix: widget.enterButton == false
          ? GestureDetector(
              onTap: widget.disabled ? null : _doSearch,
              behavior: HitTestBehavior.opaque,
              child: Icon(
                AntIcons.searchOutlined,
                size: iconSize,
                color: t.colorTextTertiary,
              ),
            )
          : null,
    );

    if (widget.enterButton == false) {
      return input;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(t.borderRadius),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(child: input),
            searchButton,
          ],
        ),
      ),
    );
  }
}

// ============================================================
// AntInputGroup
// ============================================================

/// 输入框组 — 将多个输入框组合为紧凑布局。
///
/// 对齐 antd React Input.Group，compact 模式下子项边距合并。
///
/// ```dart
/// AntInputGroup(
///   compact: true,
///   children: [
///     AntInput(addonBefore: 'http://'),
///     AntInput(placeholder: '.com'),
///   ],
/// )
/// ```
class AntInputGroup extends StatelessWidget {
  const AntInputGroup({
    super.key,
    this.compact = false,
    required this.children,
  });

  /// 是否紧凑布局。
  final bool compact;

  /// 子组件。
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    if (!compact) {
      return Wrap(
        spacing: t.s(8),
        runSpacing: t.s(8),
        children: children,
      );
    }

    // 紧凑模式：相邻边框合并（负 margin 效果通过 Stack/Transform 不便实现，
    // 改用去重边框法：每个子项左侧边框在非首项时由前一项右侧覆盖）
    final separator = Container(
      width: t.s(1),
      color: t.colorBorder,
      height: t.s(_heightOf(t, AntInputSize.middle)),
    );

    final items = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) items.add(separator);
      items.add(Expanded(child: children[i]));
    }

    return Row(children: items);
  }
}
