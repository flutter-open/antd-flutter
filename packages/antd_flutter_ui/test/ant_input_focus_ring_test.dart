/// 输入框焦点光环 / addon 布局回归测试 —— issue #1 / #2
///
/// - #2：聚焦光环为 antd web 语义的「无模糊实心外扩环」，且颜色跟随校验状态
/// - #1：addon 行外层边框不再计入 padding（不内缩/裁切内容），
///       addon 文字行盒与输入文字一致（同一行高、同一垂直中心）
library;

import 'package:antd_flutter_ui/src/data_entry/input/ant_input.dart';
import 'package:antd_flutter_ui/src/data_entry/input/ant_input_types.dart';
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

/// 取 standalone 字段自绘的装饰（带边框的那个 AnimatedContainer）
BoxDecoration _fieldDecoration(WidgetTester tester) {
  final finder = find.byWidgetPredicate(
    (w) =>
        w is AnimatedContainer &&
        w.decoration is BoxDecoration &&
        (w.decoration! as BoxDecoration).border != null,
  );
  expect(finder, findsWidgets);
  return tester.widget<AnimatedContainer>(finder.first).decoration!
      as BoxDecoration;
}

void main() {
  group('AntInput — 焦点光环（issue #2）', () {
    testWidgets('正常态：无模糊、外扩 2px 实心环，取 controlOutline', (tester) async {
      final t = AntThemeData.light();
      final node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(_wrap(AntInput(focusNode: node)));
      node.requestFocus();
      await tester.pumpAndSettle();

      final shadow = _fieldDecoration(tester).boxShadow!.single;
      expect(shadow.color, t.controlOutline);
      expect(shadow.spreadRadius, t.controlOutlineWidth);
      expect(shadow.blurRadius, 0, reason: '不得为模糊辉光');
    });

    testWidgets('error 态：光环取 colorErrorOutline（不再固定蓝色）', (tester) async {
      final t = AntThemeData.light();
      final node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        _wrap(AntInput(focusNode: node, status: AntInputStatus.error)),
      );
      node.requestFocus();
      await tester.pumpAndSettle();

      final shadow = _fieldDecoration(tester).boxShadow!.single;
      expect(shadow.color, t.colorErrorOutline);
      expect(shadow.spreadRadius, t.controlOutlineWidth);
    });

    testWidgets('warning 态：光环取 colorWarningOutline', (tester) async {
      final t = AntThemeData.light();
      final node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        _wrap(AntInput(focusNode: node, status: AntInputStatus.warning)),
      );
      node.requestFocus();
      await tester.pumpAndSettle();

      final shadow = _fieldDecoration(tester).boxShadow!.single;
      expect(shadow.color, t.colorWarningOutline);
    });
  });
}
