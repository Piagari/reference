/**
 * Created on 2024/8/21
 */
package ohos_app_cangjie_entry.component.home.videoSwiper

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.concurrency.*
import ohos.hilog.Hilog
import ohos.state_macro_manage.*
import cj_res_entry.app
import std.convert.*
import std.collection.ArrayList
import std.time.DateTime
import std.time.Duration
import ohos_app_cangjie_entry.common.Constants
import ohos_app_cangjie_entry.model.{CommentDataList, CommentDataModel, CommentDataSource}
import ohos_app_cangjie_entry.util.calTimeDifference

@Component
public class RightComponent {
    @State
    var head: CJResource = @r(app.media.app_icon)
    //点赞数
    @State
    var likeCount: String = ""
    //评论数
    @State
    var commentCount: String = ""
    //收藏数
    @State
    var favoriteCount: String = ""
    //分享数
    @State
    var shareCount: String = ""
    //是否关注
    @State
    var isFollow: Bool = false
    //是否点赞
    @State
    var isLike: Bool = false
    //是否收藏
    @State
    var isFavorite: Bool = false
    //控制评论区半模态页面的显隐
    @State
    var isShowComment: Bool = false
    @State
    var index: Int64 = 0
    //评论区半模态页面高度
    @State
    var commentSheetHeight: SheetSize = SheetSize.MEDIUM
    //评论区大家都在搜
    @State
    var hotSearch: String = "黑神话马喽"
    //评论列表
    /** @State
    var newCommentDataList: ArrayList<CommentDataModel> = ArrayList<CommentDataModel>()
     */
    @State
    var dataSourceComment: CommentDataSource = CommentDataSource(ArrayList<CommentDataModel>())
    //列表是否话划到底
    @State
    var isListEnd: Bool = false

    var controller: TextInputController = TextInputController()

    //评论的内容
    @State
    var commentContent: String = ''

    //统计点赞
    private func changeLikeCount(isAdd: Bool) {
        var likeCountNum: Int64 = Int64.parse(this.likeCount)
        if (isAdd) {
            likeCountNum++
        } else {
            likeCountNum--
        }
        this.likeCount = likeCountNum.toString()
        animateTo(
            AnimateParam(duration: Constants.DURATION, curve: Curve.EaseInOut),
            {
                => this.isLike = !this.isLike
            }
        )
    }

    //统计收藏
    private func changeFavoriteCount(isIncrease: Bool) {
        var favoriteCountNum: Int64 = Int64.parse(this.favoriteCount)
        if (isIncrease) {
            favoriteCountNum++
        } else {
            favoriteCountNum--
        }
        this.favoriteCount = favoriteCountNum.toString()
        animateTo(
            AnimateParam(duration: Constants.DURATION, curve: Curve.EaseInOut),
            {
                => this.isFavorite = !this.isFavorite
            }
        )
    }

    //关注
    private func changeisFollow(isFocus: Bool) {
        animateTo(
            AnimateParam(
                duration: Constants.DURATION,
                curve: Curve.EaseInOut
            ),
            {=> this.isFollow = !this.isFollow}
        )
    }

    //匹配SheetSize
    private func matchSheetSize(sheetSize: SheetSize): Bool {
        match (sheetSize) {
            case SheetSize.MEDIUM => true
            case _ => false
        }
    }

    //aboutToAppear()
    protected override func aboutToAppear() {
        dataSourceComment = CommentDataSource(CommentDataList)
        this.commentCount = dataSourceComment.totalCount().toString()
    }

    //评论区弹窗
    @Builder
    func commentBuilder() {
        Column() {
            Stack(Alignment.Bottom) {
                Stack(Alignment.Top) {
                    Column(14) {
                        Row() {
                            Row() {
                                Text("大家都在搜：").fontSize(18.vp).fontColor(@r(app.color.comment_text_color))
                                Text("${this.hotSearch}").fontColor(Color.BLUE).fontSize(18.vp)
                                Image(@r(app.media.ic_search_filled)).fillColor(Color.BLUE).width(10.vp).aspectRatio(
                                    1.0)
                            }.layoutWeight(1).alignItems(VerticalAlign.Top)
                            Row(10) {
                                if (this.matchSheetSize(this.commentSheetHeight)) {
                                    Image(@r(app.media.ic_arrow_up_left_and_arrow_down_right)).width(24.vp).aspectRatio(
                                        1.0).onClick({evt => this.commentSheetHeight = SheetSize.LARGE})
                                } else {
                                    Image(@r(app.media.ic_arrow_down_rightand_arrow_up_left_)).width(24.vp).aspectRatio(
                                        1.0).onClick({evt => this.commentSheetHeight = SheetSize.MEDIUM})
                                }
                                Image(@r(app.media.ic_xmark_circle_fill)).width(24.vp).aspectRatio(1.0).onClick(
                                    {evt => this.isShowComment = false})
                            }
                        }.width(100.percent).backgroundColor(@r(app.color.nor_white))
                        Row() {
                            Text(this.commentCount + "条评论").fontSize(14.vp).fontWeight(FontWeight.Bold)
                        }.width(100.percent).justifyContent(FlexAlign.Center)
                    }
                    //评论列表
                    List(space: 10) {
                        LazyForEach(
                            dataSourceComment,
                            itemGeneratorFunc: {
                                item: CommentDataModel, index: Int64 => ListItem() {
                                    commentListItemBuilder(item)
                                }
                            }
                        )
                        if (this.isListEnd) {
                            ListItem() {
                                Row() {
                                    Text("暂时没有更多内容了").fontSize(14.vp).fontColor(
                                        @r(app.color.comment_text_color))
                                }.width(100.percent).justifyContent(FlexAlign.Center)
                            }.margin(bottom: 140.vp)
                        }
                    }.width(100.percent).height(100.percent).margin(top: 60.vp).backgroundColor(@r(app.color.nor_white)).
                        onScroll(
                        {
                        idx: Float64, scrollState: ScrollState => if (idx > 0.0 && dataSourceComment.totalCount() <= 20) {
                            dataSourceComment.data_.appendAll(CommentDataList)
                            dataSourceComment.notifyChange()
                            this.commentCount = dataSourceComment.totalCount().toString()
                        }
                    }).onReachEnd({=> isListEnd = true})
                }.width(100.percent).height(100.percent).padding(left: 5, right: 5)
                //底部评论输入框
                Row() {
                    Stack(Alignment.End) {
                        TextInput(placeholder: "善语结善缘，恶言伤人心", text: this.commentContent,
                            controller: this.controller).width(100.percent).onChange(
                            {
                            value: String => this.commentContent = value
                        }).onSubmit(
                            {
                                ekt =>
                                let newComment = CommentDataModel(@r(app.media.ic_other_img), "游客", "哈哈哈哈哈哈",
                                    "", "M78", "0", "0")
                                newComment.setCommentContent(this.commentContent)
                                newComment.setCreateTime(DateTime.now().toString("yyyy/MM/dd HH:mm:ss"))
                                dataSourceComment.data_.insert(0, newComment)
                                dataSourceComment.notifyChange()
                                this.commentCount = dataSourceComment.totalCount().toString()
                                this.commentContent = ""
                            }
                        )
                        Row(10) {
                            Image(@r(app.media.ic_picture)).width(24.vp).aspectRatio(1)
                            Image(@r(app.media.ic_Eit)).width(24.vp).aspectRatio(1)
                            Image(@r(app.media.ic_emoji)).width(24.vp).aspectRatio(1)
                        }.padding(right: 5.vp)
                    }.width(100.percent)
                }.width(100.percent).height(70.vp).justifyContent(FlexAlign.Center).padding(top: 5, right: 10,
                    bottom: 10, left: 10).backgroundColor(@r(app.color.nor_white)).borderWidth(EdgeWidths(top: 0.5.vp)).
                    borderColor(@r(app.color.comment_text_color))
            }.width(100.percent).height(100.percent)
        }.width(100.percent).height(100.percent).justifyContent(FlexAlign.Start).backgroundColor(
            @r(app.color.nor_white))
    }

    @Builder
    func commentListItemBuilder(commentDataModel: CommentDataModel) {
        Column(10) {
            Row(5) {
                //头像
                Row() {
                    Image(commentDataModel.getAvatar()).width(30.vp).aspectRatio(1).borderRadius(15)
                }
                //昵称和评论内容
                Column(5) {
                    //昵称
                    Text(commentDataModel.getNickname()).fontSize(14.vp).fontColor(@r(app.color.comment_nor_text_color))
                    //评论
                    Text(commentDataModel.getCommentContent()).fontSize(16.vp).fontWeight(FontWeight.Medium).maxLines(5)
                    Row() {
                        Row(5) {
                            Text() {
                                //时间
                                Span(calTimeDifference(commentDataModel.getCreateTime()))
                                Span(" · ")
                                //地点
                                Span(commentDataModel.getAddress())
                            }.fontSize(14.vp).fontColor(@r(app.color.comment_nor_text_color))
                            //回复按钮
                            Text("回复").fontSize(14.vp).fontColor(@r(app.color.comment_text_color))
                        }.layoutWeight(1)
                        //点赞与踩row
                        Row(10) {
                            Row() {
                                Image(@r(app.media.heart)).width(24.vp).aspectRatio(1)
                                Text(commentDataModel.getLikeCount()).fontSize(14.vp).fontColor(
                                    @r(app.color.comment_text_color))
                            }
                            Row() {
                                Image(@r(app.media.dislike)).width(24.vp).aspectRatio(1)
                                Text(commentDataModel.getDisLikeCount()).fontSize(14.vp).fontColor(
                                    @r(app.color.comment_text_color))
                            }
                        }
                    }
                }.alignItems(HorizontalAlign.Start).layoutWeight(1)
            }.width(100.percent).alignItems(VerticalAlign.Top)
        }.backgroundColor(@r(app.color.nor_white)).padding(left: 5.vp, right: 5.vp)
    }

    //评论区title
    /**    @Builder
    func commentTitle() {
        Column() {
            Row() {
                Text("这是一个Title")
            }.width(100.percent).justifyContent(FlexAlign.Center)
        }
    }*/
    func build() {
        Column() {
            //头像和关注按钮
            Stack(Alignment.Bottom) {
                Image(this.head).width(45).height(45).borderRadius(22.5).border(width: 1.vp, color: Color.WHITE).
                    borderRadius(50).backgroundColor(Color.WHITE)
                if (!this.isFollow) {
                    Image(@r(app.media.ic_addfollow)).width(20).height(20).borderRadius(10).margin(bottom: -8).onClick(
                        {
                        evt => this.changeisFollow(false)
                    })
                } else {
                    Image(@r(app.media.ic_follow)).width(20).height(20).borderRadius(10).margin(bottom: -8).transition(
                        TransitionEffect.scale(ScaleOptions(z: 2.0, centerX: 50.percent, centerY: 50.percent))).onClick(
                        {
                        evt => this.changeisFollow(true)
                    })
                }
            }.width(100.percent).height(100.vp).padding(bottom: 30.vp)
            //点赞
            Column() {
                if (!this.isLike) {
                    Image(@r(app.media.fabulous)).height(30.vp).width(35.vp).objectFit(ImageFit.ScaleDown).onClick(
                        {evt => changeLikeCount(true)}).margin(bottom: 5.vp)
                    Text(this.likeCount).fontSize(10.vp).fontColor(Color.WHITE).opacity(0.7)
                } else {
                    Image(@r(app.media.fabulo)).height(30.vp).width(35.vp).objectFit(ImageFit.ScaleDown).transition(
                        TransitionEffect.scale(ScaleOptions(z: 2.0, centerX: 50.percent, centerY: 50.percent))).onClick(
                        {evt => this.changeLikeCount(false)}).margin(bottom: 5.vp)
                    Text(this.likeCount).fontSize(10.vp).fontColor(Color.WHITE).opacity(0.7)
                }
            }.width(Constants.COLUMN_WIDTH).height(60.vp)
            //评论
            Column() {
                Image(@r(app.media.ic_comment)).height(30.vp).width(35.vp).objectFit(ImageFit.ScaleDown).onClick(
                    {evt => this.isShowComment = !this.isShowComment}).bindSheet(
                    this.isShowComment,
                    commentBuilder,
                    options: SheetOptions(
                        height: this.commentSheetHeight,
                        showClose: false,
                        //dragBar:false,
                        //title:{=> commentTitle},
                        onDisappear: {
                            =>
                            this.isShowComment = false
                            this.isListEnd = false
                            this.commentSheetHeight = SheetSize.MEDIUM
                        }
                    )
                )
                Text(this.commentCount).fontSize(10.vp).fontColor(Color.WHITE).opacity(0.7)
            }.width(Constants.COLUMN_WIDTH).height(60.vp)
            //收藏
            Column() {
                if (!this.isFavorite) {
                    Image(@r(app.media.ic_star)).height(30.vp).width(35.vp).transition(
                        TransitionEffect.scale(ScaleOptions(z: 2.0, centerX: 50.percent, centerY: 50.percent))).onClick(
                        {evt => this.changeFavoriteCount(true)}).margin(bottom: 5.vp)
                    Text(this.favoriteCount).fontSize(10.vp).fontColor(Color.WHITE).opacity(0.7)
                } else {
                    Image(@r(app.media.ic_star_fill)).height(30.vp).width(35.vp).onClick(
                        {evt => this.changeFavoriteCount(false)}).margin(bottom: 5.vp)
                    Text(this.favoriteCount).fontSize(10.vp).fontColor(Color.WHITE).opacity(0.7)
                }
            }.width(Constants.COLUMN_WIDTH).height(60.vp)
            //分享
            Column() {
                Image(@r(app.media.share1)).height(30.vp).width(35.vp).objectFit(ImageFit.ScaleDown)
                Text('分享').fontSize(10.vp).fontColor(Color.WHITE).opacity(0.7)
            }.width(Constants.COLUMN_WIDTH).height(50.vp)
            //唱片
            Row() {
                Image(@r(app.media.ic_movie_fill)).width(30.vp).height(30.vp).borderRadius(50).margin(left: 2)
            }.width(Constants.COLUMN_WIDTH).height(60.vp)
        }.margin(bottom: 36.vp).height(Constants.COLUMN_HEIGHT).width(60.vp).justifyContent(FlexAlign.End)
    }
}
