library;

/// Select 选择器演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class SelectPage extends StatelessWidget {
  const SelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基础用法', description: '单选下拉选择器'),
          _BasicDemo(),
          _Section(title: '多选', description: 'mode: multiple'),
          _MultipleDemo(),
          _Section(title: '搜索', description: 'showSearch: true'),
          _SearchDemo(),
          _Section(title: '清除', description: 'allowClear: true'),
          _ClearDemo(),
          _Section(title: '加载中', description: 'loading: true'),
          _LoadingDemo(),
          _Section(title: '尺寸', description: 'size: large / middle / small'),
          _SizeDemo(),
          _Section(title: '禁用', description: 'disabled: true'),
          _DisabledDemo(),
          _Section(
            title: '自定义模型',
            description: 'options: List<City> + labelOf / valueExtractor',
          ),
          _CustomModelDemo(),
          _Section(
            title: '标签折叠',
            description: 'maxTagCount: 2 — 超出部分显示 +N',
          ),
          _MaxTagCountDemo(),
          _Section(
            title: '校验状态',
            description: 'status: error / warning',
          ),
          _StatusDemo(),
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
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AntTitle(title, level: AntTitleLevel.h4),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: AntText(
                text: description!,
                type: AntTypographyType.secondary,
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

/// 字符串选项：label 即选项本身。
const _options = ['选项一', '选项二', '选项三', '选项四'];

class _BasicDemo extends StatelessWidget {
  const _BasicDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(
      children: [
        SizedBox(
          width: 200,
          child: AntSelect<String>(
            options: _options,
            placeholder: '请选择',
            onChange: (v) => debugPrint('selected: $v'),
          ),
        ),
      ],
    );
  }
}

class _MultipleDemo extends StatelessWidget {
  const _MultipleDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(
      children: [
        SizedBox(
          width: 260,
          child: AntSelect<String>(
            mode: AntSelectMode.multiple,
            options: _options,
            placeholder: '多选',
            onChangeMultiple: (v) => debugPrint('selected: $v'),
          ),
        ),
      ],
    );
  }
}

class _SearchDemo extends StatelessWidget {
  const _SearchDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(
      children: [
        SizedBox(
          width: 200,
          child: AntSelect<String>(
            options: _options,
            showSearch: true,
            placeholder: '搜索选择',
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
          width: 200,
          child: AntSelect<String>(
            options: _options,
            defaultValue: '选项一',
            allowClear: true,
          ),
        ),
      ],
    );
  }
}

class _LoadingDemo extends StatelessWidget {
  const _LoadingDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(
      children: [
        SizedBox(
          width: 200,
          child: AntSelect<String>(
            options: const [],
            loading: true,
            placeholder: '加载中',
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
          width: 180,
          child: AntSelect<String>(
            options: _options,
            size: AntSelectSize.large,
            placeholder: '大号',
          ),
        ),
        SizedBox(
          width: 180,
          child: AntSelect<String>(
            options: _options,
            size: AntSelectSize.middle,
            placeholder: '中号',
          ),
        ),
        SizedBox(
          width: 180,
          child: AntSelect<String>(
            options: _options,
            size: AntSelectSize.small,
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
          width: 200,
          child: AntSelect<String>(
            options: _options,
            disabled: true,
            placeholder: '禁用',
          ),
        ),
      ],
    );
  }
}

/// 用户自己的领域模型——无需构造任何 AntXxxOption。
class City {
  const City(this.id, this.name, {this.disabled = false});

  final String id;
  final String name;
  final bool disabled;

  @override
  String toString() => name;
}

const _cities = [
  City('sh', '上海'),
  City('bj', '北京'),
  City('gz', '广州'),
  City('sz', '深圳', disabled: true),
];

class _CustomModelDemo extends StatefulWidget {
  const _CustomModelDemo();

  @override
  State<_CustomModelDemo> createState() => _CustomModelDemoState();
}

class _CustomModelDemoState extends State<_CustomModelDemo> {
  City? _city = _cities.first;
  List<City> _cities2 = [_cities[1]];

  @override
  Widget build(BuildContext context) {
    return _Row(
      children: [
        SizedBox(
          width: 200,
          child: AntSelect<City>(
            options: _cities,
            value: _city,
            labelOf: (city) => city.name,
            valueExtractor: (city) => city.id,
            disabledOf: (city) => city.disabled,
            onChange: (city) => setState(() => _city = city),
          ),
        ),
        SizedBox(
          width: 260,
          child: AntSelect<City>(
            mode: AntSelectMode.multiple,
            options: _cities,
            values: _cities2,
            labelOf: (city) => city.name,
            valueExtractor: (city) => city.id,
            onChangeMultiple: (cities) => setState(() => _cities2 = cities),
          ),
        ),
      ],
    );
  }
}

class _MaxTagCountDemo extends StatelessWidget {
  const _MaxTagCountDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(
      children: [
        SizedBox(
          width: 320,
          child: AntSelect<String>(
            mode: AntSelectMode.multiple,
            options: const ['杭州', '宁波', '苏州', '南京'],
            defaultValues: const ['杭州', '宁波', '苏州', '南京'],
            maxTagCount: 2,
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
          child: AntSelect<String>(
            options: const ['杭州', '宁波'],
            placeholder: 'error 状态',
            status: AntInputStatus.error,
          ),
        ),
        SizedBox(
          width: 200,
          child: AntSelect<String>(
            options: const ['杭州', '宁波'],
            placeholder: 'warning 状态',
            status: AntInputStatus.warning,
          ),
        ),
      ],
    );
  }
}
