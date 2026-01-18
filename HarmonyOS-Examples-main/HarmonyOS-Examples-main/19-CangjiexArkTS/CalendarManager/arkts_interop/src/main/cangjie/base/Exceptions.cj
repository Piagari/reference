/**
 * Created on 2025/8/26
 */
package ohos_app_cangjie_arkts_interop.base

public open class InteropException <: Exception {
    public init(mess: String) {
        super(mess)
    }
}

public class UnInitializedException <: InteropException {
    public init(mess: String) {
        super(mess + if (mess.isEmpty()) { "" } else { "\n" } + '''
            Did you initialize the InteropFramework?\n
            Note: call InteropFramework.initialize(AbilityContext) in onCreate@MainAbility.''')
    }
}

public class MethodResultRequiredException <: InteropException {
    public init(name: String) {
        super("Required result from ArkTS method '${name}' is missing or null.")
    }
}

public class PropertyRequiredException <: InteropException {
    public init(name: String) {
        super("Required ArkTS property '${name}' is missing or null.")
    }
}

public class ArkTSCallException <: InteropException {
    public let methodName: String
    public let jsError: String

    public init(methodName: String, jsError: String, customMessage!: ?String = None) {
        super(customMessage ?? "ArkTS method '${methodName}' failed. Original error: ${jsError}")
        this.methodName = methodName
        this.jsError = jsError
    }
}

public open class ArkTSConversionException <: InteropException {
    public init(mess: String) {
        super(mess)
    }
}

