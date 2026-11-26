<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；源码 /// 注释变更后重跑 gen-docs -->

# antd_flutter_ui API 文档总览

> 自动生成时间：2026-11-26T23:06:32.082538；共 441 个公开 API，详情见 `api/<名称>.md` 独立页面。

## 类（166）

| 名称 | 说明 |
| --- | --- |
| [`ActionSheetAction`](api/ActionSheetAction.md) | 动作面板选项 |
| [`AntActionSheet`](api/AntActionSheet.md) | 动作面板 — 从底部弹出的一组操作选项 |
| [`AntAffix`](api/AntAffix.md) | 固钉 — 将元素钉在可视区域 |
| [`AntAlert`](api/AntAlert.md) | 警告提示 — 展示需要用户关注的信息 |
| [`AntAnchor`](api/AntAnchor.md) | 锚点 — 用于跳转到页面指定位置 |
| [`AntAnchorController`](api/AntAnchorController.md) | 锚点控制器 — 管理当前激活的锚点 key |
| [`AntApp`](api/AntApp.md) | 全局上下文根组件 — 为全局反馈组件提供无需页面 context 的静态入口 |
| [`AntAppBar`](api/AntAppBar.md) | Ant Design 风格的 AppBar 别名（内部委托 AntNavBar） |
| [`AntAppMessageConfig`](api/AntAppMessageConfig.md) | AntApp 全局 message 默认配置 |
| [`AntAppModalConfig`](api/AntAppModalConfig.md) | AntApp 全局 modal 默认配置 |
| [`AntAppNotificationConfig`](api/AntAppNotificationConfig.md) | AntApp 全局 notification 默认配置 |
| [`AntAppState`](api/AntAppState.md) | AntApp 的状态，即静态 API 句柄（对应 antd App 的 useApp 返回值） |
| [`AntAutoCenter`](api/AntAutoCenter.md) | 自动居中 — 让内容在剩余空间中自动居中 |
| [`AntAutoComplete`](api/AntAutoComplete.md) | 自动补全输入组件 |
| [`AntAutoCompleteOption`](api/AntAutoCompleteOption.md) | 自动补全选项（旧模型，自 1.x 起推荐直接用 AntAutoComplete<T>(options: List<… |
| [`AntAvatar`](api/AntAvatar.md) | 头像 — 用于用户头像或品牌标识，支持图片、图标和文字 |
| [`AntAvatarGroup`](api/AntAvatarGroup.md) | 头像组 — 多个头像堆叠展示，支持最大数量限制 |
| [`AntBadge`](api/AntBadge.md) | 徽标 — 图标右上角展示消息数或状态点 |
| [`AntBorderBeam`](api/AntBorderBeam.md) | 边框流光 — 圆角矩形边框上有一段渐变流光沿边框循环移动 |
| [`AntBorderBeamPainter`](api/AntBorderBeamPainter.md) | 边框流光画笔 — 普通色边框 + 沿边框循环移动的渐变流光段 |
| [`AntBreadcrumb`](api/AntBreadcrumb.md) | 面包屑 — 显示当前页面在系统层级结构中的位置 |
| [`AntButton`](api/AntButton.md) | Ant Design Button 组件 |
| [`AntCapsuleTabs`](api/AntCapsuleTabs.md) | 胶囊选项卡 — 圆角胶囊形选项卡组 |
| [`AntCard`](api/AntCard.md) | 卡片 — 通用卡片容器 |
| [`AntCheckList`](api/AntCheckList.md) | 复选列表 — 列表样式的单选/多选组件 |
| [`AntCheckListItem`](api/AntCheckListItem.md) | 复选列表项（旧模型，自 1.x 起推荐直接用 AntCheckList<T>(items: List<T>) 配合… |
| [`AntCheckbox`](api/AntCheckbox.md) | 复选框 — 在一组备选项中进行多选 |
| [`AntCheckboxGroup`](api/AntCheckboxGroup.md) | 复选框组 — 包裹一组 AntCheckbox，统一管理选中值 |
| [`AntCheckboxOption`](api/AntCheckboxOption.md) | 复选框选项（旧模型，自 1.x 起推荐直接用 AntCheckboxGroup<T>(options: List<… |
| [`AntCol`](api/AntCol.md) | 栅格列 — 24 栅格系统的列容器 |
| [`AntCollapse`](api/AntCollapse.md) | 折叠面板 — 内容分组折叠展示 |
| [`AntColorPicker`](api/AntColorPicker.md) | 颜色选择器组件 |
| [`AntColorPreset`](api/AntColorPreset.md) | 预设颜色组 |
| [`AntConfigData`](api/AntConfigData.md) | AntConfigProvider 注入的配置数据 |
| [`AntConfigLocale`](api/AntConfigLocale.md) | AntConfigProvider 国际化配置 |
| [`AntConfigProvider`](api/AntConfigProvider.md) | 全局化配置入口 — 为组件树注入主题 / 国际化 / 文本方向 |
| [`AntCopyConfig`](api/AntCopyConfig.md) | 可复制配置 — 对应 antd CopyConfig |
| [`AntDescriptions`](api/AntDescriptions.md) | 描述列表 — 成列展示只读字段 |
| [`AntDialog`](api/AntDialog.md) | 对话框 — 移动端模态弹窗，用于重要信息确认或内容展示 |
| [`AntDialogAction`](api/AntDialogAction.md) | AntDialog 自定义按钮项 |
| [`AntDivider`](api/AntDivider.md) | 分割线 — 区隔内容的分割线 |
| [`AntDrawer`](api/AntDrawer.md) | 抽屉 — 从屏幕边缘滑出的浮层面板 |
| [`AntDropdown`](api/AntDropdown.md) | 下拉菜单 — 页面上的菜单导航 |
| [`AntDropdownControlDelegate`](api/AntDropdownControlDelegate.md) | Controller 与 State 之间的内部绑定协议（组件内部使用，勿自行实现） |
| [`AntDropdownController`](api/AntDropdownController.md) | AntDropdown 的程序化控制器（R35.2 受控操作 Controller 化） |
| [`AntDropdownItem`](api/AntDropdownItem.md) | 下拉菜单项 |
| [`AntEditConfig`](api/AntEditConfig.md) | 可编辑配置 — 对应 antd EditConfig |
| [`AntEllipsis`](api/AntEllipsis.md) | 文本省略 — 多行文本按行数截断，支持展开收起 |
| [`AntEllipsisConfig`](api/AntEllipsisConfig.md) | 省略配置 — 对应 antd EllipsisConfig |
| [`AntEmpty`](api/AntEmpty.md) | 空状态 — 空状态时的展示占位图 |
| [`AntErrorBlock`](api/AntErrorBlock.md) | 错误块 — 用于页面局部出现错误/空数据时的占位提示 |
| [`AntEscapeClosable`](api/AntEscapeClosable.md) | Esc 关闭包裹件 |
| [`AntFlex`](api/AntFlex.md) | 弹性布局 — 高效的对齐、间隔和分布子元素容器 |
| [`AntFlexGap`](api/AntFlexGap.md) | Flex 间距配置 |
| [`AntFloatButton`](api/AntFloatButton.md) | Ant Design 浮动按钮 |
| [`AntFloatButtonBackTop`](api/AntFloatButtonBackTop.md) | Ant Design 回到顶部按钮 |
| [`AntFloatButtonBadge`](api/AntFloatButtonBadge.md) | 悬浮按钮角标配置 — 对应 antd FloatButtonBadgeProps |
| [`AntFloatButtonGroup`](api/AntFloatButtonGroup.md) | Ant Design 浮动按钮组 |
| [`AntFooter`](api/AntFooter.md) | 页脚 — 页面底部说明与回顶部入口 |
| [`AntHotkeyBinding`](api/AntHotkeyBinding.md) | 单条热键绑定 |
| [`AntHotkeyCombo`](api/AntHotkeyCombo.md) | 一组快捷键组合（按键集合 + 修饰键集合），支持相等比较用于冲突检测 |
| [`AntHotkeys`](api/AntHotkeys.md) | 热键包裹 widget |
| [`AntImage`](api/AntImage.md) | 图片 — 可预览的图片容器，支持网络/资源图、加载占位与失败回退 |
| [`AntImageDefaults`](api/AntImageDefaults.md) | AntImage 默认配置与公共构建器 |
| [`AntImagePreviewGroup`](api/AntImagePreviewGroup.md) | 图片预览组 — 包裹一组 AntImage，点击任意一张 可在全屏预览内左右切换组内图片 |
| [`AntImageUploadItem`](api/AntImageUploadItem.md) | 图片上传项（现成模型） |
| [`AntImageUploader`](api/AntImageUploader.md) | 图片上传 — 图片选择、预览与删除的网格组件 |
| [`AntIndexBar`](api/AntIndexBar.md) | 索引栏 — 通讯录式字母索引导航 |
| [`AntIndexBarController`](api/AntIndexBarController.md) | AntIndexBar 的控制器，用于编程式滚动到指定索引 |
| [`AntInput`](api/AntInput.md) | 输入框 — 通过鼠标或键盘输入内容，是最基础的表单域包装 |
| [`AntInputGroup`](api/AntInputGroup.md) | 输入框组 — 将多个输入框组合为紧凑布局 |
| [`AntInputNumber`](api/AntInputNumber.md) | 数字输入框 — 支持步进按钮、上下限、精度控制 |
| [`AntInputPassword`](api/AntInputPassword.md) | 密码框 — 在输入框基础上切换明文/密文 |
| [`AntInputSearch`](api/AntInputSearch.md) | 搜索框 — 带搜索按钮的输入框 |
| [`AntInputTextArea`](api/AntInputTextArea.md) | 文本域 — 多行输入 |
| [`AntJumboTabs`](api/AntJumboTabs.md) | 大选项卡 — 主标题 + 描述的大尺寸选项卡，常用于服务分类 |
| [`AntLayout`](api/AntLayout.md) | 布局容器 — 协调侧边栏与主区域的页面骨架 |
| [`AntLayoutContent`](api/AntLayoutContent.md) | 内容区域 — 页面主体内容容器 |
| [`AntLayoutFooter`](api/AntLayoutFooter.md) | 底部区域 — 页面底栏容器 |
| [`AntLayoutHeader`](api/AntLayoutHeader.md) | 顶部区域 — 页面顶栏容器 |
| [`AntLayoutSider`](api/AntLayoutSider.md) | 侧边栏 — 可折叠的页面侧边导航容器 |
| [`AntLink`](api/AntLink.md) | Ant Design 链接组件 |
| [`AntList`](api/AntList.md) | 列表 — 通用数据列表 |
| [`AntListAction`](api/AntListAction.md) | 列表条目操作项 |
| [`AntListItem`](api/AntListItem.md) | 列表条目 — 主内容 / 右侧 extra / 操作组 |
| [`AntLoading`](api/AntLoading.md) | 加载 — 移动端轻量旋转加载图标 |
| [`AntLoadingSpeed`](api/AntLoadingSpeed.md) | Loading 旋转速度配置（每秒旋转圈数） |
| [`AntMask`](api/AntMask.md) | 背景遮罩 — 全屏黑色半透明遮罩，常用于加载中、内容浮层背景 |
| [`AntMentions`](api/AntMentions.md) | 提及组件 |
| [`AntMentionsOption`](api/AntMentionsOption.md) | 提及选项（旧模型，自 1.x 起推荐直接用 AntMentions<T>(options: List<T>) 配合… |
| [`AntMenu`](api/AntMenu.md) | 导航菜单 — 为页面和功能提供导航的菜单列表 |
| [`AntMessage`](api/AntMessage.md) | 全局提示 — 在页面顶部居中展示全局反馈信息 |
| [`AntMessageHandle`](api/AntMessageHandle.md) | 全局提示句柄 — 可手动关闭对应提示 |
| [`AntModal`](api/AntModal.md) | 对话框 — 模态弹窗，用于重要信息确认或内容展示 |
| [`AntNavBar`](api/AntNavBar.md) | 导航栏 — 移动端页面顶部导航 |
| [`AntNoticeBar`](api/AntNoticeBar.md) | 通告栏 — 展示一组消息通知 |
| [`AntNotification`](api/AntNotification.md) | 通知提醒框 — 全局展示通知信息 |
| [`AntOverlayShell`](api/AntOverlayShell.md) | 屏级弹层统一基座 |
| [`AntPageIndicator`](api/AntPageIndicator.md) | Ant Design 页码指示器 |
| [`AntPagination`](api/AntPagination.md) | 分页 — 采用分页的形式分隔长列表，每次只加载一个页面 |
| [`AntParagraph`](api/AntParagraph.md) | Ant Design 段落组件 |
| [`AntPickerColumn`](api/AntPickerColumn.md) | 单列滚轮数据（泛型） |
| [`AntPickerView`](api/AntPickerView.md) | 内嵌滚轮选择器 — 多列滚轮，选中项实时回调 |
| [`AntPopconfirm`](api/AntPopconfirm.md) | 气泡确认框 — 点击元素时弹出的确认气泡，包含确认/取消按钮 |
| [`AntPopconfirmButtonProps`](api/AntPopconfirmButtonProps.md) | 气泡确认框按钮附加属性（简化版 buttonProps） |
| [`AntPopconfirmControlDelegate`](api/AntPopconfirmControlDelegate.md) | Controller 与 State 之间的内部绑定协议（组件内部使用，勿自行实现） |
| [`AntPopconfirmController`](api/AntPopconfirmController.md) | AntPopconfirm 的程序化控制器（R35.2 受控操作 Controller 化） |
| [`AntPopconfirmOverlayStyle`](api/AntPopconfirmOverlayStyle.md) | 气泡确认框浮层自定义样式 |
| [`AntPopover`](api/AntPopover.md) | 气泡卡片 — 点击/悬停元素时弹出的卡片式浮层 |
| [`AntPopoverControlDelegate`](api/AntPopoverControlDelegate.md) | Controller 与 State 之间的内部绑定协议（组件内部使用，勿自行实现） |
| [`AntPopoverController`](api/AntPopoverController.md) | AntPopover 的程序化控制器（R35.2 受控操作 Controller 化） |
| [`AntPopoverOverlayStyle`](api/AntPopoverOverlayStyle.md) | 气泡浮层自定义样式 |
| [`AntPopup`](api/AntPopup.md) | 弹出层 — 从四方向滑出的浮层面板，常用于半屏内容展示 |
| [`AntPopupLayout`](api/AntPopupLayout.md) | 弹层位置解析结果 |
| [`AntPopupMotion`](api/AntPopupMotion.md) | 弹层单项出现动画 — fade + 方向滑入 / 缩放淡入 |
| [`AntPopupOverlay`](api/AntPopupOverlay.md) | 统一弹层基座 |
| [`AntPopupTriggerRegion`](api/AntPopupTriggerRegion.md) | 统一触发区域（点击 + 悬停 + 移动端 hover 降级） |
| [`AntProgress`](api/AntProgress.md) | 进度条 — 展示操作的当前进度 |
| [`AntRadio`](api/AntRadio.md) | 单选框 — 在一组备选项中进行单选 |
| [`AntRadioButton`](api/AntRadioButton.md) | 按钮风格单选 — 搭配 AntRadioGroup 使用 |
| [`AntRadioGroup`](api/AntRadioGroup.md) | 单选框组 — 包裹一组 AntRadio / AntRadioButton，统一管理选中值 |
| [`AntRadioOption`](api/AntRadioOption.md) | 单选框选项（旧模型，自 1.x 起推荐直接用 AntRadioGroup<T>(options: List<T>)… |
| [`AntRate`](api/AntRate.md) | 评分 — 评分组件，支持半星与自定义图标 |
| [`AntResult`](api/AntResult.md) | 结果页 — 用于反馈一系列操作任务的处理结果 |
| [`AntResultPage`](api/AntResultPage.md) | 页面级结果页 — 用于反馈一整套操作流程的最终处理结果 |
| [`AntRow`](api/AntRow.md) | 栅格行 — 24 栅格系统的行容器 |
| [`AntSafeArea`](api/AntSafeArea.md) | 安全区 — 适配层实现，继承 Flutter SafeArea，兼容原生位置 |
| [`AntSearchBar`](api/AntSearchBar.md) | 搜索栏 — 移动端搜索场景的输入组件 |
| [`AntSegmented`](api/AntSegmented.md) | 分段控制器 — 展示多个选项并允许用户选择其中单个选项 |
| [`AntSegmentedItem`](api/AntSegmentedItem.md) | 分段控制器选项（旧模型，自 1.x 起推荐直接用 AntSegmented<T>(options: List<T>… |
| [`AntSelect`](api/AntSelect.md) | 选择器 — 下拉选择器，支持单选、多选与搜索 |
| [`AntSelectOption`](api/AntSelectOption.md) | 选择器选项（旧模型，自 1.x 起推荐直接用 AntSelect<T>(options: List<T>) 配合 … |
| [`AntSelector`](api/AntSelector.md) | 选择组 — 标签/网格风格的单选/多选组件 |
| [`AntSelectorOption`](api/AntSelectorOption.md) | 选择器选项（旧模型，自 1.x 起推荐直接用 AntSelector<T>(options: List<T>) 配… |
| [`AntSideBar`](api/AntSideBar.md) | 侧边导航栏 — 垂直排列的导航菜单，常用于分类筛选 |
| [`AntSkeleton`](api/AntSkeleton.md) | 骨架屏 — 在需要等待加载内容的位置提供一个占位图形组合 |
| [`AntSkeletonAvatar`](api/AntSkeletonAvatar.md) | 骨架屏头像配置 |
| [`AntSkeletonParagraph`](api/AntSkeletonParagraph.md) | 骨架屏段落配置 |
| [`AntSkeletonTitle`](api/AntSkeletonTitle.md) | 骨架屏标题行配置 |
| [`AntSlider`](api/AntSlider.md) | 滑动输入条 — 滑动型输入器，展示当前值和可选范围 |
| [`AntSliderMark`](api/AntSliderMark.md) | 滑动输入条刻度标记（现成模型） |
| [`AntSpace`](api/AntSpace.md) | 间距 — 组件间设置间距，支持排列方向、间距大小和分隔符 |
| [`AntSpaceSize`](api/AntSpaceSize.md) | Space 间距配置 |
| [`AntSpin`](api/AntSpin.md) | 加载中 — 用于页面或区块的等待状态 |
| [`AntStatistic`](api/AntStatistic.md) | 统计数值 — 展示统计数值 |
| [`AntStatisticCountdown`](api/AntStatisticCountdown.md) | 倒计时统计 — 倒计时显示组件 |
| [`AntStepper`](api/AntStepper.md) | 步进器 — 移动端数值调节组件 |
| [`AntSteps`](api/AntSteps.md) | 步骤条 — 引导用户按照流程完成任务的导航条 |
| [`AntSwitch`](api/AntSwitch.md) | 开关组件 — 对齐 antd React Switch |
| [`AntTabBar`](api/AntTabBar.md) | 底部标签栏 — 移动端页面底部 Tab 切换 |
| [`AntTabs`](api/AntTabs.md) | 选项卡 — 对内容进行分区切换的导航组件 |
| [`AntTag`](api/AntTag.md) | 标签 — 进行标记和分类的小标签 |
| [`AntText`](api/AntText.md) | Ant Design 文本组件 |
| [`AntTimeline`](api/AntTimeline.md) | 时间轴 — 垂直展示的时间流信息 |
| [`AntTitle`](api/AntTitle.md) | Ant Design 标题组件 |
| [`AntToast`](api/AntToast.md) | 轻提示 — 在屏幕中央（或指定位置）展示深色半透明圆角卡片反馈 |
| [`AntToastHandle`](api/AntToastHandle.md) | 轻提示句柄 — 可手动关闭当前提示 |
| [`AntTooltip`](api/AntTooltip.md) | 文字提示 — 简单的文字提示气泡 |
| [`AntTooltipControlDelegate`](api/AntTooltipControlDelegate.md) | Controller 与 State 之间的内部绑定协议（组件内部使用，勿自行实现） |
| [`AntTooltipController`](api/AntTooltipController.md) | AntTooltip 的程序化控制器（R35.2 受控操作 Controller 化） |
| [`AntTour`](api/AntTour.md) | 漫游式引导 — 分步引导用户了解产品功能的气泡卡片组件 |
| [`AntTypography`](api/AntTypography.md) | Ant Design Typography 基础组件 |
| [`AntWatermark`](api/AntWatermark.md) | 水印 — 给页面指定区域添加水印 |
| [`HotkeyRegistry`](api/HotkeyRegistry.md) | 热键注册中心（全局单例） |
| [`PopupEngine`](api/PopupEngine.md) | 统一弹层位置计算引擎 |
| [`WheelPickerColumn`](api/WheelPickerColumn.md) | 单列滚轮引擎组件 — 基于 CupertinoPicker 的 iOS 风格滚轮 |

## 枚举（113）

| 名称 | 说明 |
| --- | --- |
| [`AntAlertType`](api/AntAlertType.md) | 警告提示语义类型 |
| [`AntAnchorDirection`](api/AntAnchorDirection.md) | 锚点方向 |
| [`AntAppMessageType`](api/AntAppMessageType.md) | 经 AntApp 弹出 message 的类型 |
| [`AntAppNotificationPlacement`](api/AntAppNotificationPlacement.md) | 经 AntApp 弹出 notification 的展示位置 |
| [`AntAutoCompleteSize`](api/AntAutoCompleteSize.md) | 自动补全尺寸 |
| [`AntAvatarShape`](api/AntAvatarShape.md) | 头像形状 |
| [`AntAvatarSize`](api/AntAvatarSize.md) | 头像尺寸预设 |
| [`AntBadgeStatus`](api/AntBadgeStatus.md) | 徽标状态 |
| [`AntButtonColor`](api/AntButtonColor.md) | 按钮颜色语义（antd v6 color 属性） |
| [`AntButtonIconPlacement`](api/AntButtonIconPlacement.md) | 图标位置（antd iconPlacement 属性） |
| [`AntButtonShape`](api/AntButtonShape.md) | 按钮形状（antd shape 属性） |
| [`AntButtonSize`](api/AntButtonSize.md) | 按钮尺寸（antd size 属性） |
| [`AntButtonType`](api/AntButtonType.md) | 按钮类型（antd type 属性） |
| [`AntButtonVariant`](api/AntButtonVariant.md) | 按钮变体（antd v6 variant 属性） |
| [`AntCardSize`](api/AntCardSize.md) | 卡片尺寸 |
| [`AntCheckboxGroupDirection`](api/AntCheckboxGroupDirection.md) | 复选框组排列方向 |
| [`AntCollapseExpandIconPosition`](api/AntCollapseExpandIconPosition.md) | 展开图标位置 |
| [`AntCollapseSize`](api/AntCollapseSize.md) | 折叠面板尺寸 |
| [`AntColorFormat`](api/AntColorFormat.md) | 颜色格式 |
| [`AntColorPickerSize`](api/AntColorPickerSize.md) | 颜色选择器尺寸 |
| [`AntConfigDirection`](api/AntConfigDirection.md) | 文本方向 |
| [`AntCopyIconPosition`](api/AntCopyIconPosition.md) | 复制图标显示位置（相对文字，默认后） |
| [`AntDescriptionsLayout`](api/AntDescriptionsLayout.md) | 描述列表布局方向 |
| [`AntDescriptionsSize`](api/AntDescriptionsSize.md) | 描述列表尺寸 |
| [`AntDialogMode`](api/AntDialogMode.md) | AntDialog 展示模式 |
| [`AntDividerOrientation`](api/AntDividerOrientation.md) | 标题位置（仅水平分割线带标题时生效） |
| [`AntDividerType`](api/AntDividerType.md) | 分割线类型 |
| [`AntDividerVariant`](api/AntDividerVariant.md) | 线条样式变体 |
| [`AntDrawerPlacement`](api/AntDrawerPlacement.md) | 抽屉滑出方向 |
| [`AntDropdownItemType`](api/AntDropdownItemType.md) | 下拉菜单项类型 |
| [`AntDropdownPlacement`](api/AntDropdownPlacement.md) | 下拉菜单弹出位置 |
| [`AntDropdownTrigger`](api/AntDropdownTrigger.md) | 下拉菜单触发方式 |
| [`AntEllipsisDirection`](api/AntEllipsisDirection.md) | 文本截断方向 |
| [`AntEmptyImage`](api/AntEmptyImage.md) | 空状态图片样式 |
| [`AntErrorBlockStatus`](api/AntErrorBlockStatus.md) | ErrorBlock 错误块状态 |
| [`AntFlexAlign`](api/AntFlexAlign.md) | 交叉轴对齐方式 |
| [`AntFlexGapSize`](api/AntFlexGapSize.md) | 间距尺寸预设 |
| [`AntFlexJustify`](api/AntFlexJustify.md) | 主轴对齐方式 |
| [`AntFloatButtonGroupPlacement`](api/AntFloatButtonGroupPlacement.md) | 悬浮按钮组的列表弹出方位 |
| [`AntFloatButtonGroupTrigger`](api/AntFloatButtonGroupTrigger.md) | 悬浮按钮组的展开触发方式 |
| [`AntFloatButtonShape`](api/AntFloatButtonShape.md) | 悬浮按钮形状 |
| [`AntFloatButtonType`](api/AntFloatButtonType.md) | 悬浮按钮类型 |
| [`AntHotkeyModifier`](api/AntHotkeyModifier.md) | 修饰键 |
| [`AntImageUploadStatus`](api/AntImageUploadStatus.md) | 图片上传状态 |
| [`AntInputNumberControls`](api/AntInputNumberControls.md) | 步进器按钮行为模式 |
| [`AntInputSize`](api/AntInputSize.md) | 输入框尺寸 |
| [`AntInputStatus`](api/AntInputStatus.md) | 输入框校验状态 |
| [`AntLayoutSiderTheme`](api/AntLayoutSiderTheme.md) | 侧边栏主题 |
| [`AntListSize`](api/AntListSize.md) | 列表尺寸 |
| [`AntLoadingDirection`](api/AntLoadingDirection.md) | 内容排布方向 |
| [`AntMentionsSize`](api/AntMentionsSize.md) | 提及组件尺寸 |
| [`AntMenuItemType`](api/AntMenuItemType.md) | 菜单项类型 |
| [`AntMenuMode`](api/AntMenuMode.md) | 菜单模式 |
| [`AntMenuTheme`](api/AntMenuTheme.md) | 菜单主题 |
| [`AntMenuTrigger`](api/AntMenuTrigger.md) | 子菜单触发方式 |
| [`AntMessageType`](api/AntMessageType.md) | 全局提示类型 |
| [`AntNoticeBarBorder`](api/AntNoticeBarBorder.md) | 通告栏边框模式 |
| [`AntNoticeBarColor`](api/AntNoticeBarColor.md) | 通告栏语义颜色类型 |
| [`AntNoticeBarShape`](api/AntNoticeBarShape.md) | 通告栏形状 |
| [`AntNotificationPlacement`](api/AntNotificationPlacement.md) | 通知弹出位置（屏幕四角） |
| [`AntNotificationType`](api/AntNotificationType.md) | 通知类型 |
| [`AntPageIndicatorDirection`](api/AntPageIndicatorDirection.md) | 页码指示器方向 |
| [`AntPageIndicatorPresetColor`](api/AntPageIndicatorPresetColor.md) | 页码指示器预设配色 |
| [`AntPaginationSize`](api/AntPaginationSize.md) | 分页尺寸 |
| [`AntPopconfirmPlacement`](api/AntPopconfirmPlacement.md) | 气泡确认框弹出位置（同 antd v6 Popconfirm placement，参考 Popover 九/十二方向） |
| [`AntPopoverPlacement`](api/AntPopoverPlacement.md) | 气泡卡片弹出位置（九方向，同 antd v6 Popover placement） |
| [`AntPopoverTrigger`](api/AntPopoverTrigger.md) | 气泡卡片触发方式 |
| [`AntPopupAlign`](api/AntPopupAlign.md) | 弹层沿目标边缘的对齐：起始 / 居中 / 末尾 |
| [`AntPopupDirection`](api/AntPopupDirection.md) | 弹层主方向（翻转决策的结果方向） |
| [`AntPopupPlacement`](api/AntPopupPlacement.md) | 统一弹层弹出位置（12 方向，对齐 antd placement） |
| [`AntPopupPosition`](api/AntPopupPosition.md) | 弹出层弹出方向 |
| [`AntProgressStatus`](api/AntProgressStatus.md) | 进度条状态 |
| [`AntProgressType`](api/AntProgressType.md) | 进度条类型 |
| [`AntRadioButtonStyle`](api/AntRadioButtonStyle.md) | 单选按钮风格 |
| [`AntRadioGroupDirection`](api/AntRadioGroupDirection.md) | 单选组排列方向 |
| [`AntRadioGroupOptionType`](api/AntRadioGroupOptionType.md) | 单选组选项类型 |
| [`AntResultPageStatus`](api/AntResultPageStatus.md) | ResultPage 结果页状态 |
| [`AntResultStatus`](api/AntResultStatus.md) | Result 结果状态 |
| [`AntRowAlign`](api/AntRowAlign.md) | Row 垂直对齐方式 |
| [`AntRowJustify`](api/AntRowJustify.md) | Row 水平分布方式 |
| [`AntSafeAreaPosition`](api/AntSafeAreaPosition.md) | 安全区位置 |
| [`AntSearchBarCancelMode`](api/AntSearchBarCancelMode.md) | 取消按钮显示策略 |
| [`AntSegmentedDirection`](api/AntSegmentedDirection.md) | 分段控制器方向 |
| [`AntSegmentedShape`](api/AntSegmentedShape.md) | 分段控制器形状 |
| [`AntSegmentedSize`](api/AntSegmentedSize.md) | 分段控制器尺寸 |
| [`AntSelectMode`](api/AntSelectMode.md) | 选择器模式 |
| [`AntSelectSize`](api/AntSelectSize.md) | 选择器尺寸 |
| [`AntSkeletonAvatarShape`](api/AntSkeletonAvatarShape.md) | 骨架屏头像形状 |
| [`AntSpaceAlign`](api/AntSpaceAlign.md) | 交叉轴对齐方式 |
| [`AntSpaceDirection`](api/AntSpaceDirection.md) | 排列方向 |
| [`AntSpaceGapSize`](api/AntSpaceGapSize.md) | 间距尺寸预设 |
| [`AntSpinIndicatorType`](api/AntSpinIndicatorType.md) | Spin 指示器样式 — 对齐 antd React Spin 的 indicator 风格 |
| [`AntSpinSize`](api/AntSpinSize.md) | Spin 尺寸 |
| [`AntStatisticValueType`](api/AntStatisticValueType.md) | 统计数值类型 |
| [`AntStepperSize`](api/AntStepperSize.md) | 步进器尺寸 |
| [`AntStepsDirection`](api/AntStepsDirection.md) | 步骤条排列方向 |
| [`AntStepsSize`](api/AntStepsSize.md) | 步骤条尺寸 |
| [`AntStepsStatus`](api/AntStepsStatus.md) | 步骤状态 |
| [`AntSwitchSize`](api/AntSwitchSize.md) | 开关尺寸 |
| [`AntTabPosition`](api/AntTabPosition.md) | 选项卡位置 |
| [`AntTabsEditAction`](api/AntTabsEditAction.md) | 编辑动作类型 |
| [`AntTabsSize`](api/AntTabsSize.md) | 选项卡尺寸 |
| [`AntTabsType`](api/AntTabsType.md) | 选项卡类型 |
| [`AntTagColor`](api/AntTagColor.md) | 标签颜色预设 |
| [`AntTimelineColor`](api/AntTimelineColor.md) | 时间轴节点颜色预设 |
| [`AntTimelineMode`](api/AntTimelineMode.md) | 时间轴模式 |
| [`AntTitleLevel`](api/AntTitleLevel.md) | 标题层级（对应 h1 ~ h5） |
| [`AntToastIconType`](api/AntToastIconType.md) | 内置图标类型 |
| [`AntToastPosition`](api/AntToastPosition.md) | 轻提示展示位置 |
| [`AntTooltipPlacement`](api/AntTooltipPlacement.md) | 气泡弹出位置 |
| [`AntTooltipTrigger`](api/AntTooltipTrigger.md) | 气泡触发方式 |
| [`AntTourPlacement`](api/AntTourPlacement.md) | 引导卡片相对于目标元素的位置（对齐 antd v6 Tour placement） |
| [`AntTypographyType`](api/AntTypographyType.md) | 文本语义类型 |

## 混入（2）

| 名称 | 说明 |
| --- | --- |
| [`PopupContentRefresher`](api/PopupContentRefresher.md) | 弹层内容刷新 mixin — 原地重建 OverlayEntry（统一沉淀，勿再各自 remove+reinsert） |
| [`PopupOpenScheduler`](api/PopupOpenScheduler.md) | 受控 open 调度 mixin — show/hide 统一延迟到帧末 |

## 扩展（1）

| 名称 | 说明 |
| --- | --- |
| [`AntResultStatusLabel`](api/AntResultStatusLabel.md) | 各状态展示数字大字时的文案 |

## 函数（16）

| 名称 | 说明 |
| --- | --- |
| [`antAvatarSizeToPx`](api/antAvatarSizeToPx.md) | 将尺寸预设解析为像素值 |
| [`antDeviceSafePadding`](api/antDeviceSafePadding.md) | 设备真实安全区 insets（取根视图 MediaQuery.padding） |
| [`antFieldBorderColorOf`](api/antFieldBorderColorOf.md) | 根据状态获取边框色 |
| [`antFieldFocusOutlineOf`](api/antFieldFocusOutlineOf.md) | 焦点光环色 — 跟随校验状态（antd 语义：error → colorErrorOutline， warning… |
| [`antFieldFocusRingOf`](api/antFieldFocusRingOf.md) | 焦点光环 — antd web 为「无模糊的实心外扩环」（box-shadow: 0 0 0 2px outlin… |
| [`antIsDesktopViewport`](api/antIsDesktopViewport.md) | 桌面端视口判定（最短边 ≥ 600 逻辑像素） |
| [`buildCalendarCompactMonthGrid`](api/buildCalendarCompactMonthGrid.md) | 生成自适应行数的月份网格：按当月实际天数向上取整为整周（紧凑布局用） |
| [`buildCalendarMonthGrid`](api/buildCalendarMonthGrid.md) | 生成月份网格：固定 maxWeeks 行（默认 6 行 × 7 列，上下月补位） |
| [`buildCalendarTwoWeeksGrid`](api/buildCalendarTwoWeeksGrid.md) | 生成锚定日期所在两周的网格（两周视图） |
| [`buildCalendarWeekGrid`](api/buildCalendarWeekGrid.md) | 生成锚定日期所在周的网格（周视图） |
| [`calendarDateOnly`](api/calendarDateOnly.md) | 去除时分秒，仅保留年月日 |
| [`calendarIsSameDay`](api/calendarIsSameDay.md) | 两个日期是否为同一天（任一为 null 返回 false） |
| [`calendarMonthLeadingOffset`](api/calendarMonthLeadingOffset.md) | 按周起始约定计算某月 1 号在网格中的前置补位天数 |
| [`calendarStartOfWeek`](api/calendarStartOfWeek.md) | 某日所在周的起始日（按周起始约定对齐） |
| [`resolveActiveModifiers`](api/resolveActiveModifiers.md) | 从当前按下键集合解析生效的修饰键 |
| [`showAntModal`](api/showAntModal.md) | 弹出确认风格的对话框，返回用户选择（true 确认 / false 取消 / null 被移除） |

## 常量（98）

| 名称 | 说明 |
| --- | --- |
| [`kAntActionSheetCancelKey`](api/kAntActionSheetCancelKey.md) | 取消按钮标记 key |
| [`kAntActionSheetDuration`](api/kAntActionSheetDuration.md) | 弹出/收起动画时长 |
| [`kAntActionSheetMaskKey`](api/kAntActionSheetMaskKey.md) | 遮罩标记 key，便于测试定位遮罩 |
| [`kAntActionSheetPanelKey`](api/kAntActionSheetPanelKey.md) | 面板标记 key，便于测试定位面板 |
| [`kAntAffixChildKey`](api/kAntAffixChildKey.md) | 钉住状态标记 key，便于测试定位钉住层 |
| [`kAntAffixDefaultOffsetTop`](api/kAntAffixDefaultOffsetTop.md) | 默认距视口顶部触发距离（对齐 antd v6 offsetTop 默认值） |
| [`kAntAffixPlaceholderKey`](api/kAntAffixPlaceholderKey.md) | 钉住时原布局占位的标记 key |
| [`kAntAffixShiftKey`](api/kAntAffixShiftKey.md) | 钉住层标记 key，仅钉住时存在（钉在根 Overlay 顶层），便于测试判断钉住状态 |
| [`kAntBorderBeamDefaultDurationSeconds`](api/kAntBorderBeamDefaultDurationSeconds.md) | 默认动画周期（秒） |
| [`kAntBorderBeamDefaultSize`](api/kAntBorderBeamDefaultSize.md) | 默认边框宽度 |
| [`kAntBorderBeamLengthRatio`](api/kAntBorderBeamLengthRatio.md) | 流光段占边框周长的比例 |
| [`kAntBorderBeamPaintKey`](api/kAntBorderBeamPaintKey.md) | 边框标记 key，便于测试定位 CustomPaint |
| [`kAntDialogActionKeyPrefix`](api/kAntDialogActionKeyPrefix.md) | 自定义动作按钮 key 前缀，完整 key 为 ValueKey('AntDialogAction$index') |
| [`kAntDialogAnimationDuration`](api/kAntDialogAnimationDuration.md) | 对话框动画时长 |
| [`kAntDialogCancelButtonKey`](api/kAntDialogCancelButtonKey.md) | 取消按钮标记 key |
| [`kAntDialogCardKey`](api/kAntDialogCardKey.md) | 对话框卡片标记 key |
| [`kAntDialogDefaultCancelText`](api/kAntDialogDefaultCancelText.md) | 默认取消按钮文案 |
| [`kAntDialogDefaultOkText`](api/kAntDialogDefaultOkText.md) | 默认确认按钮文案 |
| [`kAntDialogDefaultWidthFactor`](api/kAntDialogDefaultWidthFactor.md) | 对话框卡片宽度占屏宽比例（移动端居中小卡片） |
| [`kAntDialogMaskKey`](api/kAntDialogMaskKey.md) | 遮罩标记 key，便于测试定位 |
| [`kAntDialogOkButtonKey`](api/kAntDialogOkButtonKey.md) | 确认按钮标记 key |
| [`kAntDrawerCloseKey`](api/kAntDrawerCloseKey.md) | 右上角关闭按钮标记 key |
| [`kAntDrawerDuration`](api/kAntDrawerDuration.md) | 抽屉滑入/滑出动画时长 |
| [`kAntDrawerFooterKey`](api/kAntDrawerFooterKey.md) | 底部操作区标记 key |
| [`kAntDrawerMaskKey`](api/kAntDrawerMaskKey.md) | 遮罩标记 key，便于测试定位遮罩 |
| [`kAntDrawerPanelKey`](api/kAntDrawerPanelKey.md) | 抽屉面板标记 key，便于测试定位面板 |
| [`kAntDropdownArrowKey`](api/kAntDropdownArrowKey.md) | 下拉菜单箭头标记 key |
| [`kAntFooterDefaultContent`](api/kAntFooterDefaultContent.md) | 默认底部文案 |
| [`kAntLoadingArcSweep`](api/kAntLoadingArcSweep.md) | 圆弧缺口比例（3/4 圆弧，对齐 antd-mobile 转圈观感） |
| [`kAntLoadingDefaultDirection`](api/kAntLoadingDefaultDirection.md) | 内容在转圈图标之后（右侧） |
| [`kAntLoadingRingKey`](api/kAntLoadingRingKey.md) | 旋转圆环 key，便于测试断言动画与尺寸 |
| [`kAntLoadingRotateKey`](api/kAntLoadingRotateKey.md) | 旋转容器 key（RotationTransition 外层） |
| [`kAntLoadingSize`](api/kAntLoadingSize.md) | Loading 默认尺寸 |
| [`kAntLoadingStrokeWidth`](api/kAntLoadingStrokeWidth.md) | 圆弧描边宽度 |
| [`kAntMaskAnimationDuration`](api/kAntMaskAnimationDuration.md) | 遮罩淡入/淡出动画时长 |
| [`kAntMaskDefaultColor`](api/kAntMaskDefaultColor.md) | 默认遮罩颜色 |
| [`kAntMaskDefaultOpacity`](api/kAntMaskDefaultOpacity.md) | 默认遮罩透明度 |
| [`kAntMaskKey`](api/kAntMaskKey.md) | 遮罩层标记 key，便于测试定位 |
| [`kAntMessageAnimationDuration`](api/kAntMessageAnimationDuration.md) | 提示入场/出场动画时长 |
| [`kAntMessageCloseKey`](api/kAntMessageCloseKey.md) | 关闭按钮标记 key |
| [`kAntMessageDefaultDuration`](api/kAntMessageDefaultDuration.md) | 默认自动关闭时长 |
| [`kAntMessageItemKey`](api/kAntMessageItemKey.md) | 单条提示卡片标记 key，便于测试定位 |
| [`kAntMobileOverlayDefaultMaxWidth`](api/kAntMobileOverlayDefaultMaxWidth.md) | 移动端特有弹层组件的桌面端默认宽度上限（逻辑像素） |
| [`kAntModalAnimationDuration`](api/kAntModalAnimationDuration.md) | 对话框动画时长 |
| [`kAntModalCancelButtonKey`](api/kAntModalCancelButtonKey.md) | 取消按钮标记 key |
| [`kAntModalCardKey`](api/kAntModalCardKey.md) | 对话框卡片标记 key |
| [`kAntModalCloseKey`](api/kAntModalCloseKey.md) | 右上角关闭图标标记 key |
| [`kAntModalDefaultCancelText`](api/kAntModalDefaultCancelText.md) | 默认取消按钮文案 |
| [`kAntModalDefaultOkText`](api/kAntModalDefaultOkText.md) | 默认确认按钮文案 |
| [`kAntModalDefaultWidth`](api/kAntModalDefaultWidth.md) | 默认对话框宽度（逻辑像素） |
| [`kAntModalMaskKey`](api/kAntModalMaskKey.md) | 遮罩标记 key，便于测试定位 |
| [`kAntModalOkButtonKey`](api/kAntModalOkButtonKey.md) | 确认按钮标记 key |
| [`kAntNotificationCardKey`](api/kAntNotificationCardKey.md) | 通知卡片标记 key，便于测试定位单条通知 |
| [`kAntNotificationCloseKey`](api/kAntNotificationCloseKey.md) | 关闭按钮标记 key |
| [`kAntNotificationDefaultWidth`](api/kAntNotificationDefaultWidth.md) | 通知卡片默认宽度（antd 默认 384） |
| [`kAntNotificationDescKey`](api/kAntNotificationDescKey.md) | 通知描述标记 key |
| [`kAntNotificationStackKey`](api/kAntNotificationStackKey.md) | 通知容器（某个 placement 的堆叠层）标记 key |
| [`kAntNotificationTitleKey`](api/kAntNotificationTitleKey.md) | 通知标题标记 key |
| [`kAntPopconfirmBubbleKey`](api/kAntPopconfirmBubbleKey.md) | 气泡容器标记 key，便于测试定位气泡 |
| [`kAntPopconfirmCancelButtonKey`](api/kAntPopconfirmCancelButtonKey.md) | 取消按钮标记 key |
| [`kAntPopconfirmDefaultCancelText`](api/kAntPopconfirmDefaultCancelText.md) | 默认取消按钮文案 |
| [`kAntPopconfirmDefaultOkText`](api/kAntPopconfirmDefaultOkText.md) | 默认确认按钮文案 |
| [`kAntPopconfirmDefaultTitle`](api/kAntPopconfirmDefaultTitle.md) | 默认标题文案 |
| [`kAntPopconfirmOkButtonKey`](api/kAntPopconfirmOkButtonKey.md) | 确认按钮标记 key |
| [`kAntPopoverArrowKey`](api/kAntPopoverArrowKey.md) | 气泡箭头标记 key，便于测试定位箭头 |
| [`kAntPopoverBubbleKey`](api/kAntPopoverBubbleKey.md) | 气泡容器标记 key，便于测试定位气泡 |
| [`kAntPopupAnimationDuration`](api/kAntPopupAnimationDuration.md) | 弹出层动画时长 |
| [`kAntPopupCloseKey`](api/kAntPopupCloseKey.md) | 关闭图标标记 key |
| [`kAntPopupMaskKey`](api/kAntPopupMaskKey.md) | 遮罩标记 key，便于测试定位 |
| [`kAntPopupPanelKey`](api/kAntPopupPanelKey.md) | 弹出面板标记 key |
| [`kAntPopupSideWidthFactor`](api/kAntPopupSideWidthFactor.md) | 侧边弹出（left/right）默认宽度占屏宽比例 |
| [`kAntPopupVerticalMaxHeightFactor`](api/kAntPopupVerticalMaxHeightFactor.md) | 纵向弹出（top/bottom）默认最大高度占屏高比例 |
| [`kAntSpinDotsKey`](api/kAntSpinDotsKey.md) | dot 点阵指示器 key（供测试断言渲染） |
| [`kAntSpinFullscreenKey`](api/kAntSpinFullscreenKey.md) | 全屏遮罩层 key |
| [`kAntSpinMaskKey`](api/kAntSpinMaskKey.md) | 遮罩层 key（供测试与外部结构断言使用） |
| [`kAntToastAnimationDuration`](api/kAntToastAnimationDuration.md) | 入场/出场动画时长 |
| [`kAntToastDefaultDuration`](api/kAntToastDefaultDuration.md) | 默认自动消失时长（antd-mobile 对齐：2000ms） |
| [`kAntToastKey`](api/kAntToastKey.md) | 提示卡片标记 key，便于测试定位 |
| [`kAntToastMaskColor`](api/kAntToastMaskColor.md) | 默认遮罩颜色（深色半透明） |
| [`kAntTourArrowKey`](api/kAntTourArrowKey.md) | 箭头标记 key，便于测试定位箭头 |
| [`kAntTourCardKey`](api/kAntTourCardKey.md) | 引导卡片标记 key，便于测试定位卡片 |
| [`kAntTourFinishLabel`](api/kAntTourFinishLabel.md) | 完成按钮文案 |
| [`kAntTourMaskKey`](api/kAntTourMaskKey.md) | 遮罩标记 key，便于测试定位挖孔遮罩 |
| [`kAntTourNextButtonKey`](api/kAntTourNextButtonKey.md) | 下一步/完成按钮标记 key |
| [`kAntTourNextLabel`](api/kAntTourNextLabel.md) | 下一步按钮文案 |
| [`kAntTourPrevButtonKey`](api/kAntTourPrevButtonKey.md) | 上一步按钮标记 key |
| [`kAntTourPrevLabel`](api/kAntTourPrevLabel.md) | 上一步按钮文案 |
| [`kAntTourSkipButtonKey`](api/kAntTourSkipButtonKey.md) | 跳过按钮标记 key |
| [`kAntTourSkipLabel`](api/kAntTourSkipLabel.md) | 跳过按钮文案 |
| [`kAntWatermarkFontSize`](api/kAntWatermarkFontSize.md) | 水印默认字体大小 |
| [`kAntWatermarkGapX`](api/kAntWatermarkGapX.md) | 水印默认水平间距 |
| [`kAntWatermarkGapY`](api/kAntWatermarkGapY.md) | 水印默认垂直间距 |
| [`kAntWatermarkLayerKey`](api/kAntWatermarkLayerKey.md) | 水印层容器标记 key |
| [`kAntWatermarkOpacity`](api/kAntWatermarkOpacity.md) | 水印默认透明度 |
| [`kAntWatermarkPaintKey`](api/kAntWatermarkPaintKey.md) | 水印层 CustomPaint 标记 key，便于测试定位水印 |
| [`kAntWatermarkRotate`](api/kAntWatermarkRotate.md) | 水印默认旋转角度（弧度制外的角度值，负数表示逆时针） |
| [`kCalendarDaysPerWeek`](api/kCalendarDaysPerWeek.md) | 一周的列数 |
| [`kCalendarMaxWeeks`](api/kCalendarMaxWeeks.md) | 每个日期网格的最大单元格数量（6 行 × 7 列，月视图） |

## 类型定义（45）

| 名称 | 说明 |
| --- | --- |
| [`AntAnchorTitleBuilder`](api/AntAnchorTitleBuilder.md) | 锚点标题构建器 |
| [`AntBreadcrumbIconBuilder`](api/AntBreadcrumbIconBuilder.md) | 面包屑图标构建器 |
| [`AntBreadcrumbTitleBuilder`](api/AntBreadcrumbTitleBuilder.md) | 面包屑标题构建器 |
| [`AntCapsuleTabsChildBuilder`](api/AntCapsuleTabsChildBuilder.md) | 面板内容构建器 |
| [`AntCapsuleTabsTitleBuilder`](api/AntCapsuleTabsTitleBuilder.md) | 标题构建器 |
| [`AntCardActionBuilder`](api/AntCardActionBuilder.md) | 卡片底部操作构建器 |
| [`AntCollapseChildBuilder`](api/AntCollapseChildBuilder.md) | 面板内容构建器 |
| [`AntCollapseExtraBuilder`](api/AntCollapseExtraBuilder.md) | 面板右侧附加内容构建器 |
| [`AntCollapseLabelBuilder`](api/AntCollapseLabelBuilder.md) | 面板标题构建器 |
| [`AntDescriptionsContentBuilder`](api/AntDescriptionsContentBuilder.md) | 描述内容构建器 |
| [`AntDescriptionsLabelBuilder`](api/AntDescriptionsLabelBuilder.md) | 描述标签构建器 |
| [`AntIndexBarBriefBuilder`](api/AntIndexBarBriefBuilder.md) | 右侧索引字母构建器 |
| [`AntIndexBarChildBuilder`](api/AntIndexBarChildBuilder.md) | 分组内容构建器 |
| [`AntIndexBarTitleBuilder`](api/AntIndexBarTitleBuilder.md) | 分组标题构建器 |
| [`AntJumboTabsDescriptionBuilder`](api/AntJumboTabsDescriptionBuilder.md) | 描述构建器（套用胶囊底） |
| [`AntJumboTabsTitleBuilder`](api/AntJumboTabsTitleBuilder.md) | 主标题构建器 |
| [`AntListItemBuilder`](api/AntListItemBuilder.md) | 列表条目构建器 |
| [`AntMenuExtraBuilder`](api/AntMenuExtraBuilder.md) | 菜单右侧附加内容构建器 |
| [`AntMenuIconBuilder`](api/AntMenuIconBuilder.md) | 菜单图标构建器 |
| [`AntMenuLabelBuilder`](api/AntMenuLabelBuilder.md) | 菜单标题构建器 |
| [`AntMenuTooltipTitleOf`](api/AntMenuTooltipTitleOf.md) | 折叠态 Tooltip 标题提取器 |
| [`AntPaginationPageItemBuilder`](api/AntPaginationPageItemBuilder.md) | 页码项内容构建器 |
| [`AntPaginationTotalBuilder`](api/AntPaginationTotalBuilder.md) | 总条数构建器，替换默认的「共 N 条」文案 |
| [`AntPopconfirmOpenChange`](api/AntPopconfirmOpenChange.md) | 显示状态变化回调签名 |
| [`AntSideBarTitleBuilder`](api/AntSideBarTitleBuilder.md) | 标题构建器 |
| [`AntStepsDescriptionBuilder`](api/AntStepsDescriptionBuilder.md) | 步骤描述构建器 |
| [`AntStepsIconBuilder`](api/AntStepsIconBuilder.md) | 步骤自定义图标构建器 |
| [`AntStepsTitleBuilder`](api/AntStepsTitleBuilder.md) | 步骤标题构建器 |
| [`AntTabBarActiveIconBuilder`](api/AntTabBarActiveIconBuilder.md) | 激活态图标构建器 |
| [`AntTabBarIconBuilder`](api/AntTabBarIconBuilder.md) | 图标构建器 |
| [`AntTabBarTitleBuilder`](api/AntTabBarTitleBuilder.md) | 标题构建器 |
| [`AntTabsChildBuilder`](api/AntTabsChildBuilder.md) | 选项卡内容构建器 |
| [`AntTabsIconBuilder`](api/AntTabsIconBuilder.md) | 选项卡图标构建器 |
| [`AntTabsLabelBuilder`](api/AntTabsLabelBuilder.md) | 选项卡标题构建器 |
| [`AntTimelineContentBuilder`](api/AntTimelineContentBuilder.md) | 内容构建器 |
| [`AntTimelineDotBuilder`](api/AntTimelineDotBuilder.md) | 自定义节点构建器 |
| [`AntTimelineLabelBuilder`](api/AntTimelineLabelBuilder.md) | 时间标签构建器 |
| [`AntTourArrowOf`](api/AntTourArrowOf.md) | 步骤是否显示箭头提取器（覆盖 Tour 级 arrow） |
| [`AntTourCoverBuilder`](api/AntTourCoverBuilder.md) | 步骤封面构建器（返回 null 时不展示封面） |
| [`AntTourDescriptionBuilder`](api/AntTourDescriptionBuilder.md) | 步骤描述构建器（返回 null 时不展示描述） |
| [`AntTourMaskOf`](api/AntTourMaskOf.md) | 步骤是否显示遮罩提取器（覆盖 Tour 级 mask） |
| [`AntTourPlacementOf`](api/AntTourPlacementOf.md) | 步骤位置提取器（覆盖 Tour 级 placement） |
| [`AntTourTargetOf`](api/AntTourTargetOf.md) | 步骤目标元素提取器（用于挖孔定位，返回 null 时卡片居中） |
| [`AntTourTitleBuilder`](api/AntTourTitleBuilder.md) | 步骤标题构建器（返回 null 时不展示标题） |
| [`AntdAppBar`](api/AntdAppBar.md) | 兼容命名：AntdAppBar 与 AntAppBar 等价 |

