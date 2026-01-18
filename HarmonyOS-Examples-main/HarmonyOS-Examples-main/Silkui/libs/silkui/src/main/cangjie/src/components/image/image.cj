/**
 * Created on 2025/5/9
 *
 * SilkImage 图片组件
 *
 * 增强版的 img 标签，提供多种图片填充模式，支持加载中提示、加载失败提示。
 *
 * ## 基础用法
 * ```
 * SilkImage(
 *   props: SilkImageOptions(
 *     src: "https://example.com/image.jpg",
 *     width: 100.vp,
 *     height: 100.vp
 *   )
 * )
 * ```
 *
 * ## 填充模式
 * ```
 * SilkImage(
 *   props: SilkImageOptions(
 *     src: "https://example.com/image.jpg",
 *     width: 100.vp,
 *     height: 100.vp,
 *     fit: SilkImageFit.COVER
 *   )
 * )
 * ```
 *
 * ## 圆形图片
 * ```
 * SilkImage(
 *   props: SilkImageOptions(
 *     src: "https://example.com/image.jpg",
 *     width: 100.vp,
 *     height: 100.vp,
 *     round: true
 *   )
 * )
 * ```
 *
 * @module silkui/components/image
 */
package silkui.components.image

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.resource_manager.*
import ohos.state_macro_manage.*
import cj_res_silkui.*
import silkui.types.DefaultBuilder
import silkui.ResourceStr
import silkui.ResourceColor
import silkui.utils.ResourceStrToString
import silkui.utils.ResourceColorToColor
import silkui.components.icon.SilkIcon
import silkui.constants.getImageColorConstant
import silkui.constants.SilkImageColorKey
import silkui.constants.getImageSizeConstant
import silkui.constants.SilkImageSizeKey

/**
 * 图片组件
 *
 * 增强版的 img 标签，提供多种图片填充模式，支持加载中提示、加载失败提示
 */
@Component
public class SilkImage {
    /**
     * 图片链接
     *
     * 可以是图片URL、资源引用等
     */
    @Prop
    var src: ResourceStr

    /**
     * 图片配置选项
     */
    @Prop
    var props: SilkImageOptions

    /**
     * 自定义内容构建器
     *
     * 用于在图片下方添加自定义内容
     */
    @BuilderParam
    var Children: () -> Unit = DefaultBuilder

    /**
     * 自定义加载中提示构建器
     *
     * 用于自定义加载中的提示内容
     */
    @BuilderParam
    var Loading: () -> Unit = DefaultBuilder

    /**
     * 自定义加载失败提示构建器
     *
     * 用于自定义加载失败时的提示内容
     */
    @BuilderParam
    var Error: () -> Unit = DefaultBuilder

    /**
     * 是否正在加载
     */
    @State
    var isLoading: Bool = true

    /**
     * 是否加载失败
     */
    @State
    var isError: Bool = false

    /**
     * 点击事件回调
     */
    public var click: (event: ClickEvent) -> Unit = {_ =>}

    /**
     * 加载完成事件回调
     */
    public var load: () -> Unit = {=>}

    /**
     * 加载失败事件回调
     */
    public var error: () -> Unit = {=>}

    /**
     * 获取图片的填充模式
     *
     * 将SilkImageFit枚举转换为ImageFit枚举
     *
     * @return 图片填充模式
     */
    private func getImageFit(): ImageFit {
        match (props.fit) {
            case SilkImageFit.CONTAIN => ImageFit.Contain
            case SilkImageFit.COVER => ImageFit.Cover
            case SilkImageFit.FILL => ImageFit.Fill
            case SilkImageFit.NONE => ImageFit.None
            case SilkImageFit.SCALE_DOWN => ImageFit.ScaleDown
        }
    }

    /**
     * 获取图片的位置
     *
     * 将SilkImagePosition枚举转换为Alignment枚举
     *
     * @return 图片位置
     */
    private func getImagePosition(): Alignment {
        match (props.position) {
            case SilkImagePosition.TOP => Alignment.Top
            case SilkImagePosition.RIGHT => Alignment.End
            case SilkImagePosition.BOTTOM => Alignment.Bottom
            case SilkImagePosition.LEFT => Alignment.Start
            case SilkImagePosition.CENTER => Alignment.Center
        }
    }

    /**
     * 处理图片加载完成事件
     *
     * @param event 加载事件
     */
    private func handleLoad(event: CJImageComplete) {
        isLoading = false
        load()
    }

    /**
     * 处理图片加载失败事件
     */
    private func handleError() {
        isLoading = false
        isError = true
        error()
    }

    /**
     * 渲染加载中状态
     */
    @Builder
    private func renderLoading() {
        if (hasLoading) {
            Loading()
        } else {
            Column() {
                SilkIcon(
                    name: props.loadingIcon,
                    fontSize: props.iconSize,
                    fontColor: getImageColorConstant(SilkImageColorKey.IMAGE_LOADING_ICON_COLOR),
                    family: props.iconPrefix
                )
            }
                .width(100.percent)
                .height(100.percent)
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
                .backgroundColor(
                    ResourceColorToColor(getImageColorConstant(SilkImageColorKey.IMAGE_PLACEHOLDER_BACKGROUND)))
        }
    }

    /**
     * 渲染加载失败状态
     */
    @Builder
    private func renderError() {
        if (hasError) {
            Error()
        } else {
            Column() {
                SilkIcon(
                    name: props.errorIcon,
                    fontSize: props.iconSize,
                    fontColor: getImageColorConstant(SilkImageColorKey.IMAGE_ERROR_ICON_COLOR),
                    family: props.iconPrefix
                )
            }
                .width(100.percent)
                .height(100.percent)
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
                .backgroundColor(
                    ResourceColorToColor(getImageColorConstant(SilkImageColorKey.IMAGE_PLACEHOLDER_BACKGROUND)))
        }
    }

    /**
     * 构建组件UI
     */
    func build() {
        Column() {
            Stack() {
                // 始终渲染图片，让它在后台加载
                if ((src is String)) {
                    Image((src as String).getOrThrow())
                        .objectFit(getImageFit())
                        .objectRepeat(ImageRepeat.NoRepeat)
                        .alt(ResourceStrToString(props.alt))
                        .onComplete({e => handleLoad(e)})
                        .onError({_ => handleError()})
                        .opacity(if (isLoading || isError) {
                            0
                        } else {
                            1
                        })
                } else {
                    Image((src as CJResource).getOrThrow())
                        .objectFit(getImageFit())
                        .objectRepeat(ImageRepeat.NoRepeat)
                        .alt(ResourceStrToString(props.alt))
                        .onComplete({e => handleLoad(e)})
                        .onError({_ => handleError()})
                        .opacity(if (isLoading || isError) {
                            0
                        } else {
                            1
                        })
                }

                // 根据状态显示加载或错误提示
                if (isLoading && props.showLoading) {
                    renderLoading()
                } else if (isError && props.showError) {
                    renderError()
                }
            }
                .width(if (props.width.isSome()) {
                    props.width.getOrThrow()
                } else {
                    100.percent
                })
                .height(if (props.height.isSome()) {
                    props.height.getOrThrow()
                } else {
                    100.percent
                })
                .borderRadius(if (props.round) {
                    50.percent
                } else {
                    props.radius
                })
                .clip(true)
                .onClick(click)

            Children()
        }.width(if (props.width.isSome()) {
            props.width.getOrThrow()
        } else {
            100.percent
        })
    }

    /**
     * 是否有自定义加载中提示
     */
    public var hasLoading: Bool = false

    /**
     * 是否有自定义加载失败提示
     */
    public var hasError: Bool = false
}
