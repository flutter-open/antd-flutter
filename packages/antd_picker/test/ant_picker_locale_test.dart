/// AntPickerLocale 与日期格式化测试 —— issue #5「日期写死没适配国际化」
///
/// 覆盖：
/// - 内建语言预设与语言码解析（zh / zh-TW / en / 未知回退 zh）
/// - 字段级回退（未填字段 → 同语言预设 → 中文）
/// - 周标签周一起始轮转、年月标题模板
/// - resolve 优先级：显式参数 → Provider → App Localizations → zh
/// - 日期/时间格式化模板
library;

import 'package:antd_picker/antd_picker.dart';
import 'package:antd_picker/src/locale/ant_date_format.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _pickerHost(Widget child, {Locale locale = const Locale('en')}) {
  return MaterialApp(
    locale: locale,
    home: Scaffold(
      body: AntTheme(
        data: AntThemeData.light(),
        child: Material(child: child),
      ),
    ),
  );
}

void main() {
  group('AntPickerLocale 预设', () {
    test('zh 预设字段', () {
      const zh = AntPickerLocale.zh;
      expect(zh.effectiveDatePlaceholder, '请选择日期');
      expect(zh.effectiveTimePlaceholder, '请选择时间');
      expect(zh.effectiveConfirmText, '确定');
      expect(zh.effectiveCancelText, '取消');
      expect(zh.effectiveTodayText, '今天');
      expect(zh.effectiveRangeSeparator, '~');
      expect(zh.effectiveDateFormat, 'yyyy-MM-dd');
      expect(zh.monthTitle(2024, 1), '2024年1月');
    });

    test('en 预设字段', () {
      const en = AntPickerLocale.en;
      expect(en.effectiveDatePlaceholder, 'Select date');
      expect(en.effectiveConfirmText, 'OK');
      expect(en.effectiveDateFormat, 'MM/dd/yyyy');
      expect(en.monthTitle(2024, 1), '1/2024');
    });

    test('fromLanguageCode 解析常见写法', () {
      expect(AntPickerLocale.fromLanguageCode('zh'), AntPickerLocale.zh);
      expect(AntPickerLocale.fromLanguageCode('zh_CN'), AntPickerLocale.zh);
      expect(AntPickerLocale.fromLanguageCode('zh-Hans'), AntPickerLocale.zh);
      expect(AntPickerLocale.fromLanguageCode('zh-TW'), AntPickerLocale.zhTw);
      expect(AntPickerLocale.fromLanguageCode('en-US'), AntPickerLocale.en);
      expect(AntPickerLocale.fromLanguageCode('ja_JP'), AntPickerLocale.ja);
      // 未知语言回退中文
      expect(
        AntPickerLocale.fromLanguageCode('xx-YY'),
        AntPickerLocale.zh,
      );
    });

    test('未填字段逐级回退：自定义 → 同语言预设 → 中文', () {
      const partial = AntPickerLocale(
        languageCode: 'en',
        datePlaceholder: 'Pick a day',
      );
      expect(partial.effectiveDatePlaceholder, 'Pick a day');
      // 未填字段取同语言（en）预设
      expect(partial.effectiveConfirmText, 'OK');
      expect(partial.effectiveTodayText, 'Today');

      // 未知语言且未填字段 → 中文最终回退
      const unknown = AntPickerLocale(languageCode: 'xx');
      expect(unknown.effectiveDatePlaceholder, '请选择日期');
      expect(unknown.effectiveConfirmText, '确定');
    });

    test('messages 扩展文案', () {
      const custom = AntPickerLocale(
        languageCode: 'zh',
        messages: {'rangeTip': '最多选择 30 天'},
      );
      expect(custom.text('rangeTip'), '最多选择 30 天');
      expect(custom.text('missing', '兜底'), '兜底');
      expect(custom.text('missing'), 'missing');
    });

    test('周标签随周起始轮转', () {
      const zh = AntPickerLocale.zh;
      expect(zh.weekLabelsFor(weekStartsOnMonday: true), [
        '一',
        '二',
        '三',
        '四',
        '五',
        '六',
        '日',
      ]);
      expect(zh.weekLabelsFor(weekStartsOnMonday: false), [
        '日',
        '一',
        '二',
        '三',
        '四',
        '五',
        '六',
      ]);

      const en = AntPickerLocale.en;
      expect(en.weekLabelsFor(weekStartsOnMonday: false).first, 'Sun');
      expect(en.weekLabelsFor(weekStartsOnMonday: true).first, 'Mon');
    });

    test('相等性按字段比较', () {
      expect(
        const AntPickerLocale(languageCode: 'zh', datePlaceholder: '选日期'),
        const AntPickerLocale(languageCode: 'zh', datePlaceholder: '选日期'),
      );
      expect(
        const AntPickerLocale(languageCode: 'zh', datePlaceholder: '选日期'),
        isNot(const AntPickerLocale(languageCode: 'zh')),
      );
    });
  });

  group('AntPickerLocale.resolve 优先级', () {
    Future<AntPickerLocale> resolveIn(
      WidgetTester tester, {
      AntPickerLocale? explicit,
      AntPickerLocale? injected,
      Locale appLocale = const Locale('en'),
    }) async {
      late AntPickerLocale resolved;
      final probe = Builder(
        builder: (context) {
          resolved = AntPickerLocale.resolve(context, explicit);
          return const SizedBox();
        },
      );
      Widget page = probe;
      if (injected != null) {
        page = AntPickerLocaleProvider(locale: injected, child: page);
      }
      await tester.pumpWidget(MaterialApp(locale: appLocale, home: page));
      return resolved;
    }

    testWidgets('显式参数优先', (tester) async {
      final locale = await resolveIn(
        tester,
        explicit: AntPickerLocale.zh,
        injected: AntPickerLocale.en,
      );
      expect(locale, AntPickerLocale.zh);
    });

    testWidgets('Provider 优先于 App 语言', (tester) async {
      final locale = await resolveIn(tester, injected: AntPickerLocale.zhTw);
      expect(locale, AntPickerLocale.zhTw);
    });

    testWidgets('未注入时跟随 App 语言', (tester) async {
      final locale = await resolveIn(tester);
      expect(locale, AntPickerLocale.en);
    });
  });

  group('formatAntDate / formatAntTimeOfDay', () {
    final date = DateTime(2024, 1, 5, 9, 30, 7);

    test('yyyy-MM-dd / MM/dd/yyyy / yyyy/M/d', () {
      expect(formatAntDate(date, 'yyyy-MM-dd'), '2024-01-05');
      expect(formatAntDate(date, 'MM/dd/yyyy'), '01/05/2024');
      expect(formatAntDate(date, 'yyyy/M/d'), '2024/1/5');
      expect(formatAntDate(date, 'yy-MM-dd'), '24-01-05');
    });

    test('年月日字面量直接拼接', () {
      expect(formatAntDate(date, 'yyyy年M月d日'), '2024年1月5日');
    });

    test('时间：24 小时制与 12 小时制', () {
      expect(formatAntDate(date, 'HH:mm:ss'), '09:30:07');
      expect(formatAntDate(date, 'H:m:s'), '9:30:7');
      expect(formatAntDate(date, 'h:mm a'), '9:30 AM');
      expect(formatAntDate(date, 'hh:mm a'), '09:30 AM');
      expect(
        formatAntDate(DateTime(2024, 1, 5, 0, 5), 'h:mm a'),
        '12:05 AM',
      );
      expect(
        formatAntDate(DateTime(2024, 1, 5, 23, 59), 'h:mm a'),
        '11:59 PM',
      );
    });

    test('formatAntTimeOfDay', () {
      expect(
        formatAntTimeOfDay(const TimeOfDay(hour: 8, minute: 5), 'HH:mm'),
        '08:05',
      );
      expect(
        formatAntTimeOfDay(const TimeOfDay(hour: 20, minute: 0), 'hh:mm a'),
        '08:00 PM',
      );
    });
  });

  group('AntDatePicker 跟随国际化', () {
    testWidgets('App 语言为英文时默认显示英文文案', (tester) async {
      await tester.pumpWidget(_pickerHost(const AntDatePicker()));
      expect(find.text('Select date'), findsOneWidget);
    });

    testWidgets('显式 zh locale 显示中文文案（issue #5）', (tester) async {
      await tester.pumpWidget(
        _pickerHost(const AntDatePicker(locale: AntPickerLocale.zh)),
      );
      expect(find.text('请选择日期'), findsOneWidget);
      expect(find.text('Select date'), findsNothing);
    });

    testWidgets('面板月标题与周标签随 locale', (tester) async {
      await tester.pumpWidget(
        _pickerHost(
          AntDatePicker(
            defaultValue: DateTime(2024, 1, 15),
            locale: AntPickerLocale.zh,
          ),
          locale: const Locale('zh'),
        ),
      );
      await tester.tap(find.byType(AntDatePicker));
      await tester.pumpAndSettle();
      expect(find.text('2024年1月'), findsOneWidget);
      expect(find.text('日'), findsOneWidget);
      expect(find.textContaining('January'), findsNothing);
    });

    testWidgets('英文面板显示英文月标题', (tester) async {
      await tester.pumpWidget(
        _pickerHost(
          AntDatePicker(defaultValue: DateTime(2024, 1, 15)),
        ),
      );
      await tester.tap(find.byType(AntDatePicker));
      await tester.pumpAndSettle();
      expect(find.text('1/2024'), findsOneWidget);
    });

    testWidgets('format 参数覆盖默认格式', (tester) async {
      await tester.pumpWidget(
        _pickerHost(
          AntDatePicker(
            defaultValue: DateTime(2024, 1, 15),
            format: 'yyyy年M月d日',
            locale: AntPickerLocale.zh,
          ),
        ),
      );
      expect(find.text('2024年1月15日'), findsOneWidget);
    });
  });
}
