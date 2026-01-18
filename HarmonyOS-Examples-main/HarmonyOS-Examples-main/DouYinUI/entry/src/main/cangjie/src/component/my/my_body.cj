/**
 * Created on 2024/10/4
 */
package ohos_app_cangjie_entry.component.my

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*
import cj_res_entry.*

@Component
public class MyBody {
    func build() {
        Scroll {
            Column() {
                Row(10){
                    Image(@r(app.media.ic_other_img))
                    .width(80)
                    .aspectRatio(1.0)
                    .borderWidth(1)
                    .borderColor(Color.WHITE)
                    .borderRadius(40)
                    Column(5){
                        Row(5){
                            Text("黑马喽")
                            .fontSize(18)
                            .fontWeight(FontWeight.Bold)
                            .fontColor(Color.BLACK)
                            Image(@r(app.media.ic_arrowtriangle_down_fill_black))
                            .borderRadius(12)
                            //.backgroundColor(@r(app.color.my_body_top_row_down_img_color))
                            .padding(8)
                            .width(24)
                            .aspectRatio(1.0)
                        }
                        Text(){
                            Span("抖音号：")
                            Span("123456789")
                        }
                        .fontSize(12)
                        .fontColor(Color.BLACK)
                    }
                    .alignItems(HorizontalAlign.Start)
                }
                .width(100.percent)
                .height(200)
                .padding(left:15,right:15)
                MyInfo()
            }
            .width(100.percent)
            .height(100.percent)
        }
    }
}
