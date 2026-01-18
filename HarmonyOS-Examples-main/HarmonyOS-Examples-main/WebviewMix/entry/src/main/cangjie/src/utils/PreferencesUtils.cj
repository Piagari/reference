/**
 * Created on 2024/9/13
 */
package ohos_app_cangjie_entry.utils
internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*
import cj_res_entry.app //用于导入@r
import ohos.preferences.*

//Preferences工具类
public class PreferencesUtils {
      //单例
    private PreferencesUtils(){}
    private static var instance:PreferencesUtils = PreferencesUtils()
    public static func  getInstance():PreferencesUtils{
        return instance
    }



	
}