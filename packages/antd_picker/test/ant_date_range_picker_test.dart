/// AntDateRangePicker / AntDateTimeRangePicker 测试 —— issue #6
///
/// 覆盖：占位与范围值展示、两次点击选择、反向点击自动排序、
/// showTime 需确认才提交、清除、国际化、周起始、minDate/maxDate 禁用。
library;

import 'package:antd_picker/antd_picker.dart';
import 'package:antd_picker/src/time_picker/ant_time_wheel.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

Widget _wrap(Widget child, {AntPickerLocale locale = AntPickerLocale.zh}) {
  return MaterialApp(
    locale: const Locale('zh'),
    home: Scaffold(
      body: AntTheme(
        data: AntThemeData.light(),
        child: AntPickerLocaleProvider(
          locale: locale,
          child: Material(child: child),
        ),
      ),
    ),
  );
}

Finder _day(String day) => find.descendant(
      of: find.byType(GridView),
      matching: find.text(day),
    );

void main() {
  group('AntDateRangePicker 触发器', () {
    testWidgets('默认占位为起止文案', (tester) async {
      await tester.pumpWidget(_wrap(const AntDateRangePicker()));
      expect(find.text('开始日期 ~ 结束日期'), findsOneWidget);
    });

    testWidgets('展示格式化范围值', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntDateRangePicker(
            value: AntDateRange(
              start: DateTime(2024, 1, 15),
              end: DateTime(2024, 1, 20),
            ),
          ),
        ),
      );
      expect(find.text('2024-01-15 ~ 2024-01-20'), findsOneWidget);
    });

    testWidgets('format 参数生效', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntDateRangePicker(
            format: 'yyyy/MM/dd',
            value: AntDateRange(
              start: DateTime(2024, 1, 15),
              end: DateTime(2024, 1, 20),
            ),
          ),
        ),
      );
      expect(find.text('2024/01/15 ~ 2024/01/20'), findsOneWidget);
    });

    testWidgets('locale=en 显示英文占位与格式', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntDateRangePicker(), locale: AntPickerLocale.en),
      );
      expect(find.text('Start date ~ End date'), findsOneWidget);

      await tester.pumpWidget(
        _wrap(
          AntDateRangePicker(
            locale: AntPickerLocale.en,
            value: AntDateRange(
              start: DateTime(2024, 1, 15),
              end: DateTime(2024, 1, 20),
            ),
          ),
          locale: AntPickerLocale.en,
        ),
      );
      expect(find.text('01/15/2024 ~ 01/20/2024'), findsOneWidget);
    });

    testWidgets('allowClear 清除范围', (tester) async {
      AntDateRange? changed;
      await tester.pumpWidget(
        _wrap(
          AntDateRangePicker(
            defaultValue: AntDateRange(
              start: DateTime(2024, 1, 15),
              end: DateTime(2024, 1, 20),
            ),
            allowClear: true,
            onChange: (range) => changed = range,
          ),
        ),
      );
      await tester.tap(find.byIcon(AntIcons.closeCircleFilled));
      await tester.pump();
      expect(changed, isNull);
      expect(find.text('开始日期 ~ 结束日期'), findsOneWidget);
    });

    testWidgets('disabled 不打开面板', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntDateRangePicker(disabled: true)),
      );
      await tester.tap(find.byType(AntDateRangePicker));
      await tester.pumpAndSettle();
      expect(find.text('开始日期 ~ 结束日期'), findsOneWidget);
      expect(find.text('确定'), findsNothing);
    });
  });

  group('AntDateRangePicker 面板选择', () {
    testWidgets('打开面板显示年月标题与周标签', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntDateRangePicker(
            defaultValue: AntDateRange.sorted(
              DateTime(2024, 1, 10),
              DateTime(2024, 1, 20),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(AntDateRangePicker));
      await tester.pumpAndSettle();
      expect(find.text('2024年1月'), findsOneWidget);
      expect(find.text('日'), findsOneWidget);
      expect(find.text('六'), findsOneWidget);
      expect(find.text('确定'), findsNothing);
    });

    testWidgets('两次点击选择起止并提交关闭', (tester) async {
      AntDateRange? changed;
      await tester.pumpWidget(
        _wrap(
          AntDateRangePicker(
            defaultValue: AntDateRange(
              start: DateTime(2024, 1, 1),
              end: DateTime(2024, 1, 5),
            ),
            onChange: (range) => changed = range,
          ),
        ),
      );
      await tester.tap(find.byType(AntDateRangePicker));
      await tester.pumpAndSettle();
      expect(find.text('2024年1月'), findsOneWidget);

      await tester.tap(_day('10'));
      await tester.pumpAndSettle();
      // 只选了起点：不提交，面板仍打开
      expect(changed, isNull);

      await tester.tap(_day('20'));
      await tester.pumpAndSettle();
      expect(changed, isNotNull);
      expect(changed!.start, DateTime(2024, 1, 10));
      expect(changed!.end, DateTime(2024, 1, 20));
      // 面板已关闭
      expect(find.text('2024年1月'), findsNothing);
    });

    testWidgets('反向点击自动排序（先点大日期再点小日期）', (tester) async {
      AntDateRange? changed;
      await tester.pumpWidget(
        _wrap(
          AntDateRangePicker(
            defaultValue: AntDateRange(
              start: DateTime(2024, 1, 5),
              end: DateTime(2024, 1, 10),
            ),
            onChange: (range) => changed = range,
          ),
        ),
      );
      await tester.tap(find.byType(AntDateRangePicker));
      await tester.pumpAndSettle();
      await tester.tap(_day('25'));
      await tester.pumpAndSettle();
      await tester.tap(_day('12'));
      await tester.pumpAndSettle();
      expect(changed!.start, DateTime(2024, 1, 12));
      expect(changed!.end, DateTime(2024, 1, 25));
    });

    testWidgets('minDate/maxDate 之外的日期不可选', (tester) async {
      AntDateRange? changed;
      await tester.pumpWidget(
        _wrap(
          AntDateRangePicker(
            defaultValue: AntDateRange(
              start: DateTime(2024, 1, 10),
              end: DateTime(2024, 1, 20),
            ),
            minDate: DateTime(2024, 1, 10),
            maxDate: DateTime(2024, 1, 25),
            onChange: (range) => changed = range,
          ),
        ),
      );
      await tester.tap(find.byType(AntDateRangePicker));
      await tester.pumpAndSettle();
      await tester.tap(_day('5'));
      await tester.pumpAndSettle();
      expect(changed, isNull);
      // 面板仍打开
      expect(find.text('2024年1月'), findsOneWidget);
    });

    testWidgets('weekStartsOnMonday 调整周标签顺序', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntDateRangePicker(
            weekStartsOnMonday: true,
            defaultValue: AntDateRange(
              start: DateTime(2024, 1, 10),
              end: DateTime(2024, 1, 20),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(AntDateRangePicker));
      await tester.pumpAndSettle();
      final labels = tester
          .widgetList<Text>(find.byType(Text))
          .map((t) => t.data)
          .where((d) => const ['一', '二', '三', '四', '五', '六', '日'].contains(d))
          .toList();
      expect(labels.first, '一');
      expect(labels.last, '日');
    });
  });

  group('AntDateRangePicker showTime', () {
    testWidgets('选完日期不提交，点确定才提交', (tester) async {
      AntDateRange? changed;
      await tester.pumpWidget(
        _wrap(
          AntDateRangePicker(
            showTime: true,
            defaultValue: AntDateRange(
              start: DateTime(2024, 1, 1),
              end: DateTime(2024, 1, 5),
            ),
            onChange: (range) => changed = range,
          ),
        ),
      );
      await tester.tap(find.byType(AntDateRangePicker));
      await tester.pumpAndSettle();
      await tester.tap(_day('10'));
      await tester.pumpAndSettle();
      await tester.tap(_day('20'));
      await tester.pumpAndSettle();
      expect(changed, isNull);
      expect(find.text('确定'), findsOneWidget);
      expect(find.text('取消'), findsOneWidget);

      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(changed, isNotNull);
      expect(changed!.start, DateTime(2024, 1, 10, 0, 0));
      expect(changed!.end, DateTime(2024, 1, 20, 23, 59));
    });

    testWidgets('选择时间后提交带时间', (tester) async {
      AntDateRange? changed;
      await tester.pumpWidget(
        _wrap(
          AntDateRangePicker(
            showTime: true,
            defaultValue: AntDateRange(
              start: DateTime(2024, 1, 1),
              end: DateTime(2024, 1, 5),
            ),
            onChange: (range) => changed = range,
          ),
        ),
      );
      await tester.tap(find.byType(AntDateRangePicker));
      await tester.pumpAndSettle();
      await tester.tap(_day('10'));
      await tester.pumpAndSettle();
      await tester.tap(_day('20'));
      await tester.pumpAndSettle();

      // 起点小时滚轮选 02
      await tester.tap(
        find.descendant(
          of: find.byType(AntTimeWheel).at(0),
          matching: find.text('02'),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(changed!.start.hour, 2);
      expect(changed!.end.hour, 23);
    });

    testWidgets('取消关闭面板且不提交', (tester) async {
      AntDateRange? changed;
      await tester.pumpWidget(
        _wrap(
          AntDateRangePicker(
            showTime: true,
            defaultValue: AntDateRange(
              start: DateTime(2024, 1, 1),
              end: DateTime(2024, 1, 5),
            ),
            onChange: (range) => changed = range,
          ),
        ),
      );
      await tester.tap(find.byType(AntDateRangePicker));
      await tester.pumpAndSettle();
      await tester.tap(_day('10'));
      await tester.pumpAndSettle();
      await tester.tap(_day('20'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(changed, isNull);
      expect(find.text('确定'), findsNothing);
    });

    testWidgets('AntDateTimeRangePicker 默认开启 showTime', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntDateTimeRangePicker()),
      );
      await tester.tap(find.byType(AntDateTimeRangePicker));
      await tester.pumpAndSettle();
      expect(find.text('确定'), findsOneWidget);
    });
  });
}
