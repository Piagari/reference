/**
 * Created on 2024/9/11
 */
package ohos_app_cangjie_entry.bean
import serialization.serialization.*
import std.math.*
import encoding.json.*
import std.collection.*

/**
* 传递网页数据：标题+链接
*/

public class WebBean <:Serializable<WebBean> {
     public var title:String = ""
     public var url:String = ""

   public override  func  serialize(): DataModel {
        return DataModelStruct()
                .add(field<String>("title", title))
                .add(field<String>("url", url))

    }

    public  static  func deserialize(dm: DataModel): WebBean {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        var result = WebBean()
        result.title = String.deserialize(dms.get("title"))
        result.url = String.deserialize(dms.get("url"))

        return  result
    }
    public func toString() {
    	return "title=${title},url=${url}"
    }
}