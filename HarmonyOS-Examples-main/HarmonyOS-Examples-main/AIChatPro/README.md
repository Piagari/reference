### 项目介绍
### 项目概述
- 使用仓颉编程语言，接入mindspore-lite，完成对通义千问2（2.5系列应该也支持，一样的结构）的模型进行离线推理，目前测试的qwen2-0.5b-instruct.
- 仅支持鸿蒙Next(API 15+)。
- 推荐虚拟机内存>=16G, 储存>=32G。
- 注：代码在DevEco Studio for Windows 5.0.9.300和DevEco Studio-Cangjie Plugin 5.0.9.300 完成编译。

### 使用方法
1. 去Huggingface下载Qwen2系列的模型，例如`QWen2-0.5B-Instruct`，[下载地址](https://huggingface.co/Qwen/Qwen2-0.5B-Instruct)，[国内镜像下载地址](https://hf-mirror.com/Qwen/Qwen2-0.5B-Instruct)
2. 将对应模型的`config.json`和`tokenizer.json`放到`entry/src/main/resources/rawfile/`目录。
3. 转pytorch原版模型为mindspore-lite专用的`.ms`文件，建议使用昇腾系列的NPU开发板完成该工作。参考这个项目，[链接](https://github.com/Tlntin/qwen-mindspore-lite-llm)
   - 如果你没有昇腾开发板或者想要快速体验一下，这里我提供一个转换好的qwen2-0.5b-instruct的ms文件。 链接：https://pan.baidu.com/s/12Mk0aNLRLy2bmzHP1t5IWQ?pwd=hhrg  提取码：hhrg
4. 将`qwen2_0.5b_chat.ms`模型文件放到`entry/src/main/resources/rawfile/`目录
5. 修改OpenHarmony SDK路径，默认是`"${DEVECO_SDK_HOME}/default/openharmony/native/sysroot/usr/lib/aarch64-linux-ohos\"`和`"${DEVECO_SDK_HOME}/default/openharmony/native/sysroot/usr/lib/x86_64-linux-ohos\"`
   - 如果你是Windows系统，则不需要修改。
   - 如果你是MacOS系统，请修改`entry/src/main/cangjie/cjpm.toml`文件里面对应的OpenHarmony SDK路径。
6. 使用DevEco Studio运行该项目。

### 关联项目
1. [qwen-ascend-llm](https://github.com/Tlntin/qwen-ascend-llm), 该项目完成对通义千问系列模型代码魔改，支持onnx,om（昇腾CANN专用）导出与推理。
2. [qwen-mindspore-lite-llm](https://github.com/Tlntin/qwen-mindspore-lite-llm)，该项目在项目1的基础上继续魔改，将输入输出转成mindspore-lite需要的NCHW格式，并且利用python对mindspore-lite完成推理验证。
3. [qwen_ms_llm](https://gitcode.com/Tlntin/qwen_ms_llm/overview)，该项目使用仓颉对rust版的tokenizer导出后的c库进行绑定，并且对C语言版的mindspore-lite绑定后完成推理，成功将python的逻辑由仓颉进行编码实现，验证了仓颉做端侧推理的可行性。
4. [AIChat](https://gitcode.com/Cangjie/HarmonyOS-Examples/tree/main/AIChat)，该项目提供AI对话的皮肤，支持流式对话。通过将项目3的后端能力移植到项目4，最终得到本项目。

### 界面展示
1. 采用模拟器，CPU环境离线运行qwen2-0.5b-instruct模型
- ![](./images/aichat_pro.gif)

### 待完善的功能
- [x] 模拟器运行
- [ ] 真机调试（还有点小bug，暂时不支持真机）
- [ ] NPU推理（模拟器不支持NPU，所以还没测试这个）
- [ ] fp16支持（模拟器不支持FP16，所以还没测试这个）
- [ ] int8/int4量化

