/**
 * Created on 2025/4/27
 *
 * SilkIcon 图标组件
 *
 * 图标组件用于展示各种图标，支持字体图标和图片图标。
 *
 * ## 基础用法
 * ```
 * SilkIcon(name: "arrow")
 * ```
 *
 * ## 自定义颜色
 * ```
 * SilkIcon(name: "arrow", fontColor: Color(255, 0, 0, alpha: 1))
 * ```
 *
 * ## 自定义大小
 * ```
 * SilkIcon(name: "arrow", fontSize: 24.vp)
 * ```
 *
 * ## 使用图片URL
 * ```
 * SilkIcon(name: "https://example.com/icon.png")
 * ```
 *
 * ## 使用资源图片
 * ```
 * SilkIcon(name: @r(app.icon.arrow))
 * ```
 *
 * @module silkui/components/icon
 */
package silkui.components.icon

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.resource_manager.*
import ohos.state_macro_manage.*

import cj_res_silkui.*
import ohos.font.Font
import std.regex.Regex
import ohos.prompt_action.PromptAction
import silkui.ResourceStr
import silkui.ResourceColor
import silkui.utils.ResourceStrToString
import silkui.utils.ResourceColorToColor
import silkui.constants.SilkIconStyleKey
import silkui.constants.getIconStyleConstant
import silkui.constants.getColorConstant
import silkui.constants.SilkColorKey

/**
 * 图标组件
 *
 * 用于展示各种图标，支持字体图标和图片图标
 */
@Component
public class SilkIcon {
    /**
     * 图标名称或URL
     *
     * 可以是图标名称、图片URL或资源引用
     * 默认为"arrow"
     */
    public var name: ResourceStr = "arrow"

    /**
     * 图标颜色
     *
     * 用于设置图标的颜色
     * 默认使用文本颜色
     */
    public var fontColor: ResourceColor = getColorConstant(SilkColorKey.TEXT_COLOR)

    /**
     * 图标大小
     *
     * 用于设置图标的大小
     * 默认为32vp
     */
    public var fontSize: Length = 32.vp

    /**
     * 图标行高
     *
     * 用于设置图标的行高
     * 默认为32vp
     */
    public var lineHeight: Length  = 32.vp

//    public var icon: ResourceStr = "\u{e65e}"

    /**
     * 字体粗细
     *
     * 用于设置字体图标的粗细
     * 默认为Normal
     */
    public var weight: FontWeight = FontWeight.Normal

    /**
     * 字体族名称
     *
     * 用于指定字体图标的字体族
     * 默认使用预设字体族
     */
    public var family: ResourceStr = getIconStyleConstant(SilkIconStyleKey.ICON_FONT_FAMILY)

    /**
     * 组件即将出现时的生命周期方法
     *
     * 注册字体图标
     */
    protected override func aboutToAppear() {
        // TODO 使用资源管理注册无效
//        Font.registerFont(familyName: @r(app.string.icon_name), familySrc: @rawfile("font/SmileySans-Oblique.ttf"))

        // 注册字体图标
        Font.registerFont(familyName: ResourceStrToString(family), familySrc: "/resources/rawfile/font/iconfont.ttf")
    }

    /**
     * 判断名称是否为URL
     *
     * @param name 要判断的名称
     * @return 如果是URL返回true，否则返回false
     */
    private func isUrl (name: String): Bool {
//        // TODO  正则暂时无效
//        let urlPattern = "^https?://"
//        let regex = Regex(urlPattern)
//        return regex.matches(name).isSome()

        // 简单判断是否以http开头
        return name.startsWith("http")
    }

    /**
     * 构建组件UI
     *
     * 根据名称类型渲染不同的图标
     */
    func build () {
        if ((name is String) && isUrl((name as String).getOrThrow())) {
            // 如果是URL，渲染图片
            Image(ResourceStrToString(name))
            .width(fontSize)
            .aspectRatio(1)
            .fillColor(ResourceColorToColor(fontColor))
        } else if (name is CJResource) {
            // 如果是资源引用，渲染图片
            Image((name as CJResource).getOrThrow())
                .width(fontSize)
                .aspectRatio(1)
            .fillColor(ResourceColorToColor(fontColor))
        } else {
            // 如果是图标名称，渲染字体图标
            if (IconNames.contains(ResourceStrToString(name))) {
                    Row() {
                    Text(IconNames.get(ResourceStrToString(name)).getOrThrow())
                .fontSize(fontSize)
                .fontColor(ResourceColorToColor(fontColor))
                .fontFamily(ResourceStrToString(family))
                .fontWeight(weight)
                .align(Alignment.Center)

                    }
                .height(lineHeight)
                .alignItems(VerticalAlign.Center)

            }
        }
    }
}
