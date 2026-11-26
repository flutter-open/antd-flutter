/// AntTreeSelect 触发器边框 / 光环回归（issue #7 同族：打开态取主色 1px 边框 +
/// 无模糊实心外扩环，边框画在前景层不参与布局）。
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:antd_tree/antd_tree.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

class _Node {
  const _Node(this.id, this.name, {this.children = const <_Node>[]});

  final int id;
  final String name;
  final List<_Node> children;
}

const _nodes = <_Node>[
  _Node(1, '浙江', children: [_Node(2, '杭州')]),
  _Node(3, '江苏'),
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

  testWidgets('TreeSelect 打开态：主色 1px 边框 + controlOutline 实心环', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        AntTreeSelect<_Node>(
          dataSource: _nodes,
          keyOf: (node) => node.id,
          labelOf: (node) => node.name,
          titleBuilder: (context, node) => Text(node.name),
          childrenOf: (node) => node.children,
          placeholder: '请选择',
        ),
      ),
    );
    await tester.pumpAndSettle();

    var surface = _surfaceOf(tester, find.byType(AntTreeSelect<_Node>));
    expect(_side(surface.border).color, theme.colorBorder);
    expect(_side(surface.border).width, 1);
    expect(surface.surface?.boxShadow ?? const <BoxShadow>[], isEmpty);

    await tester.tap(find.byType(AntTreeSelect<_Node>));
    await tester.pumpAndSettle();

    surface = _surfaceOf(tester, find.byType(AntTreeSelect<_Node>));
    expect(_side(surface.border).color, theme.colorPrimary);
    expect(_side(surface.border).width, 1);
    final ring = surface.surface!.boxShadow!;
    expect(ring, hasLength(1));
    expect(ring.single.color, theme.controlOutline);
    expect(ring.single.blurRadius, 0);
    expect(ring.single.spreadRadius, theme.controlOutlineWidth);
  });
}
