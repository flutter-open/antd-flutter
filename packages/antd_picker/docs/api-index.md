<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；源码 /// 注释变更后重跑 gen-docs -->

# antd_picker API 文档总览

> 自动生成时间：2026-11-26T23:07:54.145862；共 25 个公开 API，详情见 `api/<名称>.md` 独立页面。

## 类（11）

| 名称 | 说明 |
| --- | --- |
| [`AntCascader`](api/AntCascader.md) | 级联选择组件 |
| [`AntCascaderView`](api/AntCascaderView.md) | 级联选择视图 |
| [`AntDatePicker`](api/AntDatePicker.md) | 日期选择框 — 输入或选择日期 |
| [`AntDateRange`](api/AntDateRange.md) | 日期（时间）范围值 |
| [`AntDateRangePicker`](api/AntDateRangePicker.md) | 日期范围选择框 — 一次选择起止日期（可选时间） |
| [`AntDateTimeRangePicker`](api/AntDateTimeRangePicker.md) | 日期时间范围选择框 — AntDateRangePicker 且 showTime 默认为 true |
| [`AntPicker`](api/AntPicker.md) | 底部弹出选择器 — 弹出面板中展示多列滚轮 |
| [`AntPickerColumn`](api/AntPickerColumn.md) | 单列滚轮数据（泛型） |
| [`AntPickerLocale`](api/AntPickerLocale.md) | 日期/时间选择器国际化文案 |
| [`AntPickerLocaleProvider`](api/AntPickerLocaleProvider.md) | 选择器国际化注入 — InheritedWidget，包裹一次全局生效 |
| [`AntTimePicker`](api/AntTimePicker.md) | 时间选择框 — 输入或选择时间 |

## 枚举（4）

| 名称 | 说明 |
| --- | --- |
| [`AntCascaderExpandTrigger`](api/AntCascaderExpandTrigger.md) | 次级菜单展开触发方式 |
| [`AntCascaderSize`](api/AntCascaderSize.md) | 级联尺寸 |
| [`AntDatePickerSize`](api/AntDatePickerSize.md) | 日期选择器尺寸 |
| [`AntTimePickerSize`](api/AntTimePickerSize.md) | 时间选择器尺寸 |

## 函数（3）

| 名称 | 说明 |
| --- | --- |
| [`antFieldBorderColorOf`](api/antFieldBorderColorOf.md) | 根据状态获取边框色 |
| [`antFieldFocusOutlineOf`](api/antFieldFocusOutlineOf.md) | 焦点光环色 — 跟随校验状态（antd 语义：error → colorErrorOutline， warning… |
| [`antFieldFocusRingOf`](api/antFieldFocusRingOf.md) | 焦点光环 — antd web 为「无模糊的实心外扩环」（box-shadow: 0 0 0 2px outlin… |

## 类型定义（7）

| 名称 | 说明 |
| --- | --- |
| [`AntCascaderChildrenOf`](api/AntCascaderChildrenOf.md) | 从模型取子节点 |
| [`AntCascaderDisabledOf`](api/AntCascaderDisabledOf.md) | 选项禁用判断 |
| [`AntCascaderKeyOf`](api/AntCascaderKeyOf.md) | 从模型取唯一标识 |
| [`AntCascaderLabelBuilder`](api/AntCascaderLabelBuilder.md) | 选项自定义渲染 |
| [`AntCascaderOnChange`](api/AntCascaderOnChange.md) | 选择变化回调（值为选中的模型路径） |
| [`AntCascaderViewOnChange`](api/AntCascaderViewOnChange.md) | 级联选择视图变化回调：value 为模型路径，items 为逐层选中项 （未选择层级为 null） |
| [`AntDateRangeLabelBuilder`](api/AntDateRangeLabelBuilder.md) | 范围触发器自定义渲染 |

