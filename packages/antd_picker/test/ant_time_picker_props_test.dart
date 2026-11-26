/// AntTimePicker 新增属性回归：`status`。
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
          child: Center(child: SizedBox(width: 240, child: child)),
        ),
      ),
    );

void main() {
  final theme = AntThemeData.light();

  testWidgets('status=error：边框与光环取校验色', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const AntTimePicker(
          defaultValue: TimeOfDay(hour: 9, minute: 30),
          status: AntInputStatus.error,
        ),
      ),
    );
    await tester.pumpAndSettle();

    ({BoxDecoration? surface, BoxDecoration border}) surfaceOf() {
      for (final widget in tester.widgetList<AnimatedContainer>(
        find.descendant(
          of: find.byType(AntTimePicker),
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

    var surface = surfaceOf();
    expect((surface.border.border! as Border).top.color, theme.colorError);

    await tester.tap(find.byType(AntTimePicker));
    await tester.pumpAndSettle();

    surface = surfaceOf();
    expect((surface.border.border! as Border).top.color, theme.colorError);
    expect(surface.surface!.boxShadow!.single.color, theme.colorErrorOutline);
  });
}
