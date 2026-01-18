/**
 * Created on 2024/8/27
 */
package ohos_app_cangjie_entry.component.home

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*
import std.collection.*
import cj_res_entry.app
import ohos_app_cangjie_entry.common.Constants
import ohos_app_cangjie_entry.component.home.focus.Focus
import ohos_app_cangjie_entry.component.home.recommended.Recommended
import ohos_app_cangjie_entry.component.home.winnow.Winnow
import ohos_app_cangjie_entry.model.{TopTabListData}

@Component
public class Home {
    //记录用户点击顶部导航栏
    @State
    var currentIndex: Int64 = 9

    //顶部tabList

    //修改字体颜色
    private func changeFontColor(idx: Int64): CJResource {
        match (this.currentIndex == idx) {
            case true => @r(app.color.start_window_background)
            case _ => @r(app.color.font_color)
        }
    }
    //修改Divider的宽度
    private func changeDividerWidth(idx: Int64): Length {
        match (this.currentIndex == idx) {
            case true => 30.vp
            case _ => 0.vp
        }
    }

    //修改Divider的颜色
    private func changeDividerColor(idx: Int64): Color {
        match (this.currentIndex == idx) {
            case true => Color.WHITE
            case _ => Color.GRAY
        }
    }

    func build() {
        Stack(Alignment.Top) {
            if (this.currentIndex == 9) {
                //推荐页
                Recommended()
            } else if (this.currentIndex == 8) {
                //关注页
                Focus()
            } else if (this.currentIndex == 7) {
                //精选页
                Winnow()
            }
            Row {
                Image(@r(app.media.ic_topleft_sort))
                .width(20.vp).height(20.vp)
                .fillColor(@r(app.color.nor_white))
                .margin(bottom:2)
                List(space:15,initialIndex:9) {
                    ForEach(
                        Constants.topTabList,
                        itemGeneratorFunc: {
                            item: CJResource, index: Int64 => ListItem() {
                                Column() {
                                    Text(item).fontSize(16.vp).fontColor(changeFontColor(index))
                                    Divider().width(changeDividerWidth(index)).strokeWidth(2.vp).color(
                                        changeDividerColor(index)).margin(top: 5.vp)
                                }.padding(top: 15.vp).onClick(
                                    {evt => this.currentIndex = index})
                            }
                        }
                    )
                }.id("topTabList").listDirection(Axis.Horizontal).height(Constants.FULL_SIZE).width(
                    Constants.LIST_WIDTH).scrollBar(BarState.Off)
                Image(@r(app.media.ic_search_filled))
                .width(20.vp).height(20.vp)
                .fillColor(@r(app.color.nor_white))
                .margin(bottom:2)
            }.height(50.vp).width(Constants.FULL_SIZE).alignItems(VerticalAlign.Center).justifyContent(
                FlexAlign.SpaceAround)
        }.width(Constants.FULL_SIZE).height(Constants.FULL_SIZE)
    }
}


