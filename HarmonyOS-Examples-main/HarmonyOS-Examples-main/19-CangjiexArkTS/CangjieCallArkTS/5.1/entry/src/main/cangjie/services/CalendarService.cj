/**
 * Created on 2025/8/26
 */
package ohos_app_cangjie_entry.services

import std.time.DateTime
import std.collection.ArrayList

import ohos.ark_interop.*
import ohos.base.AsyncError
import ohos.concurrency.launch
import ohos.ability_access_ctrl.*
import ohos.ability.AbilityContext
import ohos.ability.getStageContext
import ohos.ark_interop_helper.getJSContext

import ohos_app_cangjie_entry.utils.appLog

public class EventInfo <: Hashable & Equatable<EventInfo> {
    public let id: Int64
    public let title: String
    public let startTime: Int64

    public init(id: Int64, title: String, startTime: Int64) {
        this.id = id
        this.title = title
        this.startTime = startTime
    }

    // 实现Hashable和Equatable接口，以便在ForEach等组件中使用
    public func hashCode(): Int64 {
        this.id
    }

    public operator func ==(that: EventInfo): Bool {
        this.id == that.id
    }

    public operator func !=(that: EventInfo): Bool {
        this.id != that.id
    }
}

public class CalendarService {
    private static var abilityCtx: ?AbilityContext = None
    private static var runtime: JSRuntime = JSRuntime()

    /**
     * 初始化服务，获取并保存 AbilityContext
     */
    public static func initialize(abilityContext: AbilityContext): Unit {
        abilityCtx = abilityContext
    }

    /**
     * 申请日历读写权限
     * 以下设置必须被添加到 "module"@module.json5
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
     */
    public static func requestPermissions(onComplete: (Bool) -> Unit): Unit {
        let abiCtx: AbilityContext = abilityCtx ?? throw Exception("failed to fetch AbilityContext, run initialize() first.")

        let permissions: Array<String> = [
            "ohos.permission.READ_CALENDAR",
            "ohos.permission.WRITE_CALENDAR"
        ]

        let atManager: AtManager = AbilityAccessCtrl.createAtManager()

        atManager.requestPermissionsFromUser(getStageContext(abiCtx), permissions) {
            err: ?AsyncError, data: ?PermissionRequestResult =>
            if (err.isSome() || data.isNone()) {
                appLog.error("failed to require permissions.")
                launch { onComplete(false) }
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
    }

    public static func addEvent(title: String, description: String, onComplete: (Int64) -> Unit): Unit {
        appLog.info("try to add an event: ${title}")
        let callback = { ctx: JSContext, calendar: JSObject =>
            // 调用 ArkTS 类成员方法 Calendar.addEvent 来在日历中添加事件。
            // 根据 Event 的 API 文档，创建一个事件对象，作为传入的参数。
            let eventObj = createEventObject(title, description, ctx)
            // 该方法是异步方法，需要异步回调。
            let promise = calendar.callMethod("addEvent", eventObj.toJSValue()).asPromise()
            promise.then(
                // onFulfilled
                ctx.function { innerCtx: JSContext, innerCallInfo: JSCallInfo =>
                    // 从 JSCallInfo 中获取方法返回的事件 ID，是整型的。
                    let eventId = Int64(innerCallInfo[0].asNumber().toFloat64())
                    appLog.info("successfully added an event. event id: ${eventId}")
                    onComplete(eventId)
                    innerCtx.undefined().toJSValue()
                },
                // onRejected
                onRejected: ctx.function { innerCtx: JSContext, _: JSCallInfo =>
                    appLog.error("failed to add an event!")
                    onComplete(-1)
                    innerCtx.undefined().toJSValue()
                }
            )
        }
        withCalendar(onSuccess: callback, onFailure: { => onComplete(-1) })
    }

    public static func getEvents(onResult: (ArrayList<EventInfo>) -> Unit): Unit {
        appLog.info("try to get events...")
        let callback = { ctx: JSContext, calendar: JSObject =>
            let promise: JSPromise = calendar.callMethod("getEvents").asPromise()
            promise.then(
                ctx.function { innerCtx: JSContext, innerCallinfo: JSCallInfo =>
                    let jsEvents: JSArray = innerCallinfo[0].asArray()
                    let events: ArrayList<EventInfo> = ArrayList<EventInfo>()

                    for (i in 0..jsEvents.size) {
                        let jsEvent: JSObject = jsEvents[i].asObject()
                        let id: Int64 = Int64(jsEvent.getProperty("id").asNumber().toFloat64())
                        let title: String = jsEvent.getProperty("title").asString().toString()
                        let startTime: Int64 = Int64(jsEvent.getProperty("startTime").asNumber().toFloat64())
                        events.add(EventInfo(id, title, startTime))
                    }
                    appLog.info("successfully got ${events.size} events.")
                    onResult(events)
                    innerCtx.undefined().toJSValue()
                },
                onRejected: ctx.function { innerCtx: JSContext, _: JSCallInfo =>
                    appLog.error("failed to get events!")
                    onResult(ArrayList<EventInfo>())
                    innerCtx.undefined().toJSValue()
                }
            )
        }
        withCalendar(onSuccess: callback, onFailure: { => onResult(ArrayList<EventInfo>()) })
    }

    public static func deleteEvent(eventId: Int64, onComplete: (Bool) -> Unit): Unit {
        appLog.info("try to delete event: ${eventId}")
        let callback = { ctx: JSContext, calendar: JSObject =>
            let eventIdValue: JSValue = ctx.number(Float64(eventId)).toJSValue()
            let promise: JSPromise = calendar.callMethod("deleteEvent", eventIdValue).asPromise()
            promise.then(
                ctx.function { innerCtx: JSContext, _: JSCallInfo =>
                    appLog.info("successfully deleted event id: ${eventId}")
                    onComplete(true)
                    innerCtx.undefined().toJSValue()
                },
                onRejected: ctx.function { innerCtx: JSContext, _: JSCallInfo =>
                    appLog.error("failed to delete event id: ${eventId}")
                    onComplete(false)
                    innerCtx.undefined().toJSValue()
                }
            )
        }
        withCalendar(onSuccess: callback, onFailure: { => onComplete(false) })
    }

    private static func withCalendar(onSuccess!: (JSContext, JSObject) -> Unit, onFailure!: () -> Unit): Unit {
        let localAbilityCtx = abilityCtx ?? throw Exception("AbilityContext is not initialized!")

        let jsContext: JSContext = runtime.mainContext // 互操作上下文

        // 加载 calendarManager 模块
        let module: JSValue = jsContext.requireSystemNativeModule("calendarManager")
        if (module.isUndefined()) {
            appLog.error("load module 'calendarManager' failed!")
            onFailure()
            return
        }

        // 调用 JS 同步接口 getCalendarManager 获取 CalendarManager 对象
        let tsContext: JSValue = getJSContext(runtime, localAbilityCtx) // 应用上下文
        let callResult: JSValue = module.asObject().callMethod("getCalendarManager", tsContext)
        if (callResult.isUndefined()) {
            appLog.error("getCalendarManager failed!")
            onFailure()
            return
        }
        let manager: JSObject = callResult.asObject()

        // 调用 JS 异步接口 getCalendar，得到 JS Promise 对象，最终在 then 回调中获取 Calendar 对象
        let calendarPromise: JSPromise = manager.callMethod("getCalendar").asPromise()
        calendarPromise.then(
            // onFulfilled
            jsContext.function { ctx, callInfo =>
                let calendar: JSObject = callInfo[0].asObject()
                onSuccess(ctx, calendar)
                ctx.undefined().toJSValue()
            },
            // onRejected
            onRejected: jsContext.function { ctx, _ =>
                appLog.error("failed to get calendar!")
                onFailure()
                ctx.undefined().toJSValue()
            }
        )
    }

    private static func createEventObject(title: String, description: String, ctx: JSContext): JSObject {
        let eventObj: JSObject = ctx.object()

        let curTimeStamp: Int64 = DateTime.now().toUnixTimeStamp().toMilliseconds()
        let oneHour: Int64 = 3600 * 1000

        eventObj.setProperty("title", ctx.string(title).toJSValue())
        eventObj.setProperty("description", ctx.string(description).toJSValue())
        eventObj.setProperty("type", ctx.number(0.0).toJSValue()) // 0 代表 EventType.NORMAL
        eventObj.setProperty("startTime", ctx.number(Float64(curTimeStamp)).toJSValue())
        eventObj.setProperty("endTime", ctx.number(Float64(curTimeStamp + oneHour)).toJSValue())

        eventObj
    }
}