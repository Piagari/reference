/**
 * Created on 2024/9/13
 */
package ohos_app_cangjie_entry.utils
import ohos.component.*
import std.collection.*
import encoding.json.*
import serialization.serialization.*
import ohos_app_cangjie_entry.bean.*
import std.math.*
import ohos.base.*
import ohos_app_cangjie_entry.bean.*
import std.collection.*
import ohos.hilog.*

/*** 说明，次方法扩展的UI库暂时无法引用 */

//1-扩展TextInput
extend TextInput {

    public func inputStyle() {
        this
        .placeholderColor(0x808080)
        .height(45)
        .fontSize(18)
        .backgroundColor(0xFFFAFA)
        .width(100.percent)
        .padding(left:0)
        .margin(top:12)
    }
}

//2-扩展Text
extend Text{

    func blueTextStyle(){
        this
        .fontColor(0x1E90FF)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)

    }
}
//3-扩展Line
extend Line {

    func lineStyle(){
        this.width(100.percent)
        .height(1)
        .backgroundColor(0x808080)
    }

}