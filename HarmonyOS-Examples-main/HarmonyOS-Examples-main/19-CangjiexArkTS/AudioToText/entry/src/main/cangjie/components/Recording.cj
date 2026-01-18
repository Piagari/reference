/**
 * Created on 2025/5/30
 */
package ohos_app_cangjie_entry.components

import ohos_app_cangjie_entry.interop.*
import ohos.base.*
import ohos.component.*
import ohos.state_macro_manage.*

// 扩展样式复用
extend Button {
    func style() {
        this.width(80.percent)
            .height(45.vp)
            .fontSize(18.fp)
            .margin(top: 12.vp)
            .shape(ShapeType.Capsule)  // 改用胶囊形状更现代化
            .borderRadius(25.vp)       // 匹配胶囊形状
            .margin(left: 0, right: 0, bottom: 20, top: 20)
    }

    // 新增不同状态的按钮样式
    func activeStyle() {
        this.style()
            .backgroundColor(0x87CEFA)  // 蓝色表示活动状态 87CEFA
            .fontColor(Color.WHITE)
    }

    func clearStyle() {
        this.style()
            .backgroundColor(0x6C757D)  // 灰色表示清除操作
            .fontColor(Color.WHITE)
    }
}

@Component
public class Recording {
    @State
    var generatedText: String = ''

    public func build() {
         Column {
            // 可滚动的内容区域
            Scroll {
                Text(generatedText)
                .fontSize(15)
                .fontColor(Color.BLACK)
                .margin(top: 5)
                .padding(5)
                .width(100.percent)
                .textAlign(TextAlign.Center)
            }
            .margin(left: 20, right: 20, bottom: 30, top: 0)
            .width(90.percent)
            .backgroundColor(Color.WHITE)
            .borderRadius(25.vp)
            .padding(20)
            .border(width: 3.vp, color: Color(0x87CEFA)) // 细微边框

            Button("开始录音").activeStyle().onClick { =>
                    execFuncByName('startAudioRecognize') { audioInfo => generatedText = audioInfo.recognitionResult }
            }

            Button("语音文件转文字").activeStyle().onClick { =>
                    execFuncByName('startFileRecognize') { audioInfo => generatedText = audioInfo.recognitionResult }
            }

            Button("清空当前内容").clearStyle().onClick { => generatedText = '' }

        }
        .justifyContent(FlexAlign.Center)
        .width(100.percent)
    }
}