/**
 * Created on 31/8/2024
 */
package ohos_app_cangjie_entry

import ohos.state_macro_manage.*
import ohos.router.Router
import ohos.component.*
import std.convert.Parsable
import std.format.Formatter
import ohos_app_cangjie_entry.components.*
import ohos.base.*
import ohos.state_manage.*
import ohos.preferences.*
import std.collection.ArrayList

public func getContext(): CPointer<Unit> {
    return getStageContext(gloabl_context.getOrThrow())
}

@Builder
func Title(title: CJResource) {
    Row() {
        Text(title).fontSize(32).fontWeight(FontWeight.W700)
    }.width(100.percent)
    .margin(bottom: 30, top: 30)
    .justifyContent(FlexAlign.Start)
}

@Builder
func Btn(title: CJResource, onClick: (ClickEvent) -> Unit) {
    Button(title)
    .shape(ShapeType.Normal)
    .fontColor(0xffffff)
    .fontSize(16)
    .width(70)
    .height(40)
    .shape(ShapeType.Normal)
    .borderRadius(6.fp)
    .backgroundColor(0x161315)
    .onClick(onClick)
}


@Entry
@Component
class Settings {
    @State
    var model: String = ""
    @State
    var api_key: String = ""
    @State
    var base_url: String = ""
    @State
    var system_prompt: String = "You are a helpful assistant."
    @State
    var chat_timeout: Int64 = 120
    @State
    var max_tokens: Int64 = 2000 // qwen-max only suport 2000 output
    
    @State
    var temperature: Float64 = 0.7
    @State
    var top_p: Float64 = 1.0
    @State
    var stream: Bool = true

    // excute before build
    protected func aboutToAppear() {
        var my_preference = Preferences.getPreferences(getContext(), "save")
        // model
        if (my_preference.has("model")) {
            match(my_preference.get("model", ValueType.string(""))) {
                case ValueType.string(temp_str) => this.model = temp_str
                case _ => ()
            }
        }
        // api_key
        if (my_preference.has("api_key")) {
            match(my_preference.get("api_key", ValueType.string(""))) {
                case ValueType.string(temp_str) => this.api_key = temp_str
                case _ => ()
            }
        }
        // base_url
        if (my_preference.has("base_url")) {
            match(my_preference.get("base_url", ValueType.string(""))) {
                case ValueType.string(temp_str) => this.base_url = temp_str
                case _ => ()
            }
        }
        // system_prompt
        if (my_preference.has("system_prompt")) {
            match(my_preference.get("system_prompt", ValueType.string(""))) {
                case ValueType.string(temp_str) => if (temp_str.size > 0){this.system_prompt = temp_str}
                case _ => ()
            }
        }
        // max_tokens
        if (my_preference.has("max_tokens")) {
            match(my_preference.get("max_tokens", ValueType.integer(0))) {
                case ValueType.integer(temp_int) => this.max_tokens = temp_int
                case _ => ()
            }
        }
        // temperature
        if (my_preference.has("temperature")) {
            match(my_preference.get("temperature", ValueType.double(0.0))) {
                case ValueType.double(temp_float) => this.temperature = temp_float
                case _ => ()
            }
        }
        // top_p
        if (my_preference.has("top_p")) {
            match(my_preference.get("top_p", ValueType.double(0.0))) {
                case ValueType.double(temp_float) => this.top_p = temp_float
                case _ => ()
            }
        }
        // stream
        if (my_preference.has("stream")) {
            match(my_preference.get("stream", ValueType.bool(false))) {
                case ValueType.bool(temp_bool) => this.stream = temp_bool
                case _ => ()
            }
        }
        // chat timeout
        if (my_preference.has("chat_timeout")) {
            match(my_preference.get("chat_timeout", ValueType.integer(120))) {
                case ValueType.integer(temp_int) => this.chat_timeout = temp_int
                case _ => ()
            }
        }
    }

    func back(e: ClickEvent) {
        Router.back()
    }

    func save(e: ClickEvent) {
        // 加一个新逻辑，保存前校验一下接口能否正常返回，输入信息 "你好"，看看结果
        let env_info = EnvInfo(model, api_key, base_url, system_prompt)
        // 观察5秒内有没有回复
        let response: Option<String> = chat(
            "你好",
            env_info,
            ArrayList<(String, String)>(),  // history
            this.max_tokens,
            this.temperature,
            this.top_p,
            timeout: 5
        )
        if (response.getOrDefault({=>""}).size > 0) {
            var my_preference = Preferences.getPreferences(getContext(), "save")
            my_preference.put("model", ValueType.string(this.model))
            my_preference.put("api_key", ValueType.string(this.api_key))
            my_preference.put("base_url", ValueType.string(this.base_url))
            my_preference.put("system_prompt", ValueType.string(this.system_prompt))
            my_preference.put("max_tokens", ValueType.integer(this.max_tokens))
            my_preference.put("temperature", ValueType.double(this.temperature))
            my_preference.put("top_p", ValueType.double(this.top_p))
            my_preference.put("stream", ValueType.bool(this.stream))
            my_preference.put("chat_timeout", ValueType.integer(this.chat_timeout))
            my_preference.flush()
            PromptAction.showToast(message: "Configure save ok! \n 配置保存成功！")
        } else {
            PromptAction.showToast(message: "Configure save failed, please check! \n 配置保存失败，请检查你的配置！")
        }
    }


    func build() {
        Scroll() {
            // Column 1 start
            Column {
                // Column 2 start
                Column() {
                    Title(@r(app.string.setting))
                    // model name
                    FormInput(
                        label: @r(app.string.model),
                        inputType: InputType.Normal,
                        multi: false,
                        value: this.model
                    )
                    // api-key
                    FormInput(
                        label: @r(app.string.api_key),
                        inputType: InputType.Password,
                        multi: false,
                        value: this.api_key
                    )
                    // base_url
                    FormInput(
                        label: @r(app.string.base_url),
                        inputType: InputType.Normal,
                        multi: true,
                        value: this.base_url
                    )
                    // system_prompt
                    FormInput(
                        label: @r(app.string.system_prompt),
                        inputType: InputType.Normal,
                        multi: true,
                        value: this.system_prompt
                    )
                    // chat timeout
                    // FormInput(
                    //     label: @r(app.string.chat_timeout),
                    //     inputType: InputType.Number,
                    //     multi: false,
                    //     value: this.chat_timeout
                    // )
                } // Column 2 end
                Divider().strokeWidth(1).color(0x161315)
                .width(50.percent)
                .margin(top: 20, bottom: 20)
                // other model configure
                Column() {
                    Title(@r(app.string.model_generator_configure))
                    // chat timeout
                    IntSliderInput(
                        label: @r(app.string.chat_timeout),
                        value: this.chat_timeout,
                        min: 10,
                        max: 1200,
                        step: 10,
                        showSteps: true
                     )
                    // max_tokens
                    IntSliderInput(
                        label: @r(app.string.max_tokens),
                        value: this.max_tokens,
                        min: 500,
                        max: 2500,
                        step: 100,
                        showSteps: true
                    )
                    // temperature
                    FloatSliderInput(
                        label: @r(app.string.temperature),
                        value: this.temperature,
                        min: 0.0,
                        max: 2.0,
                        step: 0.1,
                        showSteps: true
                    )
                    // top_p
                    FloatSliderInput(
                        label: @r(app.string.top_p),
                        value: this.top_p,
                        min: 0.0,
                        max: 1.0,
                        step: 0.05,
                        showSteps: true
                    )
                    // stream
                    ToggleInput(
                        label: @r(app.string.stream),
                        value: this.stream
                    )
                }
                // button
                Row {
                    Btn(@r(app.string.back), back)
                    Btn(@r(app.string.save), save)
                }.width(100.percent)
                .margin(top: 20)
                .justifyContent(FlexAlign.SpaceBetween)
            }.alignItems(HorizontalAlign.Start) // Column 1 end
            .padding(left: 20, right: 20)
        }.scrollable(ScrollDirection.Vertical) // Scroll
        .width(100.percent)
        .height(100.percent)
    }
}
