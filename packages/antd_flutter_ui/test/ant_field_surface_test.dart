/// 录入类控件边框 / 焦点光环一致性回归（issue #7：Select 边框颜色不对）
///
/// antd 语义：控件边框恒 1px，聚焦/打开态取主色，外圈是 2px 无模糊的实心
/// 外扩环（`controlOutline`），且边框画在前景层不参与布局 —— 打开时内容
/// 不位移。曾把打开态边框整体换成半透明 `controlOutline` 且宽度翻倍，视觉
/// 上是一圈发淡的粗边，还被用户反馈为「边框颜色不对」。
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: AntTheme(
        data: AntThemeData.light(),
        child: Center(child: SizedBox(width: 300, child: child)),
      ),
    ),
  );
}

/// 找到画在「前景层」的边框，并返回它所在容器的背景装饰。
({BoxDecoration? surface, BoxDecoration border}) _surfaceOf(
  WidgetTester tester,
  Finder root,
) {
  for (final container in tester.widgetList<Container>(find.descendant(
    of: root,
    matching: find.byType(Container),
  ))) {
    final foreground = container.foregroundDecoration;
    if (foreground is BoxDecoration && foreground.border != null) {
      return (
        surface: container.decoration is BoxDecoration
            ? container.decoration! as BoxDecoration
            : null,
        border: foreground,
      );
    }
  }
  fail('控件没有把边框画在 foregroundDecoration 上');
}

BorderSide _borderSide(BoxDecoration decoration) =>
    (decoration.border! as Border).top;

void main() {
  final theme = AntThemeData.light();

  testWidgets('Select 打开态：1px 主色边框 + controlOutline 实心环，开合不抖动', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const AntSelect<String>(
          options: ['a', 'b'],
          placeholder: '请选择',
        ),
      ),
    );
    await tester.pumpAndSettle();

    final sizeBefore = tester.getSize(find.byType(AntSelect<String>));
    var surface = _surfaceOf(tester, find.byType(AntSelect<String>));

    // 关闭态：常规边框，无光环
    expect(_borderSide(surface.border).color, theme.colorBorder);
    expect(_borderSide(surface.border).width, 1);
    expect(surface.surface?.boxShadow ?? const <BoxShadow>[], isEmpty);

    await tester.tap(find.byType(AntSelect<String>));
    await tester.pumpAndSettle();

    surface = _surfaceOf(tester, find.byType(AntSelect<String>));
    // 打开态：边框仍是 1px，但换成主色（不是半透明的 controlOutline）
    expect(_borderSide(surface.border).color, theme.colorPrimary);
    expect(_borderSide(surface.border).width, 1);
    // 光环：无模糊、按 spread 半径外扩
    final ring = surface.surface!.boxShadow!;
    expect(ring, hasLength(1));
    expect(ring.single.color, theme.controlOutline);
    expect(ring.single.blurRadius, 0);
    expect(ring.single.spreadRadius, theme.controlOutlineWidth);
    // 边框不参与布局：打开前后尺寸一致（不抖动）
    expect(tester.getSize(find.byType(AntSelect<String>)), sizeBefore);
  });

  testWidgets('AutoComplete 聚焦态：主色 1px 边框 + controlOutline 实心环', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const AntAutoComplete<String>(
          options: ['Ruby', 'Dart'],
          placeholder: '请输入',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      _borderSide(
              _surfaceOf(tester, find.byType(AntAutoComplete<String>)).border)
          .color,
      theme.colorBorder,
    );

    await tester.tap(find.byType(AntAutoComplete<String>));
    await tester.pumpAndSettle();

    final surface = _surfaceOf(
      tester,
      find.byType(AntAutoComplete<String>),
    );
    expect(_borderSide(surface.border).color, theme.colorPrimary);
    expect(_borderSide(surface.border).width, 1);
    expect(surface.surface!.boxShadow!.single.color, theme.controlOutline);
    expect(surface.surface!.boxShadow!.single.spreadRadius,
        theme.controlOutlineWidth);
  });

  testWidgets('Mentions 聚焦态：主色 1px 边框 + controlOutline 实心环', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const AntMentions<String>(options: ['a', 'b'], placeholder: '请输入'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.showKeyboard(find.descendant(
      of: find.byType(AntMentions<String>),
      matching: find.byType(EditableText),
    ));
    await tester.pumpAndSettle();

    final surface = _surfaceOf(tester, find.byType(AntMentions<String>));
    expect(_borderSide(surface.border).color, theme.colorPrimary);
    expect(_borderSide(surface.border).width, 1);
    expect(surface.surface!.boxShadow!.single.color, theme.controlOutline);
  });
}
