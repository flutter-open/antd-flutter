/// DatePicker 触发器样式回归测试 —— issue #3
///
/// 「触发组件没有光环，颜色不对 且触发时内容抖动」
/// - 打开态：主色 1px 边框 + 无模糊外扩光环（antd 语义）
/// - 打开/关闭态边框宽度恒定 → 内容不位移
library;

import 'package:antd_picker/src/date_picker/ant_date_picker.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: AntTheme(data: AntThemeData.light(), child: Material(child: child)),
    ),
  );
}

AnimatedContainer _trigger(WidgetTester tester) {
  final finder = find.byWidgetPredicate(
    (w) => w is AnimatedContainer && w.foregroundDecoration != null,
  );
  expect(finder, findsOneWidget);
  return tester.widget<AnimatedContainer>(finder);
}

void main() {
  group('AntDatePicker — 触发器光环与抖动（issue #3）', () {
    testWidgets('关闭态：灰色 1px 边框、无光环', (tester) async {
      final t = AntThemeData.light();
      await tester.pumpWidget(
        _wrap(AntDatePicker(defaultValue: DateTime(2026, 11, 4))),
      );

      final c = _trigger(tester);
      expect((c.decoration! as BoxDecoration).boxShadow, isNull);
      final border =
          (c.foregroundDecoration! as BoxDecoration).border! as Border;
      expect(border.top.color, t.colorBorder);
      expect(border.top.width, t.s(1));
    });

    testWidgets('打开态：主色边框 + 无模糊外扩光环（取 controlOutline）', (tester) async {
      final t = AntThemeData.light();
      await tester.pumpWidget(
        _wrap(AntDatePicker(defaultValue: DateTime(2026, 11, 4))),
      );

      await tester.tap(find.byType(AntDatePicker));
      await tester.pumpAndSettle();

      final c = _trigger(tester);
      final shadow = (c.decoration! as BoxDecoration).boxShadow!.single;
      expect(shadow.color, t.controlOutline);
      expect(shadow.spreadRadius, t.controlOutlineWidth);
      expect(shadow.blurRadius, 0, reason: '不得为模糊辉光');

      final border =
          (c.foregroundDecoration! as BoxDecoration).border! as Border;
      expect(border.top.color, t.colorPrimary, reason: '打开态用主色而非浅色 outline');
      expect(border.top.width, t.s(1));
    });

    testWidgets('打开/关闭态边框宽度恒定 → 内容不抖动', (tester) async {
      await tester.pumpWidget(
        _wrap(AntDatePicker(defaultValue: DateTime(2026, 11, 4))),
      );
      final closedBorder =
          ((_trigger(tester).foregroundDecoration! as BoxDecoration).border!
                  as Border)
              .top
              .width;
      final closedText = tester.getRect(find.text('2026-11-04'));

      await tester.tap(find.byType(AntDatePicker));
      await tester.pumpAndSettle();
      final openBorder =
          ((_trigger(tester).foregroundDecoration! as BoxDecoration).border!
                  as Border)
              .top
              .width;
      final openText = tester.getRect(find.text('2026-11-04'));

      expect(openBorder, closedBorder);
      expect(openText.top, closedText.top);
      expect(openText.left, closedText.left);
    });

    testWidgets('触发器高度取 token（不硬编码 40/32/24）', (tester) async {
      // 默认主题 controlHeight=32 / controlHeightSM=24，硬编码 40/32/24 会失败
      final custom = AntThemeData.light();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AntTheme(
              data: custom,
              child: Material(
                child: Column(
                  children: [
                    AntDatePicker(
                      key: const ValueKey('middle'),
                      defaultValue: DateTime(2026, 11, 4),
                    ),
                    AntDatePicker(
                      key: const ValueKey('small'),
                      size: AntDatePickerSize.small,
                      defaultValue: DateTime(2026, 11, 4),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(
        tester.getSize(find.byKey(const ValueKey('middle'))).height,
        custom.s(custom.controlHeight),
      );
      expect(
        tester.getSize(find.byKey(const ValueKey('small'))).height,
        custom.s(custom.controlHeightSM),
      );
    });
  });
}
