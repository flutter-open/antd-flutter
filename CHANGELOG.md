# Changelog

## 1.0.2

- Bump `antd_flutter_ui` to `^1.0.4`: vertical centering of `addonBefore` / `addonAfter` input rows, a solid status-aware focus ring, and Popover bubbles that size to their content (`width` / `minWidth` / `maxWidth`).
- Bump `antd_picker` to `^1.0.2`: DatePicker trigger uses a primary-colored 1px border plus a solid focus ring, and no longer shifts its content when the panel opens.

## 1.0.1

- Fix pub.dev static analysis results by aligning internal dependency constraints.
- Ship the package example and tighten pubspec metadata for better pub.dev scoring.
- Documentation and changelog polish.

## 1.0.0

- Initial stable release of `antd_flutter_plus`, the umbrella package for Ant Design Flutter.
- Aggregates 21 packages: `antd_color`, `antd_tokens`, `antd_theme`, `antd_icons_flutter`, `antd_flutter_ui`, `antd_qrcode`, `antd_refresh`, `antd_swipe_action`, `antd_calendar`, `antd_splitter`, `antd_image_viewer`, `antd_upload`, `antd_picker`, `antd_form`, `antd_tree`, `antd_carousel`, `antd_masonry`, `antd_floating`, `antd_keyboard`, `antd_table` and `antd_transfer`.
- Re-exports the public libraries of every aggregated package, plus selected application-level entry points for pickers, refresh, table, form and swipe actions.
- Unified version line: all packages release at `1.0.0`, with `antd_icons_flutter` at `1.0.1` for icon assets; the umbrella constrains dependencies with `^1.0.0`.
- Platform layer: `AntPlatform` runtime classification (web, mobile, desktop, OHOS), the OHOS fold-state channel bridge, and `AntResponsiveInit` for wiring responsive state.
- Layered dependency model: foundations -> `antd_flutter_ui` -> independent feature packages, with no dependencies between feature packages.
