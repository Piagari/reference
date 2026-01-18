# HarmonyOS Cangjie API 命名空间映射关系详解

> 本文档详细说明 HarmonyOS 官方文档中的 API 名称与 Cangjie 语言实际导入路径之间的映射关系，这是开发中最容易出错的地方。

## 📋 目录

- [核心问题](#核心问题)
- [命名空间系统架构](#命名空间系统架构)
- [完整映射表](#完整映射表)
- [常见错误案例](#常见错误案例)
- [快速判断规则](#快速判断规则)
- [最佳实践](#最佳实践)

---

## 核心问题

### 问题描述

**HarmonyOS 官方文档**使用 `ohos.xxx` 命名，但 **Cangjie 语言**的导入路径根据库类型不同而不同。这导致：

1. 开发者看到文档写 `ohos.data.preferences`，直接导入 `import ohos.data.preferences.*` → **编译错误**
2. AI Agent 根据文档生成代码，使用错误的导入路径 → **编译失败**
3. 错误信息 `can not find the following dependencies: ohos.data.preferences` → **不知道如何修复**

### 根本原因

**文档命名 vs 实现命名不一致**：

- **文档标题**: `# ohos.data.preferences`（HarmonyOS 官方 API 名称）
- **Cangjie 导入**: `import kit.ArkData.*`（实际实现命名空间）
- **错误尝试**: `import ohos.data.preferences.Preferences` → **ERROR**

---

## 命名空间系统架构

HarmonyOS Cangjie 有**三个命名空间类别**：

### 1. `ohos.*` - 基础系统库（Base System Libraries）

**特点**：
- 核心框架组件
- 文档名称与导入路径**完全一致**
- 直接使用 `import ohos.xxx.*`

**示例**：
```cangjie
import ohos.base.*              // 基础类型（CJResource, Int64, Float64 等）
import ohos.component.*         // UI 组件（Column, Row, Text, Image 等）
import ohos.router.*            // 路由（Router.push, Router.back 等）
import ohos.ability.*           // Ability 生命周期
import ohos.state_manage.*      // 状态管理（AppStorage, LocalStorage）
import ohos.state_macro_manage.* // 状态宏（@State, @Component, @Entry）
import ohos.prompt_action.*     // 提示操作（PromptAction.showToast）
```

**判断规则**：如果文档显示 `ohos.component.*`、`ohos.base.*`、`ohos.router.*` → **直接使用 `ohos.*` 命名空间**

---

### 2. `kit.*` - Kit 库（Extended Capabilities）

**特点**：
- 扩展功能库
- 文档可能显示 `ohos.xxx`，但实际导入使用 `kit.*`
- **系统提供，无需添加到 cjpm.toml**

**示例**：
```cangjie
import kit.ArkData.*            // 数据持久化（Preferences, DistributedKVStore）
import kit.AbilityKit.*         // Ability 上下文和生命周期
import kit.ArkUI.*              // UI 回调和工具
import kit.ArkWeb.*             // WebView 相关
import kit.ImageKit.*           // 图像处理
import kit.MediaLibrary.*       // 媒体库
import kit.CoreFileKit.*        // 文件系统
```

**判断规则**：如果文档显示 `ohos.data.*`、`ohos.app.*`、`ohos.web.*`、`ohos.multimedia.*`、`ohos.file.*` → **检查是否为 Kit 库 → 使用 `kit.*` 命名空间**

---

### 3. `std.*` - 标准库（Standard Library）

**特点**：
- Cangjie 语言标准库
- 与 HarmonyOS 无关
- 文档和导入路径一致

**示例**：
```cangjie
import std.collection.*         // 集合（ArrayList, HashMap）
import std.string.*             // 字符串操作
import std.convert.*            // 类型转换
import std.math.*               // 数学函数
import std.io.*                 // 输入输出
import std.time.*               // 时间处理
```

**判断规则**：标准库始终使用 `std.*` 命名空间

---

## 完整映射表

### 数据持久化相关

| HarmonyOS 文档名称 | Cangjie 导入路径 | 主要类/函数 | 命名空间类型 |
|-------------------|-----------------|------------|------------|
| `ohos.data.preferences` | `kit.ArkData.*` | `Preferences`, `PreferencesValueType`, `PreferencesOptions` | Kit library |
| `ohos.data.distributed_kv_store` | `kit.ArkData.*` | `DistributedKVStore`, `KVManager` | Kit library |
| `ohos.data.relational_store` | `kit.ArkData.*` | `RdbStore`, `RdbPredicates` | Kit library |

**使用示例**：
```cangjie
// ❌ 错误：使用文档中的命名
import ohos.data.preferences.Preferences

// ✅ 正确：使用 kit.ArkData
import kit.ArkData.{ Preferences, PreferencesValueType, PreferencesOptions }
import kit.AbilityKit.getStageContext

// 使用示例
let options = PreferencesOptions("myStore")
let context = getStageContext(this.context)
let prefs = Preferences.getPreferences(context, options)
prefs.put("key", "value")
prefs.flush()
```

---

### Ability 相关

| HarmonyOS 文档名称 | Cangjie 导入路径 | 主要类/函数 | 命名空间类型 |
|-------------------|-----------------|------------|------------|
| `ohos.ability` | `ohos.ability.*` | `Ability`, `AbilityStage`, `WindowStage` | Base system |
| `ohos.app.ability` | `kit.AbilityKit.*` | `getStageContext`, `getContext` | Kit library |

**使用示例**：
```cangjie
// ✅ 基础 Ability 生命周期（Base system）
import ohos.ability.{ Ability, AbilityStage, WindowStage }

// ✅ Ability 上下文获取（Kit library）
import kit.AbilityKit.getStageContext

class MainAbility <: Ability {
    public override func onWindowStageCreate(windowStage: WindowStage): Unit {
        // 使用 Base system
        windowStage.loadContent("MainPage")
    }
    
    func getContext() {
        // 使用 Kit library
        let context = getStageContext(this.context)
    }
}
```

---

### UI 组件相关

| HarmonyOS 文档名称 | Cangjie 导入路径 | 主要类/函数 | 命名空间类型 |
|-------------------|-----------------|------------|------------|
| `ohos.component` | `ohos.component.*` | `Column`, `Row`, `Text`, `Image`, `Button` | Base system |
| `ohos.state_manage` | `ohos.state_manage.*` | `AppStorage`, `LocalStorage` | Base system |
| `ohos.state_macro_manage` | `ohos.state_macro_manage.*` | `@State`, `@Component`, `@Entry`, `@Prop` | Base system |
| `ohos.state_macro_manage.r` | `ohos.state_macro_manage.r` | `@r()` 资源宏 | Base system |

**使用示例**：
```cangjie
// ✅ UI 组件（Base system）
import ohos.component.*

// ✅ 状态管理（Base system）
import ohos.state_manage.*

// ✅ 状态宏（Base system）
import ohos.state_macro_manage.*
import ohos.state_macro_manage.r  // 资源宏需要单独导入

// ✅ 资源模块（Base system）
import cj_res_entry.app

@Component
public class MyPage {
    @State var count: Int64 = 0
    
    func build() {
        Column {
            Text("Count: ${this.count}")
            Button("增加")
                .onClick({ => this.count++ })
            Image(@r(app.media.icon))
        }
    }
}
```

---

### WebView 相关

| HarmonyOS 文档名称 | Cangjie 导入路径 | 主要类/函数 | 命名空间类型 |
|-------------------|-----------------|------------|------------|
| `ohos.web.webview` | `kit.ArkWeb.*` | `WebView`, `WebController` | Kit library |

**使用示例**：
```cangjie
// ❌ 错误：使用文档中的命名
import ohos.web.webview.WebView

// ✅ 正确：使用 kit.ArkWeb
import kit.ArkWeb.{ WebView, WebController }

@Component
public class WebPage {
    private let webController = WebController()
    
    func build() {
        WebView(this.webController)
            .javaScriptAccess(true)
            .onPageBegin({ url: String => 
                print("Page loading: ${url}")
            })
    }
}
```

---

### 多媒体相关

| HarmonyOS 文档名称 | Cangjie 导入路径 | 主要类/函数 | 命名空间类型 |
|-------------------|-----------------|------------|------------|
| `ohos.multimedia.image` | `kit.ImageKit.*` | `PixelMap`, `ImageSource` | Kit library |
| `ohos.multimedia.media` | `kit.MediaLibrary.*` | `MediaLibrary`, `MediaAsset` | Kit library |
| `ohos.multimedia.camera` | `kit.CameraKit.*` | `Camera`, `CaptureSession` | Kit library |

**使用示例**：
```cangjie
// ✅ 图像处理（Kit library）
import kit.ImageKit.{ PixelMap, ImageSource }

// ✅ 媒体库（Kit library）
import kit.MediaLibrary.{ MediaLibrary, MediaAsset }

// ✅ 相机（Kit library）
import kit.CameraKit.{ Camera, CaptureSession }
```

---

### 文件系统相关

| HarmonyOS 文档名称 | Cangjie 导入路径 | 主要类/函数 | 命名空间类型 |
|-------------------|-----------------|------------|------------|
| `ohos.file.fs` | `kit.CoreFileKit.*` | `File`, `Directory`, `Path` | Kit library |

**使用示例**：
```cangjie
// ❌ 错误：使用文档中的命名
import ohos.file.fs.File

// ✅ 正确：使用 kit.CoreFileKit
import kit.CoreFileKit.{ File, Directory, Path }

let file = File("/data/storage/el2/base/files/test.txt")
if (file.exists()) {
    let content = file.readText()
    print(content)
}
```

---

### 网络相关

| HarmonyOS 文档名称 | Cangjie 导入路径 | 主要类/函数 | 命名空间类型 |
|-------------------|-----------------|------------|------------|
| `ohos.net.http` | `kit.NetworkKit.*` | `HttpRequest`, `HttpResponse` | Kit library |
| `ohos.net.socket` | `kit.NetworkKit.*` | `TCPSocket`, `UDPSocket` | Kit library |

**使用示例**：
```cangjie
// ✅ 网络请求（Kit library）
import kit.NetworkKit.{ HttpRequest, HttpResponse }

let request = HttpRequest("https://api.example.com/data")
let response = request.send()
match (response) {
    case Some(resp) => print("Response: ${resp.body}")
    case None => print("Request failed")
}
```

---

### 定位服务相关

| HarmonyOS 文档名称 | Cangjie 导入路径 | 主要类/函数 | 命名空间类型 |
|-------------------|-----------------|------------|------------|
| `ohos.location` | `kit.LocationKit.*` | `Location`, `Geocoder` | Kit library |

**使用示例**：
```cangjie
// ✅ 定位服务（Kit library）
import kit.LocationKit.{ Location, Geocoder }

let location = Location.getInstance()
location.getCurrentLocation({ loc =>
    print("Latitude: ${loc.latitude}, Longitude: ${loc.longitude}")
})
```

---

### 传感器相关

| HarmonyOS 文档名称 | Cangjie 导入路径 | 主要类/函数 | 命名空间类型 |
|-------------------|-----------------|------------|------------|
| `ohos.sensor` | `kit.SensorKit.*` | `Sensor`, `SensorManager` | Kit library |

**使用示例**：
```cangjie
// ✅ 传感器（Kit library）
import kit.SensorKit.{ Sensor, SensorManager }

let sensorManager = SensorManager.getInstance()
let accelerometer = sensorManager.getSensor(SensorType.ACCELEROMETER)
accelerometer.onChange({ data =>
    print("X: ${data.x}, Y: ${data.y}, Z: ${data.z}")
})
```

---

## 常见错误案例

### 错误案例 1: Preferences 导入错误

**错误代码**：
```cangjie
// ❌ 错误：直接使用文档中的命名
import ohos.data.preferences.Preferences

// 或者在 cjpm.toml 中添加
[dependencies.preferences]
name = "ohos.data.preferences"  // ❌ 错误
```

**错误信息**：
```
Error: can not find the following dependencies: ohos.data.preferences
```

**正确修复**：
```cangjie
// ✅ 正确：使用 kit.ArkData
import kit.ArkData.{ Preferences, PreferencesValueType, PreferencesOptions }
import kit.AbilityKit.getStageContext

// ✅ 正确：Kit 库是系统提供的，不需要添加到 cjpm.toml
// 直接使用即可
```

---

### 错误案例 2: WebView 导入错误

**错误代码**：
```cangjie
// ❌ 错误：使用文档中的命名
import ohos.web.webview.WebView
```

**错误信息**：
```
Error: can not find package 'ohos.web.webview'
```

**正确修复**：
```cangjie
// ✅ 正确：使用 kit.ArkWeb
import kit.ArkWeb.{ WebView, WebController }
```

---

### 错误案例 3: 文件操作导入错误

**错误代码**：
```cangjie
// ❌ 错误：使用文档中的命名
import ohos.file.fs.File
```

**错误信息**：
```
Error: can not find package 'ohos.file.fs'
```

**正确修复**：
```cangjie
// ✅ 正确：使用 kit.CoreFileKit
import kit.CoreFileKit.{ File, Directory, Path }
```

---

### 错误案例 4: 图像处理导入错误

**错误代码**：
```cangjie
// ❌ 错误：使用文档中的命名
import ohos.multimedia.image.PixelMap
```

**错误信息**：
```
Error: can not find package 'ohos.multimedia.image'
```

**正确修复**：
```cangjie
// ✅ 正确：使用 kit.ImageKit
import kit.ImageKit.{ PixelMap, ImageSource }
```

---

## 快速判断规则

### 规则 1: 文档命名模式判断

| 文档命名模式 | 命名空间类型 | 导入路径 |
|------------|------------|---------|
| `ohos.component.*` | Base system | `import ohos.component.*` |
| `ohos.base.*` | Base system | `import ohos.base.*` |
| `ohos.router.*` | Base system | `import ohos.router.*` |
| `ohos.ability.*` | Base system | `import ohos.ability.*` |
| `ohos.state_manage.*` | Base system | `import ohos.state_manage.*` |
| `ohos.data.*` | **Kit library** | `import kit.ArkData.*` |
| `ohos.app.*` | **Kit library** | `import kit.AbilityKit.*` |
| `ohos.web.*` | **Kit library** | `import kit.ArkWeb.*` |
| `ohos.multimedia.*` | **Kit library** | `import kit.ImageKit.*` 或 `kit.MediaLibrary.*` |
| `ohos.file.*` | **Kit library** | `import kit.CoreFileKit.*` |
| `ohos.net.*` | **Kit library** | `import kit.NetworkKit.*` |
| `ohos.location.*` | **Kit library** | `import kit.LocationKit.*` |
| `ohos.sensor.*` | **Kit library** | `import kit.SensorKit.*` |

---

### 规则 2: 错误信息判断

**如果看到以下错误信息**：
```
Error: can not find the following dependencies: ohos.xxx
Error: can not find package 'ohos.xxx'
```

**检查步骤**：
1. 查看错误中的 `ohos.xxx` 是什么
2. 如果 `xxx` 是 `data.*`、`app.*`、`web.*`、`multimedia.*`、`file.*` → **很可能是 Kit 库**
3. 查找映射表，找到对应的 `kit.*` 命名空间
4. 替换导入语句

---

### 规则 3: cjpm.toml 判断

**Kit 库的特点**：
- ✅ **系统提供**，无需添加到 `cjpm.toml`
- ✅ 直接 `import kit.xxx.*` 即可使用
- ❌ **不要**在 `cjpm.toml` 中添加 Kit 库依赖

**Base system 库的特点**：
- ✅ 系统提供，无需添加到 `cjpm.toml`
- ✅ 直接 `import ohos.xxx.*` 即可使用

**第三方库的特点**：
- ✅ 需要添加到 `cjpm.toml`
- ✅ 使用 `cjpm add <package-name>` 添加

---

## 最佳实践

### 实践 1: 导入语句模板

**页面组件标准导入**：
```cangjie
// Base system（基础系统库）
import ohos.base.*                    // 基础类型
import ohos.component.*               // UI 组件
import ohos.router.*                  // 路由
import ohos.state_manage.*            // 状态管理
import ohos.state_macro_manage.*      // 状态宏
import ohos.state_macro_manage.r      // 资源宏
import cj_res_entry.app               // 应用资源

// Kit library（扩展功能库，按需导入）
import kit.ArkData.*                  // 数据持久化（如果需要）
import kit.AbilityKit.*               // Ability 上下文（如果需要）
import kit.ArkWeb.*                   // WebView（如果需要）
import kit.ImageKit.*                 // 图像处理（如果需要）

// Standard library（标准库，按需导入）
import std.collection.*               // 集合（如果需要）
import std.string.*                   // 字符串（如果需要）
```

---

### 实践 2: 错误修复流程

**遇到导入错误时的修复流程**：

1. **识别错误类型**
   ```
   Error: can not find the following dependencies: ohos.data.preferences
   ```

2. **查找映射表**
   - `ohos.data.preferences` → `kit.ArkData.*`

3. **替换导入语句**
   ```cangjie
   // 删除错误的导入
   // import ohos.data.preferences.Preferences
   
   // 添加正确的导入
   import kit.ArkData.{ Preferences, PreferencesValueType, PreferencesOptions }
   import kit.AbilityKit.getStageContext
   ```

4. **检查 cjpm.toml**
   - 如果添加了错误的依赖，删除它
   - Kit 库不需要在 `cjpm.toml` 中声明

5. **重新编译验证**
   ```bash
   cjpm build
   ```

---

### 实践 3: 文档查阅技巧

**在 HarmonyOS 官方文档中查找导入信息**：

1. **查找 "导入模块" 章节**
   - 文档通常会说明如何导入模块
   - 注意区分 Cangjie 和 ArkTS 的导入方式

2. **查找 API 参考**
   - API 参考文档会说明完整的导入路径
   - 注意命名空间前缀

3. **查找示例代码**
   - 示例代码中的导入语句是最准确的
   - 注意示例代码使用的语言（Cangjie vs ArkTS）

---

### 实践 4: 常见 Kit 库速查

**数据持久化**：
```cangjie
import kit.ArkData.*  // Preferences, DistributedKVStore, RdbStore
```

**Ability 上下文**：
```cangjie
import kit.AbilityKit.*  // getStageContext, getContext
```

**WebView**：
```cangjie
import kit.ArkWeb.*  // WebView, WebController
```

**图像处理**：
```cangjie
import kit.ImageKit.*  // PixelMap, ImageSource
```

**媒体库**：
```cangjie
import kit.MediaLibrary.*  // MediaLibrary, MediaAsset
```

**文件系统**：
```cangjie
import kit.CoreFileKit.*  // File, Directory, Path
```

**网络请求**：
```cangjie
import kit.NetworkKit.*  // HttpRequest, HttpResponse, TCPSocket
```

**定位服务**：
```cangjie
import kit.LocationKit.*  // Location, Geocoder
```

**传感器**：
```cangjie
import kit.SensorKit.*  // Sensor, SensorManager
```

---

## 总结

### 核心要点

1. **三个命名空间**：
   - `ohos.*` - 基础系统库（文档名称 = 导入路径）
   - `kit.*` - Kit 库（文档名称 ≠ 导入路径）
   - `std.*` - 标准库（文档名称 = 导入路径）

2. **常见错误**：
   - 看到文档写 `ohos.data.preferences` → 直接导入 `import ohos.data.preferences.*` → **错误**
   - 正确做法：查找映射表 → 使用 `import kit.ArkData.*`

3. **Kit 库特点**：
   - 系统提供，无需添加到 `cjpm.toml`
   - 文档命名与导入路径不一致
   - 使用 `kit.*` 命名空间

4. **快速判断**：
   - `ohos.data.*`、`ohos.app.*`、`ohos.web.*` → 很可能是 Kit 库
   - `ohos.component.*`、`ohos.base.*`、`ohos.router.*` → Base system 库

---

**文档版本**: 1.0  
**最后更新**: 2026-01-18  
**维护者**: AI Assistant
