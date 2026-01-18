/**
 * Created on 2024/8/18
 */
package ohos_app_cangjie_entry.model

import ohos.base.CJResource
import std.collection.*

// 视频数据结构。
public class VideoDataModel {
    //图片
    private let img: CJResource
    //作者名称
    private let name: String
    //作品描述
    private let description: String
    //时间
    private let time: String
    //头像
    private let head: CJResource
    //点赞数
    private let likeCount: String
    //评论数
    private let commentCount: String
    //收藏数
    private let favoriteCount: String
    //分享数
    private let shareCount: String
    //热点
    private let hotspot: String
    //索引
    private let index: Int64

    public VideoDataModel(img: CJResource, name: String, description: String, time: String, head: CJResource,
        likeCount: String, commentCount: String, favoriteCount: String, shareCount: String, hotspot: String,
        index: Int64) {
        this.img = img
        this.name = name
        this.description = description
        this.time = time
        this.head = head
        this.likeCount = likeCount
        this.commentCount = commentCount
        this.favoriteCount = favoriteCount
        this.shareCount = shareCount
        this.hotspot = hotspot
        this.index = index
    }

    public func getImg(): CJResource {
        return this.img
    }

    public func getName(): String {
        return this.name
    }

    public func getDescription(): String {
        return this.description
    }

    public func getTime(): String {
        return this.time
    }

    public func getHead(): CJResource {
        return this.head
    }

    public func getLickCount(): String {
        return this.likeCount
    }

    public func getCommentCount(): String {
        return this.commentCount
    }

    public func getFavoriteCount(): String {
        return this.favoriteCount
    }

    public func getShareCount(): String {
        return this.shareCount
    }

    public func getHotspot(): String {
        return this.hotspot
    }

    public func getIndex(): Int64 {
        return this.index
    }
}

