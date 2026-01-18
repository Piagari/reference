/**
 * Created on 2024/11/15
 */
package ohos_app_cangjie_entry.components
internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.router.Router
import cj_res_entry.*
@Builder
public func Nav (title: String) {
    RelativeContainer() {
        Text(title)
        .fontSize(17)
        .fontWeight(FontWeight.W600)
        .fontColor(@r(app.color.silkdoctextcolor2))
        .constraintSize(maxWidth: 200.vp)
        .maxLines(1)
        .textOverflow(TextOverflow.Ellipsis)
        .id("nav_title")
        .alignRules(AlignRuleOption(
                middle: HorizontalAnchor("__container__", HorizontalAlign.Center),
                center: VerticalAnchor("__container__", VerticalAlign.Center),
                )
            )
        Image(@r(app.media.ic_public_back))
        .width(24)
        .aspectRatio(1)
        .id("nav_icon")
        .alignRules(AlignRuleOption(
                center: VerticalAnchor("__container__", VerticalAlign.Center),
                left: HorizontalAnchor("__container__", HorizontalAlign.Start),
                right: HorizontalAnchor("__container__", HorizontalAlign.End),
                bias: Bias(horizontal: 0.045)
                ))
        .onClick({evt => Router.back()})
    }
    .height(56)
}

@Builder
public func Nav (title: CJResource) {
    RelativeContainer() {
        Text(title)
        .fontSize(17)
        .fontWeight(FontWeight.W600)
        .fontColor(@r(app.color.silkdoctextcolor2))
        .constraintSize(maxWidth: 200.vp)
        .maxLines(1)
        .textOverflow(TextOverflow.Ellipsis)
        .id("nav_title")
        .alignRules(AlignRuleOption(
                middle: HorizontalAnchor("__container__", HorizontalAlign.Center),
                center: VerticalAnchor("__container__", VerticalAlign.Center),
                )
            )
        Image(@r(app.media.ic_public_back))
        .width(24)
        .aspectRatio(1)
        .id("nav_icon")
        .alignRules(AlignRuleOption(
                center: VerticalAnchor("__container__", VerticalAlign.Center),
                left: HorizontalAnchor("__container__", HorizontalAlign.Start),
                right: HorizontalAnchor("__container__", HorizontalAlign.End),
                bias: Bias(horizontal: 0.045)
                ))
        .onClick({evt => Router.back()})
    }
    .height(56)
}

@Builder
public func Nav (title: PluralResource) {
    RelativeContainer() {
        Text(title)
        .fontSize(17)
        .fontWeight(FontWeight.W600)
        .fontColor(@r(app.color.silkdoctextcolor2))
        .constraintSize(maxWidth: 200.vp)
        .maxLines(1)
        .textOverflow(TextOverflow.Ellipsis)
        .id("nav_title")
        .alignRules(AlignRuleOption(
                middle: HorizontalAnchor("__container__", HorizontalAlign.Center),
                center: VerticalAnchor("__container__", VerticalAlign.Center),
                )
            )
        Image(@r(app.media.ic_public_back))
        .width(24)
        .aspectRatio(1)
        .id("nav_icon")
        .alignRules(AlignRuleOption(
                center: VerticalAnchor("__container__", VerticalAlign.Center),
                left: HorizontalAnchor("__container__", HorizontalAlign.Start),
                right: HorizontalAnchor("__container__", HorizontalAlign.End),
                bias: Bias(horizontal: 0.045)
                ))
        .onClick({evt => Router.back()})
    }
    .height(56)
}