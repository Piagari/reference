/**
 * Created on 2024/9/6
 */
package ohos_app_cangjie_entry.bean
import serialization.serialization.*
import std.math.*
import encoding.json.*
import std.collection.*

public class ResponseResult<T> <:Serializable<ResponseResult<T>> where T<:Serializable<T> {

    public var data: Option<T> = Option<T>.None
    public var errorCode:Int64 = 0
    public var errorMsg:String = ""

    public func serialize(): DataModel {
        return DataModelStruct()
            .add(field<Option<T>>("data", data))
            .add(field<Int64>("errorCode", errorCode))
            .add(field<String>("errorMsg", errorMsg))

    }
    public static func deserialize(dm: DataModel): ResponseResult<T> {
      var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        var result = ResponseResult<T>()
        result.data = Option<T>.deserialize(dms.get("data"))
        result.errorCode = Int64.deserialize(dms.get("errorCode"))
        result.errorMsg = String.deserialize(dms.get("errorMsg"))

        return  result

    }


//    public func toString(){
//        return "errorCode=${this.errorCode},errorMsg=${errorMsg},data=${data}"
//    }
}