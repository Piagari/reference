# 语音转文字应用示例（仓颉与ArkTS互操作）

本项目是一个语音识别转文字应用，展示了仓颉（Cangjie）语言与ArkTS之间的互操作。用户可以通过录音功能实现实时的语音转文字，并将识别结果实时展示在界面上。应用支持语音内容的动态更新、识别结果展示及清空操作。

## 项目结构

项目主要由两部分组成：
1. **仓颉代码**：位于`entry/src/main/cangjie/`目录下，负责UI构建、状态管理和语音识别触发
2. **ArkTS代码**：位于`entry/src/main/ets/`目录下，负责音频采集、语音识别引擎调用等原生功能

```
entry/src/main/
├── cangjie/
│   ├── ark_interop_api/
│   │    └── ark_interop_api.d.ts 
│   ├── components/
│   │   ├── background.cj    
│   │   └── recording.cj   	# 录音组件（UI和交互）
│   ├── interop/
│   │    └── index.cj       # 互操作接口定义
│   ├── cjpm.toml
│   └── main.cj
└── ets/
    ├── entryability/
    │   └── EntryAbility.ets      	# 入口Ability
    └── pages/
        ├── audio_handle.ets     	# 语音处理服务
        ├── ICapturerInterface.ets  # 接口文件
        └── Audio_capturer.ets   	# 音频采集实现

```

## 互操作流程

本项目实现了高效的跨语言回调机制，使ArkTS原生层语音识别结果能够实时传递到仓颉UI层。该机制建立了完整的回调生命周期管理，包含注册、触发、执行三个阶段。

### 1. 回调注册（建立跨语言通信通道）

#### 实现步骤：
1. **仓颉声明接口** (`index.cj`) ：在仓颉代码中（`interop/index.cj`）使用`@Interop[ArkTS]`注解声明需要ArkTS实现的函数，例如：
```cangjie
@Interop[ArkTS]
public func startRecording(fn: ((AudioFileInfo, Int8) -> Unit) -> Unit ): Unit {
    AudioCallBackFunc = fn
}

public func AudioWithStartRecording(callback: AudioFunc) {
    if (let Some(fn) <- AudioCallBackFunc) {
        fn(callback)
    } else {
        ()
    }
}
```

这里声明了一个函数`startRecording`，用于注册一个回调函数，该回调函数会在用户点击开始录音时被调用。同时定义函数 `AudioWithStartRecording` 用于传输 ArkTS 录音函数 `AudioCallBackFunc` 的信息。

2. **ArkTS类型声明** (`ark_interop_api.d.ts`)：在仓颉与ArkTS互操作的过程中，为了在ArkTS中能够正确地调用仓颉定义的函数和类，我们需要在仓颉侧生成`cangjie-ArkTS `交互操作的 api。

```typescript
export declare class AudioFileInfo {
}

export declare interface CustomLib {
    AudioFileInfo: {new (uri: string, size: number, recognitionResult: string): AudioFileInfo}
    startRecording(fn: (funcArg0: (funcArgfuncArg0: AudioFileInfo, funcArgfuncArg1: number) => void) => void): void
}
```

3. **ArkTS实现并注册** (`EntryAbility.ets`)：在ArkTS的`EntryAbility.ets`中，通过`global_cjLib`建立跨语言访问通道：
```typescript
global_cjLib.startRecording((callback: (audio: AudioFileInfo, stage: number) => void) => {
    audioHandle.startRecording(callback).then((sessionId) => {
        hilog.info(0x0000, 'ASR', `Recording started: ${sessionId}`);
    });
});
```

通过函数映射将ArkTS函数`audioHandle.startRecording`注册到仓颉环境，同时声明回调函数接口，接收`AudioFileInfo`和阶段状态。

### 2. 回调触发（结果返回与UI更新）

在完成 ArkTS 侧的回调注册后，我们便可以在仓颉侧调用回调函数来得到 ArkTS 侧的结果

#### 步骤：
1. **仓颉调用ArkTS功能** (`recording.cj`)：
```cangjie
Button("开始录音").activeStyle().onClick{ =>
    AudioWithStartRecording() { audio, stage =>
        generatedText = audio.recognitionResult
    }
}
```

用户点击仓颉UI中的"开始录音"按钮，便会由 `onClick` 事件调用已注册的 ArkTS 录音函数 `AudioCallBackFunc` 。

2. **ArkTS创建仓颉对象** (`audio_handle.ets`)：

```typescript
// audio_handle.ets
private updatePartialResult(partialResult: string, isFinal: boolean) {
    // 创建唯一会话URI
    const uri = `session://${this.activeSessionId}`;
    
    // 创建仓颉兼容对象
    const info = NewAudioFileInfo(
        uri,                      // 会话标识
        0,                        // 文件大小（实时语音无文件）
        partialResult              // 识别结果文本
    );
    
    // 确定处理阶段
    const stage = isFinal ? FINISHED : RECORDING;
    
    // 执行回调传回结果
    if (this.callback) {
        this.callback(info, stage);
    }
}
```

ArkTS 启动语音识别服务后，随着录音进行持续产生识别结果；每次有新的识别结果产生时，ArkTS 将其封装为仓颉兼容对象，并通过调用仓颉传入的回调函数将识别结果传回。

3. **UI 更新**：

```
generatedText = audio.recognitionResult // 响应式UI自动更新
```

最后对于 @State 修饰的变量 `generatedText` ，当回调在仓颉环境中执行时，结果数据自动解包并更新UI状态，触发界面刷新，最终将识别文本实时展示给用户。

## 嵌入仓颉组件（CJHybridComponentV2）

在ArkTS的UI中，我们需要嵌入由仓颉编写的组件。这是通过`CJHybridComponentV2`组件实现的，代码示例：

```typescript
// Index.ets
import { CJHybridComponentV2 } from '@cangjie/hybrid';

@Entry
@Component
struct Index {
  build() {
    Column() {
          CJHybridComponentV2({
            library: 'ohos_app_cangjie_entry',
            component: 'AudioTransform'
          })
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height('100%')

    }
}
```

## 功能模块

### 1. 语音识别流程
- **录音开始**：用户点击按钮触发录音
- **实时语音识别**：
    - 音频采集器（`AudioCapturer`）采集PCM数据
    - 分块传输到语音识别引擎（`speechRecognizer`）
- **结果实时回显**：
    - 中间结果：部分识别文本实时更新
    - 最终结果：完整识别文本显示

### 2. 状态管理
- **UI状态**：仓颉组件使用`@State`管理识别文本：
  ```cangjie
  @State var generatedText : String = ""
  ```
- **识别阶段**：ArkTS使用`stage`参数区分处理阶段：
  ```typescript
  const IDLE = 0;
  const RECORDING = 10;    // 录音中
  const PROCESSING = 20;   // 处理中
  const FINISHED = 30;     // 识别完成
  ```

### 3. UI组件
- **录音按钮**：胶囊形按钮，点击后触发录音
- **清空按钮**：清除当前识别内容
- **文本展示区**：可滚动区域展示识别结果
- **动态样式**：根据状态变化的按钮样式
  ```cangjie
  // 激活状态（红色）
  func activeStyle() {
      this.style()
          .backgroundColor(0xFF4C4C)
          .fontColor(Color.WHITE)
  }
  
  // 清除状态（灰色）
  func clearStyle() {
      this.style()
          .backgroundColor(0x6C757D)
          .fontColor(Color.WHITE)
  }
  ```

## 核心代码

### 1. 跨语言通信（仓颉侧）
`index.cj` 跨语言接口定义：
```cangjie
public type AudioFunc = (AudioFileInfo, Int8) -> Unit
public var AudioCallBackFunc : ? (AudioFunc) -> Unit = None

public func AudioWithStartRecording(callback: AudioFunc) {
    if (let Some(fn) <- AudioCallBackFunc) {
        fn(callback)
    }
}
```

### 2. 语音识别引擎（ArkTS侧）
`audio_handle.ets`核心流程：
```typescript
// 创建语音识别引擎
private async createEngine() {
    const initParamsInfo: speechRecognizer.CreateEngineParams = {
        language: 'zh-CN',
        online: 1, // 使用在线识别
        extraParams: {
            locate: 'CN',
            recognizerMode: 'short' // 短语音模式
        }
    };
    
    speechRecognizer.createEngine(initParamsInfo, (err, engine) => {
        asrEngine = engine;
        asrEngine.setListener(this.setListener());
    });
}

// 处理识别结果
private setListener(): speechRecognizer.RecognitionListener {
    return {
        onResult: (sessionId, result) => {
            // 实时更新部分结果
            this.updatePartialResult(sessionId, result.result, result.isFinal);
        },
        onComplete: (sessionId) => {
            // 传递最终结果
            this.finalizeRecognition(sessionId);
        }
    };
}
```

### 3. 录音识别（ArkTS侧）

```ArkTS
public async startRecording(callback: AudioCallback): Promise<string> {
      await this.createEngine();

      // 生成新会话ID
      this.activeSessionId = this.generateSessionId();
      this.callback = callback;

      // 设置识别参数
      const audioParams: speechRecognizer.AudioInfo = {
        audioType: 'pcm',
        sampleRate: 16000,
        soundChannel: 1,
        sampleBit: 16
      };

      const extraParams: Record<string, Object> = {
        "recognitionMode": 0, // 流式识别
        "vadBegin": 2000, // 开始静音检测时间(ms)
        "vadEnd": 3000,   // 结束静音检测时间(ms)
        "maxAudioDuration": 60000 // 最大音频时长(ms)
      };

      const startParams: speechRecognizer.StartParams = {
        sessionId: this.activeSessionId,
        audioInfo: audioParams,
        extraParams: extraParams
      };

      // 开始识别会话
      asrEngine.startListening(startParams);

      // 初始化音频采集器
      let data: ArrayBuffer;
      console.info(TAG, 'create capture success');
      this.mAudioCapturer.init((dataBuffer: ArrayBuffer) => {
        console.info(TAG, 'start write');
        console.info(TAG, 'ArrayBuffer ' + JSON.stringify(dataBuffer));
        data = dataBuffer
        let uint8Array: Uint8Array = new Uint8Array(data);
        console.info(TAG, 'ArrayBuffer uint8Array ' + JSON.stringify(uint8Array));

        asrEngine.writeAudio(this.activeSessionId, uint8Array);
      });
}
```

### 4. 音频采集器（ArkTS侧）

`Audio_capturer.ets`核心功能：
```typescript
// 初始化音频采集器
public async init(dataCallBack: (data: ArrayBuffer) => void) {
    this.mAudioCapturer = await audio.createAudioCapturer({
        streamInfo: {
            samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_16000,
            channels: audio.AudioChannel.CHANNEL_1,
            sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
            encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
        },
        capturerInfo: {
            source: audio.SourceType.SOURCE_TYPE_MIC,
            capturerFlags: 0
        }
    });
    this.mDataCallBack = dataCallBack;
}

// 采集音频数据
public async start() {
    await this.mAudioCapturer.start();
    while (this.mCanWrite) {
        let bufferSize = await this.mAudioCapturer.getBufferSize();
        let buffer = await this.mAudioCapturer.read(bufferSize, true);
        this.mDataCallBack(buffer); // 将数据传递给语音引擎
    }
}
```

### 4. 仓颉UI组件（录音界面）
`recording.cj` 组件实现：
```cangjie
@Component
public class recording {
    @State var generatedText : String = ""

    public func build() {
        Column {
            // 识别结果展示区
            Scroll {
                Text(this.generatedText)
                    .fontSize(15)
                    .fontColor(Color.BLACK)
                    .width(100.percent)
            }
            .padding(20)
            .borderRadius(12.vp)
            .backgroundColor(Color.WHITE)

            // 录音控制按钮
            Button("开始录音")
                .activeStyle()
                .onClick{ => 
                    AudioWithStartRecording() { audio, stage =>
                        generatedText = audio.recognitionResult
                    }
                }

            // 清空按钮
            Button("清空当前内容")
                .clearStyle()
                .onClick{ => generatedText = '' }
        }
        .justifyContent(FlexAlign.Center)
        .width(100.percent)
    }
}
```

## 注意事项

1. **权限申请**：
    - 在`module.json5`中声明`ohos.permission.MICROPHONE`权限
    - 首次录音前动态请求麦克风权限
2. **资源释放**：
    - 录音完成后调用`audioCapturer.release()`释放资源
    - 应用退出时确保释放语音识别引擎

## 总结

本项目实现了仓颉和 ArkTS 在语音识别场景的深度互操作：

- **仓颉优势**：简洁的声明式 UI 语法实现精美界面
- **ArkTS优势**：完整访问 HarmonyOS 原生能力（音频、AI服务）
- **高效通信**：通过跨语言对象传递和回调机制实现实时识别

这种混合编程模式充分利用了仓颉的高效UI开发能力和 ArkTS 的丰富平台 API ，为复杂应用开发提供了便利。

### *具体操作请观看演示视频*