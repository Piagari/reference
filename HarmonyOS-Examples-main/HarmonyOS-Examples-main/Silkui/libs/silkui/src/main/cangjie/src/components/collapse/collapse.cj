/**
 * Created on 2025/4/23
 *
 * SilkCollapse 折叠面板组件
 *
 * 折叠面板用于将内容区域折叠/展开，节省页面空间，常用于分组显示复杂内容。
 *
 * ## 基础用法
 * ```
 * SilkCollapse() {
 *   SilkCollapseItem(props: SilkCollapseOptions(title: "标题1"), active: true) {
 *     Text("内容1")
 *   }
 *   SilkCollapseItem(props: SilkCollapseOptions(title: "标题2")) {
 *     Text("内容2")
 *   }
 * }
 * ```
 *
 * ## 手风琴模式
 * 通过 `accordion` 属性可以设置为手风琴模式，最多展开一个面板。
 * ```
 * SilkCollapse(accordion: true) {
 *   SilkCollapseItem(props: SilkCollapseOptions(title: "标题1")) {
 *     Text("内容1")
 *   }
 *   SilkCollapseItem(props: SilkCollapseOptions(title: "标题2")) {
 *     Text("内容2")
 *   }
 * }
 * ```
 *
 * ## 自定义标题
 * 可以使用 `SilkCollapseItemCustomTitle` 自定义标题内容。
 * ```
 * SilkCollapse() {
 *   SilkCollapseItemCustomTitle(props: SilkCollapseOptions()) {
 *     Title: {
 *       Row() {
 *         Text("自定义标题")
 *         Image("icon.png")
 *       }
 *     }
 *     Content: {
 *       Text("内容")
 *     }
 *   }
 * }
 * ```
 *
 * @module silkui/components/collapse
 */
package silkui.components.collapse

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.resource_manager.*
import ohos.state_macro_manage.*
import ohos.image.Component
import std.collection.ArrayList
import silkui.SilkUIPaddingOptions
import silkui.types.DefaultBuilder

/**
 * 折叠面板组件
 *
 * 用于将内容区域折叠/展开，节省页面空间
 */
@Component
public class SilkCollapse {
//    @Prop
//    var silkCollapseToggleController: SilkCollapseToggleController
    /**
     * 子组件构建器
     *
     * 用于包含多个折叠面板项
     */
    @BuilderParam
    var Childrens: () -> Unit = DefaultBuilder
//    @Link
//    var activeNames: ArrayList<String>
//    @Prop
//    var names: ArrayList<String>
    /**
     * 是否开启手风琴模式
     *
     * 手风琴模式下最多展开一个面板
     */
    @Prop
    var accordion: Bool

    /**
     * 折叠面板控制器
     *
     * 用于管理折叠面板的展开/折叠状态
     */
    @Provide
    var silkCollapseController: SilkCollapseController = SilkCollapseController()

    /**
     * 内边距配置
     *
     * 提供给子组件使用的内边距配置
     */
    @Provide
    var paddingValue: SilkUIPaddingOptions = SilkUIPaddingOptions(left: 16.0.vp, right: 16.0.vp)

    /**
     * 组件即将出现时的生命周期方法
     *
     * 初始化折叠面板控制器
     */
    protected override func aboutToAppear () {
        // 设置是否为手风琴模式
        silkCollapseController.setAccordion(accordion)
    }

    /**
     * 构建组件UI
     *
     * 渲染折叠面板及其子项
     */
    func build () {
        Column(){
            // 渲染子组件（折叠面板项）
            Childrens()
        }
    }

}

/**
 * 可全部展开/折叠的折叠面板组件
 *
 * 提供全部展开/折叠功能的折叠面板
 */
@Component
public class SilkCollapseAll {
    /**
     * 折叠面板切换控制器
     *
     * 用于控制所有面板的展开/折叠
     */
    @Prop
    var silkCollapseToggleController: SilkCollapseToggleController

    /**
     * 子组件构建器
     *
     * 用于包含多个折叠面板项
     */
    @BuilderParam
    var Childrens: () -> Unit = DefaultBuilder
//    @Link
//    var activeNames: ArrayList<String>
//    @Prop
//    var names: ArrayList<String>
//    @Prop
//    var accordion: Bool

    /**
     * 折叠面板控制器
     *
     * 用于管理折叠面板的展开/折叠状态
     */
    @Provide
    var silkCollapseController: SilkCollapseController = SilkCollapseController()

    /**
     * 内边距配置
     *
     * 提供给子组件使用的内边距配置
     */
    @Provide
    var paddingValue: SilkUIPaddingOptions = SilkUIPaddingOptions(left: 16.0.vp, right: 16.0.vp)

    /**
     * 组件即将出现时的生命周期方法
     *
     * 初始化折叠面板控制器和切换功能
     */
    protected override func aboutToAppear () {
//        silkCollapseController = SilkCollapseController(activeNames: ObservedArrayList(activeNames), accordion: accordion, names: names)
//        if (!names.isEmpty()) {
        // 设置切换控制器的toggle方法，用于全部展开/折叠
        silkCollapseToggleController.toggle = {flag: Option<Bool> => this.silkCollapseController.toggleAll(flag:flag)}
//        }
    }

    /**
     * 构建组件UI
     *
     * 渲染折叠面板及其子项
     */
    func build () {
        Column(){
            // 渲染子组件（折叠面板项）
            Childrens()
        }
    }

//    func change () {
//        activeNames = silkCollapseController.activeNames.get();
//    }

}