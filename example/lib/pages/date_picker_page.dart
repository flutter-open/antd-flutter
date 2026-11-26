library;

/// DatePicker 日期选择框演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class DatePickerPage extends StatelessWidget {
  const DatePickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基础用法', description: '点击弹出日历面板选择日期'),
          _BasicDemo(),
          _Section(title: '默认值', description: 'defaultValue 预填日期'),
          _DefaultValueDemo(),
          _Section(title: '清除', description: 'allowClear: true'),
          _ClearDemo(),
          _Section(title: '尺寸', description: 'size: large / middle / small'),
          _SizeDemo(),
          _Section(title: '禁用', description: 'disabled: true'),
          _DisabledDemo(),
          _Section(title: '国际化', description: 'locale 可显式指定；未指定时跟随 App 语言'),
          _LocaleDemo(),
          _Section(title: '自定义格式', description: "format: 'yyyy年M月d日'"),
          _FormatDemo(),
          _Section(title: '周一起始', description: 'weekStartsOnMonday: true'),
          _WeekStartDemo(),
          _Section(title: '日期范围', description: 'AntDateRangePicker — 两次点击选择起止'),
          _RangeDemo(),
          _Section(
            title: '日期时间范围',
            description: 'AntDateTimeRangePicker — 面板内选时间，点确定提交',
          ),
          _DateTimeRangeDemo(),
          _Section(
            title: '校验状态',
            description: 'status: error / warning 让边框与光环跟随校验色',
          ),
          _StatusDemo(),
          _Section(
            title: '可选范围',
            description: 'minDate / maxDate / disabledDate 逐日禁用',
          ),
          _DisabledDateDemo(),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, this.description});

  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.colorText,
            ),
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                description!,
                style: TextStyle(fontSize: 12, color: theme.colorTextTertiary),
              ),
            ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AntFlex(
      wrap: true,
      gap: const AntFlexGap.all(24),
      children: children,
    );
  }
}

class _BasicDemo extends StatelessWidget {
  const _BasicDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(
      children: [
        SizedBox(
          width: 220,
          child: AntDatePicker(
            placeholder: '请选择日期',
            onChange: (d) => debugPrint('date: $d'),
          ),
        ),
      ],
    );
  }
}

class _DefaultValueDemo extends StatelessWidget {
  const _DefaultValueDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(
      children: [
        SizedBox(
          width: 220,
          child: AntDatePicker(
            defaultValue: DateTime(2024, 6, 1),
            onChange: (d) => debugPrint('date: $d'),
          ),
        ),
      ],
    );
  }
}

class _ClearDemo extends StatelessWidget {
  const _ClearDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(
      children: [
        SizedBox(
          width: 220,
          child: AntDatePicker(
            defaultValue: DateTime(2024, 6, 1),
            allowClear: true,
          ),
        ),
      ],
    );
  }
}

class _SizeDemo extends StatelessWidget {
  const _SizeDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(
      children: [
        SizedBox(
          width: 200,
          child: AntDatePicker(
            size: AntDatePickerSize.large,
            placeholder: '大号',
          ),
        ),
        SizedBox(
          width: 200,
          child: AntDatePicker(
            size: AntDatePickerSize.middle,
            placeholder: '中号',
          ),
        ),
        SizedBox(
          width: 200,
          child: AntDatePicker(
            size: AntDatePickerSize.small,
            placeholder: '小号',
          ),
        ),
      ],
    );
  }
}

class _DisabledDemo extends StatelessWidget {
  const _DisabledDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(
      children: [
        SizedBox(
          width: 220,
          child: AntDatePicker(disabled: true, placeholder: '禁用'),
        ),
      ],
    );
  }
}

class _LocaleDemo extends StatelessWidget {
  const _LocaleDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(
      children: [
        SizedBox(
          width: 220,
          child: AntDatePicker(locale: AntPickerLocale.zh, placeholder: '中文'),
        ),
        SizedBox(
          width: 220,
          child: AntDatePicker(locale: AntPickerLocale.en, placeholder: '中文'),
        ),
        SizedBox(
          width: 220,
          child: AntDatePicker(locale: AntPickerLocale.ja, placeholder: '中文'),
        ),
      ],
    );
  }
}

class _FormatDemo extends StatelessWidget {
  const _FormatDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(
      children: [
        SizedBox(
          width: 240,
          child: AntDatePicker(
            defaultValue: DateTime(2024, 6, 1),
            format: 'yyyy年M月d日',
          ),
        ),
        SizedBox(
          width: 240,
          child: AntDatePicker(
            defaultValue: DateTime(2024, 6, 1),
            format: 'MM/dd/yyyy',
          ),
        ),
      ],
    );
  }
}

class _WeekStartDemo extends StatelessWidget {
  const _WeekStartDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(
      children: [
        SizedBox(
          width: 220,
          child: AntDatePicker(
            defaultValue: DateTime(2024, 6, 1),
            weekStartsOnMonday: true,
          ),
        ),
      ],
    );
  }
}

class _RangeDemo extends StatelessWidget {
  const _RangeDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(
      children: [
        SizedBox(
          width: 340,
          child: AntDateRangePicker(
            defaultValue: AntDateRange.sorted(
              DateTime(2024, 6, 1),
              DateTime(2024, 6, 15),
            ),
            onChange: (range) =>
                debugPrint('range: ${range?.start} ~ ${range?.end}'),
          ),
        ),
        SizedBox(
          width: 340,
          child: AntDateRangePicker(
            allowClear: true,
            locale: AntPickerLocale.en,
            onChange: (range) => debugPrint('range: $range'),
          ),
        ),
      ],
    );
  }
}

class _DateTimeRangeDemo extends StatelessWidget {
  const _DateTimeRangeDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(
      children: [
        SizedBox(
          width: 360,
          child: AntDateTimeRangePicker(
            allowClear: true,
            onChange: (range) => debugPrint('datetime range: $range'),
          ),
        ),
      ],
    );
  }
}

class _StatusDemo extends StatelessWidget {
  const _StatusDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(
      children: [
        SizedBox(
          width: 200,
          child: AntDatePicker(
            placeholder: 'error 状态',
            status: AntInputStatus.error,
          ),
        ),
        SizedBox(
          width: 200,
          child: AntDatePicker(
            placeholder: 'warning 状态',
            status: AntInputStatus.warning,
          ),
        ),
        SizedBox(
          width: 200,
          child: AntTimePicker(
            placeholder: 'error 状态',
            status: AntInputStatus.error,
          ),
        ),
      ],
    );
  }
}

class _DisabledDateDemo extends StatelessWidget {
  const _DisabledDateDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(
      children: [
        SizedBox(
          width: 220,
          child: AntDatePicker(
            placeholder: '仅可选 2024 年',
            minDate: DateTime(2024, 1, 1),
            maxDate: DateTime(2024, 12, 31),
            defaultValue: DateTime(2024, 6, 15),
          ),
        ),
        SizedBox(
          width: 220,
          child: AntDatePicker(
            placeholder: '仅可选工作日',
            defaultValue: DateTime(2024, 6, 17),
            disabledDate: (date) =>
                date.weekday == DateTime.saturday ||
                date.weekday == DateTime.sunday,
          ),
        ),
      ],
    );
  }
}
