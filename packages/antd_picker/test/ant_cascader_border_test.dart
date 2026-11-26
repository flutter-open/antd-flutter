/// AntCascader 触发器边框 / 光环回归（issue #7 同族：打开态取主色 1px 边框 +
/// 无模糊实心外扩环，边框画在前景层不参与布局）。
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_picker/antd_picker.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

class _Region {
  const _Region(this.code, this.name, {this.children = const <_Region>[]});

  final String code;
  final String name;
  final List<_Region> children;
}

const _regions = <_Region>[
  _Region('zj', '浙江', children: [_Region('hz', '杭州')]),
  _Region('js', '江苏', children: [_Region('nj', '南京')]),
];

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
  Finder root,
) {
  for (final container in tester.widgetList<Container>(
    find.descendant(of: root, matching: find.byType(Container)),
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

BorderSide _side(BoxDecoration decoration) =>
    (decoration.border! as Border).top;

void main() {
  final theme = AntThemeData.light();

  testWidgets('Cascader 打开态：主色 1px 边框 + controlOutline 实心环', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        AntCascader<_Region>(
          dataSource: _regions,
          keyOf: (region) => region.code,
          childrenOf: (region) => region.children,
          placeholder: '请选择',
        ),
      ),
    );
    await tester.pumpAndSettle();

    var surface = _surfaceOf(tester, find.byType(AntCascader<_Region>));
    expect(_side(surface.border).color, theme.colorBorder);
    expect(_side(surface.border).width, 1);
    expect(surface.surface?.boxShadow ?? const <BoxShadow>[], isEmpty);

    await tester.tap(find.byType(AntCascader<_Region>));
    await tester.pumpAndSettle();

    surface = _surfaceOf(tester, find.byType(AntCascader<_Region>));
    expect(_side(surface.border).color, theme.colorPrimary);
    expect(_side(surface.border).width, 1);
    final ring = surface.surface!.boxShadow!;
    expect(ring, hasLength(1));
    expect(ring.single.color, theme.controlOutline);
    expect(ring.single.blurRadius, 0);
    expect(ring.single.spreadRadius, theme.controlOutlineWidth);
  });
}
