/**
 * Created on 2025/2/13
 */
package ohos_app_cangjie_entry.pages
import ohos.base.*
import ohos.component.*
import ohos.state_macro_manage.*
import ohos.state_manage.*
import ohos.resource_manager.*
import cj_res_entry.*
import ohos.router.Router
import ohos_app_cangjie_entry.util.*
import ohos.prompt_action.*
import encoding.json.*
import std.collection.*

extend Text {
    func style(color!: Color = Color(0x000000), size!: Int64 = 12, weight!: FontWeight = FontWeight.Medium) {
        this.fontColor(color)
        .fontSize(size)
        .fontWeight(weight)
    }

    func alertBottomStyle() {
        this.backgroundColor(0xffffff)
        .width(50.percent)
        .textAlign(TextAlign.Center)
        .borderStyle(BorderStyle.Solid)
        .borderColor(0xd5d5d5)
        .padding(top: 16, bottom: 16)
    }
}

extend Row {
    func style() {
        this.width(100.percent)
        .padding(left: 5, right: 5, bottom: 15, top: 10)
        .justifyContent(FlexAlign.SpaceBetween)
    }
}

extend Column {
    func style() {
        this.padding(left: 20, right: 20, top:5, bottom: 5)
        .margin(left:10, right:10)
        .backgroundColor(0xffffff)
        .borderRadius(15)
    }
}

@CustomDialog
class radioDialog {
    @Link var selectValues: GeneralDataSource<String>
    var controller: Option<CustomDialogController> = Option.None
    var title: String
    var radioList: Array<String>
    var currentIndex: Int64

    func build() {
        Column {
            Text(title).style(size: 18, weight: FontWeight.Bold).height(60)
            Divider().strokeWidth(1).color(0xd5d5d5)
            Column {
                List(space: 25) {
                    ForEach(radioList, itemGeneratorFunc: {item: String, index: Int64 =>
                        ListItem {
                            Row {
                                Radio(group: title, value: item).checked(selectValues[currentIndex] == item).height(22).width(22).margin(right: 15, left: 20).onChange{ isChecked =>
                                    if(isChecked) {
                                        selectValues.update(currentIndex, item)
                                    }
                                }
                                Text(item).fontSize(16).fontWeight(Bold)
                            }
                            .width(100.percent)
                            .justifyContent(FlexAlign.Start)
                        }
                    })
                  }
            }.constraintSize(maxHeight: 300.vp)
            .padding(20)

            Divider().strokeWidth(1).color(0xd5d5d5)

            Button("确定")
            .width(90.percent)
            .backgroundColor(0xffffff)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(0x3f7cdc)
            .margin(top: 5, bottom: 5)
            .onClick { e =>
                controller?.close()
            }
        }
        .width(300)
        .backgroundColor(0xffffff)
        .borderRadius(24.vp)
        .justifyContent(FlexAlign.Center)
    }
}

@CustomDialog
class alertDialog {
    var controller: Option<CustomDialogController> = Option.None
    var title: String
    var content: String
    var buttonText: String
    func build() {
        Column {
            Text(title).style(size: 18, weight: FontWeight.Bold).margin(top: 25, bottom: 15)
            Text(content).style(size: 15).lineHeight(24).width(240).textAlign(TextAlign.Center)
            Row {
                Text("取消").style(color: Color(0x4381e7), size: 18, weight: FontWeight.Bold)
                .alertBottomStyle()
                .borderRadius(bottomLeft: 24.vp)
                .borderWidth(EdgeWidths(top:1.vp, right:1.vp))

                .onClick { evt =>
                    controller?.close()
                }

                Text(buttonText).style(color: Color(0xde4e4c), size: 18, weight: FontWeight.Bold)
                .alertBottomStyle()
                .borderRadius(bottomRight: 24.vp)
                .borderWidth(EdgeWidths(top:1.vp))
                .onClick { evt =>
                    controller?.close()
                }
            }.margin(top: 25)

        }
        .width(290)
        .backgroundColor(0xffffff)
        .borderRadius(24.vp)
        .justifyContent(FlexAlign.SpaceBetween)
    }
}

@Entry
@Component
public class userView {
    @State var selectValues: GeneralDataSource<String> = GeneralDataSource<String>(["系统", "中文(繁体中文)"])

    public func noEvent () {}

    // 回退的按钮点击
    func onBackBtnClick() {
        Router.back()
    }

    func toUserAgreementPage() {
        var params: JsonObject = JsonObject()
        params.put("title", JsonString("DeepSeek 用户协议"))
        params.put("src", JsonString("https://cdn.deepseek.com/policies/zh-CN/deepseek-terms-of-use.html"))
        Router.push(url: "aboutView", params: params)
    }

    func toPrivacyPolicyPage() {
        var params: JsonObject = JsonObject()
        params.put("title", JsonString("DeepSeek 隐私政策"))
        params.put("src", JsonString("https://cdn.deepseek.com/policies/zh-CN/deepseek-privacy-policy.html"))
        Router.push(url: "aboutView", params: params)
    }

    func toThirdPartyInfoSharingListPage() {
        var params: JsonObject = JsonObject()
        params.put("title", JsonString("DeepSeek 第三方信息共享清单"))
        params.put("src", JsonString("https://cdn.deepseek.com/policies/zh-CN/third-party-info-sharing-list.html"))
        Router.push(url: "aboutView", params: params)
    }

    func toAppPermissionsPage() {
        var params: JsonObject = JsonObject()
        params.put("title", JsonString("应用权限申请与使用情况说明"))
        params.put("src", JsonString("https://cdn.deepseek.com/policies/zh-CN/app-permissions.html"))
        Router.push(url: "aboutView", params: params)
    }

    var colorDialogController: CustomDialogController = CustomDialogController(
        CustomDialogControllerOptions(
            builder: radioDialog(
                selectValues: selectValues, title: "颜色主题",
                radioList: ["系统", "浅色", "深色"],
                currentIndex: 0),
            maskColor: Color(0x66000000),
            customStyle: true)
        )
    var languageDialogController: CustomDialogController = CustomDialogController(
        CustomDialogControllerOptions(
            builder: radioDialog(selectValues: selectValues, title: "应用语言",
                radioList: ["系统", "中文(繁体中文)", "中文(简体中文)", "中文(香港)", "hrvatski", "dansk", "Nederlands",
                    "English", "Filipino", "suomi", "Deutsch", "magyar", "Indonesia", "italiano", "日本语"],
                currentIndex: 1),
            maskColor: Color(0x66000000),
            customStyle: true)
        )
    var logoutDialogController: CustomDialogController = CustomDialogController(
        CustomDialogControllerOptions(
            builder: alertDialog(
                title: "确认登出？",
                content: "登出不会遗失任何资料，你仍可登录此账号",
                buttonText: "登出"),
            maskColor: Color(0x66000000),
            customStyle: true)
        )
    var historyDialogController: CustomDialogController = CustomDialogController(
        CustomDialogControllerOptions(
            builder: alertDialog(
                title: "删除所有对话",
                content: "如点击确认删除，曾前账号的所有史对话將被清空，无法找回。确认要删除所有历史对话吗?",
                buttonText: "确认删除"),
            maskColor: Color(0x66000000),
            customStyle: true)
        )
    var userDialogController: CustomDialogController = CustomDialogController(
        CustomDialogControllerOptions(
            builder: alertDialog(
                title: "确认删除账号",
                content: "注销后，你将无法存取 DeepSeek 的所有服务。如你的开放平台账户中尚有储值余额，注销即视为放弃。",
                buttonText: "删除"),
            maskColor: Color(0x66000000),
            customStyle: true)
        )

    func openColorDialog() {
        colorDialogController.`open`()
    }

    func openLanguageDialog() {
        languageDialogController.`open`()
    }

    func openLogoutDialog() {
        logoutDialogController.`open`()
    }

    func openHistoryDialog() {
        historyDialogController.`open`()
    }

    func openUserDialog() {
        userDialogController.`open`()
    }

    func toUpdateApp() {
        PromptAction.showToast(message: "目前已经是最新版本")
    }

    @Builder
    func Item(src!: CJResource, name!: String, text!: String = "",
            color!: Color = Color(0x000000), next!: Bool = true, event!: () -> Unit = noEvent) {
        Row {
            Row {
                Image(src).size(width: 15, height: 15).margin(right: 15)
                Text(name)
                .fontColor(color)
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
            }.justifyContent(FlexAlign.Start)

            Row {
                if (!text.isEmpty()) {
                    Text(text)
                    .fontColor(color)
                    .fontSize(14)
                    .fontWeight(FontWeight.Medium)
                    .margin(right: 5)
                }
                if (next) {
                    Image(@r(app.media.next)).size(width: 20, height: 20)
                }
            }.justifyContent(FlexAlign.End)
        }.width(100.percent)
        .backgroundColor(0xffffff)
        .padding(left: 0, right: 0, bottom: 10, top: 10)
        .justifyContent(FlexAlign.SpaceBetween)
        .onClick ({ e =>
            event()
        })
    }

    @Builder
    func Title(text: String) {
        Row {
            Text(text).fontColor(0x9ba2a8)
            .fontSize(12)
            .fontWeight(Bold)
        }.width(90.percent)
        .justifyContent(FlexAlign.Start)
        .margin(left: 20)
        .padding(top: 5, bottom: 5)
    }

    func build() {
        Scroll {
            Column {
                Row {
                    Image(@r(app.media.prev)).size(width: 22, height: 22).fillColor(0x000000)
                    .onClick({
                        e: ClickEvent => this.onBackBtnClick()
                    })
                    Text("账户").style(size: 16, weight: FontWeight.Bold)
                    Column().width(22)
                }.style()

                Column {
                    Title("账户")
                    Column {
                        Item(src: @r(app.media.phone), name: "手机号码", text: "138****3838", next: false)
                        Item(src: @r(app.media.wechat), name: "微信", text: "已绑定", next: false)
                    }.style()
                }.margin(bottom: 10)

                Column {
                    Title("关于")
                    Column {
                        Item(src: @r(app.media.agreement), name: "用户协议", event: toUserAgreementPage)
                        Item(src: @r(app.media.privacy), name: "隐私政策", event: toPrivacyPolicyPage)
                        Item(src: @r(app.media.share), name: "第三方资讯共享清单", event: toThirdPartyInfoSharingListPage)
                        Item(src: @r(app.media.limit), name: "应用程式权限", event: toAppPermissionsPage)
                        Item(src: @r(app.media.update), name: "检查更新", text: "1.0.7(36)", event: toUpdateApp)
                    }.style()
                }.margin(bottom: 10)

                Column {
                    Title("应用")
                    Column {
                        LazyForEach(selectValues, itemGeneratorFunc: {item: String, index: Int64 =>
                            if (index == 0) {
                                Item(src: @r(app.media.color), name: "颜色主题", text: item, event: openColorDialog)
                            } else if (index == 1) {
                                Item(src: @r(app.media.language), name: "应用语言", text: item, event: openLanguageDialog)
                            }
                        })
                    }.style()
                }.margin(bottom: 18)

                Column {
                    Column {
                        Item(src: @r(app.media.us), name: "联络我们")
                    }.style()
                }.margin(bottom: 18)

                Column {
                    Column {
                        Item(src: @r(app.media.out), name: "登出", next: false, event: openLogoutDialog)
                    }.style()
                }.margin(bottom: 18)

                Column {
                    Column {
                        Item(src: @r(app.media.deletehistory), name: "删除所有历史对话", color: Color(0xd74c47), next: false, event: openHistoryDialog)
                        Item(src: @r(app.media.deleteuser), name: "删除账户", color: Color(0xd74c47), next: false, event: openUserDialog)
                    }.style()
                }.margin(bottom: 22)

                Column {
                    Text("模型名称: Deepseek Chat").style(color: Color(0x737373))
                    Text("备案号: Beijing-DeepseekChat-202404280016").style(color: Color(0x737373))
                    Text("浙ICP备2023025841号-3A").style(color: Color(0x737373))
                    Text("應用程式内容由AI生成，請勿從事反法律法规的活動。").style(color: Color(0x737373))
                }.margin(bottom: 36)
            }
        }
        .backgroundColor(0xfafafa)
        .width(100.percent)
        .height(100.percent)
    }
}