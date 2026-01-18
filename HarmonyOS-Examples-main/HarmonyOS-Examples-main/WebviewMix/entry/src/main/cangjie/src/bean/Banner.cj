/**
 * Created on 2024/9/9
 */
package ohos_app_cangjie_entry.bean
internal import ohos.state_manage.*
import ohos.state_macro_manage.*
import serialization.serialization
import ohos.base.CJResource

/**首页轮播图  */
public class Banner{

    public let imagePath:CJResource
    public let title:String
    public let url:String

    public Banner(imagePath:CJResource,title:String,url:String){
        this.imagePath = imagePath
        this.title = title
        this.url = url
    }

}