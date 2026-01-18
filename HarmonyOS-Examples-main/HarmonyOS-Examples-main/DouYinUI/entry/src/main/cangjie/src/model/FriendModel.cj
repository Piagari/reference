/**
 * Created on 2024/8/29
 */
package ohos_app_cangjie_entry.model

import ohos.base.CJResource
import ohos.state_macro_manage.*
import cj_res_entry.app
import std.collection.ArrayList

public class FriendModel <: Message {
    //头像
    let img: CJResource
    //名称
    let name: String
    //状态
    let status: String

    public FriendModel(img: CJResource, name: String, status: String,message:String) {
        super(message)
        this.img = img
        this.name = name
        this.status = status
    }

    public func getImg(): CJResource {
        return this.img
    }

    public func getName(): String {
        return this.name
    }

    public func getStatus(): String {
        return this.status
    }

    public override func getMessage():String{
        return this.message
    }
}

//好友列表
public let FriendList: ArrayList<FriendModel> = ArrayList<FriendModel>(
    [
        FriendModel(@r(app.media.head), "帕鲁", "在线", "[分享视频] · 08/16"),
        FriendModel(@r(app.media.head), "帕鲁", "不在线", "[分享视频] · 08/16"),
        FriendModel(@r(app.media.head), "帕鲁", "在线", "[分享视频] · 08/16"),
        FriendModel(@r(app.media.head), "帕鲁", "不在线", "[分享视频] · 08/16"),
        FriendModel(@r(app.media.head), "帕鲁", "在线", "[分享视频] · 08/16"),
        FriendModel(@r(app.media.head), "帕鲁", "不在线", "[分享视频] · 08/16"),
        FriendModel(@r(app.media.head), "帕鲁", "在线", "[分享视频] · 08/16"),
        FriendModel(@r(app.media.head), "帕鲁", "不在线", "[分享视频] · 08/16"),
        FriendModel(@r(app.media.head), "帕鲁", "在线", "[分享视频]· 08/16")
    ]
)
