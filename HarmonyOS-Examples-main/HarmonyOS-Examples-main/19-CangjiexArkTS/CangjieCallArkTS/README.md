# 在纯仓颉应用中使用ArkTS的API示例

>**made by** 林子淇

本项目是 “HarmonyOS - 仓颉” 的[在仓颉应用中使用ArkTS的API](https://developer.huawei.com/consumer/cn/doc/cangjie-guides-V5/cj-arktsapi-in-cangjie-V5)的示例项目。旨在向开发者简单演示在**纯仓颉应用**中调用 ArkTS 的 [Node-API](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/napi-introduction-V5) 模块。

> ArkTS 模块主要分为 NAPI 模块以及普通 ArkTS 模块，仓颉仅支持对 NAPI 模块的调用。

> 仓颉提供的应用开发API、语言库正在持续完善中，使用仓颉语言的应用开发者如果遇到仓颉暂未提供所需的API，可以调用ArkTS的API完成应用开发。这也就是本示例的应用场景。

本项目选取了 ArkTS 的[日历服务](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/calendarmanager-overview)模块的相关能力，包括**获取日历**、**创建和删除日程**。本项目仅是简单演示了互操作库调用 ArkTS API 的能力；[CalendarManager](https://gitcode.com/Cangjie/HarmonyOS-Examples/tree/main/CalendarManager) 项目对互操作库进行封装以获得更好的开发体验，且演示了对日历服务的完整调用，可以进一步参考。

## 效果预览

<img src="./example.gif" width="30%">

## 实现思路

### 1. 互操作的核心数据桥梁

通过互操作库实现的**所有跨语言的数据传递**，都必须先打包成 `JSValue`。从 ArkTS 函数返回的内容，也都是 `JSValue`（或者 `JSValue` 的数组）。开发者必须**明确 ArkTS 函数的 API 原型**，利用对应的方法去拆箱/装箱。

例如，对于以下 ArkTS 函数：

```arkts
getCalendarManager(context: Context): CalendarManager
```

其返回值是一个 `CalendarManager` 对象，则使用 `JSObject` 进行拆箱：

```cangjie
let callResult: JSValue = module.asObject().callMethod("getCalendarManager", tsContext)
let manager: JSObject = callResult.asObject()
```

又如，对于以下 ArkTS 函数：

```arkts
deleteEvent(id: number): Promise<void>
```

其参数是一个 `number`，对应仓颉中的整型或者浮点型，则使用 `JSContext.number()` 进行装箱：

```cangjie
let eventIdValue: JSValue = ctx.number(Float64(eventId)).toJSValue()
let deletePromise: JSPromise = calendar.callMethod("deleteEvent", eventIdValue).asPromise()
```

同时对它的返回值 `Promise<void>`，由 `asPromise()` 进行转换。

### 2. 互操作的调用流程

本项目中的 `CalendarService.cj` 完整地演示了从加载模块到调用其内部方法的标准流程。

1. 首先需要获取仓颉侧的上下文，在 `MainAbility` 中获取 `AbilityContext`，并传递给服务类存储。

    ```cangjie
    // 在 MainAbility.cj 中
    public override func onCreate(want: Want, launchParam: LaunchParam): Unit {
        // ...
        CalendarService.initialize(context)
    }
    
    // 在 CalendarService.cj 中
    public static func initialize(abilityContext: AbilityContext): Unit {
        abilityCtx = abilityContext
    }
    ```

2. 使用 `JSContext` 的 `requireSystemNativeModule` 方法加载系统模块。ArkTS 模块名 `@ohos.calendarManager` 对应到仓颉的调用参数是 `"calendarManager"`。

    ```cangjie
    let module: JSObject = jsContext.requireSystemNativeModule("calendarManager").asObject()
    ```

3. 获得模块实例之后，就可以通过 `callMethod()` 调用其上的方法。一些方法需要申请权限，首先需要在 `modules.json5` 文件中添加权限：

    ```json
    "requestPermissions": [
        {
            "name": "ohos.permission.READ_CALENDAR",
            "reason": "$string:app_name",
            "usedScene": {
                "when": "always"
            }
        },
        {
            "name": "ohos.permission.WRITE_CALENDAR",
            "reason": "$string:app_name",
            "usedScene": {
                "when": "always"
            }
        }
    ]
    ```
   
    其次在代码中通过 `AtManager.requestPermissionsFromUser` 来向用户申请允许相关权限：

    ```cangjie
    atManager.requestPermissionsFromUser(getStageContext(abiCtx), permissions) {
        err: ?AsyncError, data: ?PermissionRequestResult =>
        if (err.isSome() || data.isNone()) {
            appLog.error("failed to require permissions.")
            launch { onComplete(false) } // 更新状态变量需要使用 launch 提回到主线程执行。
            return
        }
        let result: PermissionRequestResult = data.getOrThrow()
        var allGranted: Bool = true
        for (i in 0..result.permissions.size) {
            let p: String = result.permissions[i]
            let r: Int32 = result.authResults[i]
            if (r == 0) {
                appLog.info("permission ${p} is required.")
            } else {
                appLog.warn("permission ${p} is rejected.")
                allGranted = false
            }
        }
        let res: Bool = allGranted
        launch { onComplete(res) }
    }
    ```
   
    这里需要注意，这个仓颉侧的方法采用异步回调，如果直接在它的回调函数中更新状态变量（如上 `onComplete`），则需要使用 `launch` 来将任务提回到主线程执行。

### 3. 互操作调用 ArkTS 同步与异步函数的区别

- 同步函数，如项目中的 `getCalendarManager`，其结果会直接以 `JSValue` 形式返回，可以将其转换为需要的类型（比如 `JSObject`） 并继续使用。

    ```cangjie
    // 同步调用，直接获得结果
    let callResult: JSValue = module.asObject().callMethod("getCalendarManager", tsContext)
    let manager: JSObject = callResult.asObject()
    ```
  
- 异步函数，如项目中的 `getEvents`，其返回的 `JSValue` 需要转换为 `JSPromise` 对象，然后使用 `.then()` 方法注册成功和失败的回调函数来处理异步结果。

    ```cangjie
    // 在 CalendarService.getEvents() 中
    // getEvents 是异步方法，返回 Promise
    let getEventsPromise: JSPromise = calendar.callMethod("getEvents").asPromise()
    
    getEventsPromise.then(
        // 成功回调 onFulfilled
        ctx.function { innerCtx: JSContext, innerCallinfo: JSCallInfo =>
            // 异步结果在回调函数的参数 callInfo[0] 中
            let jsEvents: JSArray = innerCallinfo[0].asArray()
            let events: ArrayList<EventInfo> = ArrayList<EventInfo>()
            
            // 解析 ArkTS 数组并转换为仓颉对象列表
            for (i in 0..jsEvents.size) {
                let jsEvent: JSObject = jsEvents[i].asObject()
                let id: Int64 = Int64(jsEvent.getProperty("id").asNumber().toFloat64())
                let title: String = jsEvent.getProperty("title").asString().toString()
                let startTime: Int64 = Int64(jsEvent.getProperty("startTime").asNumber().toFloat64())
                events.append(EventInfo(id, title, startTime))
            }
            onResult(events) // 将最终结果通过仓颉的回调传递出去
            innerCtx.undefined().toJSValue()
        },
        // 失败回调 onRejected
        onRejected: ctx.function { innerCtx: JSContext, _: JSCallInfo =>
            appLog.error("failed to get events!")
            onResult(ArrayList<EventInfo>())
            innerCtx.undefined().toJSValue()
        }
    )
    ```
  
### 4. JSRuntime 的生命周期管理

`JSRuntime` 实例代表一个 ArkTS 运行时环境，如果不保存为静态变量，在遇到 GC 时有可能会被回收，导致互操作调用异常。因此，建议将 `JSRuntime` 保存为一个静态变量。

```cangjie
// 在 CalendarService.cj 中
public class CalendarService {
    private static var abilityCtx: ?AbilityContext = None
    // 将 runtime 定义为静态变量，确保其生命周期与应用进程绑定
    private static var runtime: JSRuntime = JSRuntime()
}
```

通过这种方式，`runtime` 实例将一直存在，为所有日历服务相关的互操作提供稳定可靠的 ArkTS 运行环境。

## 工程目录

```
├── entry/src/main/cangjie            // 仓颉源代码
│   ├── MainAbility.cj                // 应用主 Ability，负责窗口创建、初始化服务和加载主页
│   ├── MyAbilityStage.cj             // 应用 AbilityStage
│   ├── services                      // 服务层
│   │   └── CalendarService.cj        // 核心服务，封装与 ArkTS 日历模块的互操作逻辑（权限申请、增删查）
│   ├── utils                         // 工具类
│   │   └── AppLog.cj                 // 日志工具
│   └── views                         // UI 视图组件
│       ├── EntryView.cj              // 应用主页入口 (@Entry)，管理UI状态、布局和用户交互
│       ├── EventListItem.cj          // 单个日程列表项的UI组件，负责展示日程信息和删除操作
│       └── CommonStyles.cj           // 通用UI组件的样式扩展，用于统一界面风格
```