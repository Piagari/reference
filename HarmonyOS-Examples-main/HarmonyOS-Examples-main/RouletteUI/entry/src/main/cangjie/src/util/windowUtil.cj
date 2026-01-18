/**
 * Created on 2024/9/6
 */
package ohos_app_cangjie_entry.util

import ohos.base.*
import ohos.window.*
import ohos.ability.*

public class WindowUtil {

    //获取屏幕宽高
    public func getWindowUtilRect(windowStage: WindowStage):(UInt32,UInt32) {
        //获取该WindowStage实例下的主窗口。
        let window: Window = windowStage.getMainWindow()
        //获取当前窗口的属性
        let properties: WindowProperties = window.getWindowProperties()
        //获取宽
        let width: UInt32 = properties.windowRect.width
        //获取高
        let height: UInt32 = properties.windowRect.height
        //用一个元组来存储获取到的长和宽
        (width, height)
    }
}
