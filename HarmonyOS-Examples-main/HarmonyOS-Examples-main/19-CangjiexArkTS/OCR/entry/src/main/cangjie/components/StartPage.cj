/**
 * Created on 2025/5/29
 */
package ohos_app_cangjie_entry.components

import ohos.state_macro_manage.*
import cj_res_entry.app

@Component
public class StartPage {

    func build() {
        Column {
            Row() {
                Text("OCR").fontSize(12)
            }
            .width(100.percent)
            .borderWidth(1)
            .borderColor(0xf0f0f0)
            .justifyContent(FlexAlign.Center)
            .expandSafeArea(
                types: [SafeAreaType.SYSTEM],
                edges: [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]
            )

            Image(@r(app.media.ocr_1)).height(100).margin(30).padding(top: 20)
            Text("📷 识别指南")
            .fontSize(24)
            .margin(top: 60)

            Text("· 点击【拍照】拍摄照片")
            .fontSize(16)
            .margin(top: 10)

            Text("· 点击【图库】选择已有图片")
            .fontSize(16)
            .margin(top: 10)

            Text("· 点击【文件】选择支持格式的文件")
            .fontSize(16)
            .margin(top: 10)

            Text("( 支持 JPG/PNG/PDF 格式文件 )")
            .fontSize(16)
            .margin(top: 10)

        }
        .width(100.percent)
        .height(100.percent)
        .backgroundColor(0xe0ffff)
        .padding(top : 5, bottom: 35)
    }
}