/**
 * Created on 2024/8/24
 */
package ohos_app_cangjie_entry.model

import std.collection.ArrayList
import cj_res_entry.app
import ohos.state_macro_manage.*

public class CommentDataModel {
    //头像
    private var avatar: CJResource
    //昵称
    private var nickname: String
    //评论内容
    private var commentContent: String
    //评论时间
    private var createTime: String
    //地址
    private var address: String
    //点赞数
    private var likeCount: String
    //踩
    private var dislikeCount: String

    public CommentDataModel( avatar: CJResource,  nickname: String,  commentContent: String, createTime: String,
        address: String, likeCount: String, dislikeCount: String) {
        this.avatar = avatar
        this.nickname = nickname
        this.commentContent = commentContent
        this.createTime = createTime
        this.address = address
        this.likeCount = likeCount
        this.dislikeCount = dislikeCount
    }

    public func getAvatar(): CJResource {
        return this.avatar
    }
    public func getNickname(): String {
        return this.nickname
    }
    public func getCommentContent(): String {
        return this.commentContent
    }
    public func getCreateTime(): String {
        return this.createTime
    }
    public func getAddress(): String {
        return this.address
    }
    public func getLikeCount(): String {
        return this.likeCount
    }
    public func getDisLikeCount(): String {
        return this.dislikeCount
    }

    public func setAvatar(value: CJResource) {
        this.avatar = value
    }
    public func setNickname(value: String) {
        this.nickname = value
    }
    public func setCommentContent(value: String) {
        this.commentContent = value
    }
    public func setCreateTime(value: String) {
        this.createTime = value
    }
    public func setAddress(value: String) {
        this.address = value
    }
    public func setLikeCount(value: String) {
        this.likeCount = value
    }
    public func setDisLikeCount(value: String) {
        this.dislikeCount = value
    }
}

public let CommentDataList: ArrayList<CommentDataModel> = ArrayList<CommentDataModel>(
    CommentDataModel(@r(app.media.ic_other_img), "张三", "哈哈哈哈哈哈", "2024/08/24 10:00:00", "M78", "100", "0"),
    CommentDataModel(@r(app.media.ic_other_img), "李四", "11111111", "2024/08/24 14:00:00", "地球", "101", "0"),
    CommentDataModel(@r(app.media.ic_other_img), "王五", "神了！！！", "2024/08/24 19:00:00", "火星", "102", "0"),
    CommentDataModel(@r(app.media.ic_other_img), "赵六", "遥遥领先", "2024/08/24 23:00:00", "水星", "103", "0"),
    CommentDataModel(@r(app.media.ic_other_img), "奥特曼", "大狙起了，一枪秒了，我能怎么办嘛", "2024/08/22 10:00:00",
        "木星", "104", "0"),
    CommentDataModel(@r(app.media.ic_other_img), "超人", "我带刀，带刀好人！", "2024/08/21 01:00:00", "金星", "105", "0"
    ),
    CommentDataModel(@r(app.media.ic_other_img), "钢铁侠", "Love you three thousand times", "2024/08/20 08:00:00",
        "土星", "106", "0"),
    CommentDataModel(@r(app.media.ic_other_img), "离谱的人生", "这是电视剧", "2024/08/19 21:00:00", "海王星", "107", "0"
    ),
)
