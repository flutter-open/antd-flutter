/// AntPopover — antd React Popover 的 Flutter 实现
///
/// API 与 antd React 对齐：
/// - [child] — 触发元素
/// - [title] — 气泡标题
/// - [content] — 气泡内容
/// - [trigger] — hover / click
/// - [placement] — 九方向弹出位置
/// - [open] / [defaultOpen] / [onOpenChange] — 受控/非受控显示
/// - [color] — 自定义背景色
/// - [arrow] — 是否显示箭头
/// - [overlayStyle] — 浮层自定义样式（含 width / minWidth / maxWidth 尺寸控制）
///
/// ```dart
/// AntPopover(
///   title: const Text('标题'),
///   content: const Text('气泡内容'),
///   child: AntButton(child: Text('触发')),
/// )
/// ```
library;

import 'dart:async';

import 'package:antd_flutter_ui/src/engines/popup_engine.dart';
import 'package:antd_flutter_ui/src/engines/popup_overlay.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_popover_types.dart';

// ============================================================
// AntPopoverController — 程序化控制（R35.2）
// ============================================================

/// Controller 与 State 之间的内部绑定协议（组件内部使用，勿自行实现）。
abstract interface class AntPopoverControlDelegate {
  /// 程序化显示气泡。
  void controllerShow();

  /// 程序化隐藏气泡。
  void controllerHide();

  /// 当前是否处于打开状态。
  bool get controllerIsOpen;
}

/// [AntPopover] 的程序化控制器（R35.2 受控操作 Controller 化）。
///
/// Flutter 惯例模式（参考 [ScrollController] / EasyRefreshController）：
/// 组件挂载时自动 [attach]，卸载时自动 [detach]；使用方无需
/// GlobalKey 或自维护 bool state + setState，直接调用
/// [show] / [hide] 即可。
class AntPopoverController {
  AntPopoverControlDelegate? _delegate;

  /// 是否已绑定到挂载的 [AntPopover]。
  bool get isAttached => _delegate != null;

  /// 绑定 State（组件 initState 时自动调用，一般无需手动调用）。
  void attach(AntPopoverControlDelegate delegate) {
    _delegate = delegate;
  }

  /// 解绑 State（组件 dispose 时自动调用，一般无需手动调用）。
  void detach() {
    _delegate = null;
  }

  /// 显示气泡。未挂载时 debug 断言（ScrollController 风格），release 静默忽略。
  void show() {
    final delegate = _delegate;
    if (delegate == null) {
      assert(
        false,
        'AntPopoverController.show() 调用时未挂载 AntPopover：'
        '请确认该 controller 已通过 controller 参数传入在树上的 AntPopover',
      );
      return;
    }
    delegate.controllerShow();
  }

  /// 隐藏气泡。未挂载时 debug 断言，release 静默忽略。
  void hide() {
    final delegate = _delegate;
    if (delegate == null) {
      assert(
        false,
        'AntPopoverController.hide() 调用时未挂载 AntPopover：'
        '请确认该 controller 已通过 controller 参数传入在树上的 AntPopover',
      );
      return;
    }
    delegate.controllerHide();
  }
}

// ============================================================
// AntPopover
// ============================================================

/// 气泡卡片 — 点击/悬停元素时弹出的卡片式浮层。
///
/// 对齐 antd React Popover 组件，用于展示富文本内容，
/// 支持标题区、九方向弹出位置、受控显示、自定义背景色与箭头。
class AntPopover extends StatefulWidget {
  const AntPopover({
    super.key,
    required this.child,
    required this.content,
    this.title,
    this.trigger = AntPopoverTrigger.hover,
    this.placement = AntPopoverPlacement.bottomLeft,
    this.open,
    this.defaultOpen = false,
    this.onOpenChange,
    this.controller,
    this.color,
    this.arrow = false,
    this.overlayStyle,
    this.disabled = false,
  });

  /// 触发元素。
  final Widget child;

  /// 气泡内容。
  final Widget content;

  /// 气泡标题区。
  final Widget? title;

  /// 触发方式。
  final AntPopoverTrigger trigger;

  /// 弹出位置。
  final AntPopoverPlacement placement;

  /// 受控显示状态（非空时进入受控模式）。
  final bool? open;

  /// 非受控默认显示状态。
  final bool defaultOpen;

  /// 显示状态变化回调。
  final ValueChanged<bool>? onOpenChange;

  /// 程序化控制器（可选）。传入后可通过 [AntPopoverController.show] /
  /// [AntPopoverController.hide] 控制气泡，无需 GlobalKey 或外部 state。
  final AntPopoverController? controller;

  /// 自定义气泡背景色（文字自动反白）。
  final Color? color;

  /// 是否显示箭头。
  final bool arrow;

  /// 浮层自定义样式。
  ///
  /// 宽度默认随内容自适应；定宽/限宽经 [AntPopoverOverlayStyle.width]
  /// （固定宽度）或 [AntPopoverOverlayStyle.minWidth] /
  /// [AntPopoverOverlayStyle.maxWidth]（自适应区间）声明。
  final AntPopoverOverlayStyle? overlayStyle;

  /// 是否禁用。
  final bool disabled;

  @override
  State<AntPopover> createState() => _AntPopoverState();
}

class _AntPopoverState extends State<AntPopover>
    with PopupOpenScheduler
    implements AntPopoverControlDelegate {
  /// 平台适配：移动端 hover 降级为点击。
  /// 按当前 trigger 解析并缓存（平台恒定，避免重建期反复读取导致接线抖动）。
  AntPopoverTrigger? _resolvedTrigger;
  bool _hoverEffective = false;
  bool _tapEffective = false;

  void _resolveTrigger() {
    if (_resolvedTrigger == widget.trigger) return;
    _resolvedTrigger = widget.trigger;
    _hoverEffective =
        widget.trigger == AntPopoverTrigger.hover && AntPlatform.isDesktop;
    _tapEffective = widget.trigger == AntPopoverTrigger.click ||
        (widget.trigger == AntPopoverTrigger.hover && !AntPlatform.isDesktop);
  }

  final GlobalKey _childKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _internalOpen = false;

  /// 联合 hover 判定状态（触发元素 / 气泡 是否有指针停留）。
  bool _insideTrigger = false;
  bool _insideBubble = false;
  Timer? _hoverCloseTimer;

  bool get _currentOpen => widget.open ?? _internalOpen;

  @override
  void initState() {
    super.initState();
    widget.controller?.attach(this);
    if (widget.defaultOpen || widget.open == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showOverlay();
      });
    }
  }

  @override
  void didUpdateWidget(covariant AntPopover oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.detach();
      widget.controller?.attach(this);
    }
    if (widget.open != null && oldWidget.open != widget.open) {
      // 受控切换可能发生在父级 build 阶段，show/hide 延迟到帧末
      schedulePopupOpen(
        open: widget.open!,
        show: _showOverlay,
        hide: _hideOverlay,
      );
    }
    if (widget.disabled) {
      _hideOverlay();
    }
  }

  @override
  void dispose() {
    widget.controller?.detach();
    _hoverCloseTimer?.cancel();
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _setOpen(bool value) {
    widget.onOpenChange?.call(value);
    if (widget.open == null) {
      _internalOpen = value;
      if (value) {
        _showOverlay();
      } else {
        _hideOverlay();
      }
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null || !mounted || widget.disabled) return;
    final theme = AntTheme.of(context);
    final overlay = Overlay.of(context, rootOverlay: true);
    _overlayEntry = OverlayEntry(
      builder: (context) => _PopoverOverlay(
        childKey: _childKey,
        content: widget.content,
        title: widget.title,
        placement: widget.placement,
        arrow: widget.arrow,
        color: widget.color,
        overlayStyle: widget.overlayStyle,
        themeData: theme,
        onDismiss: () => _setOpen(false),
        onBubbleHoverEnter:
            _hoverEffective ? _handleBubbleHoverEnter : null,
        onBubbleHoverExit: _hoverEffective ? _handleBubbleHoverExit : null,
      ),
    );
    overlay.insert(_overlayEntry!);
    if (mounted) setState(() {});
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() {});
  }

  // ---- Controller 程序化控制（R35.2）----

  @override
  bool get controllerIsOpen => _currentOpen;

  @override
  void controllerShow() {
    if (!mounted) return;
    // setState 调度一帧，保证帧末回调一定会执行（controller 可能在无帧待渲染时被调用）
    setState(() {
      _internalOpen = true;
    });
    widget.onOpenChange?.call(true);
    // 受控切换可能发生在父级 build 阶段，show 延迟到帧末
    schedulePopupOpen(open: true, show: _showOverlay, hide: _hideOverlay);
  }

  @override
  void controllerHide() {
    if (!mounted) return;
    setState(() {
      _internalOpen = false;
    });
    widget.onOpenChange?.call(false);
    schedulePopupOpen(open: false, show: _showOverlay, hide: _hideOverlay);
  }

  void _handleTap() {
    if (widget.disabled) return;
    _setOpen(!_currentOpen);
  }

  void _handleHoverEnter() {
    if (widget.disabled) return;
    _insideTrigger = true;
    _cancelHoverCloseTimer();
    if (!_currentOpen) _setOpen(true);
  }

  void _handleHoverExit() {
    if (widget.disabled) return;
    _insideTrigger = false;
    _scheduleHoverClose();
  }

  /// 联合 hover 判定——鼠标进入气泡：保持打开（不误关）。
  void _handleBubbleHoverEnter() {
    _insideBubble = true;
    _cancelHoverCloseTimer();
  }

  /// 联合 hover 判定——鼠标离开气泡：与触发元素退出共同决定关闭。
  void _handleBubbleHoverExit() {
    _insideBubble = false;
    _scheduleHoverClose();
  }

  /// 触发元素与气泡都已离开才启动关闭（短缓冲容忍区域间跳转的
  /// exit/enter 乱序，气泡内按钮等交互不受影响）。
  void _scheduleHoverClose() {
    if (_insideTrigger || _insideBubble) return;
    if (!_currentOpen) return;
    _hoverCloseTimer?.cancel();
    _hoverCloseTimer = Timer(const Duration(milliseconds: 100), () {
      _hoverCloseTimer = null;
      if (mounted && _currentOpen && !_insideTrigger && !_insideBubble) {
        _setOpen(false);
      }
    });
  }

  void _cancelHoverCloseTimer() {
    _hoverCloseTimer?.cancel();
    _hoverCloseTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    _resolveTrigger();
    return AntPopupTriggerRegion(
      onTap: _handleTap,
      tapEnabled: _tapEffective,
      hoverEnabled: _hoverEffective,
      onHoverEnter: _handleHoverEnter,
      onHoverExit: _handleHoverExit,
      child: KeyedSubtree(
        key: _childKey,
        child: widget.child,
      ),
    );
  }
}

// ============================================================
// _PopoverOverlay — 气泡浮层（基于统一弹层底座 AntPopupOverlay）
// ============================================================

/// 气泡箭头标记 key，便于测试定位箭头。
const Key kAntPopoverArrowKey = ValueKey<String>('AntPopoverArrow');

/// 气泡容器标记 key，便于测试定位气泡。
const Key kAntPopoverBubbleKey = ValueKey<String>('AntPopoverBubble');

class _PopoverOverlay extends StatelessWidget {
  const _PopoverOverlay({
    required this.childKey,
    required this.content,
    required this.title,
    required this.placement,
    required this.arrow,
    required this.color,
    required this.overlayStyle,
    required this.themeData,
    required this.onDismiss,
    this.onBubbleHoverEnter,
    this.onBubbleHoverExit,
  });

  final GlobalKey childKey;
  final Widget content;
  final Widget? title;
  final AntPopoverPlacement placement;
  final bool arrow;
  final Color? color;
  final AntPopoverOverlayStyle? overlayStyle;
  final AntThemeData themeData;
  final VoidCallback onDismiss;
  final VoidCallback? onBubbleHoverEnter;
  final VoidCallback? onBubbleHoverExit;

  @override
  Widget build(BuildContext context) {
    final overlayStyle = this.overlayStyle;
    final customColor = overlayStyle?.backgroundColor ?? color;
    final bubbleColor = customColor ?? themeData.colorBgContainer;

    return AntPopupOverlay(
      targetKey: childKey,
      placement: _mapPlacement(placement),
      arrow: arrow,
      arrowColor: bubbleColor,
      arrowKey: arrow ? kAntPopoverArrowKey : null,
      gap: themeData.s(8),
      onDismiss: onDismiss,
      onBubbleHoverEnter: onBubbleHoverEnter,
      onBubbleHoverExit: onBubbleHoverExit,
      child: _buildBubble(context, bubbleColor),
    );
  }

  Widget _buildBubble(BuildContext context, Color bubbleColor) {
    final theme = themeData;
    final overlayStyle = this.overlayStyle;
    final customColor = overlayStyle?.backgroundColor ?? color;
    // 自定义背景色时文字反白
    final fgColor = customColor != null ? Colors.white : theme.colorText;
    final fgSecondary = customColor != null
        ? Colors.white.withValues(alpha: 0.75)
        : theme.colorTextSecondary;
    final radius = overlayStyle?.borderRadius ??
        BorderRadius.circular(theme.borderRadiusLG);
    final padding = overlayStyle?.padding ??
        EdgeInsets.symmetric(horizontal: theme.s(16), vertical: theme.s(12));

    final children = <Widget>[];
    if (title != null) {
      children.add(
        Padding(
          padding: EdgeInsets.only(bottom: theme.s(4)),
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: theme.s(16),
              fontWeight: FontWeight.w500,
              color: fgColor,
            ),
            child: title!,
          ),
        ),
      );
    }
    children.add(
      DefaultTextStyle(
        style: TextStyle(fontSize: theme.s(14), color: fgSecondary),
        child: content,
      ),
    );

    final bubbleDecoration = BoxDecoration(
      color: bubbleColor,
      borderRadius: radius,
      border: overlayStyle?.border,
      boxShadow: overlayStyle?.boxShadow ??
          [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: theme.s(12),
              offset: const Offset(0, 4),
            ),
          ],
    );

    // 宽度策略（对齐 antd web）：默认随内容自适应，不锁死固定宽度；
    // 需要定宽/限宽时经 overlayStyle.width / minWidth / maxWidth 声明。
    final styleWidth = overlayStyle?.width;
    final styleMinWidth = overlayStyle?.minWidth;
    final styleMaxWidth = overlayStyle?.maxWidth;
    final widthConstraints = styleWidth != null
        ? BoxConstraints.tightFor(width: theme.s(styleWidth))
        : BoxConstraints(
            minWidth: theme.s(styleMinWidth ?? 0),
            // 默认上限：视口宽度 − 2×margin，长文本自动换行而不溢出屏幕
            maxWidth: theme.s(
              styleMaxWidth ??
                  (MediaQuery.sizeOf(context).width -
                      PopupEngine.defaultMargin * 2),
            ),
          );

    return KeyedSubtree(
      key: kAntPopoverBubbleKey,
      child: ConstrainedBox(
        constraints: widthConstraints,
        child: Container(
          padding: padding,
          decoration: bubbleDecoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}

/// AntPopoverPlacement（topCenter/leftCenter 等九变体）→ 引擎统一 12 方向。
AntPopupPlacement _mapPlacement(AntPopoverPlacement placement) =>
    switch (placement) {
      AntPopoverPlacement.topLeft => AntPopupPlacement.topLeft,
      AntPopoverPlacement.topCenter => AntPopupPlacement.top,
      AntPopoverPlacement.topRight => AntPopupPlacement.topRight,
      AntPopoverPlacement.bottomLeft => AntPopupPlacement.bottomLeft,
      AntPopoverPlacement.bottomCenter => AntPopupPlacement.bottom,
      AntPopoverPlacement.bottomRight => AntPopupPlacement.bottomRight,
      AntPopoverPlacement.leftTop => AntPopupPlacement.leftTop,
      AntPopoverPlacement.leftCenter => AntPopupPlacement.left,
      AntPopoverPlacement.leftBottom => AntPopupPlacement.leftBottom,
      AntPopoverPlacement.rightTop => AntPopupPlacement.rightTop,
      AntPopoverPlacement.rightCenter => AntPopupPlacement.right,
      AntPopoverPlacement.rightBottom => AntPopupPlacement.rightBottom,
    };
