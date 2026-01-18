/**
 * Created on 2024/8/22
 */
package ohos_app_cangjie_entry.component.home.videoSwiper

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.image.PixelMap
import ohos.state_macro_manage.*
import ohos.concurrency.*
import std.collection.*
import ohos.hilog.*
import cj_res_entry.app
import ohos_app_cangjie_entry.model.{VideoDataModel, VideoDataSource}
import ohos_app_cangjie_entry.model.{TopTabListData}
import ohos_app_cangjie_entry.common.Constants

@Component
public class VideoSwiper {
    private var swiperController: SwiperController = SwiperController()
    @State
    var index: Int64 = 0

    var videoIndex: UInt32 = 0

    @State
    var imgIndexStr: String = "01"
    var imgIndex: Int64 = 1

    //目前没有Video组件数据使用图片代替
    let videoData: ArrayList<VideoDataModel> = ArrayList<VideoDataModel>(
        VideoDataModel(@r(app.media.ic_img01), "张三", "你好你好你好。。。。", "2024-8-22 14:56", @r(app.media.head),
            "1111", "1111", "1112", "1113", "你好", 0),
        VideoDataModel(@r(app.media.ic_img02), "李四", "嗨嗨嗨嗨。。。。", "2024-8-21 14:56", @r(app.media.head), "1111",
            "1116", "1117", "1119", "你好", 1),
        VideoDataModel(@r(app.media.ic_img03), "王五", "哈哈哈哈哈哈哈。。。。", "2024-8-20 14:56", @r(app.media.head),
            "1112", "1514", "1122", "1133", "你好", 2),
    )

    // 文档的 aboutToAppear()
    protected override func aboutToAppear() {
        if (this.videoIndex >= 0) {
            this.index = Int64(this.videoIndex)
        }
    }

    func build() {
        Column() {
            Swiper(swiperController) {
                ForEach(
                    this.videoData,
                    itemGeneratorFunc: {
                        item: VideoDataModel, index: Int64 => Stack(Alignment.Center) {
                            Stack(Alignment.BottomStart) {
                                Stack(Alignment.BottomEnd) {
                                    Image("https://game.gtimg.cn/images/val/agamezlk/portrait/${this.imgIndexStr}.png").
                                        width(Constants.FULL_SIZE).height(Constants.FULL_SIZE).objectFit(
                                        ImageFit.Contain)

                                    RightComponent(
                                        head: item.getHead(),
                                        likeCount: item.getLickCount(),
                                        commentCount: item.getCommentCount(),
                                        favoriteCount: item.getFavoriteCount(),
                                        shareCount: item.getShareCount(),
                                        index: item.getIndex()
                                    )
                                }.width(Constants.FULL_SIZE).height(Constants.FULL_SIZE).padding(0)

                                VideoInfoComponent(
                                    name: item.getName(),
                                    description: item.getDescription(),
                                )
                                Row() {
                                    Row(5) {
                                        Image(@r(app.media.ic_search_filled)).height(14.vp).width(14.vp).fillColor(
                                            @r(app.color.nor_white))
                                        Text("相关搜索").fontSize(14.vp).fontColor(@r(app.color.nor_white)).fontWeight(FontWeight.Bold)
                                        Text(" · " + item.getHotspot()).fontSize(12.vp).maxLines(1).width(
                                            item.getHotspot().size * 12).fontColor(Color.WHITE).height(20.vp).
                                            textOverflow(TextOverflow.Ellipsis).layoutWeight(1).fontWeight(FontWeight.Bold)
                                    }.width(Constants.ROW_WIDTH)

                                    Row() {
                                        Image(@r(app.media.ic_arrow_right)).width(24).aspectRatio(1) //宽高比1:1
                                            .fillColor(@r(app.color.dark_gray_color))
                                    }.layoutWeight(1).justifyContent(FlexAlign.End)
                                }.width(Constants.FULL_SIZE).height(36.vp).backgroundColor(@r(app.color.light_black)).opacity(0.7).
                                    padding(left: 12.vp, right: 12.vp).justifyContent(FlexAlign.Start)
                            }.width(Constants.FULL_SIZE).height(Constants.FULL_SIZE)
                        }.margin(bottom: 50.vp)
                    }
                )
            }.index(videoIndex).width(Constants.FULL_SIZE).height(Constants.FULL_SIZE).autoPlay(false).indicator(false).
                loop(true).duration(UInt32(Constants.DURATION)).cachedCount(0).vertical(true).itemSpace(0).curve(
                Curve.Linear).onChange(
                {
                    index: Int32 =>
                    this.index = Int64(index)
                    videoIndex = UInt32(index)
                    //刷新图片的index
                    if (this.imgIndex <= 9) {
                        this.imgIndex++
                        var idx = this.imgIndex
                        this.imgIndexStr = "0${idx}"
                    } else if (this.imgIndex > 9 && this.imgIndex <= 24) {
                        this.imgIndex++
                        this.imgIndexStr = this.imgIndex.toString()
                    } else {
                        this.imgIndexStr = "01"
                        this.imgIndex = 1
                    }
                }
            )
        }.width(Constants.FULL_SIZE).height(Constants.FULL_SIZE).backgroundColor(Color.BLACK).expandSafeArea(
            types: [SafeAreaType.SYSTEM], edges: [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    }
}
