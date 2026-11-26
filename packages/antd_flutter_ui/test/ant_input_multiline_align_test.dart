/// 多行输入回归：正文左缘与单行一致（前部对齐）、禁用灰底单层绘制。
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Widget _wrap(Widget child) => MaterialApp(
      home: AntTheme(
        data: AntThemeData.light(),
        child: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(width: 300, child: child),
          ),
        ),
      ),
    );

/// 容器左缘到正文首个字形（caret）的距离。
double _glyphInset(WidgetTester tester, Finder container) {
  final rect = tester.getRect(container.first);
  final wrapper = tester.renderObject<RenderObject>(
    find.descendant(of: container, matching: find.byType(EditableText)),
  );
  RenderEditable? editable;
  void walk(RenderObject node) {
    if (editable != null) return;
    if (node is RenderEditable) {
      editable = node;
      return;
    }
    node.visitChildren(walk);
  }

  walk(wrapper);
  final caret = editable!.getLocalRectForCaret(const TextPosition(offset: 0));
  return caret.left + editable!.localToGlobal(Offset.zero).dx - rect.left;
}

InputDecorator _decorator(WidgetTester tester, Finder container) =>
    tester.widget<InputDecorator>(
      find.descendant(of: container, matching: find.byType(InputDecorator)),
    );

void main() {
  testWidgets('多行正文左缘与单行一致', (tester) async {
    await tester.pumpWidget(_wrap(const AntInput(defaultValue: '单行')));
    await tester.pump();
    final single = _glyphInset(tester, find.byType(AntInput));

    await tester.pumpWidget(_wrap(const AntInputTextArea(defaultValue: '多行')));
    await tester.pump();
    final multi = _glyphInset(tester, find.byType(AntInputTextArea));

    expect(multi, closeTo(single, 1.5), reason: '多行正文应与单行前部对齐');
  });

  testWidgets('多行禁用：灰底只由外层容器绘制一层', (tester) async {
    final t = AntThemeData.light();
    await tester.pumpWidget(
      _wrap(const AntInputTextArea(defaultValue: '多行', disabled: true)),
    );
    await tester.pump();

    final decorator = _decorator(tester, find.byType(AntInputTextArea));
    expect(decorator.decoration.fillColor, Colors.transparent);

    final surface = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(AntInputTextArea),
            matching: find.byType(Container),
          )
          .first,
    );
    expect(
      (surface.decoration! as BoxDecoration).color,
      t.colorBgContainerDisabled,
    );
  });

  testWidgets('单行禁用：灰底只由外层容器绘制一层', (tester) async {
    final t = AntThemeData.light();
    await tester.pumpWidget(
      _wrap(const AntInput(defaultValue: 'abc', disabled: true)),
    );
    await tester.pump();

    final decorator = _decorator(tester, find.byType(AntInput));
    expect(decorator.decoration.fillColor, Colors.transparent);

    final surface = tester.widget<AnimatedContainer>(
      find.descendant(
        of: find.byType(AntInput),
        matching: find.byType(AnimatedContainer),
      ),
    );
    expect(
      (surface.decoration! as BoxDecoration).color,
      t.colorBgContainerDisabled,
    );
  });
}
