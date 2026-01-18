/**
 * Created on 2025/8/26
 */
package ohos_app_cangjie_entry.calendar_manager

import std.collection.ArrayList

import ohos.ark_interop.*

import ohos_app_cangjie_arkts_interop.base.*

public class RecurrenceRule <: ArkTSClass & JSConvertible<RecurrenceRule> {
    public let recurrenceFrequency: ArkTSRequiredReadWriteProperty<RecurrenceFrequency>
    public let expire: ArkTSOptionalReadWriteProperty<Number>
    public let count: ArkTSOptionalReadWriteProperty<Number>
    public let interval: ArkTSOptionalReadWriteProperty<Number>
    public let excludedDates: ArkTSOptionalReadWriteProperty<ArrayList<Number>>
    public let daysOfWeek: ArkTSOptionalReadWriteProperty<ArrayList<Number>>
    public let daysOfMonth: ArkTSOptionalReadWriteProperty<ArrayList<Number>>
    public let daysOfYear: ArkTSOptionalReadWriteProperty<ArrayList<Number>>
    public let weeksOfMonth: ArkTSOptionalReadWriteProperty<ArrayList<Number>>
    public let weeksOfYear: ArkTSOptionalReadWriteProperty<ArrayList<Number>>
    public let monthsOfYear: ArkTSOptionalReadWriteProperty<ArrayList<Number>>

    public init(jsObj: JSObject) {
        super(jsObj)
        this.recurrenceFrequency = requiredProp("recurrenceFrequency")
        this.expire = optionalProp("expire")
        this.count = optionalProp("count")
        this.interval = optionalProp("interval")
        this.excludedDates = optionalProp("excludedDates")
        this.daysOfWeek = optionalProp("daysOfWeek")
        this.daysOfMonth = optionalProp("daysOfMonth")
        this.daysOfYear = optionalProp("daysOfYear")
        this.weeksOfMonth = optionalProp("weeksOfMonth")
        this.weeksOfYear = optionalProp("weeksOfYear")
        this.monthsOfYear = optionalProp("monthsOfYear")
    }

    public init(recurrenceFrequency: RecurrenceFrequency,
        expire!: ?Number = None, count!: ?Number = None, interval!: ?Number = None,
        excludedDates!: ?ArrayList<Number> = None, daysOfWeek!: ?ArrayList<Number> = None,
        daysOfMonth!: ?ArrayList<Number> = None, daysOfYear!: ?ArrayList<Number> = None,
        weeksOfMonth!: ?ArrayList<Number> = None, weeksOfYear!: ?ArrayList<Number> = None,
        monthsOfYear!: ?ArrayList<Number> = None) {
        this(createJSObject(("recurrenceFrequency", recurrenceFrequency), ("expire", expire),
            ("count", count), ("interval", interval), ("excludedDates", excludedDates),
            ("daysOfWeek", daysOfWeek), ("daysOfMonth", daysOfMonth), ("daysOfYear", daysOfYear),
            ("weeksOfMonth", weeksOfMonth), ("weeksOfYear", weeksOfYear), ("monthsOfYear", monthsOfYear)))
    }

    public static func fromJSV(value: ?JSValue): ?RecurrenceRule {
        fromJSVHelper(value, "RecurrenceRule", { v: JSValue => v.isObject() }) { v: JSValue =>
            RecurrenceRule(v.asObject())
        }
    }
}