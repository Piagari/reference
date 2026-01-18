/**
 * Created on 2025/7/18
 *
 * Picker 选择器组件演示页面
 */
package ohos_app_cangjie_entry.pages

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.resource_manager.*
import ohos.state_macro_manage.*
import cj_res_entry.*
import ohos_app_cangjie_entry.components.{Nav, Title}
import silkui.components.picker.{SilkPicker, SilkPickerOptions, SilkPickerColumn, SilkPickerOption}
import silkui.components.button.{SilkButton, SilkButtonOptions, SilkButtonType}
import silkui.components.popup.{SilkPopup, SilkPopupOptions, SilkPopupPosition}
import silkui.utils.ResourceStrToString
import ohos.prompt_action.PromptAction
import silkui.components.toast.SilkToast
import silkui.ResourceStr
import silkui.components.cell.SilkCell
import silkui.components.cell.SilkCellOptions
import silkui.components.picker.SilkPickerLink

@Entry
@Component
class PickerPage {
    @State
    var showBasicPicker: Bool = false

    @State
    var showMultiColumnPicker: Bool = false

    @State
    var showCascadePicker: Bool = false

    @State
    var selectedResult: String = "未选择"

    @State
    var popupFlag: Bool = false
    @State
    var popupValues: Array<String> = []

    @State
    var linkPicker: ObservedArrayList<String> = ObservedArrayList([])
    @Builder
    func PopupPicker  () {
        SilkPicker(
                            columns: ObservedArrayList([
                                SilkPickerColumn(
                                    [
                                        SilkPickerOption(text: "杭州", value: "Hangzhou"),
                                        SilkPickerOption(text: "宁波", value: "Ningbo"),
                                        SilkPickerOption(text: "温州", value: "Wenzhou"),
                                        SilkPickerOption(text: "绍兴", value: "Shaoxing"),
                                        SilkPickerOption(text: "湖州", value: "Huzhou")
                                    ]
                                )
                            ]),
                            options: SilkPickerOptions(
                                title: "标题"
                            ),
                            confirm: { values: Array<String>, indexs: Array<Int32> => popupFlag = false; this.popupValues = values},
                            cancel: {=> this.popupFlag = false}
                        )
    }


    @Builder
    func empty () {
        // TODO 等待空状态组件完成
        Image('https://fastly.jsdelivr.net/npm/@vant/assets/custom-empty-image.png')
        .width(80)
    }

    func build() {
        Column() {
            Nav("Picker")
            Scroll() {
                Column() {
                    // 基础用法
                    Title("基础用法")
                    Column(16) {
                        SilkPicker(
                            columns: ObservedArrayList([
                                SilkPickerColumn(
                                    [
                                        SilkPickerOption(text: "杭州", value: "Hangzhou"),
                                        SilkPickerOption(text: "宁波", value: "Ningbo"),
                                        SilkPickerOption(text: "温州", value: "Wenzhou"),
                                        SilkPickerOption(text: "绍兴", value: "Shaoxing"),
                                        SilkPickerOption(text: "湖州", value: "Huzhou")
                                    ]
                                )
                            ]),
                            options: SilkPickerOptions(
                            ),
                            confirm: { values: Array<String>, indexs: Array<Int32> => SilkToast.toast("values: ${values.toString()}, 索引: ${indexs.toString()}")},
                            change: { values: Array<String>, indexs: Array<Int32>, columnIndex: Int64 => SilkToast.toast("values: ${values.toString()}, 索引: ${indexs.toString()}, 列索引：${columnIndex}")},
                            cancel: {=> SilkToast.toast("取消")}
                        )
                    }.alignItems(HorizontalAlign.Start).width(100.percent).padding(16.vp)
                    // 基础用法
                    Title("搭配弹出层使用")
                    SilkCell(
                        props: SilkCellOptions(title: "选择城市", value: "内容", isLink: true),
                        click: { _=> popupFlag = true}
                    )
                    SilkPopup(show: popupFlag, props: SilkPopupOptions(position: SilkPopupPosition.BOTTOM,round: true), Children: PopupPicker)

                    Title("双向绑定")
                     Column(16){
SilkPickerLink(
                        values: linkPicker,
                            columns: ObservedArrayList([
                                SilkPickerColumn(
                                    [
                                        SilkPickerOption(text: "杭州", value: "Hangzhou"),
                                        SilkPickerOption(text: "宁波", value: "Ningbo"),
                                        SilkPickerOption(text: "温州", value: "Wenzhou"),
                                        SilkPickerOption(text: "绍兴", value: "Shaoxing"),
                                        SilkPickerOption(text: "湖州", value: "Huzhou")
                                    ]
                                )
                            ]),
                            options: SilkPickerOptions(
                            ),
                        )}.alignItems(HorizontalAlign.Start).width(100.percent).padding(16.vp)

                    // 多列选择
                    Title("多列选择")
                    Column(16) {
                        SilkPicker(
                            columns: ObservedArrayList([
                                SilkPickerColumn(
                                    [
                                        SilkPickerOption(text: "周一", value: "Monday"),
                                        SilkPickerOption(text: "周二", value: "Tuesday"),
                                        SilkPickerOption(text: "周三", value: "Wednesday"),
                                        SilkPickerOption(text: "周四", value: "Thursday"),
                                        SilkPickerOption(text: "周五", value: "Friday")
                                    ]
                                ),
                                SilkPickerColumn(
                                    [
                                        SilkPickerOption(text: "上午", value: "Morning"),
                                        SilkPickerOption(text: "下午", value: "Afternoon"),
                                        SilkPickerOption(text: "晚上", value: "Evening")
                                    ]
                                )
                            ]),
                            options: SilkPickerOptions(
                                title: "选择时间",
                            ),
                            confirm: { values: Array<String>, indexs: Array<Int32> => SilkToast.toast("values: ${values.toString()}, 索引: ${indexs.toString()}")},
                            change: { values: Array<String>, indexs: Array<Int32>, columnIndex: Int64 => SilkToast.toast("values: ${values.toString()}, 索引: ${indexs.toString()}, 列索引：${columnIndex}")},
                            cancel: {=> SilkToast.toast("取消")}
                        )
                    }.alignItems(HorizontalAlign.Start).width(100.percent).padding(16.vp)

                    // 级联选择
                    Title("级联选择")

                    Column(16) {
                        SilkPicker(
                            columns: ObservedArrayList([
                                SilkPickerColumn(
                                     [
                                        // 浙江省
                                        SilkPickerOption(
                                            text: "浙江",
                                            value: "Zhejiang", 
                                            children: [
                                                // 杭州市
                                                SilkPickerOption(
                                                    text: "杭州",
                                                    value: "Hangzhou",
                                                    children: [
                                                        SilkPickerOption(text: "西湖区", value: "Xihu"),
                                                        SilkPickerOption(text: "余杭区", value: "Yuhang")
                                                    ]
                                                ),
                                                // 温州市
                                                SilkPickerOption(
                                                    text: "温州",
                                                    value: "Wenzhou", 
                                                    children: [
                                                        SilkPickerOption(text: "鹿城区", value: "Lucheng"),
                                                        SilkPickerOption(text: "瓯海区", value: "Ouhai")
                                                    ]
                                                )
                                            ]
                                        ),
                                        // 福建省
                                        SilkPickerOption(
                                            text: "福建",
                                            value: "Fujian",
                                            children: [
                                                // 福州市
                                                SilkPickerOption(
                                                    text: "福州",
                                                    value: "Fuzhou",
                                                    children: [
                                                        SilkPickerOption(text: "鼓楼区", value: "Gulou"),
                                                        SilkPickerOption(text: "台江区", value: "Taijiang")
                                                    ]
                                                ),
                                                // 厦门市
                                                SilkPickerOption(
                                                    text: "厦门", 
                                                    value: "Xiamen",
                                                    children: [
                                                        SilkPickerOption(text: "思明区", value: "Siming"),
                                                        SilkPickerOption(text: "海沧区", value: "Haicang")
                                                    ]
                                                )
                                            ]
                                        )
                                    ]
                                )
                            ]),
                            options: SilkPickerOptions(
                                title: "选择地区",
                            ),
                            confirm: { values: Array<String>, indexs: Array<Int32> => SilkToast.toast("values: ${values.toString()}, 索引: ${indexs.toString()}")},
                            change: { values: Array<String>, indexs: Array<Int32>, columnIndex: Int64 => SilkToast.toast("values: ${values.toString()}, 索引: ${indexs.toString()}, 列索引：${columnIndex}")},
                            cancel: {=> SilkToast.toast("取消")}
                        )
                    }.alignItems(HorizontalAlign.Start).width(100.percent).padding(16.vp)

                    // 禁用选项
                    Title("禁用选项")
                    Column(16) {
                        SilkPicker(
                            columns: ObservedArrayList([
                                SilkPickerColumn(
                                    [
                                        SilkPickerOption(text: "杭州", value: "Hangzhou", disabled: true),
                                        SilkPickerOption(text: "宁波", value: "Ningbo"),
                                        SilkPickerOption(text: "温州", value: "Wenzhou")
                                    ]
                                )
                            ]),
                            options: SilkPickerOptions(
                            ),
                            confirm: { values: Array<String>, indexs: Array<Int32> => SilkToast.toast("values: ${values.toString()}, 索引: ${indexs.toString()}")},
                            change: { values: Array<String>, indexs: Array<Int32>, columnIndex: Int64 => SilkToast.toast("values: ${values.toString()}, 索引: ${indexs.toString()}, 列索引：${columnIndex}")},
                            cancel: {=> SilkToast.toast("取消")}
                        )
                    }.alignItems(HorizontalAlign.Start).width(100.percent).padding(16.vp)

                    Title("空状态")
                    Column(16) {
                        SilkPicker(
                            columns: ObservedArrayList([]),
                            options: SilkPickerOptions(
                            ),
                            empty: empty,
                            confirm: { values: Array<String>, indexs: Array<Int32> => SilkToast.toast("values: ${values.toString()}, 索引: ${indexs.toString()}")},
                            change: { values: Array<String>, indexs: Array<Int32>, columnIndex: Int64 => SilkToast.toast("values: ${values.toString()}, 索引: ${indexs.toString()}, 列索引：${columnIndex}")},
                            cancel: {=> SilkToast.toast("取消")}
                        )
                    }.alignItems(HorizontalAlign.Start).width(100.percent).padding(16.vp)
                    Title("加载中")
                    Column(16) {
                        SilkPicker(
                            columns: ObservedArrayList([]),
                            options: SilkPickerOptions(
                                loading: true
                            ),
                            empty: empty,
                            confirm: { values: Array<String>, indexs: Array<Int32> => SilkToast.toast("values: ${values.toString()}, 索引: ${indexs.toString()}")},
                            change: { values: Array<String>, indexs: Array<Int32>, columnIndex: Int64 => SilkToast.toast("values: ${values.toString()}, 索引: ${indexs.toString()}, 列索引：${columnIndex}")},
                            cancel: {=> SilkToast.toast("取消")}
                        )
                    }.alignItems(HorizontalAlign.Start).width(100.percent).padding(16.vp)
                }.width(100.percent)
            }.layoutWeight(1)
        }.width(100.percent).height(100.percent).backgroundColor(Color(245, 245, 245, alpha: 1.0))
    }
}
