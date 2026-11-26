/// antd_picker — antd-mobile 弹层选择器族独立组件包（Picker / DatePicker / TimePicker / Cascader）
///
/// 从主包 antd_flutter_plus（此前误迁 ui）拆分的独立组件包：
/// - [AntPicker] — 滚轮选择器（单列 / 多列联动，对齐 antd-mobile Picker API）
/// - [AntDatePicker] — 日期选择器（年月日，对齐 antd-mobile DatePicker API）
/// - [AntDateRangePicker] — 日期范围选择器（对齐 antd React DatePicker.RangePicker）
/// - [AntDateTimeRangePicker] — 日期时间范围选择器（RangePicker + showTime）
/// - [AntPickerLocale] — 选择器族国际化文案（并可经 AntPickerLocaleProvider 全局生效）
/// - [AntTimePicker] — 时间选择器（时分秒，对齐 antd-mobile TimePicker API）
/// - [AntCascader] — 级联选择器（对齐 antd-mobile Cascader API）
/// - [AntCascaderView] — 内嵌级联视图（不弹层直接内嵌）
///
/// 归属边界：AntPickerView（ui display/picker_view）为通用文字滚轮视图，
/// 留在 antd_flutter_ui 不迁；本包 [AntPicker] 使用包内自建泛型滚轮
/// （CupertinoPicker）以支持 `labelBuilder` 渲染任意 Widget。
/// 滚轮引擎（wheel_picker_engine / wheel_column_model）同为 ui 共享引擎，留 ui。
///
/// 数据源一律泛型：`AntPicker<T>` / `AntPickerColumn<T>` / `AntCascader<T>` /
/// `AntCascaderView<T>` 直接吃用户模型，不构造组件库内部的 String 选项。
///
/// 依赖方向约定：antd_picker → antd_flutter_ui → antd_theme/tokens/color/icons，
/// 不依赖其他独立组件包。
/// 弹层选择器类组件（Overlay 弹层选择，非滚动场景），不需要 sliver 支持（R33）。
/// 主包 antd_flutter_plus 经 re-export 保持对外兼容。
library;

export 'src/picker/ant_picker.dart';
export 'src/picker/ant_picker_types.dart';

export 'src/date_picker/ant_date_picker.dart';
export 'src/date_picker/ant_date_picker_types.dart';
export 'src/date_picker/ant_date_range_picker.dart';
export 'src/date_picker/ant_date_range_types.dart';

export 'src/locale/ant_picker_locale.dart';

export 'src/time_picker/ant_time_picker.dart';
export 'src/time_picker/ant_time_picker_types.dart';

export 'src/cascader/ant_cascader.dart';
export 'src/cascader/ant_cascader_types.dart';
export 'src/cascader/ant_cascader_view.dart';
