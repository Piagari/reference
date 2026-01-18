package ohos_app_cangjie_entry

internal import ohos.base.LengthProp
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.router.Router
import ohos_app_cangjie_entry.constants.{PageListConstants, PageItem}
import silkui.components.icon.SilkIcon
import ohos.base.Color
import ohos.font.Font
import ohos.prompt_action.PromptAction
import silkui.components.icon.SilkIconRegisterIconFont
import std.collection.HashMap



@Entry
@Component
class MyView {
    let message: String = "SILK_UI"
    func build() {
        Column {
            Text(message).fontSize(40).fontWeight(FontWeight.W600)
            .flexShrink(0)
            List(space: 15) {
                ForEach(
                    PageListConstants.items,
                    itemGeneratorFunc: {
                        item: PageItem, _: Int64 => ListItem() {
                            Button(item.title).onClick({
                                evt => Router.push(url: item.name)
                            })
                        }
                    }
                )
            }
            .layoutWeight(1)
        }.width(100.percent).height(100.percent)
    }
}


