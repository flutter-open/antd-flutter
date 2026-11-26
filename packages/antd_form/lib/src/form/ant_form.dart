/// AntForm — antd React Form 的 Flutter 实现
///
/// API 与 antd React Form 对齐：
/// - [controller] — 表单控制器，用于编程式读写值、校验、提交、重置
/// - [initialValues] — 表单初始值
/// - [onFinish] — 校验通过后的提交回调
/// - [onFinishFailed] — 校验失败的回调
/// - [layout] — 表单布局（horizontal/vertical/inline）
/// - [disabled] — 禁用全部表单项
///
/// ```dart
/// AntForm(
///   controller: controller,
///   onFinish: (values) => print(values),
///   children: [
///     AntFormItem<String>(
///       name: 'username',
///       label: '用户名',
///       rules: [AntFormFieldRule.required(message: '请输入用户名')],
///       builder: (field) => AntInput(
///         value: field.value ?? '',
///         onChanged: field.didChange,
///       ),
///     ),
///   ],
/// )
/// ```
library;

import 'package:antd_form/src/form/ant_form_types.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

// ============================================================
// AntFormController
// ============================================================

/// 表单控制器，管理字段值、错误与校验。
///
/// 通过 [AntForm.controller] 传入表单后，可用它编程式读写字段值、
/// 触发校验、提交或重置表单。
class AntFormController extends ChangeNotifier {
  final Map<String, dynamic> _values = {};
  final Map<String, String?> _errors = {};
  final Map<String, List<AntFormFieldRule>> _rules = {};
  Map<String, dynamic> _initialValues = {};
  VoidCallback? _submitHandler;

  /// 提交表单（触发校验，通过回调 onFinish，失败回调 onFinishFailed）
  void submit() => _submitHandler?.call();

  /// 设置初始值（由 AntForm.initState 调用）
  void _setInitialValues(Map<String, dynamic> values) {
    _initialValues = Map<String, dynamic>.from(values);
  }

  /// 注册字段（由 AntFormItem.didChangeDependencies 调用）
  void _registerField(
      String name, List<AntFormFieldRule> rules, dynamic initialValue) {
    _rules[name] = rules;
    if (!_values.containsKey(name)) {
      _values[name] = initialValue ?? _initialValues[name];
    }
  }

  /// 注销字段
  void _unregisterField(String name) {
    _rules.remove(name);
  }

  /// 获取字段值
  dynamic getValue(String name) => _values[name];

  /// 获取字段错误文案
  String? getError(String name) => _errors[name];

  /// 设置字段值
  ///
  /// [validate] 为 true 时同步触发该字段校验。
  void setValue(String name, dynamic value, {bool validate = false}) {
    _values[name] = value;
    if (validate) {
      _validateField(name);
    }
    notifyListeners();
  }

  /// 获取全部字段值（副本）
  Map<String, dynamic> getValues() => Map<String, dynamic>.from(_values);

  /// 获取全部错误（仅含未通过的字段）
  Map<String, String> getErrors() {
    final result = <String, String>{};
    _errors.forEach((name, error) {
      if (error != null) result[name] = error;
    });
    return result;
  }

  /// 校验全部字段，返回是否全部通过。
  ///
  /// 校验结果同时写入 [getError]，可通过 [getErrors] 获取。
  Future<bool> validate() async {
    var hasError = false;
    for (final name in _rules.keys) {
      final error = _validateFieldValue(name, _values[name]);
      _errors[name] = error;
      if (error != null) hasError = true;
    }
    notifyListeners();
    return !hasError;
  }

  /// 校验单个字段
  String? _validateField(String name) {
    final error = _validateFieldValue(name, _values[name]);
    _errors[name] = error;
    return error;
  }

  String? _validateFieldValue(String name, dynamic value) {
    for (final rule in _rules[name] ?? const <AntFormFieldRule>[]) {
      final error = rule.validate(value);
      if (error != null) return error;
    }
    return null;
  }

  /// 清除全部错误
  void clearErrors() {
    _errors.clear();
    notifyListeners();
  }

  /// 重置表单（恢复初始值并清除错误）
  void reset() {
    _values
      ..clear()
      ..addAll(_initialValues);
    _errors.clear();
    notifyListeners();
  }

  /// 是否存在校验错误
  bool get hasErrors => _errors.values.any((e) => e != null);
}

// ============================================================
// _FormScope (InheritedWidget)
// ============================================================

class _FormScope extends InheritedWidget {
  const _FormScope({
    required this.controller,
    required this.layout,
    required this.labelWidth,
    required this.disabled,
    required this.submit,
    this.itemMarginBottom,
    this.hintColor,
    this.labelColor,
    required super.child,
  });

  final AntFormController controller;
  final AntFormLayout layout;
  final double? labelWidth;
  final bool disabled;
  final VoidCallback submit;

  /// 表单项底部间距（null 表示跟随主题令牌）
  final double? itemMarginBottom;

  /// 帮助 / 额外说明文案颜色（null 表示取 [AntThemeData.colorTextDescription]）
  final Color? hintColor;

  /// 标签文案颜色（null 表示取 [AntThemeData.colorText]）
  final Color? labelColor;

  static _FormScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_FormScope>();
  }

  @override
  bool updateShouldNotify(_FormScope oldWidget) {
    return controller != oldWidget.controller ||
        layout != oldWidget.layout ||
        labelWidth != oldWidget.labelWidth ||
        disabled != oldWidget.disabled ||
        itemMarginBottom != oldWidget.itemMarginBottom ||
        hintColor != oldWidget.hintColor ||
        labelColor != oldWidget.labelColor;
  }
}

// ============================================================
// AntForm
// ============================================================

/// 表单容器组件。
///
/// 通过 [AntFormItem] 组合表单字段，通过 [controller] 管理表单数据。
class AntForm extends StatefulWidget {
  const AntForm({
    super.key,
    this.controller,
    this.initialValues,
    this.onFinish,
    this.onFinishFailed,
    this.layout = AntFormLayout.vertical,
    this.labelWidth,
    this.disabled = false,
    this.itemMarginBottom,
    this.hintColor,
    this.labelColor,
    required this.children,
  });

  /// 表单控制器（传入后可通过它编程式操作表单）
  final AntFormController? controller;

  /// 表单初始值
  final Map<String, dynamic>? initialValues;

  /// 校验通过后的提交回调
  final ValueChanged<Map<String, dynamic>>? onFinish;

  /// 校验失败的回调
  final ValueChanged<Map<String, String>>? onFinishFailed;

  /// 表单布局
  final AntFormLayout layout;

  /// 水平布局下标签宽度
  final double? labelWidth;

  /// 是否禁用全部表单项
  final bool disabled;

  /// 表单项底部间距（纵向布局默认 16，水平布局默认 24）。
  ///
  /// 未显式指定时，带 [AntFormItem.help] / [AntFormItem.extra] 或校验错误的
  /// 表单项会自动去掉底部间距（与 antd web `.ant-form-item-with-help` 一致），
  /// 避免帮助文案下方再多出一段空白。
  final double? itemMarginBottom;

  /// 帮助 / 额外说明文案颜色。
  ///
  /// 未指定时取主题的 [AntThemeData.colorTextDescription]。
  final Color? hintColor;

  /// 标签文案颜色。
  ///
  /// 未指定时取主题的 [AntThemeData.colorText]。
  final Color? labelColor;

  /// 表单子项
  final List<Widget> children;

  @override
  State<AntForm> createState() => _AntFormState();

  /// 获取给定 [context] 最近的上层 AntFormController
  static AntFormController? controllerOf(BuildContext context) {
    return _FormScope.of(context)?.controller;
  }
}

class _AntFormState extends State<AntForm> {
  AntFormController? _internalController;

  AntFormController get _controller =>
      widget.controller ?? (_internalController ??= AntFormController());

  @override
  void initState() {
    super.initState();
    _controller._submitHandler = _submit;
    if (widget.initialValues != null) {
      _controller._setInitialValues(widget.initialValues!);
    }
  }

  @override
  void didUpdateWidget(AntForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValues != oldWidget.initialValues &&
        widget.initialValues != null) {
      _controller._setInitialValues(widget.initialValues!);
    }
  }

  Future<void> _submit() async {
    final valid = await _controller.validate();
    if (!mounted) return;
    if (valid) {
      widget.onFinish?.call(_controller.getValues());
    } else {
      widget.onFinishFailed?.call(_controller.getErrors());
    }
  }

  @override
  Widget build(BuildContext context) {
    return _FormScope(
      controller: _controller,
      layout: widget.layout,
      labelWidth: widget.labelWidth,
      disabled: widget.disabled,
      submit: _submit,
      itemMarginBottom: widget.itemMarginBottom,
      hintColor: widget.hintColor,
      labelColor: widget.labelColor,
      child: widget.layout == AntFormLayout.inline
          ? Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: widget.children,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.children,
            ),
    );
  }
}

// ============================================================
// AntFormField — 传递给 builder 的字段状态
// ============================================================

/// 表单字段状态，通过 [AntFormItem.builder] 传递给表单控件。
class AntFormField<T> {
  const AntFormField({
    required this.value,
    this.errorText,
    required this.didChange,
  });

  /// 当前字段值
  final T? value;

  /// 当前校验错误文案（无错误时为 null）
  final String? errorText;

  /// 更新字段值（触发校验取决于 validateTrigger）
  final ValueChanged<T> didChange;
}

// ============================================================
// AntFormItem
// ============================================================

/// 表单字段组件，包裹单个表单控件并提供标签、校验与错误提示。
///
/// 通过 [builder] 获取字段状态（值/错误），将表单控件与表单数据绑定：
///
/// ```dart
/// AntFormItem<String>(
///   name: 'username',
///   label: '用户名',
///   rules: [AntFormFieldRule.required(message: '请输入用户名')],
///   builder: (field) => AntInput(
///     value: field.value ?? '',
///     onChanged: field.didChange,
///   ),
/// )
/// ```
class AntFormItem<T> extends StatefulWidget {
  const AntFormItem({
    super.key,
    this.name,
    this.label,
    this.rules,
    this.required,
    this.help,
    this.extra,
    this.initialValue,
    this.validateTrigger = AntFormValidateTrigger.onChange,
    this.marginBottom,
    this.hintColor,
    this.labelColor,
    required this.builder,
  });

  /// 字段名（注册到表单控制器的键）
  final String? name;

  /// 标签文案
  final String? label;

  /// 校验规则列表
  final List<AntFormFieldRule>? rules;

  /// 是否必填（为 true 时自动添加必填规则并显示星号）
  final bool? required;

  /// 帮助文案（始终显示在控件下方）
  final String? help;

  /// 额外信息（显示在错误/帮助文案下方）
  final String? extra;

  /// 字段初始值
  final T? initialValue;

  /// 校验触发时机
  final AntFormValidateTrigger validateTrigger;

  /// 该表单项的底部间距，优先于 [AntForm.itemMarginBottom]。
  final double? marginBottom;

  /// 该表单项帮助 / 额外说明文案颜色，优先于 [AntForm.hintColor]。
  final Color? hintColor;

  /// 该表单项标签文案颜色，优先于 [AntForm.labelColor]。
  final Color? labelColor;

  /// 表单控件构建器
  final Widget Function(AntFormField<T> field) builder;

  @override
  State<AntFormItem<T>> createState() => _AntFormItemState<T>();
}

class _AntFormItemState<T> extends State<AntFormItem<T>> {
  AntFormController? _controller;
  _FormScope? _scope;
  T? _localValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scope = _FormScope.of(context);
    if (scope != _scope) {
      _scope = scope;
      _controller = scope?.controller;
    }
    if (widget.name != null && _controller != null) {
      _controller!._registerField(
        widget.name!,
        _effectiveRules(),
        widget.initialValue,
      );
    }
  }

  @override
  void dispose() {
    if (widget.name != null && _controller != null) {
      _controller!._unregisterField(widget.name!);
    }
    super.dispose();
  }

  List<AntFormFieldRule> _effectiveRules() {
    final rules = <AntFormFieldRule>[...?widget.rules];
    if (widget.required == true && !rules.any((r) => r.required)) {
      rules.insert(
        0,
        AntFormFieldRule.required(message: '请输入${widget.label ?? '该项'}'),
      );
    }
    return rules;
  }

  bool get _isRequired {
    if (widget.required == true) return true;
    return (widget.rules ?? const <AntFormFieldRule>[]).any((r) => r.required);
  }

  T? get _currentValue {
    if (widget.name != null && _controller != null) {
      return _controller!.getValue(widget.name!) as T? ?? widget.initialValue;
    }
    return _localValue ?? widget.initialValue;
  }

  String? get _currentError {
    if (widget.name != null && _controller != null) {
      return _controller!.getError(widget.name!);
    }
    return null;
  }

  void _didChange(T value) {
    // 相等性检查：值未变化时跳过，避免 build 期间通知循环
    if (value == _currentValue) return;
    setState(() => _localValue = value);
    if (widget.name != null && _controller != null) {
      _controller!.setValue(
        widget.name!,
        value,
        validate: widget.validateTrigger == AntFormValidateTrigger.onChange,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final scope = _scope;
    final layout = scope?.layout ?? AntFormLayout.vertical;

    return ListenableBuilder(
      listenable: _controller ?? const _NoListen(),
      builder: (context, _) {
        final field = AntFormField<T>(
          value: _currentValue,
          errorText: _currentError,
          didChange: _didChange,
        );
        final control = widget.builder(field);
        return _buildLayout(
          t: t,
          layout: layout,
          control: control,
          errorText: _currentError,
        );
      },
    );
  }

  Widget _buildLayout({
    required AntThemeData t,
    required AntFormLayout layout,
    required Widget control,
    required String? errorText,
  }) {
    final scope = _scope;
    final labelColor = widget.labelColor ?? scope?.labelColor ?? t.colorText;
    final hintColor =
        widget.hintColor ?? scope?.hintColor ?? t.colorTextDescription;
    final labelWidget = _buildLabel(t, labelColor);

    // 帮助 / 额外说明 / 校验错误
    final explain = <Widget>[
      if (errorText != null) _buildError(t, errorText),
      if (widget.help != null) _buildHint(t, widget.help!, hintColor),
      if (widget.extra != null) _buildHint(t, widget.extra!, hintColor),
    ];
    final hasExplain = explain.isNotEmpty;

    // 底部间距：优先用显式配置（item > form），否则有说明文案时归零，
    // 否则取主题的 margin 令牌。antd web 的 `.ant-form-item-with-help`
    // 同样是「说明文案占据间距」，避免文案下方再多出一段空白。
    final double bottomMargin;
    if (widget.marginBottom != null) {
      bottomMargin = widget.marginBottom!;
    } else if (scope?.itemMarginBottom != null) {
      bottomMargin = scope!.itemMarginBottom!;
    } else {
      bottomMargin = hasExplain ? 0 : t.margin;
    }

    if (layout == AntFormLayout.horizontal && labelWidget != null) {
      final resolvedLabelWidth = scope?.labelWidth;
      return Padding(
        padding: EdgeInsets.only(bottom: bottomMargin),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: resolvedLabelWidth ?? t.s(100),
              child: labelWidget,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [control, ...explain],
              ),
            ),
          ],
        ),
      );
    }

    if (layout == AntFormLayout.inline) {
      final bool disabled = scope?.disabled ?? false;
      return Padding(
        padding: EdgeInsets.only(right: t.margin, bottom: t.marginXS),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (labelWidget != null) ...[
              labelWidget,
              SizedBox(width: t.marginXS),
            ],
            Opacity(opacity: disabled ? 0.5 : 1, child: control),
          ],
        ),
      );
    }

    // vertical（默认）
    return Padding(
      padding: EdgeInsets.only(bottom: bottomMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (labelWidget != null) ...[
            labelWidget,
            SizedBox(height: t.marginXS),
          ],
          control,
          ...explain,
        ],
      ),
    );
  }

  /// 帮助 / 额外说明文案（颜色取 hintColor，默认 colorTextDescription）
  Widget _buildHint(AntThemeData t, String text, Color color) {
    return Padding(
      padding: EdgeInsets.only(top: t.s(4)),
      child: Text(
        text,
        style: TextStyle(fontSize: t.fontSizeSM, color: color),
      ),
    );
  }

  Widget? _buildLabel(AntThemeData t, Color labelColor) {
    if (widget.label == null) return null;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: t.s(2)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isRequired)
            Padding(
              padding: EdgeInsets.only(right: t.s(4)),
              child: Text(
                '*',
                style: TextStyle(
                  fontSize: t.fontSize,
                  color: t.colorError,
                ),
              ),
            ),
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: t.fontSize,
              color: labelColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(AntThemeData t, String errorText) {
    return Padding(
      padding: EdgeInsets.only(top: t.s(4)),
      child: Text(
        errorText,
        style: TextStyle(
          fontSize: t.fontSizeSM,
          color: t.colorError,
        ),
      ),
    );
  }
}

/// 空监听器（无控制器时使用）
class _NoListen implements Listenable {
  const _NoListen();

  @override
  void addListener(VoidCallback listener) {}

  @override
  void removeListener(VoidCallback listener) {}
}
