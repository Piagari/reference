/**
 * Created on 2024/8/24
 * 导航栏按钮
 */
package ohos_app_cangjie_entry.component

import ohos.state_macro_manage.*

@Component
protected class NavigationComponent {
    @Link
    var navigation: Link

    func build() {
        Button(navigation.title).shape(ShapeType.Normal).borderRadius(8).stateEffect(true).fontSize(16).fontColor(
            @r(app.color.primary)).backgroundColor(@r(app.color.sub)).margin(4).onClick(
            {
            evt => Router.push(url: "Content", params: navigation.href)
        })
    }
}
