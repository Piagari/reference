/**
 * Created on 2025/4/29
 */
package ohos_app_cangjie_entry.pages

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.resource_manager.*
import ohos.state_macro_manage.*
import cj_res_entry.*
import ohos_app_cangjie_entry.components.{Nav, Title}
import silkui.components.highlight.SilkHighLight
import silkui.components.highlight.SilkHighLightOptions


@Entry
@Component
class HighLightPage {

    func build() {
        Column() {
            Nav("HighLight")
            Scroll() {
                Column() {
                    Title("基础用法")
                    Row() {
                        SilkHighLight(
                            props: SilkHighLightOptions(
                                sourceString: "慢慢来，不要急，生活给你出了难题，可也终有一天会给出答案。",
                                keywords: ["难题"]
                            )
                        )
                    }
                    .padding(20)
                    Title("多字符匹配")
                    Row() {
                        SilkHighLight(
                            props: SilkHighLightOptions(
                                sourceString: "慢慢来，不要急，生活给你出了难题，可也终有一天会给出答案。",
                                keywords: ["难题", "终有一天", "答案"]
                            )
                        )
                    }
                    .padding(20)
                    Title("设置高亮文本颜色")
                    Row() {
                        SilkHighLight(
                            props: SilkHighLightOptions(
                                sourceString: "慢慢来，不要急，生活给你出了难题，可也终有一天会给出答案。",
                                keywords: ["生活"],
                                color: Color.RED
                            )
                        )
                    }
                    .padding(20)
                }
                .justifyContent(FlexAlign.Start)
            }
            .layoutWeight(1)
            .align(Alignment.Top)
        }.width(100.percent).height(100.percent)
    }

}