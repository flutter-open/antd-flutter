/// AntPopover 类型定义 — antd React Popover 的 Flutter 实现
library;

import 'package:flutter/widgets.dart';

// ============================================================
// AntPopoverTrigger — 触发方式
// ============================================================

/// 气泡卡片触发方式。
///
/// 对齐 antd React Popover 的 trigger：hover（桌面）/ click（移动端）。
enum AntPopoverTrigger {
  /// 悬停触发（桌面端常用，移动端也可点击触发）。
  hover,

  /// 点击触发。
  click,
}

// ============================================================
// AntPopoverPlacement — 弹出位置
// ============================================================

/// 气泡卡片弹出位置（九方向，同 antd v6 Popover placement）。
///
/// - 上：[topLeft] / [topCenter] / [topRight]
/// - 下：[bottomLeft] / [bottomCenter] / [bottomRight]
/// - 左：[leftTop] / [leftCenter] / [leftBottom]
/// - 右：[rightTop] / [rightCenter] / [rightBottom]
enum AntPopoverPlacement {
  /// 上方，左对齐。
  topLeft,

  /// 上方，水平居中。
  topCenter,

  /// 上方，右对齐。
  topRight,

  /// 下方，左对齐（默认）。
  bottomLeft,

  /// 下方，水平居中。
  bottomCenter,

  /// 下方，右对齐。
  bottomRight,

  /// 左侧，顶部对齐。
  leftTop,

  /// 左侧，垂直居中。
  leftCenter,

  /// 左侧，底部对齐。
  leftBottom,

  /// 右侧，顶部对齐。
  rightTop,

  /// 右侧，垂直居中。
  rightCenter,

  /// 右侧，底部对齐。
  rightBottom,
}

// ============================================================
// AntPopoverOverlayStyle — 浮层样式
// ============================================================

/// 气泡浮层自定义样式。
///
/// 对齐 antd React Popover 的 styles.overlay，可覆盖默认的
/// 背景色、边框、圆角与阴影。
class AntPopoverOverlayStyle {
  const AntPopoverOverlayStyle({
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.padding,
    this.width,
    this.minWidth,
    this.maxWidth,
  });

  /// 浮层背景色（优先于 [AntPopover.color] 生效）。
  final Color? backgroundColor;

  /// 浮层圆角。
  final BorderRadius? borderRadius;

  /// 浮层边框。
  final Border? border;

  /// 浮层阴影。
  final List<BoxShadow>? boxShadow;

  /// 浮层内边距。
  final EdgeInsetsGeometry? padding;

  /// 浮层固定宽度（逻辑像素，按主题缩放）。
  ///
  /// 为空时宽度随内容自适应（受 [minWidth] / [maxWidth] 约束）。
  final double? width;

  /// 浮层最小宽度（逻辑像素，按主题缩放）。仅在 [width] 为空时生效。
  final double? minWidth;

  /// 浮层最大宽度（逻辑像素，按主题缩放）。仅在 [width] 为空时生效；
  /// 默认取「视口宽度 − 16」，保证长内容自动换行而不溢出屏幕。
  final double? maxWidth;
}
