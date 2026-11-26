/// popup_engine — 统一弹层位置计算引擎（纯计算层，可单测）
///
/// 算法吸收自开源项目 [minikin/popover](https://github.com/minikin/popover)
/// （v0.5.1，MIT License，Copyright (c) 2019 Sergey Mitrovic）：
/// - 方向决策 + 边界翻转：首选方向放不下翻到对侧，对侧也放不下再试垂直两侧，
///   四个方向都放不下取空间更大的一侧
/// - 滑动夹回：气泡沿目标边对齐后，clamp 到视口内（遵守 safe area 边距）
/// - 箭头 tip clamp：箭头锚点跟随触发元素中心，但夹回气泡内防撞圆角
///
/// 不吸收其 route/Navigator 弹出方式与 iOS 原生视觉（见 P15 任务文档调研结论）。
library;

import 'dart:ui' show Offset, Rect, Size;

// ============================================================
// AntPopupPlacement — 统一 12 方向
// ============================================================

/// 统一弹层弹出位置（12 方向，对齐 antd placement）。
enum AntPopupPlacement {
  /// 上方，左对齐。
  topLeft,

  /// 上方，水平居中。
  top,

  /// 上方，右对齐。
  topRight,

  /// 下方，左对齐。
  bottomLeft,

  /// 下方，水平居中。
  bottom,

  /// 下方，右对齐。
  bottomRight,

  /// 左侧，顶部对齐。
  leftTop,

  /// 左侧，垂直居中。
  left,

  /// 左侧，底部对齐。
  leftBottom,

  /// 右侧，顶部对齐。
  rightTop,

  /// 右侧，垂直居中。
  right,

  /// 右侧，底部对齐。
  rightBottom,
}

/// 弹层主方向（翻转决策的结果方向）。
enum AntPopupDirection {
  /// 气泡在触发元素上方。
  top,

  /// 气泡在触发元素下方。
  bottom,

  /// 气泡在触发元素左侧。
  left,

  /// 气泡在触发元素右侧。
  right,
}

/// 弹层沿目标边缘的对齐：起始 / 居中 / 末尾。
enum AntPopupAlign {
  /// 起始对齐（垂直方向即左对齐，水平方向即顶对齐）。
  start,

  /// 居中对齐。
  center,

  /// 末尾对齐。
  end,
}

/// 弹层位置解析结果。
class AntPopupLayout {
  const AntPopupLayout({
    required this.direction,
    required this.align,
    required this.offset,
    required this.arrowOffset,
  });

  /// 翻转决策后的最终方向。
  final AntPopupDirection direction;

  /// 沿目标边缘的对齐。
  final AntPopupAlign align;

  /// 气泡左上角相对视口（Overlay 全屏坐标系）的位置。
  final Offset offset;

  /// 箭头 tip 在气泡边缘上的位置：
  /// 垂直方向为距气泡左缘的距离，水平方向为距气泡上缘的距离。
  /// 无箭头场景仍会给出（跟随触发元素中心），由调用方决定是否渲染。
  final double arrowOffset;

  /// 方向是否垂直（top/bottom）。
  bool get isVertical => direction == AntPopupDirection.top || direction == AntPopupDirection.bottom;

  /// 气泡出现动画的对齐锚点向量（朝向触发元素一侧；Alignment 语义的 dx/dy）。
  Offset get scaleAlignment => switch (direction) {
        AntPopupDirection.top => const Offset(0, 1),
        AntPopupDirection.bottom => const Offset(0, -1),
        AntPopupDirection.left => const Offset(1, 0),
        AntPopupDirection.right => const Offset(-1, 0),
      };
}

// ============================================================
// 引擎入口
// ============================================================

/// 统一弹层位置计算引擎。
///
/// 算法来源：minikin/popover（MIT）的 PopoverRenderShiftedBox 方向决策 /
/// 边界翻转 / 滑动夹回逻辑的 Dart 移植与简化。
abstract final class PopupEngine {
  /// 视口内边距默认值（气泡与视口边缘的最小距离）。
  static const double defaultMargin = 8;

  /// 解析弹层位置。
  ///
  /// - [targetRect]：触发元素的全局矩形
  /// - [bubbleSize]：气泡尺寸
  /// - [viewport]：可视区域（通常为 Overlay 全屏矩形）
  /// - [placement]：首选弹出位置
  /// - [gap]：气泡与触发元素的间距
  /// - [arrowSize]：箭头突出气泡边缘的长度（计入主轴占位）
  /// - [margin]：气泡与视口边缘的最小边距（safe area 语义）
  static AntPopupLayout solve({
    required Rect targetRect,
    required Size bubbleSize,
    required Rect viewport,
    AntPopupPlacement placement = AntPopupPlacement.bottom,
    double gap = 8,
    double arrowSize = 0,
    double margin = defaultMargin,
  }) {
    // 各方向可用空间（视口边到触发元素对应边）
    final spaceTop = targetRect.top - viewport.top - margin;
    final spaceBottom = viewport.bottom - margin - targetRect.bottom;
    final spaceLeft = targetRect.left - viewport.left - margin;
    final spaceRight = viewport.right - margin - targetRect.right;

    // 主轴方向需要的空间 = 间距 + 箭头 + 气泡主轴尺寸
    final verticalNeed = gap + arrowSize + bubbleSize.height;
    final horizontalNeed = gap + arrowSize + bubbleSize.width;

    final (preferred, align) = _decompose(placement);
    final fitsTop = spaceTop >= verticalNeed;
    final fitsBottom = spaceBottom >= verticalNeed;
    final fitsLeft = spaceLeft >= horizontalNeed;
    final fitsRight = spaceRight >= horizontalNeed;

    // 1. 首选方向放不下翻到对侧（popover 翻转决策）
    // 2. 垂直两侧都放不下再试水平两侧；反之亦然
    // 3. 都放不下取空间更大的一侧
    AntPopupDirection direction;
    final preferredVertical = preferred == AntPopupDirection.top || preferred == AntPopupDirection.bottom;
    final firstFits = preferredVertical ? (preferred == AntPopupDirection.top ? fitsTop : fitsBottom) : (preferred == AntPopupDirection.left ? fitsLeft : fitsRight);
    final opposite = _flip(preferred);
    // 对侧与首选方向同轴：bottom 的对侧是 top（仍是垂直），left 的对侧是 right。
    // 曾误写成「!preferredVertical」，导致垂直首选时用水平空间判定对侧能否放下，
    // 长面板（如 RangePicker）在下方放不下时会被误翻到上方并溢出屏幕顶部被裁切。
    final oppositeVertical = preferredVertical;
    final oppositeFits = oppositeVertical ? (opposite == AntPopupDirection.top ? fitsTop : fitsBottom) : (opposite == AntPopupDirection.left ? fitsLeft : fitsRight);

    if (firstFits) {
      direction = preferred;
    } else if (oppositeFits) {
      direction = opposite;
      // 对侧翻转时沿边对齐保持（popover 行为：对齐不变，仅主轴翻转）
    } else if (preferredVertical) {
      // 垂直两侧都放不下：试水平两侧（对齐语义按新轴解释）
      if (fitsLeft) {
        direction = AntPopupDirection.left;
      } else if (fitsRight) {
        direction = AntPopupDirection.right;
      } else {
        direction = spaceTop >= spaceBottom ? AntPopupDirection.top : AntPopupDirection.bottom;
      }
    } else {
      if (fitsTop) {
        direction = AntPopupDirection.top;
      } else if (fitsBottom) {
        direction = AntPopupDirection.bottom;
      } else {
        direction = spaceLeft >= spaceRight ? AntPopupDirection.left : AntPopupDirection.right;
      }
    }

    // ---- 沿边定位 + 滑动夹回 ----
    final directionVertical = direction == AntPopupDirection.top || direction == AntPopupDirection.bottom;
    final bubbleMain = directionVertical ? bubbleSize.height : bubbleSize.width;
    final bubbleCross = directionVertical ? bubbleSize.width : bubbleSize.height;

    double offsetMain;
    switch (direction) {
      case AntPopupDirection.top:
        offsetMain = targetRect.top - gap - arrowSize - bubbleMain;
      case AntPopupDirection.bottom:
        offsetMain = targetRect.bottom + gap + arrowSize;
      case AntPopupDirection.left:
        offsetMain = targetRect.left - gap - arrowSize - bubbleMain;
      case AntPopupDirection.right:
        offsetMain = targetRect.right + gap + arrowSize;
    }

    // 主轴夹回：气泡比视口小时保证整块面板留在屏幕内。
    // 垂直/水平两侧都放不下（长面板 + 矮视口，如 RangePicker 带时间轮）时，
    // 上面算出的 offsetMain 会越界，面板被屏幕边缘裁掉；此时允许与触发元素重叠，
    // 把气泡沿主轴推回视口内，用户仍能看到并操作完整面板。
    final mainViewportStart = directionVertical ? viewport.top : viewport.left;
    final mainViewportSize = directionVertical ? viewport.height : viewport.width;
    if (bubbleMain <= mainViewportSize - margin * 2) {
      final minMain = mainViewportStart + margin;
      final maxMain = mainViewportStart + mainViewportSize - margin - bubbleMain;
      offsetMain = offsetMain.clamp(minMain, maxMain);
    }

    // 沿边锚点（触发元素上的锚点位置）
    final targetMainStart = directionVertical ? targetRect.left : targetRect.top;
    final targetCrossSize = directionVertical ? targetRect.width : targetRect.height;
    final anchorCenter = targetMainStart + switch (align) {
        AntPopupAlign.start => bubbleCross / 2,
        AntPopupAlign.center => targetCrossSize / 2,
        AntPopupAlign.end => targetCrossSize - bubbleCross / 2,
      };

    // 滑动夹回：气泡完全落在视口内（含 margin）
    final viewMainSize = directionVertical ? viewport.width : viewport.height;
    final crossStart = directionVertical ? viewport.left : viewport.top;
    final minCross = crossStart + margin;
    final maxCross = crossStart + viewMainSize - margin - bubbleCross;
    var bubbleCrossStart = anchorCenter - bubbleCross / 2;
    if (maxCross >= minCross) {
      bubbleCrossStart = bubbleCrossStart.clamp(minCross, maxCross);
    }

    // 箭头 tip：跟随触发元素中心，clamp 到气泡内防撞圆角
    const tipInset = PopupEngine.defaultMargin;
    final tipMin = tipInset + arrowSize;
    final tipMax = bubbleCross - tipInset - arrowSize;
    final targetCrossCenter = targetMainStart + targetCrossSize / 2;
    final rawTip = targetCrossCenter - bubbleCrossStart;
    final arrowOffset = tipMax >= tipMin ? rawTip.clamp(tipMin, tipMax) : bubbleCross / 2;

    final topLeft = directionVertical
        ? Offset(bubbleCrossStart, offsetMain)
        : Offset(offsetMain, bubbleCrossStart);

    return AntPopupLayout(
      direction: direction,
      align: align,
      offset: topLeft,
      arrowOffset: arrowOffset,
    );
  }

  /// 把 placement 拆成（主方向，沿边对齐）。
  static (AntPopupDirection, AntPopupAlign) _decompose(AntPopupPlacement placement) {
    return switch (placement) {
      AntPopupPlacement.topLeft => (AntPopupDirection.top, AntPopupAlign.start),
      AntPopupPlacement.top => (AntPopupDirection.top, AntPopupAlign.center),
      AntPopupPlacement.topRight => (AntPopupDirection.top, AntPopupAlign.end),
      AntPopupPlacement.bottomLeft => (AntPopupDirection.bottom, AntPopupAlign.start),
      AntPopupPlacement.bottom => (AntPopupDirection.bottom, AntPopupAlign.center),
      AntPopupPlacement.bottomRight => (AntPopupDirection.bottom, AntPopupAlign.end),
      AntPopupPlacement.leftTop => (AntPopupDirection.left, AntPopupAlign.start),
      AntPopupPlacement.left => (AntPopupDirection.left, AntPopupAlign.center),
      AntPopupPlacement.leftBottom => (AntPopupDirection.left, AntPopupAlign.end),
      AntPopupPlacement.rightTop => (AntPopupDirection.right, AntPopupAlign.start),
      AntPopupPlacement.right => (AntPopupDirection.right, AntPopupAlign.center),
      AntPopupPlacement.rightBottom => (AntPopupDirection.right, AntPopupAlign.end),
    };
  }

  /// 翻到对侧。
  static AntPopupDirection _flip(AntPopupDirection direction) => switch (direction) {
        AntPopupDirection.top => AntPopupDirection.bottom,
        AntPopupDirection.bottom => AntPopupDirection.top,
        AntPopupDirection.left => AntPopupDirection.right,
        AntPopupDirection.right => AntPopupDirection.left,
      };
}

