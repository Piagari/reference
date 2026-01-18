/**
 * Created on 2024/8/18
 */
package ohos_app_cangjie_entry.common

internal import ohos.base.*
import std.collection.ArrayList
import ohos.state_macro_manage.*
import cj_res_entry.app

public class Constants {
    /**
     * FULL SIZE
     */
    public static let FULL_SIZE: Length = 100.percent

    /**
     * List item width.
     */
    public static let LIST_ITEM_WIDTH: Length = 30.percent

    /**
     * List width
     */
    public static let LIST_WIDTH: Length = 80.percent

    /**
     * Column width.
     */
    public static let COLUMN_WIDTH: Length = 60.percent

    /**
     * Video information width
     */
    public static let VIDEO_INFO_WIDTH: Length = 80.percent

    /**
     * Text width
     */
    public static let TEXT_WIDTH: Length = 70.percent

    /**
     * Column height
     */
    public static let COLUMN_HEIGHT: Length = 100.percent

    /**
     * Row width
     */
    public static let ROW_WIDTH: Length = 66.percent

    /**
     * Duration
     */
    public static let DURATION: Int32 = 200

    /**
     * 首页顶部Tabs列表
     **/
    public static let topTabList: ArrayList<CJResource> = ArrayList<CJResource>(
        [
            @r(app.string.live),
            @r(app.string.game),
            @r(app.string.free_tv),
            @r(app.string.exp),
            @r(app.string.children),
            @r(app.string.address),
            @r(app.string.playlet),
            @r(app.string.winnow),
            @r(app.string.focus),
            @r(app.string.recommend)
        ]
    )

    /**
    *首页底部Tabs列表
    **/
    public static let bottomTabList: Array<CJResource> = [@r(app.string.home), @r(app.string.friend),@r(app.media.ic_plus_square),@r(app.string.message), @r(app.string.my)]


    /*
    * 我的页面tabs列表
    */
    public static let my_tablist:Array<String> = ["作品","私密","推荐","收藏","喜欢"]
}
