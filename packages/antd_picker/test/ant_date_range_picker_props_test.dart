/// AntDateRangePicker 新增属性回归：`status` / `disabledDate`。
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_picker/antd_picker.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Widget _wrap(Widget child) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Center(child: SizedBox(width: 320, child: child)),
        ),
      ),
    );

({BoxDecoration? surface, BoxDecoration border}) _surfaceOf(
  WidgetTester tester,
) {
  for (final widget in tester.widgetList<AnimatedContainer>(
    find.descendant(
      of: find.byType(AntDateRangePicker),
      matching: find.byType(AnimatedContainer),
    ),
  )) {
    final foreground = widget.foregroundDecoration;
    if (foreground is BoxDecoration && foreground.border != null) {
      return (
        surface: widget.decoration is BoxDecoration
            ? widget.decoration! as BoxDecoration
            : null,
        border: foreground,
      );
    }
  }
  fail('触发器没有把边框画在 foregroundDecoration 上');
}

Finder _day(String day) => find.descendant(
      of: find.byType(GridView),
      matching: find.text(day),
    );

void main() {
  final theme = AntThemeData.light();

  testWidgets('status=error：边框与光环取校验色', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AntDateRangePicker(
          defaultValue: AntDateRange(
            start: DateTime(2024, 1, 10),
            end: DateTime(2024, 1, 20),
          ),
          status: AntInputStatus.error,
        ),
      ),
    );
    await tester.pumpAndSettle();

    var surface = _surfaceOf(tester);
    expect((surface.border.border! as Border).top.color, theme.colorError);

    await tester.tap(find.byType(AntDateRangePicker));
    await tester.pumpAndSettle();

    surface = _surfaceOf(tester);
    expect((surface.border.border! as Border).top.color, theme.colorError);
    expect(surface.surface!.boxShadow!.single.color, theme.colorErrorOutline);
  });

  testWidgets('disabledDate：命中日期置灰且不参与选择', (tester) async {
    AntDateRange? changed;
    await tester.pumpWidget(
      _wrap(
        AntDateRangePicker(
          defaultValue: AntDateRange(
            start: DateTime(2024, 1, 10),
            end: DateTime(2024, 1, 20),
          ),
          disabledDate: (date) => date.day == 15,
          onChange: (range) => changed = range,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(AntDateRangePicker));
    await tester.pumpAndSettle();

    final cell = tester.widget<Text>(_day('15').first);
    expect(cell.style?.color, theme.colorTextDisabled);

    // 点到不可选日期不应开始新区间
    await tester.tap(_day('15'));
    await tester.pumpAndSettle();
    expect(find.byType(AntDateRangePicker), findsOneWidget);

    // 可选日期仍能完成选择
    await tester.tap(_day('12'));
    await tester.pumpAndSettle();
    await tester.tap(_day('18'));
    await tester.pumpAndSettle();
    expect(changed, isNotNull);
    expect(changed!.start, DateTime(2024, 1, 12));
    expect(changed!.end, DateTime(2024, 1, 18));
  });
}
