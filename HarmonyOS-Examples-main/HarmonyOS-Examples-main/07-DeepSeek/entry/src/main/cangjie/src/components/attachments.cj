/**
 * Created on 2025/2/12
 */
package ohos_app_cangjie_entry.components
import ohos.base.*
import ohos.component.*
import ohos.state_macro_manage.*
import ohos.state_manage.*
import ohos_app_cangjie_entry.util.*

extend Text {
    func style(fcolor: Color, fsize: Int64, width: Int64) {
        this.fontColor(fcolor)
        .fontSize(fsize)
        .width(width)
        .maxLines(1)
        .textOverflow(TextOverflow.Ellipsis)
    }
}

@Component
public class FileLine {
    @Prop var dataList: GeneralDataSource<(String, FileType)>
    let WIDTH: Int64 = 200
    let HEIGHT: Int64 = 50
    @Link var choiceState: Bool
    @Builder
    public func fileLineItem(text!: String, logo!: CJResource) {
        Row {
            Image(logo).width(30).height(30)
            Column {
                Text(text).style(Color(0x000000), 16, WIDTH - 50)
                Text("已解析").style(Color(0x777777), 14, WIDTH - 50)
            }
            .justifyContent(FlexAlign.Start)

        }.borderRadius(10)
        .backgroundColor(0xffffff)
        .borderColor(0xe5e5e5)
        .borderWidth(2)
        .width(WIDTH)
        .height(HEIGHT)
        .justifyContent(FlexAlign.SpaceAround)
    }

    func setHeight(choiceState: Bool) {
        return if (choiceState) { 65 } else { 0 }
    }

    func build() {
        Row {
            List {
                LazyForEach(dataList, itemGeneratorFunc: { item: (String, FileType), id: Int64 =>
                    ListItem {
                        Row {
                            Badge(
                                BadgeParams(value: "×",
                                style: BadgeStyle(color: Color(0xffffff), fontSize: 30, badgeSize: 25, badgeColor: Color.RED),
                                position: BadgePosition.RightTop,
                                )
                            ) {
                                fileLineItem(text: item[0], logo: item[1].icon())
                            }
                            .onClick { _ =>
                                dataList.delete(id)
                                if(dataList.totalCount() == 0) {
                                    choiceState = false
                                }
                            }
                            .width(WIDTH)
                            .height(HEIGHT)
                        }.padding(top:5, bottom: 5,right: 8)
                    }
                })
            }
            .scrollBar(BarState.Off)
            .height(setHeight(choiceState))
            .listDirection(Axis.Horizontal)
            .align(Alignment.Center)
            .layoutWeight(1)
            .backgroundColor(0xffffff)
        }
    }
}