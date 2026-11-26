/// AntSelect 新增属性回归：`status` / `maxTagCount`。
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Widget _wrap(Widget child) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Center(child: SizedBox(width: 300, child: child)),
        ),
      ),
    );

({BoxDecoration? surface, BoxDecoration border}) _surfaceOf(
  WidgetTester tester,
) {
  for (final container in tester.widgetList<Container>(
    find.descendant(
      of: find.byType(AntSelect<String>),
      matching: find.byType(Container),
    ),
  )) {
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
  fail('触发器没有把边框画在 foregroundDecoration 上');
}

void main() {
  final theme = AntThemeData.light();
  const options = ['杭州', '宁波', '苏州', '南京'];

  testWidgets('status=error：边框与光环取校验色', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const AntSelect<String>(
          options: options,
          status: AntInputStatus.error,
        ),
      ),
    );
    await tester.pumpAndSettle();

    var surface = _surfaceOf(tester);
    expect((surface.border.border! as Border).top.color, theme.colorError);

    await tester.tap(find.byType(AntSelect<String>));
    await tester.pumpAndSettle();

    surface = _surfaceOf(tester);
    expect((surface.border.border! as Border).top.color, theme.colorError);
    expect(surface.surface!.boxShadow!.single.color, theme.colorErrorOutline);
  });

  testWidgets('maxTagCount：超出部分折叠为 +N', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const AntSelect<String>(
          mode: AntSelectMode.multiple,
          options: options,
          defaultValues: options,
          maxTagCount: 2,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('杭州'), findsOneWidget);
    expect(find.text('宁波'), findsOneWidget);
    // 被折叠的两个标签不渲染
    expect(find.text('苏州'), findsNothing);
    expect(find.text('南京'), findsNothing);
    expect(find.text('+2'), findsOneWidget);
  });

  testWidgets('maxTagCount 为空时全部展开', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const AntSelect<String>(
          mode: AntSelectMode.multiple,
          options: options,
          defaultValues: options,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('苏州'), findsOneWidget);
    expect(find.text('南京'), findsOneWidget);
    expect(find.textContaining('+'), findsNothing);
  });
}
