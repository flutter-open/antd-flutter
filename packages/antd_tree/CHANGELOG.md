# Changelog

## 1.0.2

- `AntTreeSelect` trigger: the open state now uses a 1px `colorPrimary` border plus a solid `controlOutline` ring drawn in the foreground layer, instead of a 2px translucent outline that shifted the content by 1px (issue #7 family).
- Depend on `antd_flutter_ui ^1.0.5` for the shared border/ring helpers.

## 1.0.1

- Fix pub.dev static analysis results by aligning internal dependency constraints.
- Ship the package example and tighten pubspec metadata for better pub.dev scoring.
- Documentation and changelog polish.

## 1.0.0

Initial stable release of the standalone `antd_tree` package.

### Features

- `AntTree<T>` renders a generic hierarchy from `dataSource` using `keyOf`, `titleBuilder`, `childrenOf`, `disabledOf`, and `checkableOf`.
- Expansion supports initial keys, expand-all, controlled `expandedKeys`, and per-node switcher toggling; selection supports controlled and uncontrolled key sets and can be disabled with `selectable`.
- Checkable mode supports parent/child cascading in both directions, derived half-checked keys reported through `onCheck`, and `checkStrictly` for independent node checks.
- Guide lines (`showLine`) and per-level indentation (`indent`) are available for deep hierarchies.
- `AntTreeSelect<T>` provides a dropdown selector over the same generic hierarchy, with single and multiple selection, labels, placeholder, clear affordance, and initial expand-all.
- Tree select supports controlled and uncontrolled values, emits a key for single selection and `List<Object>` for multiple selection, and sizes its trigger from `size`, `height`, and `width`.
- The dropdown is built on the shared popup overlay: it follows the trigger width, flips and clamps within the viewport, scrolls internally, and closes on an outside tap.
- Controlled values and replaced data sources refresh correctly while the dropdown is open, including recomputed expansion keys.
- Added `AntTreeSelectSize` and the `AntTree*Of` callback typedefs.

### Deprecated

- `AntTreeNode`, `AntTreeSelectOption`, and `AntTreeSelectFieldNames` are deprecated in favor of a user-defined model with the generic callbacks.
