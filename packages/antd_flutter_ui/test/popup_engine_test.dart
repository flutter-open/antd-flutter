/// PopupEngine 纯计算引擎单测 — 覆盖方向决策 / 边界翻转 / 滑动夹回 / 箭头 clamp
///
/// 算法吸收自 minikin/popover（MIT），测试语义对应其方向翻转决策。
library;

import 'package:antd_flutter_ui/src/engines/popup_engine.dart';
import 'dart:ui' show Rect, Size;

import 'package:flutter_test/flutter_test.dart';

Rect _viewport({double width = 400, double height = 600}) =>
    Rect.fromLTWH(0, 0, width, height);

void main() {
  group('PopupEngine — 基础定位', () {
    test('bottom 气泡在触发元素下方', () {
      final layout = PopupEngine.solve(
        targetRect: const Rect.fromLTWH(180, 280, 40, 40),
        bubbleSize: const Size(120, 60),
        viewport: _viewport(),
        placement: AntPopupPlacement.bottom,
        gap: 6,
      );
      expect(layout.direction, AntPopupDirection.bottom);
      expect(layout.offset.dy, 280 + 40 + 6);
      // 水平居中
      expect(layout.offset.dx + 60, 200);
    });

    test('top 气泡在触发元素上方', () {
      final layout = PopupEngine.solve(
        targetRect: const Rect.fromLTWH(180, 280, 40, 40),
        bubbleSize: const Size(120, 60),
        viewport: _viewport(),
        placement: AntPopupPlacement.top,
        gap: 6,
      );
      expect(layout.direction, AntPopupDirection.top);
      expect(layout.offset.dy + 60, 280 - 6);
      expect(layout.offset.dy, 280 - 6 - 60);
    });

    test('start 对齐气泡左缘对齐触发元素左缘', () {
      final layout = PopupEngine.solve(
        targetRect: const Rect.fromLTWH(100, 280, 40, 40),
        bubbleSize: const Size(120, 60),
        viewport: _viewport(),
        placement: AntPopupPlacement.bottomLeft,
        gap: 6,
      );
      expect(layout.offset.dx, 100);
    });

    test('end 对齐气泡右缘对齐触发元素右缘', () {
      final layout = PopupEngine.solve(
        targetRect: const Rect.fromLTWH(100, 280, 40, 40),
        bubbleSize: const Size(120, 60),
        viewport: _viewport(),
        placement: AntPopupPlacement.bottomRight,
        gap: 6,
      );
      expect(layout.offset.dx + 120, 140);
    });
  });

  group('PopupEngine — 边界翻转', () {
    test('贴近视口底部：bottom 放不下翻到 top', () {
      final layout = PopupEngine.solve(
        targetRect: const Rect.fromLTWH(180, 560, 40, 30),
        bubbleSize: const Size(120, 60),
        viewport: _viewport(),
        placement: AntPopupPlacement.bottom,
        gap: 6,
        margin: 8,
      );
      expect(layout.direction, AntPopupDirection.top);
      // 不溢出视口（顶部留 margin 以上空间）
      expect(layout.offset.dy, greaterThanOrEqualTo(8));
    });

    test('贴近视口顶部：top 放不下翻到 bottom', () {
      final layout = PopupEngine.solve(
        targetRect: const Rect.fromLTWH(180, 5, 40, 25),
        bubbleSize: const Size(120, 60),
        viewport: _viewport(),
        placement: AntPopupPlacement.top,
        gap: 6,
      );
      expect(layout.direction, AntPopupDirection.bottom);
    });

    test('贴近右缘：right 放不下翻到 left', () {
      final layout = PopupEngine.solve(
        targetRect: const Rect.fromLTWH(360, 280, 36, 40),
        bubbleSize: const Size(100, 60),
        viewport: _viewport(),
        placement: AntPopupPlacement.right,
        gap: 6,
      );
      expect(layout.direction, AntPopupDirection.left);
    });

    test('贴近左缘：left 放不下翻到 right', () {
      final layout = PopupEngine.solve(
        targetRect: const Rect.fromLTWH(4, 280, 36, 40),
        bubbleSize: const Size(100, 60),
        viewport: _viewport(),
        placement: AntPopupPlacement.left,
        gap: 6,
      );
      expect(layout.direction, AntPopupDirection.right);
    });

    test('垂直两侧都放不下翻到水平空间更大侧', () {
      // 目标在左上角，top/left 都放不下 → 试 right（右空间大）
      final layout = PopupEngine.solve(
        targetRect: const Rect.fromLTWH(4, 4, 30, 30),
        bubbleSize: const Size(100, 80),
        viewport: _viewport(),
        placement: AntPopupPlacement.top,
        gap: 6,
      );
      expect(
        layout.direction,
        anyOf(AntPopupDirection.right, AntPopupDirection.bottom),
      );
    });

    test('翻转后不溢出视口', () {
      final layout = PopupEngine.solve(
        targetRect: const Rect.fromLTWH(180, 570, 40, 28),
        bubbleSize: const Size(200, 50),
        viewport: _viewport(),
        placement: AntPopupPlacement.bottom,
        gap: 6,
      );
      expect(layout.direction, AntPopupDirection.top);
      expect(layout.offset.dy, greaterThanOrEqualTo(8));
      expect(layout.offset.dx, greaterThanOrEqualTo(8));
      expect(layout.offset.dx + 200, lessThanOrEqualTo(392));
    });
  });

  group('PopupEngine — 滑动夹回', () {
    test('气泡超出左缘时夹回 margin', () {
      final layout = PopupEngine.solve(
        targetRect: const Rect.fromLTWH(2, 280, 20, 20),
        bubbleSize: const Size(200, 60),
        viewport: _viewport(),
        placement: AntPopupPlacement.bottomLeft,
        gap: 6,
      );
      expect(layout.offset.dx, 8);
    });

    test('气泡超出右缘时夹回视口内', () {
      final layout = PopupEngine.solve(
        targetRect: const Rect.fromLTWH(382, 280, 18, 20),
        bubbleSize: const Size(200, 60),
        viewport: _viewport(),
        placement: AntPopupPlacement.bottomRight,
        gap: 6,
      );
      expect(layout.offset.dx + 200, 392);
    });

    test('遵守 safe area 视口边界', () {
      final layout = PopupEngine.solve(
        targetRect: const Rect.fromLTWH(180, 280, 40, 40),
        bubbleSize: const Size(120, 60),
        viewport: const Rect.fromLTRB(40, 40, 360, 560),
        placement: AntPopupPlacement.bottom,
        gap: 6,
      );
      expect(layout.offset.dx, greaterThanOrEqualTo(40));
      expect(layout.offset.dx + 120, lessThanOrEqualTo(360));
    });
  });

  group('PopupEngine — 长面板主轴夹回', () {
    test('垂直两侧都放不下时按水平空间选向，不误翻到对侧', () {
      // 高面板在窄视口里：上、下都放不下，左右还有空间 → 应走 left/right，
      // 而不是因「对侧按水平空间判定」误翻到上方并溢出屏幕。
      final layout = PopupEngine.solve(
        targetRect: const Rect.fromLTWH(600, 380, 320, 32),
        bubbleSize: const Size(320, 520),
        viewport: _viewport(width: 1280, height: 813),
        placement: AntPopupPlacement.bottomLeft,
        gap: 8,
      );
      expect(
        layout.direction,
        anyOf(AntPopupDirection.left, AntPopupDirection.right),
      );
      expect(layout.offset.dy, greaterThanOrEqualTo(8));
      expect(layout.offset.dy + 520, lessThanOrEqualTo(813 - 8));
    });

    test('两侧都放不下且水平也没空间时主轴夹回视口内', () {
      // 手机竖屏：字段在中部，520 高面板上下都放不下，左右也不够 → 主轴夹回，
      // 允许与触发元素重叠，但面板必须完整可见（不再溢出屏幕顶部被裁切）。
      final layout = PopupEngine.solve(
        targetRect: const Rect.fromLTWH(35, 406, 320, 32),
        bubbleSize: const Size(320, 520),
        viewport: _viewport(width: 390, height: 844),
        placement: AntPopupPlacement.bottomLeft,
        gap: 8,
      );
      expect(
        layout.direction,
        anyOf(AntPopupDirection.top, AntPopupDirection.bottom),
      );
      expect(layout.offset.dy, greaterThanOrEqualTo(8));
      expect(layout.offset.dy + 520, lessThanOrEqualTo(844 - 8));
    });

    test('气泡比视口还高时不做夹回（保持原方向偏移）', () {
      final layout = PopupEngine.solve(
        targetRect: const Rect.fromLTWH(35, 300, 320, 32),
        bubbleSize: const Size(320, 700),
        viewport: _viewport(width: 390, height: 600),
        placement: AntPopupPlacement.bottom,
        gap: 8,
      );
      // 上下都放不下、左右也不够 → 取空间更大的上方；气泡高于视口，夹回无意义
      expect(layout.direction, AntPopupDirection.top);
      expect(layout.offset.dy, 300 - 8 - 700);
    });
  });

  group('PopupEngine — 箭头 tip clamp', () {
    test('箭头跟随触发元素中心', () {
      final layout = PopupEngine.solve(
        targetRect: const Rect.fromLTWH(180, 280, 40, 40),
        bubbleSize: const Size(120, 60),
        viewport: _viewport(),
        placement: AntPopupPlacement.bottom,
        gap: 6,
        arrowSize: 8,
      );
      // 触发元素中心 x=200，气泡左缘 140 → tip 相对位置 60
      expect(layout.arrowOffset, 60);
    });

    test('触发元素贴近左缘时箭头 clamp 防撞圆角', () {
      final layout = PopupEngine.solve(
        targetRect: const Rect.fromLTWH(4, 280, 20, 20),
        bubbleSize: const Size(200, 60),
        viewport: _viewport(),
        placement: AntPopupPlacement.bottom,
        gap: 6,
        arrowSize: 8,
      );
      // tip 不小于 margin + arrowSize
      expect(layout.arrowOffset, greaterThanOrEqualTo(16));
    });

    test('触发元素贴近右缘时箭头 clamp 防撞圆角', () {
      final layout = PopupEngine.solve(
        targetRect: const Rect.fromLTWH(380, 280, 18, 20),
        bubbleSize: const Size(200, 60),
        viewport: _viewport(),
        placement: AntPopupPlacement.bottom,
        gap: 6,
        arrowSize: 8,
      );
      expect(layout.arrowOffset, lessThanOrEqualTo(200 - 16));
    });
  });

  group('PopupEngine — 动画锚点', () {
    test('scaleAlignment 朝向触发元素一侧', () {
      final layout = PopupEngine.solve(
        targetRect: const Rect.fromLTWH(180, 280, 40, 40),
        bubbleSize: const Size(120, 60),
        viewport: _viewport(),
        placement: AntPopupPlacement.top,
      );
      expect(layout.scaleAlignment, const Offset(0, 1));
    });
  });
}
