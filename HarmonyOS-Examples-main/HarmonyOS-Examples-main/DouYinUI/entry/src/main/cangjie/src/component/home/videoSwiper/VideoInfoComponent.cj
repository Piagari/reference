/**
 * Created on 2024/8/22
 */
package ohos_app_cangjie_entry.component.home.videoSwiper

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*
import cj_res_entry.app
import ohos_app_cangjie_entry.common.Constants

@Component
public class VideoInfoComponent {
    @State
    var name: String = ""
    @State
    var description: String = ""

    func build() {
        Column(5) {
            Text() {
                Span("@")
                Span(this.name)
            }.fontSize(18.vp).fontWeight(FontWeight.Bold).fontColor(Color.WHITE).margin(bottom: 8.vp)

            Text(this.description).fontSize(14.vp).fontColor(Color.WHITE).width(Constants.TEXT_WIDTH).maxLines(2).
                textOverflow(TextOverflow.Ellipsis)
        }.padding(left: 10.vp,bottom: 40.vp).alignItems(HorizontalAlign.Start).width(Constants.VIDEO_INFO_WIDTH)
    }
}
