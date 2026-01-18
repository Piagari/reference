/**
 * Created on 2025/8/15
 */
package ohos_app_cangjie_entry.calendar_manager

import ohos_app_cangjie_arkts_interop.base.*

public class InvalidCalendarTypeException <: ArkTSConversionException {
    public init(v: String) {
        super('''
            Invalid CalendarType value.\n
            Expected: 'local' | 'email' | 'birthday' | 'caldav' | 'subscribed'\n
            Found: ${v}''')
    }
}

public class InvalidEventTypeException <: ArkTSConversionException {
    public init(v: Number) {
        super('''
            Invalid EventType value.\n
            Expected: 0.0 | 1.0\n
            Found: ${v}''')
    }
}

public class InvalidAttendeeRoleException <: ArkTSConversionException {
    public init(v: String) {
        super('''
            Invalid AttendeeRole value.\n
            Expected: 'organizer' | 'participant'\n
            Found: ${v}''')
    }
}

public class InvalidRecurrenceFrequencyException <: ArkTSConversionException {
    public init(v: Number) {
        super('''
            Invalid RecurrenceFrequency value.\n
            Expected: 0.0 | 1.0 | 2.0 | 3.0\n
            Found: ${v}''')
    }
}

public class InvalidServiceTypeException <: ArkTSConversionException {
    public init(v: String) {
        super('''
            Invalid ServiceType value.\n
            Expected: 'Meeting' | 'Watching' | 'Repayment' | 'Live' | 'Shopping' | 'Trip' | 'Class' | 'SportsEvents' | 'SportsExercise'\n
            Found: ${v}''')
    }
}
