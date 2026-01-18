package ohos_app_cangjie_entry

internal import ohos.base.BusinessException
internal import ohos.base.Color
internal import ohos.base.CJResource
internal import ohos.base.__GenerateResource__
internal import ohos.base.LengthProp
internal import ohos.base.Length
import ohos.concurrency.launch
internal import ohos.component.Alignment
internal import ohos.component.ClickEvent
internal import ohos.component.Column
internal import ohos.component.Row
internal import ohos.component.Button
internal import ohos.component.FlexAlign
internal import ohos.component.ForEach
internal import ohos.component.TextArea
internal import ohos.component.TextInput
internal import ohos.component.Text
internal import ohos.component.LazyForEach
internal import ohos.component.List
internal import ohos.component.ListItem
internal import ohos.component.BarPosition
internal import ohos.component.CustomView
internal import ohos.component.CJEntry
internal import ohos.component.FontWeight
internal import ohos.component.NestedScrollMode
internal import ohos.component.NestedScrollOptions
internal import ohos.component.loadNativeView
internal import ohos.component.LegalCallCheck
internal import ohos.component.If
internal import ohos.component.Image
internal import ohos.component.HorizontalAlign
internal import ohos.component.Scroll
internal import ohos.component.ShapeType
internal import ohos.component.SafeAreaEdge
internal import ohos.component.SafeAreaType
internal import ohos.component.SourceType
internal import ohos.component.StickyStyle
internal import ohos.component.TextAlign
internal import ohos.component.ViewBuilder
internal import ohos.component.VerticalAlign
internal import ohos.resource_manager.ResourceManager
internal import ohos.prompt_action.*
internal import ohos.state_manage.LocalStorage
internal import ohos.state_manage.ObservedArrayList
internal import ohos.state_manage.ObservedProperty
internal import ohos.state_manage.SubscriberManager
internal import ohos.state_manage.ViewStackProcessor
// custom import
import ohos_app_cangjie_entry.view.ChatLine

import ohos.state_macro_manage.Entry
import ohos.state_macro_manage.Component
import ohos.state_macro_manage.State
import ohos.state_macro_manage.r
import ohos.state_macro_manage.Builder
import ohos.net.http.*
import ohos.hilog.Hilog
import ohos.router.Router
import std.collection.HashMap
import std.collection.ArrayList
import encoding.json.stream.*
import std.io.ByteArrayStream
import std.time.Duration
import std.sync.sleep
import ohos.preferences.*
import ohos_app_cangjie_entry.mindspore.MindSporeLite
import ohos.file_fs.FileFs
import ohos.file_fs.ReadOptions

@Entry
@Component
class MyView {
    // user input
    @State
    var prompt: String = "";         // 用户输入信息
    var max_tokens: Int64 = 512;     // 单次最大生成token, 目前默认512，设置界面可调。
    var temperature: Float64 = 0.7;  // 温度
    var top_p: Float64 = 1.0
    var stream: Bool = true;         // 是否开启流式对话
    var eos_token_id: UInt32 = 0;    // 对话暂停信号
    var system_prompt: String = "You are a helpful assistant.";

    @State
    var temp_user_content: String = "";
		@State
    var temp_assistant_content: String = "";
    @State
    var blank_height: Length = 0.percent;

    // 模型相关参数
    let max_input_length: Int64 = 512;
    let kv_cache_length: UInt32 = 1024;
    let max_output_length: UInt32 = 1024;
    let sampling_method: SamplingMethod = SamplingMethod.Top_p;
    let use_fp16: Bool = false;
    // tokenizer/model/config等待会再做初始化
    var tokenizer: HuggingfaceTokenizer = HuggingfaceTokenizer();
    var config: Option<ModelConfig> = None;
    var model: MindSporeLite = MindSporeLite()
    var is_first: Bool = true;          // 记录是否首次推理
    var has_model_load: Bool = false;   // 记录是否已加载模型
    var model_build_res: Bool = false;  // 记录模型是否编译成功

    // total message
    @State
    var messages: ObservedArrayList<Message> = ObservedArrayList<Message>([
        Message(RoleType.System, this.system_prompt)
    ]);
    // hisotry
    var history: ArrayList<(String, String)> = ArrayList<(String, String)>([]);

    let user_avatar: CJResource = @r(app.media.user_avatar);
    let bot_avatar: CJResource = @r(app.media.bot_avatar);

	  @Builder
    func generate_chatLine(msg: Message, index: Int64) {
      if (index == 0) {
         // todo system prompt process
      } else if (index % 2 == 1) {
        ChatLine(src: user_avatar, content: msg.content, is_self: true)
      } else {
        ChatLine(src: bot_avatar, content: msg.content, is_self: false)
      }
    }

    public func read_buffer() {
      let context = get_context();
      let stage_context = getStageContext(context);
      let resource_manager = ResourceManager.getResourceManager(stage_context);
      // load config.json
      // let config_buffer: Array<UInt8> = resource_manager.getRawFileContent("config.json");
      // Hilog.info(0, "load config", "=== get raw fd ===");
      let config_fd = resource_manager.getRawFd("config.json");
      // Hilog.info(0, "load config", "=== fd: ${config_fd.fd}, offset: ${config_fd.offset}, length: ${config_fd.length} ===");
      let config_buffer: Array<Byte> = Array<Byte>(config_fd.length, item: 0);
      // Hilog.info(0, "load config", "=== file fs read ===");
      FileFs.read(
        config_fd.fd,
        config_buffer,
        options: ReadOptions(offset: Some(config_fd.offset), length: Some(UIntNative(config_fd.length)))
      );
      this.config = Some(read_config(config_buffer));
      Hilog.info(0, "load config", "=== load config.json success ===");
      // load tokenizer.json
      let tokenizer_buffer: Array<UInt8> = resource_manager.getRawFileContent("tokenizer.json");
      this.tokenizer.load_vocab(buffer: tokenizer_buffer);
      Hilog.info(0, "load config", "=== load tokenizer.json success ===");
      // load model
      let temp_config = this.config.getOrThrow();
      this.eos_token_id = temp_config.eos_token_id;
      this.model.load_params(
         num_hidden_layers: temp_config.num_hidden_layers,
         num_key_value_heads: temp_config.num_key_value_heads,
         per_head_dim: temp_config.hidden_size / temp_config.num_attention_heads,
         vocab_size: temp_config.vocab_size,
         kv_cache_length: this.kv_cache_length,
         use_fp16: this.use_fp16
      );
      Hilog.info(0, "info", "=== files dir: ${context.filesDir} === ");
   }

   public func load_model() {
      spawn {
        Hilog.info(0, "info", "=== load model buffer === ");
        if (this.has_model_load) {
          if (this.model_build_res) {
            launch {
              PromptAction.showToast(message: "模型已经加载过了");
            }
          } else {
            launch {
              PromptAction.showToast(message: "模型编译失败");
            }
          }
          return;
        }
        let context = get_context();
        let stage_context = getStageContext(context);
        let resource_manager = ResourceManager.getResourceManager(stage_context);
        let raw_file_fd = resource_manager.getRawFd("qwen2_0.5b_chat.ms");
        Hilog.info(0, "info", "=== fd: ${raw_file_fd.fd}, offset: ${raw_file_fd.offset}, length: ${raw_file_fd.length} === ");
        Hilog.info(0, "info", "=== model malloc buffer === ");
        this.model.malloc_buffer(raw_file_fd.length);
        Hilog.info(0, "info", "=== model malloc buffer success === ");
        // 批量导入model_buffer
        // 因为堆最高不得超过64M,保险起见，我取50M
        var temp_buffer_size: Int64 = 50 * 1000 * 1000;
        let temp_model_buffer: Array<UInt8> = Array<UInt8>(temp_buffer_size, item: 0);
        // 计算循环次数，向上取整
        let batch: Int64 = (raw_file_fd.length + temp_buffer_size - 1) / temp_buffer_size;
        var read_offset: Int64 = 0;
        var p_temp_model: CPointer<UInt8> = this.model.p_model_buffer;
        // 读取前n-1个batch的buffer，每次读取50M
        for (i in 0..batch) {
          // 读到最后一个buffer时，计算一下还能读多少数据
          if (i == (batch - 1)) {
            temp_buffer_size = raw_file_fd.length - read_offset;
          }
          Hilog.info(0, "info", "=== (${i + 1}/${batch}) offset=${read_offset}, length=${temp_buffer_size} === ");
          let progress = (i + 1) * 10000 / batch;
          let progress_a = progress / 100;
          let progress_b = progress % 100;
          launch {
            PromptAction.showToast(message: "加载模型中（${progress_a}.${progress_b}%）");
          }
          // 先读取结果存到temp_model_buffer
          let read_length: Int64 = FileFs.read(
            raw_file_fd.fd,
            temp_model_buffer,
            options: ReadOptions(offset: Some(raw_file_fd.offset + read_offset), length: Some(UIntNative(temp_buffer_size)))
          );
          Hilog.info(0, "info", "=== read_length: ${read_length} === ");
          // 再将这个buffer传给c指针，给下一次写入
          p_temp_model = this.model.load_model_buffer_iter(temp_model_buffer, temp_buffer_size, p_temp_model);
          // 偏移offset
          read_offset += temp_buffer_size;
        }
        this.has_model_load = true;
        this.model_build_res = this.model.build_model();
        if (!this.model_build_res) {
          PromptAction.showToast(message: "模型编译失败");
        } else {
          PromptAction.showToast(message: "模型编译成功");
        }
      }
    }

    private func free() {
      this.model.free();
    }

    private func reset() {
      // 重置模型状态
      this.model.reset();
    }

    protected func aboutToAppear() {
      this.read_buffer();
    }

    protected func aboutToDisappear() {
      // 即将销毁app时，释放内存
      this.free();
    }


    protected func onPageShow() {
      // 页面开启自动加载模型
      this.load_model();
      var my_preference = Preferences.getPreferences(get_stage_context(), "save")
      // system_prompt
      if (my_preference.has("system_prompt")) {
				match(my_preference.get("system_prompt", ValueType.string(""))) {
          case ValueType.string(temp_str) => this.system_prompt = temp_str;
          case _ => ()
				}
      }
      // max_tokens
      if (my_preference.has("max_tokens")) {
				match(my_preference.get("max_tokens", ValueType.integer(0))) {
          case ValueType.integer(temp_int) => this.max_tokens = temp_int;
          case _ => ()
				}
      }
      // temperature
      if (my_preference.has("temperature")) {
				match(my_preference.get("temperature", ValueType.double(0.0))) {
          case ValueType.double(temp_float) => this.temperature = temp_float;
          case _ => ()
				}
      }
      // top_p
      if (my_preference.has("top_p")) {
				match(my_preference.get("top_p", ValueType.double(0.0))) {
          case ValueType.double(temp_float) => this.top_p = temp_float;
          case _ => ()
				}
      }
      // stream
      if (my_preference.has("stream")) {
				match(my_preference.get("stream", ValueType.bool(false))) {
          case ValueType.bool(temp_bool) => this.stream = temp_bool;
          case _ => ()
				}
      }
    }

    // public func chat_callback() {
    //   spawn {
    //     if (this.prompt.size > 0)  {
    //       try {
    //         // add user message
    //         let temp_prompt: String = this.prompt;
    //         launch {
    //           this.temp_user_content = this.prompt;
    //           this.prompt = "";
    //         }
    //         // Hilog.error(0, "response", "prompt: ${temp_prompt}");
    //         // Hilog.error(0, "response", "url: ${env_info.base_url}");
    //         let response: Option<String> = chat(
    //             temp_prompt,
    //             env_info,
    //             this.history,
    //             this.max_tokens,
    //             this.temperature,
    //             this.top_p,
    //         );
    //         // Hilog.error(0, "response", "response: ${response}");
    //         match (response) {
    //           case Some(res: String) =>
    //             // Hilog.error(0, "res", "res: ${res}");
    //             // update message and history
    //             launch {
    //               this.messages.append(Message(RoleType.User, "${this.temp_user_content}"));
    //               this.messages.append(Message(RoleType.Assistant, res));
    //               this.history.append(("${this.temp_user_content}", res));
    //               this.temp_user_content = "";
    //             }
    //           case None =>
    //               Hilog.error(0, "AIChat", "can't get Response");
    //               PromptAction.showToast(message: "Error! call api failed, can't get Response \n 错误！调用接口失败，未收到任何返回。");
    //         }
    //       } catch (e: Exception) {
    //           Hilog.error(0, "AIChat", "Network error");
    //           PromptAction.showToast(message: "Error! Network error \n 错误！网络异常。");
    //       }
    //       launch {
    //         this.temp_user_content = "";
    //       }
    //     }
    //   }
    // }

    public func stream_chat_callback() {
      spawn {
        // 检查模型加载、编译情况
        if (this.has_model_load) {
          if (!this.model_build_res) {
            launch {
              PromptAction.showToast(message: "模型编译失败");
            }
            return;
          }
        } else {
          launch {
            PromptAction.showToast(message: "模型加载失败");
          }
          return ;
        }
        if (this.prompt.size > 0)  {
          // add user message
          let temp_prompt = this.prompt;
          launch {
            this.temp_user_content = this.prompt;
            this.prompt = "";
          }
          // 创建new_message，用于构造prompt
          var new_messages: ArrayList<Message> = ArrayList<Message>(
            this.history.size * 2 + 1
          );
          new_messages.append(Message(RoleType.System, this.system_prompt));
          for ((user_msg, bot_msg) in history) {
            new_messages.append(Message(RoleType.User, user_msg));
            new_messages.append(Message(RoleType.Assistant, bot_msg));
          }
          new_messages.append(Message(RoleType.User, prompt));
          let text: String = this.tokenizer.apply_chat_template(
            new_messages, add_generation_prompt: true
          );
          var input_ids: Array<UInt32> = this.tokenizer.encode(text);
          if (input_ids.size > Int64(this.max_input_length)) {
            input_ids = input_ids[input_ids.size - this.max_input_length..];
          }
          this.is_first = false;
          var ids_list: ArrayList<UInt32> = ArrayList<UInt32>();
          var rune_length = 0;
          let input_length = UInt32(input_ids.size);
          var max_output_len = this.max_output_length - input_length;
          if (this.max_tokens < Int64(max_output_len)) {
            max_output_len = UInt32(this.max_tokens)
          }
          let error_rune: Rune = r'\u{efbfbd}';
          // 新增文本
          var new_text: String = "";
          // 最终返回的文本
          var text_output: String = "";
          for (_ in 0..max_output_len) {
            let logits_option = this.model.inference(input_ids);
            if (logits_option.isSome()) {
              let logits: Array<Float32> = logits_option.getOrThrow();
              input_ids = sample_logists(
                logits,
                this.sampling_method,
                Float32(this.top_p),
                Float32(this.temperature),
              )
              // ealy stop?
              if (input_ids[0] == this.eos_token_id) {
                break;
              }
              ids_list.append(input_ids[0]);
              // 理论上可以只解码新的token,但是可能会导致英文字符空格丢失，所以这里全部解码
              text_output = this.tokenizer.decode(ids_list.toArray());
              let text_out_runes: Array<Rune> = text_output.toRuneArray();
              let new_runes: Array<Rune> = text_out_runes[rune_length..];
              // if b"\xef\xbf\xbd" in new_text.encode():
              if (new_runes.contains(error_rune)) {
                println("new_runes: ${new_runes}");
                // 说明出现乱码，需要等待下一次解码
                continue;
              }
              new_text = "";
              for (rune in new_runes) {
                new_text += rune.toString();
              }
              // print("${new_text}", flush: true);
              let delta_content: String = new_text;
              launch{
                this.temp_assistant_content += delta_content;
              }
              if (new_runes.size > 0 && new_text.size > 0) {
                rune_length = text_out_runes.size;
              }
            } else {
              eprintln("inference failed");
              break;
            }
          }
          // update messages and history
          launch {
            this.messages.append(Message(RoleType.User, "${this.temp_user_content}"));
            this.messages.append(Message(RoleType.Assistant, "${this.temp_assistant_content}"));
            this.history.append(("${this.temp_user_content}", "${this.temp_assistant_content}"));
            this.temp_user_content = "";
            this.temp_assistant_content = "";
          }
        }
      }
    }

    func build() {
      Column {
        // title
        Column() {
          Row {
             // setting button
             Button {
               Image(@r(app.media.ic_public_settings))
                 .width(32)
                 .height(32)
                 .margin(left: 4, right: 4)
                 .align(Alignment.Center)
             }
               .shape(ShapeType.CircleType)
               .width(12.percent)
               .backgroundColor(Color(242, 241, 247))
               .padding(right: 10)
               .margin(right: 10)
               .onClick({=> Router.push(url: "Settings")})
             // text
             Text("AI Chat Pro").fontSize(24).width(76.percent).textAlign(TextAlign.Center).align(Alignment.Center)
             // clear button
             Button {
               Image(@r(app.media.ic_public_clean))
                 .width(32)
                 .height(32)
                 .margin(left: 4, right: 4)
                 .align(Alignment.Center)
             }
               .shape(ShapeType.CircleType)
               .width(12.percent)
               .backgroundColor(Color(242, 241, 247))
               .padding(right: 10)
               .margin(right: 10)
               .onClick({=>
                  spawn {
                    this.history.clear();
                    this.messages.clear();
                    this.messages.append(Message(RoleType.System, this.system_prompt));
                  }
                  this.model.reset();
               })
          }.width(100.percent).padding(10)
        }.expandSafeArea(
            types: [SafeAreaType.SYSTEM, SafeAreaType.KEYBOARD],
            edges: [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]
        )
        // chat
        Column(5) {
          List() {
            ForEach(
              this.messages,
              {
                msg: Message, index: Int64 =>
                  ListItem() {
                    this.generate_chatLine(msg, index)
                  }
              }
            )
          }
          .nestedScroll(NestedScrollOptions(NestedScrollMode.SELF_ONLY, NestedScrollMode.SELF_ONLY))
          if(temp_user_content.size > 0) {
               ChatLine(src: user_avatar, content: temp_user_content, is_self: true)
            }
            if (temp_assistant_content.size > 0) {
               ChatLine(src: bot_avatar, content: temp_assistant_content, is_self: false)
            }
        }
        .align(Alignment.TopStart)
        .layoutWeight(1)
        .backgroundColor(Color(238, 237, 242))
        // input
			  Column(10) {
			  	Row() {
			  		TextArea(text: this.prompt)
			  		  .fontColor(0x000000)
			  		  .backgroundColor(0xffffff)
			  		  .layoutWeight(1)
			  		  .borderRadius(6.fp)
			  		  .margin(right: 10)
                    .constraintSize(minHeight: 40.vp)
              .onChange({change_str: String => this.prompt = change_str;})
              .onClick({event: ClickEvent =>
                 match (event.source) {
                   case SourceType.TouchScreen => this.blank_height = 38.percent;
                   case _ => ()
                 }
               })
               .onEditChange({is_edit: Bool => if (!is_edit) {this.blank_height = 0.percent;}})

			  		Button(@r(app.string.send))
              .shape(ShapeType.Normal)
			  		  .height(40)
			  		  .width(60)
			  		  .fontSize(12)
			  		  .fontColor(0xffffff)
			  		  .borderRadius(6.fp)
			  		  .backgroundColor(Color(67, 151, 247))
              .onClick({
                  =>
                if (this.system_prompt.size == 0) {
                   PromptAction.showToast(message: "Attention! The system prompt is not configured \n 警告！未配置系统提示词");
                } else {
								  if (this.stream) {
								  	this.stream_chat_callback()
								  } else {
                     // this.chat_callback();
                     PromptAction.showToast(message: "Not support chat without stream.  \n 暂不支持非流式对话");
								  }
                }
              }) // button
			  	  }.padding(left: 2, right: 2) // row
			   } // column(10)
            .padding(left: 10, right: 10, top: 5)
            .expandSafeArea(
                types: [SafeAreaType.SYSTEM],
                edges: [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]
            )
         Column {
         }.height(this.blank_height)
       } // Column
        .width(100.percent)
        .height(100.percent)
        .backgroundColor(Color(242, 241, 247))
        .expandSafeArea(
            types: [SafeAreaType.SYSTEM, SafeAreaType.KEYBOARD],
            edges: [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]
        )
    } // build
}
