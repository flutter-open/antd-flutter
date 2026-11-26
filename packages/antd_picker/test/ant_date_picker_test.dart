import 'package:antd_picker/antd_picker.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: AntTheme(
        data: AntThemeData.light(),
        child: AntPickerLocaleProvider(
          locale: AntPickerLocale.zh,
          child: Material(child: child),
        ),
      ),
    ),
  );
}

void main() {
  group('AntDatePicker', () {
    testWidgets('renders placeholder by default', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntDatePicker(
            placeholder: '请选择',
          ),
        ),
      );
      expect(find.text('请选择'), findsOneWidget);
    });

    testWidgets('renders default value formatted', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntDatePicker(
            defaultValue: DateTime(2024, 1, 15),
          ),
        ),
      );
      expect(find.text('2024-01-15'), findsOneWidget);
    });

    testWidgets('disabled does not open panel', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntDatePicker(
            disabled: true,
          ),
        ),
      );
      await tester.tap(find.byType(AntDatePicker));
      await tester.pump();
      expect(find.textContaining('年'), findsNothing);
    });

    testWidgets('tap opens calendar panel', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntDatePicker(
            defaultValue: DateTime(2024, 1, 15),
          ),
        ),
      );
      await tester.tap(find.byType(AntDatePicker));
      await tester.pump();
      expect(find.text('2024年1月'), findsOneWidget);
    });

    testWidgets('selecting a date calls onChange and closes', (tester) async {
      DateTime? changed;
      await tester.pumpWidget(
        _wrap(
          AntDatePicker(
            defaultValue: DateTime(2024, 1, 1),
            onChange: (d) => changed = d,
          ),
        ),
      );
      await tester.tap(find.byType(AntDatePicker));
      await tester.pump();
      await tester.tap(find.text('15'));
      await tester.pump();
      expect(changed, DateTime(2024, 1, 15));
      expect(find.text('2024-01-15'), findsOneWidget);
      expect(find.text('2024年1月'), findsNothing);
    });

    testWidgets('month navigation works', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntDatePicker(
            defaultValue: DateTime(2024, 1, 1),
          ),
        ),
      );
      await tester.tap(find.byType(AntDatePicker));
      await tester.pump();
      expect(find.text('2024年1月'), findsOneWidget);
      await tester.tap(find.byIcon(AntIcons.rightOutlined));
      await tester.pump();
      expect(find.text('2024年2月'), findsOneWidget);
      await tester.tap(find.byIcon(AntIcons.leftOutlined));
      await tester.pump();
      expect(find.text('2024年1月'), findsOneWidget);
    });

    testWidgets('allowClear clears value', (tester) async {
      DateTime? changed = DateTime(2024, 1, 1);
      await tester.pumpWidget(
        _wrap(
          AntDatePicker(
            defaultValue: DateTime(2024, 1, 1),
            allowClear: true,
            onChange: (d) => changed = d,
          ),
        ),
      );
      expect(find.text('2024-01-01'), findsOneWidget);
      await tester.tap(find.byIcon(AntIcons.closeCircleFilled));
      await tester.pump();
      expect(changed, null);
      expect(find.text('请选择日期'), findsOneWidget);
    });

    testWidgets('controlled value updates display', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntDatePicker(
            value: DateTime(2025, 6, 20),
          ),
        ),
      );
      expect(find.text('2025-06-20'), findsOneWidget);
    });

    testWidgets('labelBuilder renders custom trigger widget', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntDatePicker(
            value: DateTime(2025, 6, 20),
            labelBuilder: (context, date) =>
                Text('自定义:${date.year}/${date.month}/${date.day}'),
          ),
        ),
      );
      expect(find.text('自定义:2025/6/20'), findsOneWidget);
      expect(find.text('2025-06-20'), findsNothing);
    });
  });
}
