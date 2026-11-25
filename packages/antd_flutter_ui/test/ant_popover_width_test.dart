/// AntPopover 宽度语义测试 —— issue #4
/// 「宽度无法自适应内容且无法设置尺寸」
library;

import 'package:antd_flutter_ui/src/display/popover/ant_popover.dart';
import 'package:antd_flutter_ui/src/display/popover/ant_popover_types.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: AntTheme(
          data: AntThemeData.light(),
          child: Material(child: child),
        ),
      ),
    ),
  );
}

Widget _popover({
  required Widget content,
  AntPopoverOverlayStyle? overlayStyle,
  Key? key,
}) {
  return AntPopover(
    key: key,
    trigger: AntPopoverTrigger.click,
    defaultOpen: true,
    content: content,
    overlayStyle: overlayStyle,
    child: const Text('触发'),
  );
}

double _bubbleWidth(WidgetTester tester) =>
    tester.getSize(find.byKey(kAntPopoverBubbleKey)).width;

void main() {
  group('AntPopover — 宽度自适应（issue #4）', () {
    testWidgets('默认宽度随内容自适应（短内容不再被固定 240 撑满）', (tester) async {
      await tester.pumpWidget(
        _wrap(_popover(key: const ValueKey('short'), content: const Text('短'))),
      );
      await tester.pumpAndSettle();
      final short = _bubbleWidth(tester);

      await tester.pumpWidget(
        _wrap(
          _popover(
            key: const ValueKey('long'),
            content: const Text('这是一段明显更长的气泡内容文本'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final long = _bubbleWidth(tester);

      // 自适应语义：宽度由内容决定，而非固定值
      expect(long, greaterThan(short));
      expect(short, lessThan(240 - 1), reason: '短内容应小于旧的固定 240 宽');
    });

    testWidgets('overlayStyle.width 可固定宽度', (tester) async {
      final t = AntThemeData.light();
      await tester.pumpWidget(
        _wrap(
          _popover(
            content: const Text('短'),
            overlayStyle: const AntPopoverOverlayStyle(width: 320),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(_bubbleWidth(tester), closeTo(t.s(320), 0.5));
    });

    testWidgets('overlayStyle.minWidth 生效（短内容也保底宽度）', (tester) async {
      final t = AntThemeData.light();
      await tester.pumpWidget(
        _wrap(
          _popover(
            content: const Text('短'),
            overlayStyle: const AntPopoverOverlayStyle(minWidth: 200),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(_bubbleWidth(tester), greaterThanOrEqualTo(t.s(200)));
    });

    testWidgets('overlayStyle.maxWidth 生效（长内容自动换行不溢出）', (tester) async {
      final t = AntThemeData.light();
      await tester.pumpWidget(
        _wrap(
          _popover(
            content: const Text('这是一段非常长的气泡内容文本，需要在最大宽度处自动换行显示'),
            overlayStyle: const AntPopoverOverlayStyle(maxWidth: 180),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(_bubbleWidth(tester), lessThanOrEqualTo(t.s(180) + 0.5));
    });
  });
}
