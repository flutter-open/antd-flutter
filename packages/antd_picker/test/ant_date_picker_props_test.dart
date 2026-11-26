/// AntDatePicker 新增属性回归：`status` / `disabledDate` / `minDate` / `maxDate`。
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
          child: Center(child: SizedBox(width: 260, child: child)),
        ),
      ),
    );

/// 触发器：前景层画边框的 Container / AnimatedContainer。
({BoxDecoration? surface, BoxDecoration border}) _surfaceOf(
  WidgetTester tester,
  Finder root,
) {
  for (final widget in [
    ...tester.widgetList<AnimatedContainer>(
      find.descendant(of: root, matching: find.byType(AnimatedContainer)),
    ),
  ]) {
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

BorderSide _side(BoxDecoration decoration) =>
    (decoration.border! as Border).top;

Text _dayText(WidgetTester tester, String day) => tester.widget<Text>(
      find.descendant(
        of: find.byType(GridView),
        matching: find.text(day),
      ).first,
    );

void main() {
  final theme = AntThemeData.light();

  testWidgets('status=error：边框与光环取校验色', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AntDatePicker(
          defaultValue: DateTime(2024, 1, 15),
          status: AntInputStatus.error,
        ),
      ),
    );
    await tester.pumpAndSettle();

    var surface = _surfaceOf(tester, find.byType(AntDatePicker));
    expect(_side(surface.border).color, theme.colorError);

    await tester.tap(find.byType(AntDatePicker));
    await tester.pumpAndSettle();

    surface = _surfaceOf(tester, find.byType(AntDatePicker));
    expect(_side(surface.border).color, theme.colorError);
    expect(surface.surface!.boxShadow!.single.color, theme.colorErrorOutline);
  });

  testWidgets('disabledDate：命中日期置灰且点击无效', (tester) async {
    DateTime? changed;
    await tester.pumpWidget(
      _wrap(
        AntDatePicker(
          defaultValue: DateTime(2024, 1, 15),
          disabledDate: (date) => date.day == 10,
          onChange: (value) => changed = value,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(AntDatePicker));
    await tester.pumpAndSettle();

    expect(_dayText(tester, '10').style?.color, theme.colorTextDisabled);

    await tester.tap(
      find.descendant(of: find.byType(GridView), matching: find.text('10')),
    );
    await tester.pumpAndSettle();
    expect(changed, isNull);

    // 可选日期仍能选中
    await tester.tap(
      find.descendant(of: find.byType(GridView), matching: find.text('12')),
    );
    await tester.pumpAndSettle();
    expect(changed, DateTime(2024, 1, 12));
  });

  testWidgets('minDate / maxDate：范围外置灰且不可选', (tester) async {
    DateTime? changed;
    await tester.pumpWidget(
      _wrap(
        AntDatePicker(
          defaultValue: DateTime(2024, 1, 15),
          minDate: DateTime(2024, 1, 10),
          maxDate: DateTime(2024, 1, 20),
          onChange: (value) => changed = value,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(AntDatePicker));
    await tester.pumpAndSettle();

    expect(_dayText(tester, '5').style?.color, theme.colorTextDisabled);
    expect(_dayText(tester, '25').style?.color, theme.colorTextDisabled);
    expect(_dayText(tester, '15').style?.color, isNot(theme.colorTextDisabled));

    await tester.tap(
      find.descendant(of: find.byType(GridView), matching: find.text('5')),
    );
    await tester.pumpAndSettle();
    expect(changed, isNull);
  });
}
