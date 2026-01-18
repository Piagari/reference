/**
 * Created on 2025/4/23
 */
package ohos_app_cangjie_entry.pages

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.resource_manager.*
import ohos.state_macro_manage.*
import cj_res_entry.*
import ohos_app_cangjie_entry.components.{Nav, Title}
import silkui.components.collapse.*
import silkui.SilkUIPaddingOptions
import std.collection.ArrayList

@Entry
@Component
class CollapsePage {
    @State
    var baseActiveNames: ArrayList<String> = ArrayList(["1"])
    @State
    var accordion: Bool = false

    @Builder
    func C1_Children1 () {
        Text("代码是写出来给人看的，附带能在机器上运行附带能在机器上运行。")
        .width(100.percent)
        .padding(top: 12,bottom: 12)
        .fontSize(14)
        .fontColor(@r(app.color.silkdoctextcolor4))
        .textAlign(TextAlign.Start)
    }
    @Builder
    func C1_Children2 () {
        Text("技术无非就是那些开发它的人的共同灵魂。")
        .width(100.percent)
        .padding(top: 12,bottom: 12)
        .fontSize(14)
        .fontColor(@r(app.color.silkdoctextcolor4))
        .textAlign(TextAlign.Start)
    }
 @Builder
    func C1_Children3 () {
        Text("在代码阅读过程中人们说脏话的频率是衡量代码质量的唯一标准。")
        .width(100.percent)
        .padding(top: 12,bottom: 12)
        .fontSize(14)
        .fontColor(@r(app.color.silkdoctextcolor4))
        .textAlign(TextAlign.Start)
    }
    @Builder
    func Children1 () {
        Column(){
            SilkCollapseItem(active: true, props: SilkCollapseOptions(title: "标题1"), Content: C1_Children1)
            SilkCollapseItem(active: false, props: SilkCollapseOptions(title: "标题2"), Content: C1_Children2)
            SilkCollapseItem(active: false, props: SilkCollapseOptions(title: "标题3"), Content: C1_Children3)
        }
    }
    @Builder
    func Children2 () {
        Column(){
            SilkCollapseItem(active: true, props: SilkCollapseOptions(title: "标题1"), Content: C1_Children1)
            SilkCollapseItem(active: false, props: SilkCollapseOptions(title: "标题2", disabled: true), Content: C1_Children2)
            SilkCollapseItem(active: false, props: SilkCollapseOptions(title: "标题3", disabled: true), Content: C1_Children3)
        }
    }

    @Builder
    func CollapseTitle1 () {
        Text() {
            Span("标题1")
            ImageSpan(@r(app.media.ic_public_warn))
            .width(12)
            .aspectRatio(1)
        }
    }
    @Builder
    func CollapseCon () {
      Text('在代码阅读过程中人们说脏话的频率是衡量代码质量的唯一标准')
      .width(100.percent)
      .padding(top: 12, bottom: 12)
      .fontSize(14)
      .fontColor(@r(app.color.silkdoctextcolor4))
      .textAlign(TextAlign.Start)
    }

    @Builder
    func Children3 () {
        Column(){
            SilkCollapseItemCustomTitle(active: true, props: SilkCollapseOptions(), Content: CollapseCon, Title: CollapseTitle1)
        }
    }



    @State
    var silkCollapseToggleController: SilkCollapseToggleController = SilkCollapseToggleController()

    func build () {
        Column(){
            Nav("Collapse")
            Scroll() {
                Column(){
                    Title("基础用法")
                    SilkCollapse(accordion: false, Childrens: Children1)
                    Title("手风琴")
                    SilkCollapse(accordion: true, Childrens: Children1)
                    Title("禁用状态")
                    SilkCollapse(accordion: true, Childrens: Children2)
                    Title("自定义标题内容")
                    SilkCollapse(accordion: true, Childrens: Children3)
                    Title("全部展开与全部切换")
                    SilkCollapseAll(silkCollapseToggleController: silkCollapseToggleController, Childrens: Children1)
                    Row() {
                        Button("全部展开")
                        .onClick({e => (this.silkCollapseToggleController.toggle ?? {f: Option<Bool> =>})(true)})
                        Button("全部切换")
                        .onClick({e => (this.silkCollapseToggleController.toggle ?? {f: Option<Bool> =>})(None)})
                        Button("全部折叠")
                        .onClick({e => (this.silkCollapseToggleController.toggle ?? {f: Option<Bool> =>})(false)})
                    }
                }
                .justifyContent(FlexAlign.Start)
            }
            .layoutWeight(1)
            .backgroundColor(@r(app.color.silkdocbackground))
            .align(Alignment.Top)
        }
        .width(100.percent)
        .height(100.percent)
    }

}