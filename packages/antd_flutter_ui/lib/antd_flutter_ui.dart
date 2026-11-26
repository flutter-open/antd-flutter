/// antd_flutter_ui — Ant Design v6 Flutter 基础组件库
///
/// 全量组件库拆分的「基础库」：
/// - `src/engines/` 跨包共享引擎（滚轮选择引擎 + 列数据模型、虚拟键盘/格子输入模型）
/// - `src/basic/` 基础层组件（Button/Typography/布局系…，随迁移逐步落位）
/// - `src/display|entry|feedback|global/` 通用展示/录入/反馈/全局（后续迁移）
///
/// 依赖方向约定：独立组件包 → antd_flutter_ui → antd_theme/tokens/color/icons，
/// 独立包之间禁止互相依赖。主包 antd_flutter_plus 经 re-export 保持对外兼容。
library;

// ── 共享引擎 ────────────────────────────────────────────────
export 'src/display/popover/ant_popover.dart';
export 'src/display/popover/ant_popover_types.dart';
export 'src/display/popover/ant_popconfirm.dart';
export 'src/display/popover/ant_popconfirm_types.dart';
export 'src/display/popover/ant_dropdown.dart';
export 'src/display/popover/ant_dropdown_types.dart';
export 'src/engines/popup_engine.dart';
export 'src/engines/popup_overlay.dart';
export 'src/engines/hotkeys/hotkey_binding.dart';
export 'src/engines/hotkeys/hotkey_registry.dart';
export 'src/engines/hotkeys/ant_hotkeys.dart';
export 'src/engines/hotkeys/ant_escape_closable.dart';
export 'src/engines/wheel_column_model.dart';
export 'src/engines/wheel_picker_engine.dart';
export 'src/engines/calendar_grid_engine.dart';

// ── 基础层 ────────────────────────────────────────────────
export 'src/basic/button/ant_button.dart';
export 'src/basic/button/ant_button_types.dart';

// ── AutoCenter 自动居中 ────────────────────────────────────
export 'src/basic/auto_center/ant_auto_center.dart';

// ── Flex 弹性布局 ──────────────────────────────────────────
export 'src/basic/flex/ant_flex.dart';
export 'src/basic/flex/ant_flex_types.dart';

// ── Grid 栅格 ──────────────────────────────────────────────
export 'src/basic/grid/ant_grid.dart';
export 'src/basic/grid/ant_grid_types.dart';

// ── Layout 布局 ────────────────────────────────────────────
export 'src/basic/layout/ant_layout.dart';
export 'src/basic/layout/ant_layout_types.dart';

// ── SafeArea 安全区 ────────────────────────────────────────
export 'src/basic/safe_area/ant_safe_area.dart';
export 'src/basic/safe_area/ant_safe_area_types.dart';

// ── Divider 分割线 ─────────────────────────────────────────
export 'src/basic/divider/ant_divider.dart';
export 'src/basic/divider/ant_divider_types.dart';

// ── Space 间距 ─────────────────────────────────────────────
export 'src/basic/space/ant_space.dart';
export 'src/basic/space/ant_space_types.dart';

// ── Typography 排版 ────────────────────────────────────────
export 'src/basic/typography/ant_typography.dart';
export 'src/basic/typography/ant_typography_types.dart';

export 'src/basic/tooltip/ant_tooltip.dart';
export 'src/basic/tooltip/ant_tooltip_types.dart';

// ── Empty 空状态 ───────────────────────────────────────────
export 'src/display/empty/ant_empty.dart';
export 'src/display/empty/ant_empty_types.dart';

// ── PageIndicator 页面指示器 ────────────────────────────────
export 'src/display/page_indicator/ant_page_indicator.dart';
export 'src/display/page_indicator/ant_page_indicator_types.dart';

// ── Tour 漫游式引导 ────────────────────────────────────────
export 'src/display/tour/ant_tour.dart';
export 'src/display/tour/ant_tour_types.dart';

// ── Avatar 头像 ────────────────────────────────────────────
export 'src/display/avatar/ant_avatar.dart';
export 'src/display/avatar/ant_avatar_types.dart';

// ── Badge 徽标 ─────────────────────────────────────────────
export 'src/display/badge/ant_badge.dart';
export 'src/display/badge/ant_badge_types.dart';

// ── Tag 标签 ────────────────────────────────────────────────
export 'src/display/tag/ant_tag.dart';
export 'src/display/tag/ant_tag_types.dart';

// ── Card 卡片 ───────────────────────────────────────────────
export 'src/display/card/ant_card.dart';
export 'src/display/card/ant_card_types.dart';

// ── Statistic 统计数值 ──────────────────────────────────────
export 'src/display/statistic/ant_statistic.dart';
export 'src/display/statistic/ant_statistic_types.dart';

// ── Collapse 折叠面板 ───────────────────────────────────────
export 'src/display/collapse/ant_collapse.dart';
export 'src/display/collapse/ant_collapse_types.dart';

// ── Descriptions 描述列表 ───────────────────────────────────
export 'src/display/descriptions/ant_descriptions.dart';
export 'src/display/descriptions/ant_descriptions_types.dart';

// ── List 列表 ──────────────────────────────────────────────
export 'src/display/list/ant_list.dart';
export 'src/display/list/ant_list_types.dart';

// ── Timeline 时间轴 ────────────────────────────────────────
export 'src/display/timeline/ant_timeline.dart';
export 'src/display/timeline/ant_timeline_types.dart';

// ── Ellipsis 文本省略 ───────────────────────────────────────
export 'src/display/ellipsis/ant_ellipsis.dart';
export 'src/display/ellipsis/ant_ellipsis_types.dart';

// ── Footer 页脚 ────────────────────────────────────────────
export 'src/basic/footer/ant_footer.dart';
export 'src/basic/footer/ant_footer_types.dart';

// ── NoticeBar 通告栏 ────────────────────────────────────────
export 'src/feedback/alert/ant_alert.dart';
export 'src/feedback/alert/ant_alert_types.dart';
export 'src/feedback/error_block/ant_error_block.dart';
export 'src/feedback/error_block/ant_error_block_types.dart';
export 'src/feedback/loading/ant_loading.dart';
export 'src/feedback/loading/ant_loading_types.dart';
export 'src/feedback/mask/ant_mask.dart';
export 'src/feedback/mask/ant_mask_types.dart';
export 'src/feedback/notice_bar/ant_notice_bar.dart';
export 'src/feedback/notice_bar/ant_notice_bar_types.dart';
export 'src/feedback/progress/ant_progress.dart';
export 'src/feedback/progress/ant_progress_types.dart';
export 'src/feedback/result/ant_result.dart';
export 'src/feedback/result/ant_result_types.dart';
export 'src/feedback/result_page/ant_result_page.dart';
export 'src/feedback/result_page/ant_result_page_types.dart';
export 'src/feedback/skeleton/ant_skeleton.dart';
export 'src/feedback/skeleton/ant_skeleton_types.dart';
export 'src/feedback/spin/ant_spin.dart';
export 'src/feedback/spin/ant_spin_types.dart';
export 'src/feedback/watermark/ant_watermark.dart';
export 'src/feedback/watermark/ant_watermark_types.dart';

// ── 反馈·弹层族（批次 0-2，接 popup_engine/overlay_shell 弹层基座）──
export 'src/feedback/action_sheet/ant_action_sheet.dart';
export 'src/feedback/action_sheet/ant_action_sheet_types.dart';
export 'src/feedback/dialog/ant_dialog.dart';
export 'src/feedback/dialog/ant_dialog_types.dart';
export 'src/feedback/drawer/ant_drawer.dart';
export 'src/feedback/drawer/ant_drawer_types.dart';
export 'src/feedback/message/ant_message.dart';
export 'src/feedback/message/ant_message_types.dart';
export 'src/feedback/modal/ant_modal.dart';
export 'src/feedback/modal/ant_modal_types.dart';
export 'src/feedback/notification/ant_notification.dart';
export 'src/feedback/notification/ant_notification_types.dart';
export 'src/feedback/popup/ant_popup.dart';
export 'src/feedback/popup/ant_popup_types.dart';
export 'src/feedback/toast/ant_toast.dart';
export 'src/feedback/toast/ant_toast_types.dart';

// ── 弹层基座·模态分支（屏级弹层统一遮罩/动画/生命周期）──
export 'src/engines/overlay_shell.dart';

// ── Segmented 分段控制器 ────────────────────────────────────
export 'src/display/segmented/ant_segmented.dart';
export 'src/display/segmented/ant_segmented_types.dart';

// ── Image 图片 ─────────────────────────────────────────────
export 'src/display/image/ant_image.dart';
export 'src/display/image/ant_image_types.dart';

// ── PickerView 内嵌滚轮选择器（通用滚轮视图，供 Picker/CalendarPicker 等） ──
export 'src/display/picker_view/ant_picker_view.dart';

// ── Picker 选择器族（已迁独立包 antd_picker：Picker/DatePicker/TimePicker/Cascader）
//    AntPickerView（通用滚轮视图）留 ui，见下。

// ── 数据录入·简单族（批次 0-3，自主包 antd_flutter_plus 迁入）──
export 'src/data_entry/checkbox/ant_checkbox.dart';
export 'src/data_entry/checkbox/ant_checkbox_types.dart';
export 'src/data_entry/radio/ant_radio.dart';
export 'src/data_entry/radio/ant_radio_types.dart';
export 'src/data_entry/rate/ant_rate.dart';
export 'src/data_entry/rate/ant_rate_types.dart';
export 'src/data_entry/slider/ant_slider.dart';
export 'src/data_entry/slider/ant_slider_types.dart';
export 'src/data_entry/switch/ant_switch.dart';
export 'src/data_entry/switch/ant_switch_types.dart';
export 'src/data_entry/stepper/ant_stepper.dart';
export 'src/data_entry/stepper/ant_stepper_types.dart';
export 'src/data_entry/input/ant_input.dart';
export 'src/data_entry/input/ant_input_types.dart';
export 'src/data_entry/input/ant_field_surface.dart';
export 'src/data_entry/input_number/ant_input_number.dart';
export 'src/data_entry/input_number/ant_input_number_types.dart';
export 'src/data_entry/search_bar/ant_search_bar.dart';
export 'src/data_entry/search_bar/ant_search_bar_types.dart';
export 'src/data_entry/check_list/ant_check_list.dart';
export 'src/data_entry/check_list/ant_check_list_types.dart';
export 'src/data_entry/selector/ant_selector.dart';
export 'src/data_entry/selector/ant_selector_types.dart';
export 'src/data_entry/image_uploader/ant_image_uploader.dart';
export 'src/data_entry/image_uploader/ant_image_uploader_types.dart';

// ── 数据录入·select-like 族（批次 0-4，自主包 antd_flutter_plus 迁入，
//    弹层统一接入 popup_engine 底座）──
export 'src/data_entry/select/ant_select.dart';
export 'src/data_entry/select/ant_select_types.dart';
export 'src/data_entry/color_picker/ant_color_picker.dart';
export 'src/data_entry/color_picker/ant_color_picker_types.dart';
export 'src/data_entry/auto_complete/ant_auto_complete.dart';
export 'src/data_entry/auto_complete/ant_auto_complete_types.dart';
export 'src/data_entry/mentions/ant_mentions.dart';
export 'src/data_entry/mentions/ant_mentions_types.dart';


// Transfer 穿梭框已迁移至独立包 antd_transfer（P08 拆分批次，从 ui 迁出），主包经 re-export 兼容

// ── 导航族（批次 0-6，自主包 antd_flutter_plus 迁入）──
export 'src/navigation/breadcrumb/ant_breadcrumb.dart';
export 'src/navigation/breadcrumb/ant_breadcrumb_types.dart';
export 'src/navigation/pagination/ant_pagination.dart';
export 'src/navigation/pagination/ant_pagination_types.dart';
export 'src/navigation/steps/ant_steps.dart';
export 'src/navigation/steps/ant_steps_types.dart';
export 'src/navigation/tabs/ant_tabs.dart';
export 'src/navigation/tabs/ant_tabs_types.dart';
export 'src/navigation/menu/ant_menu.dart';
export 'src/navigation/menu/ant_menu_types.dart';
export 'src/navigation/anchor/ant_anchor.dart';
export 'src/navigation/anchor/ant_anchor_types.dart';
export 'src/navigation/nav_bar/ant_app_bar.dart';
export 'src/navigation/nav_bar/ant_nav_bar.dart';
export 'src/navigation/tab_bar/ant_tab_bar.dart';
export 'src/navigation/tab_bar/ant_tab_bar_types.dart';
export 'src/navigation/side_bar/ant_side_bar.dart';
export 'src/navigation/side_bar/ant_side_bar_types.dart';
export 'src/navigation/index_bar/ant_index_bar.dart';
export 'src/navigation/index_bar/ant_index_bar_types.dart';
export 'src/navigation/capsule_tabs/ant_capsule_tabs.dart';
export 'src/navigation/capsule_tabs/ant_capsule_tabs_types.dart';
export 'src/navigation/jumbo_tabs/ant_jumbo_tabs.dart';
export 'src/navigation/jumbo_tabs/ant_jumbo_tabs_types.dart';

// ── misc 族（批次 0-7，自主包 antd_flutter_plus 迁入）──
export 'src/misc/affix/ant_affix.dart';
export 'src/misc/affix/ant_affix_types.dart';
export 'src/misc/app/ant_app.dart';
export 'src/misc/app/ant_app_types.dart';
export 'src/misc/border_beam/ant_border_beam.dart';
export 'src/misc/border_beam/ant_border_beam_types.dart';
export 'src/misc/config_provider/ant_config_provider.dart';
export 'src/misc/config_provider/ant_config_provider_types.dart';

// ── FloatButton 悬浮按钮（批次 0-7，自主包 antd_flutter_plus 迁入，antd 归类通用）──
export 'src/general/float_button/ant_float_button.dart';
export 'src/general/float_button/ant_float_button_types.dart';
