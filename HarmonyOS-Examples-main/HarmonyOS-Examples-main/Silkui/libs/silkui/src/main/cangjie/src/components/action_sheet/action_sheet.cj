/**
 * Created on 2025/7/8
 */
package silkui.components.action_sheet

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.Component
import ohos.state_macro_manage.Link
import silkui.components.popup.SilkPopup
import silkui.components.popup.SilkPopupOptions
import silkui.components.popup.SilkPopupPosition
import ohos.state_macro_manage.Prop
import ohos.state_macro_manage.Builder
import silkui.components.icon.SilkIcon
import silkui.constants.getActionSheetSizeConstant
import silkui.constants.SilkActionSheetSizeKey
import silkui.utils.ResourceStrToString
import silkui.constants.getSizeConstant
import silkui.constants.SilkSizeKey
import silkui.constants.getActionSheetColorConstant
import silkui.constants.SilkActionSheetColorKey
import silkui.utils.ResourceColorToColor
import silkui.constants.getColorConstant
import silkui.constants.SilkColorKey
import silkui.components.loading.SilkLoading
import silkui.constants.getActionSheetPercentConstant
import silkui.constants.SilkActionSheetPercentKey

/**
 * 动作面板组件
 *
 * 动作面板从底部弹起，展示一系列操作选项供用户选择。
 * 支持自定义标题、描述、图标、取消按钮等功能。
 */
@Component
public class SilkActionSheet {
    /**
     * 是否显示动作面板
     * 使用 @Link 装饰器与父组件双向绑定
     */
    @Link
    var show: Bool = false

    /**
     * 动作面板配置选项
     * 包含选项列表、标题、样式等配置
     */
    @Prop
    var props: SilkActionSheetOptions

    /**
     * 自定义面板内容插槽
     * 当需要完全自定义面板内容时使用
     * 默认为 None，使用 actions 列表渲染
     */
    public var content: Option<(CustomView) -> ViewBuilder> = None

    /**
     * 取消按钮点击回调
     * 当用户点击取消按钮时触发
     */
    public var cancel: () -> Unit = {=>}

    /**
     * 选项点击回调
     * @param action 被点击的选项对象
     * @param index 选项在列表中的索引
     */
    public var select: (action: SilkActionSheetAction, index: Int64) -> Unit = {action, index =>}

    /**
     * 面板开始打开时的回调
     * 在动画开始前触发
     */
    public var open: () -> Unit = {=>}

    /**
     * 面板开始关闭时的回调
     * 在动画开始前触发
     */
    public var close: () -> Unit = {=>}

    /**
     * 面板完全打开后的回调
     * 在动画完成后触发
     */
    public var opened: () -> Unit = {=>}

    /**
     * 面板完全关闭后的回调
     * 在动画完成后触发
     */
    public var closed: () -> Unit = {=>}

    /**
     * 遮罩层点击回调
     * 当用户点击遮罩层时触发
     */
    public var clickOverlay: () -> Unit = {=>}
    func build() {
        SilkPopup(
            show: show,
            props: SilkPopupOptions(
                position: SilkPopupPosition.BOTTOM,
                overlay: props.overlay,
                overlayColor: props.overlayColor,
                duration: props.duration,
                round: props.round,
                closeOnPopState: props.closeOnPopState,
                closeOnClickOverlay: props.closeOnClickOverlay
            ),
            _Children: {_ => ContentBuilder(this)},
            open: open,
            close: close,
            opened: opened,
            closed: closed,
            clickOverlay: clickOverlay,
        )
    }

    @Builder
    func ContentTitle() {
        if (props.title.isSome()) {
            Stack() {
                Text(ResourceStrToString(props.title))
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .textAlign(TextAlign.Center)
                    .padding(top: 16, bottom: 8)
                if (props.closeable) {
                    Row() {
                        Row() {
                            SilkIcon(
                                name: props.closeIcon,
                                fontSize: getActionSheetSizeConstant(
                                    SilkActionSheetSizeKey.ACTION_SHEET_CLOSE_ICON_SIZE),
                                fontColor: getActionSheetColorConstant(
                                    SilkActionSheetColorKey.ACTION_SHEET_CLOSE_ICON_COLOR)
                            )
                        }
                            .padding(
                                top: getActionSheetSizeConstant(
                                    SilkActionSheetSizeKey.ACTION_SHEET_CLOSE_ICON_PADDING_TOP),
                                right: getActionSheetSizeConstant(
                                    SilkActionSheetSizeKey.ACTION_SHEET_CLOSE_ICON_PADDING_RIGHT),
                                bottom: getActionSheetSizeConstant(
                                    SilkActionSheetSizeKey.ACTION_SHEET_CLOSE_ICON_PADDING_BOTTOM),
                                left: getActionSheetSizeConstant(
                                    SilkActionSheetSizeKey.ACTION_SHEET_CLOSE_ICON_PADDING_LEFT)
                            )
                            .onClick() {
                                _ => show = false
                            }
                    }.width(100.percent).justifyContent(FlexAlign.End)
                }
            }
        }
    }

    @Builder
    func ContentDescription() {
        if (props.description.isSome()) {
            Column(20) {
                Text(ResourceStrToString(props.description))
                    .fontSize(getActionSheetSizeConstant(SilkActionSheetSizeKey.ACTION_SHEET_DESCRIPTION_FONT_SIZE))
                    .lineHeight(getActionSheetSizeConstant(SilkActionSheetSizeKey.ACTION_SHEET_DESCRIPTION_LINE_HEIGHT))
                    .fontColor(
                        ResourceColorToColor(
                            getActionSheetColorConstant(SilkActionSheetColorKey.ACTION_SHEET_DESCRIPTION_COLOR)))
                Line()
                    .height(1.px)
                    .width(100.percent)
                    .backgroundColor(ResourceColorToColor(getColorConstant(SilkColorKey.BORDER_COLOR)))
            }
                .alignItems(HorizontalAlign.Center)
                .width(100.percent)
                .padding(top: 20.vp, left: getSizeConstant(SilkSizeKey.PADDING_MD),
                    right: getSizeConstant(SilkSizeKey.PADDING_MD))
        }
    }

    @Builder
    func ContentCancel() {
        if (props.cancelText.isSome()) {
            Column() {
                Line()
                    .width(100.percent)
                    .height(getActionSheetSizeConstant(SilkActionSheetSizeKey.ACTION_SHEET_CANCEL_PADDING_TOP))
                    .fill(
                        ResourceColorToColor(
                            getActionSheetColorConstant(SilkActionSheetColorKey.ACTION_SHEET_CANCEL_PADDING_COLOR)))
                Button(ResourceStrToString(props.cancelText))
                    .width(100.percent)
                    .shape(ShapeType.Normal)
                    .padding(
                        top: 14.vp,
                        right: getSizeConstant(SilkSizeKey.PADDING_MD),
                        bottom: 14.vp,
                        left: getSizeConstant(SilkSizeKey.PADDING_MD)
                    )
                    .backgroundColor(
                        ResourceColorToColor(
                            getActionSheetColorConstant(SilkActionSheetColorKey.ACTION_SHEET_ITEM_BACKGROUND)))
                    .fontSize(getActionSheetSizeConstant(SilkActionSheetSizeKey.ACTION_SHEET_ITEM_FONT_SIZE))
                    .fontColor(
                        ResourceColorToColor(
                            getActionSheetColorConstant(SilkActionSheetColorKey.ACTION_SHEET_CANCEL_TEXT_COLOR)))
                    .onClick() {
                        =>
                        show = false
                        cancel()
                    }
            }.width(100.percent)
        }
    }

    @Builder
    func ActionSheetItemBuilder(action: SilkActionSheetAction, index: Int64) {
        Button() {
            Flex(FlexParams(wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center)) {
                if (action.loading) {
                    SilkLoading(size: getActionSheetSizeConstant(SilkActionSheetSizeKey.ACTION_SHEET_LOADING_ICON_SIZE))
                } else {
                    if (action.icon.isSome()) {
                        Row() {
                            SilkIcon(
                                name: action.icon.getOrThrow(),
                                fontSize: getActionSheetSizeConstant(SilkActionSheetSizeKey.ACTION_SHEET_ITEM_ICON_SIZE),
                                fontColor: if (action.disabled) {
                                    getActionSheetColorConstant(
                                        SilkActionSheetColorKey.ACTION_SHEET_ITEM_DISABLED_TEXT_COLOR)
                                } else {
                                    action.color
                                }
                            )
                        }.margin(
                            right: getActionSheetSizeConstant(
                                SilkActionSheetSizeKey.ACTION_SHEET_ITEM_ICON_MARGIN_RIGHT))
                    }
                }
                Text(ResourceStrToString(action.name))
                    .lineHeight(getActionSheetSizeConstant(SilkActionSheetSizeKey.ACTION_SHEET_ITEM_LINE_HEIGHT))
                    .fontColor(
                        ResourceColorToColor(
                            if (action.disabled) {
                                getActionSheetColorConstant(
                                    SilkActionSheetColorKey.ACTION_SHEET_ITEM_DISABLED_TEXT_COLOR)
                            } else {
                                action.color
                            }))
                    .fontSize(getActionSheetSizeConstant(SilkActionSheetSizeKey.ACTION_SHEET_ITEM_FONT_SIZE))
                if (action.subname.isSome()) {
                    Text(ResourceStrToString(action.subname))
                        .width(100.percent)
                        .textAlign(TextAlign.Center)
                        .margin(top: getSizeConstant(SilkSizeKey.PADDING_XS))
                        .fontColor(
                            ResourceColorToColor(
                                getActionSheetColorConstant(SilkActionSheetColorKey.ACTION_SHEET_SUBNAME_COLOR)))
                        .fontSize(getActionSheetSizeConstant(SilkActionSheetSizeKey.ACTION_SHEET_SUBNAME_FONT_SIZE))
                        .lineHeight(getActionSheetSizeConstant(SilkActionSheetSizeKey.ACTION_SHEET_SUBNAME_LINE_HEIGHT))
                }
            }
                .padding(
                    top: 14.vp,
                    bottom: 14.vp,
                    left: getSizeConstant(SilkSizeKey.PADDING_MD),
                    right: getSizeConstant(SilkSizeKey.PADDING_MD)
                )
                .backgroundColor(
                    ResourceColorToColor(
                        getActionSheetColorConstant(SilkActionSheetColorKey.ACTION_SHEET_ITEM_BACKGROUND)))
                .width(100.percent)
        }
            .shape(ShapeType.Normal)
            .padding(0)
            .backgroundColor(Color.TRANSPARENT)
            .onClick() {
                =>
                select(action, index);
                if (props.closeOnClickAction) {
                    show = false
                }
            }
    }

    @Builder
    func ContentBuilder() {
        Column() {
                ContentTitle()
                ContentDescription()
            Scroll() {
                Column() {
                    if (content.isSome()) {
                        content.getOrThrow()()
                    } else {
                        ForEach(
                            props.actions,
                            {
                                action: SilkActionSheetAction, i: Int64 => ActionSheetItemBuilder(action, i)
                            }
                        )
                    }
                }
            }
                .constraintSize(maxHeight: 70.percent)
                .width(100.percent)
                ContentCancel()
        }
            .width(100.percent)
    }
}
