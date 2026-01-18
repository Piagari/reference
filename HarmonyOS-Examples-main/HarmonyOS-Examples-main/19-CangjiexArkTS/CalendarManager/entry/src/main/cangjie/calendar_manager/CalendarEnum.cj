/**
 * Created on 2025/8/15
 */
package ohos_app_cangjie_entry.calendar_manager

import ohos.ark_interop.*

import ohos_app_cangjie_arkts_interop.base.*

public enum CalendarType <: JSConvertible<CalendarType> {
    LOCAL | EMAIL | BIRTHDAY | CALDAV | SUBSCRIBED

    public func toJSV(ctx: JSContext): JSValue {
        let m: String = match (this) {
            case LOCAL => "local"
            case EMAIL => "email"
            case BIRTHDAY => "birthday"
            case CALDAV => "caldav"
            case SUBSCRIBED => "subscribed"
        }
        m.toJSV(ctx)
    }

    public static func fromJSV(value: ?JSValue): ?CalendarType {
        let m: String = String.fromJSV(value) ?? return None
        match (m) {
            case "local" => LOCAL
            case "email" => EMAIL
            case "birthday" => BIRTHDAY
            case "caldav" => CALDAV
            case "subscribed" => SUBSCRIBED
            case _ => throw InvalidCalendarTypeException(m)
        }
    }
}

public enum EventType <: JSConvertible<EventType> {
    NORMAL | IMPORTANT

    public func toJSV(ctx: JSContext): JSValue {
        let m: Number = match (this) {
            case NORMAL => 0.0
            case IMPORTANT => 1.0
        }
        m.toJSV(ctx)
    }

    public static func fromJSV(value: ?JSValue): ?EventType {
        let m: Number = Number.fromJSV(value) ?? return None
        match (m) {
            case 0.0 => NORMAL
            case 1.0 => IMPORTANT
            case _ => throw InvalidEventTypeException(m)
        }
    }
}

public enum AttendeeRole <: JSConvertible<AttendeeRole> {
    ORGANIZER | PARTICIPANT

    public func toJSV(ctx: JSContext): JSValue {
        let m: String = match (this) {
            case ORGANIZER => 'organizer'
            case PARTICIPANT => 'participant'
        }
        m.toJSV(ctx)
    }

    public static func fromJSV(value: ?JSValue): ?AttendeeRole {
        let m: String = String.fromJSV(value) ?? return None
        match (m) {
            case 'organizer' => ORGANIZER
            case 'participant' => PARTICIPANT
            case _ => throw InvalidAttendeeRoleException(m)
        }
    }
}

public enum RecurrenceFrequency <: JSConvertible<RecurrenceFrequency> {
    YEARLY | MONTHLY | WEEKLY | DAILY

    public func toJSV(ctx: JSContext): JSValue {
        let m: Number = match (this) {
            case YEARLY => 0.0
            case MONTHLY => 1.0
            case WEEKLY => 2.0
            case DAILY => 3.0
        }
        m.toJSV(ctx)
    }

    public static func fromJSV(value: ?JSValue): ?RecurrenceFrequency {
        let m: Number = Number.fromJSV(value) ?? return None
        match (m) {
            case 0.0 => YEARLY
            case 1.0 => MONTHLY
            case 2.0 => WEEKLY
            case 3.0 => DAILY
            case _ => throw InvalidRecurrenceFrequencyException(m)
        }
    }
}

public enum ServiceType <: JSConvertible<ServiceType> {
    MEETING | WATCHING | REPAYMENT | LIVE | SHOPPING | TRIP | CLASS | SPORTS_EVENTS | SPORTS_EXERCISE

    public func toJSV(ctx: JSContext): JSValue {
        let m: String = match (this) {
            case MEETING => 'Meeting'
            case WATCHING => 'Watching'
            case REPAYMENT => 'Repayment'
            case LIVE => 'Live'
            case SHOPPING => 'Shopping'
            case TRIP => 'Trip'
            case CLASS => 'Class'
            case SPORTS_EVENTS => 'SportsEvents'
            case SPORTS_EXERCISE => 'SportsExercise'
        }
        m.toJSV(ctx)
    }

    public static func fromJSV(value: ?JSValue): ?ServiceType {
        let m: String = String.fromJSV(value) ?? return None
        match (m) {
            case 'Meeting' => MEETING
            case 'Watching' => WATCHING
            case 'Repayment' => REPAYMENT
            case 'Live' => LIVE
            case 'Shopping' => SHOPPING
            case 'Trip' => TRIP
            case 'Class' => CLASS
            case 'SportsEvents' => SPORTS_EVENTS
            case 'SportsExercise' => SPORTS_EXERCISE
            case _ => throw InvalidServiceTypeException(m)
        }
    }
}
