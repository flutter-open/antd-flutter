# Changelog

## 1.0.2

- Form item spacing is configurable: `AntForm.itemMarginBottom` / `AntFormItem.marginBottom` replace the hard-coded 16px bottom padding, and an item with help/extra text now defaults to `0` bottom spacing (antd `.ant-form-item-with-help { margin-bottom: 0 }`), fixing the extra gap reported in issue #8. Explicit values always win, including when help text is present.
- Hint styling is configurable: `hintColor` (form level and per item) replaces the hard-coded `colorTextTertiary`, defaulting to `colorTextDescription`; `labelColor` colors the label.
- Label-to-control spacing uses the `marginXS` token instead of a magic number, and inline items keep their right/bottom rhythm.

## 1.0.1

- Fix pub.dev static analysis results by aligning internal dependency constraints.
- Ship the package example and tighten pubspec metadata for better pub.dev scoring.
- Documentation and changelog polish.

## 1.0.0

- Initial stable release of `antd_form`, the form package of the Ant Design Flutter suite.
- `AntForm` container with `vertical`, `horizontal` and `inline` layouts, configurable `labelWidth`, whole-form `disabled` state, `initialValues`, and `onFinish` / `onFinishFailed` callbacks.
- `AntFormItem<T>` field binding with label, required marker, `help` / `extra` text, initial value, and per-field `AntFormValidateTrigger` (`onChange` or `onSubmit`).
- `AntFormController` with `submit`, `validate`, `setValue`, `getValue`, `getValues`, `getError`, `getErrors`, `clearErrors`, `reset` and `hasErrors` for programmatic form control.
- `AntFormFieldRule` validation for required values, regular expressions, numeric and length ranges, number parsing, and custom validators, plus the `AntFormFieldRule.required` shorthand.
- Dynamic form fields through stable field names: items register on mount and unregister on dispose, so rows can be added or removed without leaking values.
- `AntFormField<T>` exposes `value`, `errorText` and `didChange`, keeping the package independent of any specific input widget.
