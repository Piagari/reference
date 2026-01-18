/**
 * Created on 2024/9/9
 */
package ohos_app_cangjie_entry.api
import ohos.base.*
import std.collection.*
import ohos_app_cangjie_entry.bean.*
import cj_res_entry.app //用于导入@r
import ohos.state_macro_manage.r

public class MockService {

    //1-首页轮播图
    public static var bannerList:ArrayList<Banner> = ArrayList<Banner>(
        Banner(@r(app.media.img_banner_1),  "鸿蒙学习路径",  "https://gongpujun.blog.csdn.net/article/details/141126597"),
        Banner(@r(app.media.img_banner_2),  "鸿蒙开发",  "https://blog.csdn.net/panerchao/article/details/139080326"),
        Banner(@r(app.media.img_banner_3),  "鸿蒙应用开发学习",  "https://blog.csdn.net/m0_37449634/article/details/136329862"),
        )


	
}