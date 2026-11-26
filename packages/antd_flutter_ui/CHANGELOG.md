# Changelog

## 1.0.5

- Popup engine: a popup that prefers a vertical direction no longer measures the *horizontal* space to decide whether its opposite side fits, so a long panel that does not fit below the trigger is no longer flipped above it and clipped by the top edge.
- Popup engine: the popup's main axis is now clamped into the viewport (previously only the cross axis was). A panel that fits neither below nor above the trigger stays fully visible, overlapping the trigger, instead of running off the screen edge.

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
