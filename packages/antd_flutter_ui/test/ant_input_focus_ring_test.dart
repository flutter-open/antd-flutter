/// 输入框焦点光环 / addon 布局回归测试 —— issue #1 / #2
///
/// - #2：聚焦光环为 antd web 语义的「无模糊实心外扩环」，且颜色跟随校验状态
/// - #1：addon 行外层边框不再计入 padding（不内缩/裁切内容），
///       addon 文字行盒与输入文字一致（同一行高、同一垂直中心）
library;

import 'package:antd_flutter_ui/src/data_entry/input/ant_input.dart';
import 'package:antd_flutter_ui/src/data_entry/input/ant_input_field.dart';
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

/// 取 addon 模式外层容器（边框绘制在前景层的那个 AnimatedContainer）
AnimatedContainer _addonShell(WidgetTester tester) {
  final finder = find.byWidgetPredicate(
    (w) => w is AnimatedContainer && w.foregroundDecoration != null,
  );
  expect(finder, findsOneWidget);
  return tester.widget<AnimatedContainer>(finder);
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

    testWidgets('addon 模式：光环同样按校验状态着色', (tester) async {
      final t = AntThemeData.light();
      final node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        _wrap(
          AntInput(
            focusNode: node,
            status: AntInputStatus.error,
            addonBefore: const Text('http://'),
          ),
        ),
      );
      node.requestFocus();
      await tester.pumpAndSettle();

      final shell = _addonShell(tester);
      final shadow = (shell.decoration! as BoxDecoration).boxShadow!.single;
      expect(shadow.color, t.colorErrorOutline);
      expect(shadow.blurRadius, 0);
      expect(shadow.spreadRadius, t.controlOutlineWidth);
    });
  });

  group('AntInput — addon 布局（issue #1）', () {
    testWidgets('外层边框绘制于前景层：不计入 padding，内容铺满整框', (tester) async {
      final t = AntThemeData.light();
      await tester.pumpWidget(
        _wrap(
          const AntInput(
            addonBefore: Text('http://'),
            addonAfter: Text('.com'),
            placeholder: '前后置标签',
          ),
        ),
      );

      final shell = _addonShell(tester);
      // 边框不进 decoration（不进布局）
      expect((shell.decoration! as BoxDecoration).border, isNull);
      expect((shell.foregroundDecoration! as BoxDecoration).border, isNotNull);
      // 边框宽度仍为 1，颜色仍按状态取值
      final border =
          (shell.foregroundDecoration! as BoxDecoration).border! as Border;
      expect(border.top.width, t.s(1));

      // 内容高度 = 整框高度（不再少 2px）
      final shellRect = tester.getRect(
        find.byWidgetPredicate(
          (w) => w is AnimatedContainer && w.foregroundDecoration != null,
        ),
      );
      final addonRect = tester.getRect(
        find
            .ancestor(
              of: find.text('http://'),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(addonRect.height, closeTo(shellRect.height, 0.01));
      expect(
        addonRect.center.dy,
        closeTo(shellRect.center.dy, 0.01),
      );
    });

    testWidgets('addon 文字与输入文字行盒一致（同为 fontSize 高、同一中心）', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntInput(
            addonBefore: Text('http://'),
            placeholder: '前后置标签',
          ),
        ),
      );

      final addonText = tester.getRect(find.text('http://'));
      final field = tester.getRect(
        find.descendant(
          of: find.byType(AntInputField),
          matching: find.byType(EditableText),
        ),
      );
      expect(addonText.height, closeTo(field.height, 0.01));
      expect(addonText.center.dy, closeTo(field.center.dy, 0.01));
    });

    testWidgets('embedded 单行：装饰器行盒撑满控件高度（真机字体下不偏移）', (tester) async {
      final t = AntThemeData.light();
      await tester.pumpWidget(
        _wrap(
          const AntInput(
            addonBefore: Text('http://'),
            placeholder: '前后置标签',
          ),
        ),
      );

      // embedded 模式此前用零上下内边距：行盒只有一行字高，填充/基线在
      // 真机字体（web 的 Noto/SF 等大 ascent 字体）下会整体下移数 px。
      // 基座应与 standalone 一样用对称内边距把行盒撑满控件高度。
      final decorator = tester.getRect(
        find.descendant(
          of: find.byType(AntInputField),
          matching: find.byType(InputDecorator),
        ),
      );
      expect(decorator.height, closeTo(t.s(t.controlHeight), 0.01));

      // 行盒中心 = 外层整框中心（上下对称，文字不会偏下）
      final shell = tester.getRect(
        find.byWidgetPredicate(
          (w) => w is AnimatedContainer && w.foregroundDecoration != null,
        ),
      );
      expect(decorator.center.dy, closeTo(shell.center.dy, 0.01));
    });
  });
}
