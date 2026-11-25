/// AntInputField — 输入族共享字段基座（TextFormField 封装）
///
/// **基座级统一语义（唯一实现点，全家族继承）**：
/// - **垂直居中**：单行模式下由基座内部锁定高度并垂直居中（基于字段高度而非
///   padding 拼凑）；多行输入（minLines/maxLines>1）例外——顶部对齐语义，
///   不做垂直居中（见 multiline 分支）
/// - **hover 态**：standalone 模式边框 hover 反馈（colorPrimaryHover token），
///   desktop 密度附加悬停底色；embedded 模式 hover 由外层容器承接
/// - **disabled 态**：禁用灰底（colorBgContainerDisabled）+ 禁用文字
///   （colorTextQuaternary）+ 光标封锁（basic 鼠标样式）+ 输入封锁（enabled:false），
///   全家族统一，不再逐组件打补丁
///
/// 模式：
/// - `standalone`：字段自绘边框与填充（AntInput / AntInputTextArea）
/// - `embedded`：无边框无填充，输出「高度锁定 + 居中」的字段块，
///   由外层容器统一绘制边框（InputNumber / SearchBar / Stepper /
///   PasscodeInput 桌面态 / VirtualInput 桌面态）
///
/// 内部共享组件，不进 barrel 导出。
library;

import 'package:antd_flutter_ui/src/data_entry/input/ant_input_types.dart';
import 'package:antd_theme/antd_theme.dart';
// 项目约定：material 系组件统一经 material_ui（vendored material）引入，
// 与主包其它组件保持同一类系，避免跨 Material 类系查找失败
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// 根据尺寸获取高度
double antFieldHeightOf(AntThemeData t, AntInputSize size) {
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
double antFieldFontSizeOf(AntThemeData t, AntInputSize size) {
  switch (size) {
    case AntInputSize.large:
      return t.fontSizeLG;
    case AntInputSize.middle:
      return t.fontSize;
    case AntInputSize.small:
      return t.fontSizeSM;
  }
}

/// 根据状态获取边框色
Color antFieldBorderColorOf(
  AntThemeData t,
  AntInputStatus status, {
  bool focused = false,
  bool hovered = false,
}) {
  switch (status) {
    case AntInputStatus.error:
      return t.colorError;
    case AntInputStatus.warning:
      return t.colorWarning;
    case AntInputStatus.normal:
      if (focused) return t.colorPrimary;
      // hover 反馈色（基座单点，全家族继承）
      if (hovered) return t.colorPrimaryHover;
      return t.colorBorder;
  }
}

/// 焦点光环色 — 跟随校验状态（antd 语义：error → colorErrorOutline，
/// warning → colorWarningOutline，正常 → controlOutline）。
Color antFieldFocusOutlineOf(AntThemeData t, AntInputStatus status) {
  switch (status) {
    case AntInputStatus.error:
      return t.colorErrorOutline;
    case AntInputStatus.warning:
      return t.colorWarningOutline;
    case AntInputStatus.normal:
      return t.controlOutline;
  }
}

/// 焦点光环 — antd web 为「无模糊的实心外扩环」（`box-shadow: 0 0 0 2px
/// outline`），不是模糊辉光；外扩不参与布局，因此不引起内容位移。
List<BoxShadow> antFieldFocusRingOf(AntThemeData t, AntInputStatus status) => [
      BoxShadow(
        color: antFieldFocusOutlineOf(t, status),
        spreadRadius: t.controlOutlineWidth,
      ),
    ];

class AntInputField extends StatefulWidget {
  const AntInputField({
    super.key,
    this.size = AntInputSize.middle,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLength,
    this.keyboardType,
    this.inputFormatters,
    this.textInputAction,
    this.placeholder,
    this.prefix,
    this.suffix,
    this.status = AntInputStatus.normal,
    this.mode = AntInputFieldMode.standalone,
    this.bordered = true,
    this.contentPadding,
    this.height,
    this.textSize,
    this.embeddedPadding,
    this.minLines = 1,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
  });

  /// 尺寸（决定单行高度与字号）。
  final AntInputSize size;

  final TextEditingController? controller;
  final FocusNode? focusNode;

  /// 是否启用（false = 禁用态：灰底/禁用文字/光标封锁，基座统一）。
  final bool enabled;

  final bool readOnly;
  final bool obscureText;
  final int? maxLength;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  /// 键盘动作按钮（如 TextInputAction.search）。
  final TextInputAction? textInputAction;
  final String? placeholder;

  /// 前缀（置于字段内部，带标准水平内边距）。
  final Widget? prefix;

  /// 后缀（置于字段内部，带标准水平内边距）。
  final Widget? suffix;

  /// 校验状态。
  final AntInputStatus status;

  /// 呈现模式。
  final AntInputFieldMode mode;

  /// standalone 模式下是否绘制边框（false = 无边框变体）。
  final bool bordered;

  /// 多行模式的内容内边距覆盖（单行模式由基座统一，忽略此参数）。
  final EdgeInsetsGeometry? contentPadding;

  /// 高度覆盖（null 时按 [size] 取 token 高度）。
  final double? height;

  /// 字号覆盖（null 时按 [size] 取 token 字号）。
  final double? textSize;

  /// embedded 单行的上下内边距覆盖（null 时为 0）。
  /// 由外层容器传入「(容器高 - 字号) / 2」以让行盒在整块内垂直居中。
  final double? embeddedPadding;

  final int minLines;
  final int? maxLines;
  final TextAlign textAlign;
  final bool autofocus;
  final ValueChanged<String>? onChanged;

  /// 回车提交回调。
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;

  @override
  State<AntInputField> createState() => _AntInputFieldState();
}

class _AntInputFieldState extends State<AntInputField> {
  bool _hovered = false;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode?.addListener(_handleFocusChange);
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.focusNode?.requestFocus();
      });
    }
  }

  @override
  void didUpdateWidget(covariant AntInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChange);
      widget.focusNode?.addListener(_handleFocusChange);
    }
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _handleFocusChange() {
    if (mounted) setState(() => _focused = widget.focusNode?.hasFocus ?? false);
  }

  bool get _isMultiline {
    final maxLines = widget.maxLines ?? 1;
    return widget.minLines > 1 || maxLines > 1;
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final standalone = widget.mode == AntInputFieldMode.standalone;
    final fontSize = widget.textSize ?? t.s(antFieldFontSizeOf(t, widget.size));
    final multiline = _isMultiline;
    final height = widget.height ?? antFieldHeightOf(t, widget.size);

    // ----------------------------------------------------------
    // 基座单点：垂直居中（单行）/ 顶部对齐（多行例外）
    // ----------------------------------------------------------
    final field = TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      obscureText: widget.obscureText,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      textInputAction: widget.textInputAction,
      autofocus: widget.autofocus,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      textAlign: widget.textAlign,
      textAlignVertical:
          multiline ? TextAlignVertical.top : TextAlignVertical.center,
      style: TextStyle(
        fontSize: fontSize,
        height: 1.0,
        color: widget.enabled ? t.colorText : t.colorTextQuaternary,
      ),
      cursorColor: t.colorPrimary,
      cursorHeight: fontSize,
      mouseCursor: !widget.enabled
          ? SystemMouseCursors.basic
          : widget.readOnly
              ? SystemMouseCursors.basic
              : SystemMouseCursors.text,
      decoration: InputDecoration(
        isDense: true,
        // isCollapsed 移除：其把输入区压成行盒并顶置（文字偏上），
        // 由下方对称 contentPadding + textAlignVertical.center 实现居中
        // 基座统一：填充与 hover 全显式接管，全局主题不再渗入
        filled: standalone,
        fillColor:
            widget.enabled ? t.colorBgContainer : t.colorBgContainerDisabled,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        counterText: '',
        hintText: widget.placeholder,
        hintStyle: TextStyle(
          fontSize: fontSize,
          height: 1.0,
          color: t.colorTextPlaceholder,
        ),
        contentPadding: multiline
            ? EdgeInsets.symmetric(
                horizontal: t.marginSM, vertical: t.marginSM,)
            // standalone 单行：上下对称内边距撑满高度锁定块
            // （textAlignVertical.center 需对称余量执行居中；isCollapsed
            // 会把输入区压成行盒并顶置——桌面/移动端均出现文字偏上）
            : standalone
                ? EdgeInsets.symmetric(
                    vertical: (t.s(height) - fontSize) / 2,
                  )
                // embedded：与 standalone 同一套对称内边距，行盒在整块内垂直
                // 居中；外层可用 embeddedPadding 覆盖（AutoComplete 等自绘边框
                // 场景高度小于标准控件高时传更小的值）
                : EdgeInsets.symmetric(
                    vertical: widget.embeddedPadding ??
                        (t.s(height) - fontSize) / 2,
                  ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        prefixIcon: widget.prefix != null
            ? _FieldSlot(
                height: height,
                isLeading: true,
                child: widget.prefix!,
              )
            : null,
        prefixIconConstraints: BoxConstraints(minHeight: t.s(height), minWidth: 0),
        suffixIcon: widget.suffix != null
            ? _FieldSlot(
                height: height,
                isLeading: false,
                child: widget.suffix!,
              )
            : null,
        suffixIconConstraints: BoxConstraints(minHeight: t.s(height), minWidth: 0),
      ),
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      // 点击字段外部统一失焦（与 antd 行为一致；桌面端系统键盘同样适用）
      onTapOutside: (_) => widget.focusNode?.unfocus(),
    );

    // 多行例外：顶部对齐，不锁高度不居中
    if (multiline) {
      if (!standalone) return field;
      return Container(
        decoration: _decorationOf(t, height, multiline: true),
        padding: widget.bordered
            ? EdgeInsets.symmetric(horizontal: t.marginSM)
            : EdgeInsets.zero,
        child: field,
      );
    }

    // 单行：基座锁定高度并垂直居中（文字/光标相对容器垂直居中的唯一实现点）
    // 字段以 tight 约束填充高度锁定块：decorator 铺满整框（fill/disabled 灰底
    // 整框绘制），文字垂直居中由 textAlignVertical.center 单点保证——
    // 避免 Center 松约束下 disabled 字段按 intrinsic 收缩出现灰条/偏移
    //（桌面字体度量下实测偏移 4px）。水平边距由外层容器 padding 承担。
    // 垂直居中：Center（height 松约束 → 字段行盒居中）；
    // widthFactor:1 → 宽度铺满（decorator fill 行为与宽度无关，禁用灰底
    // 由外层容器统一绘制，避免 disabled 字段 intrinsic 收缩灰条）
    final centered = SizedBox(
      height: t.s(height),
      child: Center(
        widthFactor: 1,
        child: field,
      ),
    );

    if (!standalone) {
      // embedded：输出高度锁定 + 居中的字段块，边框由外层容器绘制
      return centered;
    }

    // standalone 无边框变体：不绘制边框容器
    if (!widget.bordered) {
      return MouseRegion(
        cursor: !widget.enabled
            ? SystemMouseCursors.basic
            : widget.readOnly
                ? SystemMouseCursors.basic
                : SystemMouseCursors.text,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: SizedBox(height: t.s(height), child: centered),
      );
    }

    // standalone：基座绘制边框/填充/hover/聚焦环
    return MouseRegion(
      cursor: !widget.enabled
          ? SystemMouseCursors.basic
          : widget.readOnly
              ? SystemMouseCursors.basic
              : SystemMouseCursors.text,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: t.s(height),
        alignment: Alignment.center,
        decoration: _decorationOf(t, height),
        clipBehavior: Clip.antiAlias,
        padding: EdgeInsets.symmetric(horizontal: t.marginSM),
        child: centered,
      ),
    );
  }

  BoxDecoration _decorationOf(
    AntThemeData t,
    double height, {
    bool multiline = false,
  }) {
    final enabled = widget.enabled;
    final radius = BorderRadius.circular(t.borderRadius);
    final baseColor = enabled
        ? antFieldBorderColorOf(
            t,
            widget.status,
            focused: _focused,
            hovered: _hovered && !_focused,
          )
        : t.colorBorder;
    if (!widget.bordered || widget.mode != AntInputFieldMode.standalone) {
      return BoxDecoration(
        color: enabled ? t.colorBgContainer : t.colorBgContainerDisabled,
        borderRadius: radius,
      );
    }
    return BoxDecoration(
      color: enabled ? t.colorBgContainer : t.colorBgContainerDisabled,
      borderRadius: radius,
      border: Border.all(color: baseColor, width: t.s(1)),
      boxShadow: _focused && enabled
          ? antFieldFocusRingOf(t, widget.status)
          : null,
    );
  }
}

/// 字段内部前/后缀槽位（标准水平内边距 + 垂直居中）
class _FieldSlot extends StatelessWidget {
  const _FieldSlot({
    required this.child,
    required this.height,
    required this.isLeading,
  });

  final Widget child;
  final double height;
  final bool isLeading;

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: isLeading ? t.marginSM : t.marginXS,
        right: isLeading ? t.marginXS : t.marginSM,
      ),
      child: child,
    );
  }
}

/// 字段呈现模式
enum AntInputFieldMode {
  /// 字段自绘边框与填充（AntInput / AntInputTextArea）
  standalone,

  /// 无边框无填充，由外层容器统一绘制（InputNumber / SearchBar / Stepper 等）
  embedded,
}
