/**
 * Created on 2024/8/27
 */
package ohos_app_cangjie_entry.component.commonComponent

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos_app_cangjie_entry.common.Constants
import cj_res_entry.*

//底部导航栏
@Component
public class BottomTab {
    @Link
    var currentIndex: Int64

    //根据用户的点击index更改bottomTab中的字体的颜色
    private func changeTextColorByIndex(index: Int64): CJResource {
        if (this.currentIndex != index) {
            return @r(app.color.dark_gray_color)
        } else if (this.currentIndex == index && this.currentIndex > 1) {
            return @r(app.color.light_black)
        } else {
            return @r(app.color.nor_white)
        }
    }

    //根据用户点击的index更改bottomTab中间添加按钮的颜色
    private func changeAddColorByIndex(): CJResource {
        match (this.currentIndex) {
            case 0 | 1 => @r(app.color.nor_white)
            case _ => @r(app.color.light_black)
        }
    }

    //根据用户点击的index更改bottomTab的背景颜色
    private func changeBackGround(): Color {
        match (this.currentIndex) {
            case 0 | 1 => Color.TRANSPARENT
            case _ => Color.WHITE
        }
    }

    func build() {
        List() {
            ForEach(
                Constants.bottomTabList,
                itemGeneratorFunc: {
                    item: CJResource, index: Int64 => ListItem() {
                        Row() {
                            Text(item).fontSize(16.vp).fontColor(changeTextColorByIndex(index))
                            if (index == 2) {
                                Image(item).width(28.vp).aspectRatio(1).fillColor(changeAddColorByIndex())
                            }
                        }.padding(top: 15.vp).width(20.percent).height(Constants.FULL_SIZE).justifyContent(
                            FlexAlign.Center).onClick({evt => this.currentIndex = index})
                    }
                }
            )
        }.id("bottomTabList").listDirection(Axis.Horizontal).height(Constants.FULL_SIZE).width(Constants.FULL_SIZE).
            backgroundColor(changeBackGround()).expandSafeArea(types: [SafeAreaType.SYSTEM],
            edges: [SafeAreaEdge.BOTTOM])
    }
}
