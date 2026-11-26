# Changelog

## 1.0.7

- Input (disabled): the disabled fill is now painted once by the control surface instead of twice. The `InputDecorator` used to fill an inset rectangle on top of the container's `colorBgContainerDisabled`, which read as a grey box with a darker inner band; the decorator now keeps `filled: true` (it still supplies the 4dp input gap) but with a transparent fill color.
- `AntInputTextArea`: body text now starts at the same left inset as a single-line `AntInput`. The multiline path added the theme `marginSM` on top of the container's own horizontal padding, so the text sat one `marginSM` further right than single-line text.
- `AntInputField.contentPadding` is now honored; it was declared but ignored, so callers passing a custom padding (such as `AntInputTextArea`) were silently overridden.

## 1.0.6

- `AntSelect` gains `status`: the trigger border and focus ring follow the validation state (`colorError` / `colorWarning`, with `colorErrorOutline` / `colorWarningOutline` rings), matching `AntInput`.
- `AntSelect` gains `maxTagCount` for multiple mode: tags beyond the limit collapse into a `+N` counter tag instead of expanding the control height.
- Export `antFieldBorderColorOf`, `antFieldFocusOutlineOf` and `antFieldFocusRingOf` helpers so every field-styled control can share the same border/ring treatment.

## 1.0.5

- Popup engine: a popup that prefers a vertical direction no longer measures the *horizontal* space to decide whether its opposite side fits, so a long panel that does not fit below the trigger is no longer flipped above it and clipped by the top edge.
- Popup engine: the popup's main axis is now clamped into the viewport (previously only the cross axis was). A panel that fits neither below nor above the trigger stays fully visible, overlapping the trigger, instead of running off the screen edge.
- Select / AutoComplete / Mentions / Cascader / TreeSelect triggers: the open (focused) state now draws a 1px `colorPrimary` border plus a solid `controlOutline` ring in the foreground layer. Previously the border itself was replaced by a 2px translucent `controlOutline`, which read as a pale, wrong-colored thick border and shifted the content by 1px on open (issue #7).
- Mentions: focus changes now repaint the field, so the focused border and ring are actually visible (the focus listener only handled blur before).
- Export `antFieldBorderColorOf`, `antFieldFocusOutlineOf` and `antFieldFocusRingOf` from the new `ant_field_surface.dart`, so components outside the input family can share the same border/ring treatment.


## 1.0.4

- Input: fix vertical centering when `addonBefore` / `addonAfter` (or `prefix` / `suffix`) is present. The embedded single-line field now centers its line box inside the control height, so addon text and input text share one baseline; the addon border is drawn in the foreground layer so it no longer shrinks the content box.
- Input: the focus outline is now a solid, unblurred ring (`box-shadow: 0 0 0 2px` semantics) that follows validation status — `colorErrorOutline` for error, `colorWarningOutline` for warning and `controlOutline` otherwise.
- Popover: the bubble width now follows its content instead of a fixed 240; `AntPopoverOverlayStyle` gains `width`, `minWidth` and `maxWidth` (defaults to the viewport width minus the default margin) for explicit sizing.

## 1.0.3

- Republished against antd_theme 1.0.2 so the Web platform build no longer resolves a dart:io dependency chain.

## 1.0.2

- Added an example application so pub.dev can render live usage.
- Added Web platform support: network images now go through a conditional loader (`Image.network` on Web, `cached_network_image` on IO), so the package compiles and runs on all six platforms.
- Republished with corrected pubspec metadata for pub.dev scoring.


## 1.0.1

- Fix pub.dev static analysis results by aligning internal dependency constraints.
- Ship the package example and tighten pubspec metadata for better pub.dev scoring.
- Documentation and changelog polish.

## 1.0.0

- Initial stable release of `antd_flutter_ui`, the base component layer shared by the Ant Design Flutter suite.
- Component set spanning `basic` (button, typography, flex, grid, layout, space, divider, tooltip, auto center, safe area, footer), `data_entry` (input family, input number, checkbox, radio, switch, slider, rate, stepper, select, auto complete, mentions, color picker, search bar, check list, selector, image uploader), `display` (avatar, badge, card, collapse, descriptions, ellipsis, empty, image, list, page indicator, picker view, popover, popconfirm, dropdown, segmented, statistic, tag, timeline, tour), `feedback` (action sheet, alert, dialog, drawer, error block, loading, mask, message, modal, notice bar, notification, popup, progress, result, result page, skeleton, spin, toast, watermark), `navigation` (anchor, breadcrumb, capsule tabs, index bar, jumbo tabs, menu, app bar, nav bar, pagination, side bar, steps, tab bar, tabs), `general` (float button) and `misc` (affix, app, border beam, config provider).
- Generic data parameters: option-driven widgets accept `List<T>` with `keyOf`, `labelOf`, `labelBuilder`, `itemBuilder` and `childBuilder`, replacing component-specific option models. Legacy option constructors are deprecated and will be removed in 2.0.
- Dual style sources: desktop components follow Ant Design v6, mobile components follow antd-mobile v5.
- `AntScale` sizing system: every component resolves design values through `theme.s(...)`, with fixed factors and screen-derived factors via `AntScale.auto`.
- Shared engines for anchored popup placement and viewport flipping, wheel-picker columns, keyboard hotkeys and calendar grids.
