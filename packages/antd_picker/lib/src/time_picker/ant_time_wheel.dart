/// 时间滚轮列（内部共享组件）。
///
/// 由 `AntTimePicker` 与 `AntDateRangePicker(showTime: true)` 复用：
/// - 控制器只在 state 初始化时创建一次并随组件销毁释放
///   （旧实现每次 build 新建 `ScrollController`，既不释放也会重置滚动位置）；
/// - 外部改变 [selectedIndex] 时按固定行高跳转到对应位置；
/// - [enabled] 为 false 时置灰且不响应点击（范围未选完时的禁用态）。
library;

import 'dart:math' as math;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

/// 单列时间滚轮。
class AntTimeWheel extends StatefulWidget {
  /// 创建滚轮列。
  const AntTimeWheel({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.theme,
    required this.onSelected,
    this.height = 180,
    this.itemExtent = 36,
    this.enabled = true,
  });

  /// 选项文案。
  final List<String> items;

  /// 当前选中下标。
  final int selectedIndex;

  /// 主题数据。
  final AntThemeData theme;

  /// 选中回调。
  final ValueChanged<int> onSelected;

  /// 可视高度（逻辑像素，未缩放）。
  final double height;

  /// 单行高度（逻辑像素，未缩放）。
  final double itemExtent;

  /// 是否可交互；false 时置灰。
  final bool enabled;

  @override
  State<AntTimeWheel> createState() => _AntTimeWheelState();
}

class _AntTimeWheelState extends State<AntTimeWheel> {
  late ScrollController _controller;

  double get _itemExtent => widget.theme.s(widget.itemExtent);

  @override
  void initState() {
    super.initState();
    _controller = ScrollController(
      initialScrollOffset: _offsetFor(widget.selectedIndex),
    );
  }

  @override
  void didUpdateWidget(covariant AntTimeWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex ||
        oldWidget.itemExtent != widget.itemExtent) {
      final target = _offsetFor(widget.selectedIndex);
      if (_controller.hasClients) {
        _controller.jumpTo(target);
      } else {
        _controller.dispose();
        _controller = ScrollController(initialScrollOffset: target);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _offsetFor(int index) => math.max(0, index - 2) * _itemExtent;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return SizedBox(
      height: theme.s(widget.height),
      child: Opacity(
        opacity: widget.enabled ? 1 : 0.45,
        child: IgnorePointer(
          ignoring: !widget.enabled,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            controller: _controller,
            itemExtent: _itemExtent,
            scrollDirection: Axis.vertical,
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final selected = index == widget.selectedIndex;
              return GestureDetector(
                onTap: () => widget.onSelected(index),
                child: Container(
                  alignment: Alignment.center,
                  color:
                      selected ? theme.colorFillSecondary : Colors.transparent,
                  child: Text(
                    widget.items[index],
                    style: TextStyle(
                      fontSize: theme.fontSize,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      color: selected ? theme.colorPrimary : theme.colorText,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
