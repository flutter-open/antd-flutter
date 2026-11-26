# Changelog

## 1.1.0

- Add `AntDateRangePicker`: pick a start and an end date in one panel, with `allowClear`, `minDate` / `maxDate`, `weekStartsOnMonday`, `showToday` and automatic start/end ordering.
- Add `AntDateTimeRangePicker`: a `AntDateRangePicker` subclass whose `showTime` defaults to `true`, adding hour/minute columns plus confirm/cancel actions inside the same panel.
- Add `AntPickerLocale` and `AntPickerLocaleProvider`: 15 built-in language presets (`zh`, `zhTw`, `en`, `ja`, `ko`, `fr`, `de`, `es`, `ru`, `pt`, `it`, `ar`, `th`, `vi`, `id`) with per-field fallback, custom `messages`, and automatic resolution from the app's `Localizations` locale.
- `AntDatePicker` / `AntTimePicker` now localize the placeholder, month title, weekday labels, confirm/cancel and Today copy in place of hard-coded Chinese strings (issue #5), and accept a per-widget `locale:` argument.
- `AntDatePicker`'s `format` argument is now honored; `format` / `timeFormat` accept antd patterns such as `yyyy-MM-dd`, `yyyy年M月d日`, `HH:mm` and `hh:mm a`.
- `AntDatePicker` renders a fixed 6x7 month grid, so the panel no longer changes height between months, and adds `weekStartsOnMonday` / `showToday` options.
- `AntCascader` trigger: the open state now uses a 1px `colorPrimary` border plus a solid `controlOutline` ring drawn in the foreground layer, instead of a 2px translucent outline that shifted the content by 1px.
- Depend on `antd_flutter_ui ^1.0.5`: the popup engine keeps a long date-time range panel fully on screen instead of clipping it at the viewport edge.
- `AntTimePicker` control height now follows the `controlHeight` / `controlHeightSM` / `controlHeightLG` tokens, and its wheel keeps a single `ScrollController` instead of recreating (and leaking) one on every build.

## 1.0.2

- DatePicker trigger: the open state now uses a `colorPrimary` 1px border plus a solid `controlOutline` ring instead of a pale 2px outline, so the focus treatment matches antd and follows the primary color.
- DatePicker trigger: the border is drawn in the foreground layer, so opening the panel no longer changes the content box — text no longer shifts on open/close.
- DatePicker trigger: height now follows `controlHeight` / `controlHeightSM` / `controlHeightLG` tokens instead of hard-coded `40` / `32` / `24`.
- Depend on `antd_flutter_ui ^1.0.4`.

## 1.0.1

- Fix pub.dev static analysis results by aligning internal dependency constraints.
- Ship the package example and tighten pubspec metadata for better pub.dev scoring.
- Documentation and changelog polish.

## 1.0.0

### AntPicker

- Generic `AntPicker<T>` built on `AntPickerColumn<T>`: columns consume your own model type, with
  `keyOf` for identity and `labelBuilder` for rendering.
- Bottom sheet presentation with title, confirm/cancel labels, independent column scrolling and
  mask-tap closing.
- Controlled and uncontrolled modes: `value` / `defaultValue` accept either models or keys;
  `visible` / `onClose` allow programmatic opening and closing.
- `onSelect` reports scrolling changes and `onConfirm` returns the selected model per column;
  `itemHeight` and `pickerHeight` tune wheel geometry.

### AntCascader

- Generic cascader `AntCascader<T>` over a tree supplied by `dataSource`, `childrenOf`, `keyOf`,
  `labelBuilder` and `disabledOf`.
- Overlay panel with level-by-level expansion, click or hover triggers, clear affordance and
  `changeOnSelect` for committing at intermediate levels.
- Controlled and uncontrolled path values; paths may contain models or keys.
- `size` variants (`large`, `middle`, `small`) and `placeholder` for the empty state.

### AntCascaderView

- Embedded cascade view with a tab bar per level and no popup, for inline form and side-panel use.
- `onChange` exposes both the selected model path and per-level slots (unselected levels are null);
  `onTabsChange`, `activeIcon` and `height` customize navigation and layout.

### AntDatePicker and AntTimePicker

- Anchored picker panels that open below the field and close on selection.
- Controlled/uncontrolled values, `allowClear`, `disabled`, size variants and `labelBuilder`.
- Date panel supports month navigation and a configurable `format` for the field text.
- Time panel supports hour, minute and second steps (`hourStep`, `minuteStep`, `secondStep`).
- Wheel behaviour comes from the shared engine in `antd_flutter_ui`, keeping snapping and item
  metrics consistent with the rest of the picker family.
