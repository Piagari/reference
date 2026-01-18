# OCR应用示例（仓颉与ArkTS互操作）

本项目是一个OCR（光学字符识别）应用，展示了仓颉（Cangjie）语言与ArkTS之间的互操作。用户可以通过拍照、选择图片或文档进行文字识别，并将识别结果展示在界面上。

## 项目结构

项目主要由两部分组成：
1. **仓颉代码**：位于`entry/src/main/cangjie/`目录下，负责UI构建、状态管理和核心逻辑。
2. **ArkTS代码**：位于`entry/src/main/ets/`目录下，负责文件选择、拍照、OCR识别等平台相关功能。



## 仓颉与ArkTS互操作流程

### 1. 仓颉调用ArkTS函数（注册回调）

在仓颉中，我们通过`@Interop[ArkTS]`注解声明函数，然后在ArkTS中实现这些函数并注册，使得仓颉可以调用ArkTS的功能。

#### 步骤：
1、**仓颉声明接口**：在仓颉代码中（`interop/index.cj`）使用`@Interop[ArkTS]`注解声明需要ArkTS实现的函数，例如：

```
@Interop[ArkTS]
public func registerOcrWithSelectedImage(fn: ((OcrFileInfo, Int8) -> Unit) -> Unit): Unit {
    arkOcrWithSelectedImageFunc = fn
}
```

这里声明了一个函数`registerOcrWithSelectedImage`，用于注册一个回调函数，该回调函数会在用户选择图片时被调用。		

2、 **ARKTS声明类型**：在仓颉与ArkTS互操作的过程中，为了在ArkTS中能够正确地调用仓颉定义的函数和类，我们需要在ArkTS侧提供类型定义。可以创建`cjlib.d.ts` 文件用来声明这些类型。

```
export declare class OcrFileInfo {
}

export interface CJLib {
  registerJSFunction(funcName: string, navFunc: Function): void
  OcrFileInfo: {new (uri: string, size: number, ocrResult: string): OcrFileInfo}
  registerOcrWithSelectedImage(fn: (callback: OcrCallBackFunc) => void): void
  registerOcrWithCamera(fn: (callback: OcrCallBackFunc) => void): void
  registerOcrWithDocument(fn: (callback: OcrCallBackFunc) => void): void
  registerShowToast(fn: (toast: string) => void): void
}

```

3 、 **ArkTS实现并注册**：在ArkTS的`EntryAbility.ets`中，使用`global_cjLib`注册这些函数：	

```
global_cjLib.registerOcrWithSelectedImage((callback: (image: OcrFileInfo, stage: number) => void) => {
  Image_handle.selectImage(callback).then((uri: string) => {
    hilog.info(0, "OCR", "selectedImage.uri: " + uri)
  })
})
```

这里实现了当用户选择图片后，调用仓颉传入的回调函数，传递图片信息和处理阶段。

4、**仓颉调用ArkTS功能**：在仓颉的`picker.cj`组件中，当用户点击 “图库” 按钮时，调用`arkOcrWithSelectedImage`函数（该函数会触发在ArkTS中注册的回调）：

```javascript
arkOcrWithSelectedImage() { image, stage =>
    handleOcrResult(image, stage, true)
}
```

### 2. ArkTS调用仓颉函数（创建对象）

在ArkTS中，我们可以调用仓颉中定义的类来创建对象，并通过这些对象传递数据。

#### 步骤：

1、**仓颉定义类**：在仓颉中（`interop/index.cj`）使用`@Interop[ArkTS]`注解定义类，例如`OcrFileInfo`：

```javascript
@Interop[ArkTS]
public class OcrFileInfo {
    public OcrFileInfo(
        public let uri: String,
        public let size: Int64,
        public let ocrResult: String
    ) {}
}
```

2、**ArkTS中创建对象**：在ArkTS中，通过`global_cjLib`创建仓颉中定义的对象：

```typescript
export let NewOcrFileInfo = (uri: string, size: number = 0, ocrResult: string = '') => {
  return new global_cjLib.OcrFileInfo(uri, size, ocrResult);
};
```

这样在ArkTS中就可以创建`OcrFileInfo`对象，并传递给仓颉。

### 3. 数据传递

- **从ArkTS到仓颉**：在OCR处理过程中，ArkTS将处理结果（如文件URI、大小、OCR文本）通过回调函数传递给仓颉。
- **从仓颉到ArkTS**：仓颉通过调用在ArkTS中注册的函数，触发文件选择、拍照等操作，并接收返回的数据。
- UI 交互 → ArkTS原生能力 → Cangjie业务逻辑 → UI更新



## 嵌入仓颉组件（CJHybridComponentV2）

在ArkTS的UI中，我们需要嵌入由仓颉编写的组件。这是通过`CJHybridComponentV2`组件实现的，代码示例：

```
// Index.ets
import { CJHybridComponentV2 } from '@cangjie/hybrid';

@Entry
@Component
struct Index {
  build() {
    Column() {
      // 嵌入仓颉组件
      CJHybridComponentV2({
        library: 'ohos_app_cangjie_entry',  // 仓颉库的名称，对应仓颉模块的包名
        component: 'Main'                  // 要加载的仓颉组件的名称，这里为Main组件
      })
        .height('100%')
        .width('100%')
    }
    .height('100%')
    .width('100%')
  }
}
```

渲染过程

1. 当ArkTS渲染`CJHybridComponentV2`时，它会根据`library`和`component`参数找到对应的仓颉组件。
2. 仓颉的运行时环境会加载并渲染指定的仓颉组件（`Main`组件）。
3. 该组件将作为ArkTS UI的一部分进行布局和绘制，占据指定的高度和宽度（这里设置为100%）。



## 功能模块

### 1. 文件选择与OCR处理

- **图片OCR**：从图库选择图片，调用系统OCR服务识别文字。
- **拍照OCR**：调用摄像头拍照，然后识别照片中的文字。
- **文档OCR**：选择PDF、TXT等文档，提取文字（PDF通过转换为图片再识别）。

### 2. 状态管理

仓颉组件使用`@Provide`和`@Consume`注解管理状态，例如：

- `filePicked`：标记用户是否选择了文件。
- `attachments`：存储用户选择的文件列表。
- `filesAreValid`：标记文件是否有效（OCR识别成功）。

### 3. UI组件

- **FileLine**：展示用户选择的附件列表和OCR提取的文本内容。
- **FileItem**：展示单个附件的信息（文件名、大小、状态）和删除按钮。
- **PickerBar**：提供三个选择按钮（拍照、图片、文档）。



## 核心代码

### 1. 跨语言通信机制 (Cangjie ⇄ ArkTS)

`index.cj`

```cangjie
// Cangjie 定义接口
public type OcrCallBackFunc = (OcrFileInfo, Int8) -> Unit
var arkOcrWithCameraFunc: ?(OcrCallBackFunc) -> Unit = None

@Interop[ArkTS]
public func registerOcrWithCamera(fn: ((OcrFileInfo, Int8) -> Unit) -> Unit): Unit {
    arkOcrWithCameraFunc = fn
}

// Cangjie 调用 ArkTS 功能
public func arkOcrWithCamera(callback: OcrCallBackFunc) {
    if (let Some(fn) <- arkOcrWithCameraFunc) {
        fn(callback)
    }
}
```

`EntryAbility.ets`:

```typescript
global_cjLib.registerOcrWithCamera((callback: OcrCallBackFunc) => {
  Image_handle.takePhoto(callback).then((uri: string) => {
    hilog.info(0, "OCR", "tookPhoto.uri: " + uri)
  })
})

```

### 2. 文件状态管理

```cangjie
// index.cj
public enum ProcessStage <: Hashable & ToString {
    UPLOADING | PENDING | PARSING | FINISHED | FAILED | INVALID
    
    public func i8(): Int8 {
        match (this) {
            case UPLOADING => 0
            case PENDING => 1
            case PARSING => 2
            // ...其他状态
        }
    }
}

//data_type.cj
public class AttachmentInfo {
    protected let uri: String         // 文件URI
    protected let size: Int64         // 文件大小
    protected var stage: ProcessStage // 当前处理阶段
    protected var ocrResult: String   // OCR结果文本
}
```

### 3. 动态UI组件 (Cangjie)

 `fileLine.cj`

```cangjie
@Component
public class FileLine {
    @Provide var fileLineHeight: Int64 = 0
    @Consume var filePicked: Bool
    @Consume var attachments: GeneralDataSource<AttachmentInfo>

    func build() {
        Scroll() {
            LazyForEach(attachments, { item: AttachmentInfo, idx: Int64 =>
                ListItem {
                    Column {
                        // OCR结果展示
                        Scroll(scroller) {
                            Text(item.ocrResult)
                        }.height(500)
                        
                        // 文件信息卡片
                        FileItem(
                            uri: item.uri,
                            stage: item.stage,
                            ocrResult: item.ocrResult
                        )
                    }
                }
            })
        }
        .height(filePicked ? 100.percent : 0) // 动态高度控制
    }
}
```

### 5. OCR处理

 `picker_bar.cj`

```cangjie
    // 处理OCR结果回调
    func handleOcrResult(fileInfo: OcrFileInfo, stage: Int8, isImage: Bool) {
        // 确定日志标签（图片或文档）
        let tag = if (isImage) { "OcrWithImage" } else { "OcrWithDoc" }

        // 转换处理阶段枚举
        let ps = ProcessStage.fromInt8(stage)
        AppLog.info("[${tag}] ${ps}, size: ${fileInfo.size}, ocrResult/reason: ${fileInfo.ocrResult}")

        if (let UPLOADING <- ps) {
            var duplicate = false
            var duplicateFileName: String = ""
            for (i in 0..attachments.totalCount()) {
                if (attachments[i].uri == fileInfo.uri) {
                    duplicate = true
                    duplicateFileName = getFileName(fileInfo.uri)  // 获取重复文件的文件名
                    break
                }
            }
            if(!duplicate){
                showToast("开始处理: ${getFileName(fileInfo.uri)}")
                let attachInfo = AttachmentInfo(fileInfo, if (isImage) { FileType.Image } else { FileType.Document }, attachments.totalCount())
                attachments.append(attachInfo)
                // 添加到附件列表后，更新状态
                filePicked = true
                // 初始时认为无效，直到解析完成
                filesAreValid = false
            }else {
                showToast("重复文件: ${duplicateFileName}")
                AppLog.warn("[${tag}] duplicate file: ${fileInfo.uri}, skip adding")
            }
        }
        // 处理其他阶段（解析中/完成/失败）
        else {
            // 查找当前附件列表中与fileInfo.uri相同的附件（因为可能顺序变化，但uri唯一）
            for (i in 0..attachments.totalCount()) {
                let item = attachments[i]
                if (item.uri == fileInfo.uri) {
                    item.stage = ps
                    if (let FINISHED <- ps) {
                        if (!fileInfo.ocrResult.isEmpty()) {
                            showToast("处理完成: ${getFileName(fileInfo.uri)}")
                            item.ocrResult = fileInfo.ocrResult
                        }
                    }
                    attachments.update(i, item, notify: true)
                    break
                }
            }
        }
    }
```



## 注意事项

- 确保设备支持OCR功能（需要安装相应的OCR服务）。
- 文件选择功能需要相应的权限，请确保在应用中申请了必要的权限（如相机、存储权限）。



## 总结

本项目展示了仓颉和ArkTS之间如何通过互操作实现功能互补：

- 仓颉负责UI构建和状态管理，提供声明式的UI描述。
- ArkTS负责平台相关的功能（如文件选择、拍照、OCR识别），并通过回调将结果传递给仓颉。

这种混合编程模式充分利用了仓颉的高效UI开发能力和ArkTS的丰富平台API，为复杂应用开发提供了便利。

### *具体操作请观看演示视频*