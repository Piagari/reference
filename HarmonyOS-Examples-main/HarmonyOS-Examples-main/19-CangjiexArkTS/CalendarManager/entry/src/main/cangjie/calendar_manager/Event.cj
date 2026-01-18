/**
 * Created on 2025/8/26
 */
package ohos_app_cangjie_entry.calendar_manager

import std.collection.ArrayList

import ohos.ark_interop.*

import ohos_app_cangjie_arkts_interop.base.*

public class Event <: ArkTSClass & JSConvertible<Event> {
    public let `type`: ArkTSRequiredReadOnlyProperty<EventType>
    public let startTime: ArkTSRequiredReadOnlyProperty<Number>
    public let endTime: ArkTSRequiredReadOnlyProperty<Number>
    public let id: ArkTSOptionalReadWriteProperty<Number>
    public let title: ArkTSOptionalReadWriteProperty<String>
    public let location: ArkTSOptionalReadWriteProperty<Location>
    public let isAllDay: ArkTSOptionalReadWriteProperty<Bool>
    public let attendee: ArkTSOptionalReadWriteProperty<ArrayList<Attendee>>
    public let timeZone: ArkTSOptionalReadWriteProperty<String>
    public let reminderTime: ArkTSOptionalReadWriteProperty<ArrayList<Number>>
    public let recurrenceRule: ArkTSOptionalReadWriteProperty<RecurrenceRule>
    public let description: ArkTSOptionalReadWriteProperty<String>
    public let service: ArkTSOptionalReadWriteProperty<EventService>
    public let identifier: ArkTSOptionalReadWriteProperty<String>
    public let isLunar: ArkTSOptionalReadWriteProperty<Bool>

    public init(jsObj: JSObject) {
        super(jsObj)
        this.`type` = requiredReadOnlyProp("type")
        this.startTime = requiredReadOnlyProp("startTime")
        this.endTime = requiredReadOnlyProp("endTime")
        this.id = optionalProp("id")
        this.title = optionalProp("title")
        this.location = optionalProp("location")
        this.isAllDay = optionalProp("isAllDay")
        this.attendee = optionalProp("attendee")
        this.timeZone = optionalProp("timeZone")
        this.reminderTime = optionalProp("reminderTime")
        this.recurrenceRule = optionalProp("recurrenceRule")
        this.description = optionalProp("description")
        this.service = optionalProp("service")
        this.identifier = optionalProp("identifier")
        this.isLunar = optionalProp("isLunar")
    }

    public init(`type`: EventType, startTime: Number, endTime: Number,
        id!: ?Number = None, title!: ?String = None, location!: ?Location = None,
        isAllDay!: ?Bool = None, attendee!: ?ArrayList<Attendee> = None,
        timeZone!: ?String = None, reminderTime!: ?ArrayList<Number> = None,
        recurrenceRule!: ?RecurrenceRule = None, description!: ?String = None,
        service!: ?EventService = None, identifier!: ?String = None, isLunar!: ?Bool = None) {
        this(createJSObject(("type", `type`), ("startTime", startTime), ("endTime", endTime),
            ("id", id), ("title", title), ("location", location), ("isAllDay", isAllDay),
            ("attendee", attendee), ("timeZone", timeZone), ("reminderTime", reminderTime),
            ("recurrenceRule", recurrenceRule), ("description", description),
            ("service", service), ("identifier", identifier), ("isLunar", isLunar)))
    }

    public static func fromJSV(value: ?JSValue): ?Event {
        fromJSVHelper(value, "Event", { v: JSValue => v.isObject() }) { v: JSValue =>
            Event(v.asObject())
        }
    }
}