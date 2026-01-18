/**
 * Created on 2024/8/25
 */
package ohos_app_cangjie_entry.util

import std.time.*
import ohos.hilog.Hilog

//计算时间差值
public func calTimeDifference(value: String): String {
    //准备结果
    var result: String = ""
    //获取当前日期
    let todayTime: DateTime = DateTime.now()
    //将字符串格式的时间格式化成DateTime格式
    var date: DateTime = DateTime.parse(value,"yyyy/MM/dd HH:mm:ss")
    //使用Duration计算时间差返回Duration实例
    var calDate: Duration = Duration.since(date)
    //匹配计算出的时间差值，并返回对应的字符串
    if (todayTime.year - date.year > 0) {
        result = "${todayTime.year - date.year}年前"
    }else if (todayTime.month.value() - date.month.value() > 0) {
    	result = "${todayTime.month.value() - date.month.value()}月前"
    }else if (calDate.toDays() > 0 && calDate.toDays() < 30) {
    	 result = "${calDate.toDays()}天前"
    }else if (calDate.toHours() > 0 && calDate.toHours() < 24) {
        result = "${calDate.toHours()}小时前"
    }else if (calDate.toMinutes() > 0 && calDate.toMinutes() < 60) {
        result = "${calDate.toMinutes()}分钟前"
    }else if (calDate.toSeconds() > 0 && calDate.toMinutes() < 60) {
        result = "${calDate.toSeconds()}秒前"
    } else {
        result = "刚刚"
    }
    return result
}
