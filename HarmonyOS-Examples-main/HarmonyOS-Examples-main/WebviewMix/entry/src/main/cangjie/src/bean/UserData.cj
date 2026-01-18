/**
 * Created on 2024/9/12
 */
package ohos_app_cangjie_entry.bean
import serialization.serialization.*
import std.math.*
import encoding.json.*
import std.collection.*
public class UserData <:Serializable<UserData>{

    public var coinInfo: Option<CoinInfo> = Option<CoinInfo>.None
    public var userInfo: Option<UserInfo> = Option<UserInfo>.None

    public func serialize(): DataModel {
        return DataModelStruct()
         .add(field<Option<CoinInfo>>("coinInfo", coinInfo))
         .add(field<Option<UserInfo>>("userInfo", userInfo))

    }
    public static func deserialize(dm: DataModel): UserData {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        var result = UserData()
        result.coinInfo = Option<CoinInfo>.deserialize(dms.get("coinInfo"))
        result.userInfo = Option<UserInfo>.deserialize(dms.get("userInfo"))

        return result
    }
}

public class UserInfo <:Serializable<UserInfo>{

    public var admin:Bool = false
    public var chapterTops:Option<Array<Int64>> = Option<Array<Int64>>.None
    public var coinCount:Int64 = 0
    public var collectIds:Option<Array<Int64>> = Option<Array<Int64>>.None
    public var email:String = ""
    public var icon:String = ""
    public var id:Int64 = 0
    public var nickname:String = ""
    public var password:String = ""
    public var publicName:String = ""
    public var token:String = ""
    //public var `type`:Int64 = 0 //特殊符号，易出错，暂停解析
    public var username:String = ""

     public func serialize(): DataModel {
        return DataModelStruct()
         .add(field<Bool>("admin", admin))
         .add(field<Option<Array<Int64>>>("chapterTops", chapterTops))
         .add(field<Int64>("coinCount", coinCount))
         .add(field<Option<Array<Int64>>>("collectIds", collectIds))
         .add(field<String>("email", email))
         .add(field<String>("icon", icon))
         .add(field<Int64>("id", id))
         .add(field<String>("nickname", nickname))
         .add(field<String>("password", password))
         //.add(field<Int64>("`type`", `type`))
         .add(field<String>("username", username))


    }
    public static func deserialize(dm: DataModel): UserInfo {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        var result = UserInfo()
        result.admin = Bool.deserialize(dms.get("admin"))
        result.chapterTops = Option<Array<Int64>>.deserialize(dms.get("chapterTops"))
        result.coinCount = Int64.deserialize(dms.get("coinCount"))
        result.collectIds = Option<Array<Int64>>.deserialize(dms.get("collectIds"))
        result.email = String.deserialize(dms.get("email"))
        result.icon = String.deserialize(dms.get("icon"))
        result.id = Int64.deserialize(dms.get("id"))
        result.nickname = String.deserialize(dms.get("nickname"))
        //result.`type` = Int64.deserialize(dms.get("type"))
        result.username = String.deserialize(dms.get("username"))

        return result
    }

}
public class CoinInfo  <:Serializable<CoinInfo>{

    public var coinCount:Int64 = 0
    public var level:Int64 = 0
    public var nickname:String = ""
    public var rank:String = ""
    public var userId:Int64 = 0
    public var username:String = ""

	 public func serialize(): DataModel {
        return DataModelStruct()
         .add(field<Int64>("coinCount", coinCount))
         .add(field<Int64>("level", level))
         .add(field<String>("nickname", nickname))
         .add(field<String>("rank", rank))
         .add(field<Int64>("userId", userId))
         .add(field<String>("username", username))


    }
    public static func deserialize(dm: DataModel): CoinInfo {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        var result = CoinInfo()

        result.coinCount = Int64.deserialize(dms.get("coinCount"))
        result.level = Int64.deserialize(dms.get("level"))
        result.nickname = String.deserialize(dms.get("nickname"))
        result.rank = String.deserialize(dms.get("rank"))
        result.userId = Int64.deserialize(dms.get("userId"))
        result.username = String.deserialize(dms.get("username"))

        return result
    }
}