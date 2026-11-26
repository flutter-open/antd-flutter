/// 录入类控件共享的边框 / 焦点光环装饰。
///
/// antd web 的聚焦观感是「1px 主色边框 + 2px 无模糊实心外扩环」，且边框
/// 加粗不参与布局。这里把该装饰单点收口，供 Input 家族之外的 Select、
/// Cascader、TreeSelect、Mentions、AutoComplete 复用，避免各组件各写一套
/// 导致风格漂移：
/// - 曾把打开态边框直接换成半透明的 `controlOutline` 且宽度翻倍，视觉上是
///   一圈发灰/发淡的粗边（用户反馈「边框颜色不对」），并且让内容抖动 1px；
/// - 正确做法是边框恒 1px、打开态取主色，光环交给 `antFieldFocusRingOf`
///   以 spread 半径画在外侧（`foregroundDecoration` 不参与布局）。
library;

export 'ant_input_field.dart'
    show
        antFieldBorderColorOf,
        antFieldFocusOutlineOf,
        antFieldFocusRingOf;
export 'ant_input_types.dart' show AntInputStatus;
