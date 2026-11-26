/// AntFormItem 间距与提示色配置（issue #8）。
///
/// 覆盖：
/// - 默认底部间距取主题 margin 令牌，带帮助文案时归零（antd `with-help` 语义）
/// - [AntForm.itemMarginBottom] / [AntFormItem.marginBottom] 两级覆盖
/// - 帮助文案颜色可通过 [AntForm.hintColor] / [AntFormItem.hintColor] 配置
/// - 标签颜色可通过 [AntForm.labelColor] 配置
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_form/antd_form.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Widget _wrap(Widget child) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Material(child: child),
        ),
      ),
    );

/// 表单项最外层用于控制间距的 Padding（AntFormItem 下第一个 Padding）。
Padding _itemPadding(WidgetTester tester) {
  return tester.widget<Padding>(
    find
        .descendant(
          of: find.byType(AntFormItem<String>),
          matching: find.byType(Padding),
        )
        .first,
  );
}

double _bottomMargin(WidgetTester tester) =>
    _itemPadding(tester).padding.resolve(TextDirection.ltr).bottom;

void main() {
  final theme = AntThemeData.light();

  testWidgets('无帮助文案：底部间距取主题 margin 令牌', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AntForm(
          children: [
            AntFormItem<String>(
              name: 'a',
              label: '账号',
              builder: (field) => AntInput(
                value: field.value ?? '',
                onChange: field.didChange,
              ),
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(_bottomMargin(tester), theme.margin);
  });

  testWidgets('带帮助文案：底部间距归零，避免文案下方多出空白', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AntForm(
          children: [
            AntFormItem<String>(
              name: 'a',
              label: '账号',
              help: '证件有效期须大于 60 天',
              builder: (field) => AntInput(
                value: field.value ?? '',
                onChange: field.didChange,
              ),
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(_bottomMargin(tester), 0);
    expect(find.text('证件有效期须大于 60 天'), findsOneWidget);
  });

  testWidgets('AntForm.itemMarginBottom 覆盖默认值（含帮助文案时）', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AntForm(
          itemMarginBottom: 24,
          children: [
            AntFormItem<String>(
              name: 'a',
              label: '账号',
              help: '说明',
              builder: (field) => AntInput(
                value: field.value ?? '',
                onChange: field.didChange,
              ),
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(_bottomMargin(tester), 24);
  });

  testWidgets('AntFormItem.marginBottom 优先于表单级配置', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AntForm(
          itemMarginBottom: 24,
          children: [
            AntFormItem<String>(
              name: 'a',
              label: '账号',
              marginBottom: 8,
              builder: (field) => AntInput(
                value: field.value ?? '',
                onChange: field.didChange,
              ),
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(_bottomMargin(tester), 8);
  });

  testWidgets('帮助文案颜色默认取 colorTextDescription', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AntForm(
          children: [
            AntFormItem<String>(
              name: 'a',
              label: '账号',
              help: '默认提示色',
              builder: (field) => AntInput(
                value: field.value ?? '',
                onChange: field.didChange,
              ),
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    final text = tester.widget<Text>(find.text('默认提示色'));
    expect(text.style?.color, theme.colorTextDescription);
  });

  testWidgets('hintColor 可在表单级与字段级配置', (tester) async {
    const formHint = Color(0xFF112233);
    const itemHint = Color(0xFF445566);

    await tester.pumpWidget(
      _wrap(
        AntForm(
          hintColor: formHint,
          children: [
            AntFormItem<String>(
              name: 'a',
              label: '账号',
              help: '表单级',
              builder: (field) => AntInput(
                value: field.value ?? '',
                onChange: field.didChange,
              ),
            ),
            AntFormItem<String>(
              name: 'b',
              label: '邮箱',
              help: '字段级',
              hintColor: itemHint,
              builder: (field) => AntInput(
                value: field.value ?? '',
                onChange: field.didChange,
              ),
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.widget<Text>(find.text('表单级')).style?.color, formHint);
    expect(tester.widget<Text>(find.text('字段级')).style?.color, itemHint);
  });

  testWidgets('labelColor 可配置', (tester) async {
    const labelColor = Color(0xFF778899);
    await tester.pumpWidget(
      _wrap(
        AntForm(
          labelColor: labelColor,
          children: [
            AntFormItem<String>(
              name: 'a',
              label: '账号',
              builder: (field) => AntInput(
                value: field.value ?? '',
                onChange: field.didChange,
              ),
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.widget<Text>(find.text('账号')).style?.color, labelColor);
  });
}
