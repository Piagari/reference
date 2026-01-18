/**
 * Created on 2024/10/7
 */
package ohos_app_cangjie_entry.component.my

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*
import cj_res_entry.*
import ohos_app_cangjie_entry.common.Constants

@Component
public class MyInfo {
    @State
    var currentIndex: Int64 = 0

    func build() {
        Column(20) {
            Row(15) {
                basicInfoOne(999, "获赞")
                basicInfoOne(999, "朋友")
                basicInfoOne(999, "关注")
                basicInfoOne(999, "粉丝")
                Text("编辑资料").fontSize(16).fontWeight(FontWeight.Bold).width(80).height(30).backgroundColor(
                    @r(app.color.my_body_top_row_down_img_color)).layoutWeight(1).textAlign(TextAlign.Center).
                    borderRadius(5.vp)
            }
            Column(5) {
                Row() {
                    Text("点击添加介绍，让大家认识你...").fontColor(@r(app.color.message_text_color)).fontSize(12)
                    Image(@r(app.media.ic_pencil_line_1)).width(15).aspectRatio(1)
                }
                Row(5) {
                    Row() {
                        //占位
                        Text("")
                        Text("24岁").fontSize(10).fontWeight(FontWeight.Regular)
                    }.backgroundColor(@r(app.color.my_body_top_row_down_img_color)).padding(5).borderRadius(5.vp)
                    Row() {
                        Image(@r(app.media.ic_plus)).width(10).aspectRatio(1)
                        Text("添加所在市、学校等标签").fontSize(10).fontWeight(FontWeight.Regular)
                    }.borderRadius(5.vp).backgroundColor(@r(app.color.my_body_top_row_down_img_color)).padding(5)
                }.width(100.percent)
            }.width(100.percent).alignItems(HorizontalAlign.Start)

            //工具
            Row() {
                toolItem(@r(app.media.ic_shopping), "商城")
                toolItem(@r(app.media.ic_clock), "观看历史")
                toolItem(@r(app.media.ic_wallet_one), "我的钱包")
                toolItem(@r(app.media.ic_person), "常访问的人")
                toolItem(@r(app.media.ic_bytedance_applets), "我的小程序")
                toolItem(@r(app.media.ic_more_black), "查看更多")
            }.width(100.percent).justifyContent(FlexAlign.SpaceBetween)

            //视频内容类型列表
            List() {
                ForEach(
                    Constants.my_tablist,
                    itemGeneratorFunc: {
                        item: String, index: Int64 => ListItem() {
                            this.contentItem(item, index)
                        }.width(20.percent)
                        .borderWidth(EdgeWidths(bottom: 1.vp)).borderColor(
                            this.changeItemBorderColorByIndex(index))
                        .onClick({evt=>
                            this.currentIndex = index
                            })
                        .padding(bottom:5)
                    }
                )
            }
            .width(100.percent)
            .height(27)
            .listDirection(Axis.Horizontal)
            .borderWidth(EdgeWidths(bottom: 1.vp))
            .borderColor(@r(app.color.my_body_top_row_down_img_color))
        }.width(100.percent).height(100.percent)
        .borderRadius(topLeft: 10.vp, topRight: 10.vp)
        .padding(top: 10, right: 15, left: 15)
        .margin(top:-50)
    }

    //获赞、朋友、关注、粉丝
    @Builder
    func basicInfoOne(count: Int64, label: String) {
        Column(5) {
            Text(count.toString()).fontSize(16).fontWeight(FontWeight.Bold)
            Text(label).fontSize(14).fontColor(@r(app.color.message_text_color))
        }
    }

    //商城、观看历史、钱包、常访问的人、小程序、查看更多
    @Builder
    func toolItem(img: CJResource, label: String) {
        Column(5) {
            Image(img).width(24).aspectRatio(1)
            Text(label).fontSize(12)
        }
    }

    //作品、私密、推荐、收藏、喜欢
    @Builder
    func contentItem(label: String, index: Int64) {
        Text(label)
        .fontSize(16)
        .fontColor(this.changeTextColorByIndex(index))
        .fontWeight(FontWeight.Bold)
    }

    //根据用户的点击index更改contentItem中的字体的颜色
    private func changeTextColorByIndex(index: Int64): CJResource {
        match (this.currentIndex == index) {
            case true => @r(app.color.light_black)
            case _ => @r(app.color.message_text_color)
        }
    }

    //根据用户点击index控制相关视频内容类型列表item的底部边框显隐
    private func changeItemBorderColorByIndex(index: Int64): Color {
        match (this.currentIndex == index) {
            case true => Color.BLACK
            case _ => Color.TRANSPARENT
        }
    }
}
