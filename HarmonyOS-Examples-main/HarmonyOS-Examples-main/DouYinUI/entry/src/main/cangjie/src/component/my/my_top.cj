/**
 * Created on 2024/9/10
 */
package ohos_app_cangjie_entry.component.my

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*
import cj_res_entry.*

@Component
public class MyTop {
    func build() {
        Row(10) {
            this.imgRow(@r(app.media.ic_person_badge_plus), "添加朋友",true)
            Blank()
            this.imgRow(@r(app.media.ic_person_2), "朋友",false)
            this.imgRow(@r(app.media.ic_search_filled), "搜索",false)
            this.imgRow(@r(app.media.ic_more), "更多",false)
        }
        .width(100.percent)
        .height(60)
        .padding(left:15,right:15)
    }

    @Builder
    func imgRow(img: CJResource, label: String, isShowLabel: Bool) {
        Row(matchSpace(isShowLabel)) {
            Image(img)
            .width(20)
            .fillColor(@r(app.color.nor_white))
            if (isShowLabel) {
                Text(label)
                .fontSize(12)
                .fontWeight(FontWeight.Regular)
                .fontColor(Color.WHITE)
            }
        }
        .padding(5)
        .borderRadius(50)
        .backgroundColor(@r(app.color.my_top_img_row_color))
        .opacity(0.8)
    }

    //匹配Row的空间
    func matchSpace(isShowLabel: Bool){
        match (isShowLabel) {
        	case true  => 5
            case _=>0
        }
    }

}
