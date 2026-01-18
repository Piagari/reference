/**
 * Created on 2025/8/26
 */
package ohos_app_cangjie_arkts_interop.base

import ohos.ark_interop.*

open class ArkTSPropertyBase<T> where T <: JSConvertible<T> {
    protected let parentObj: JSObject
    protected let ctx: JSContext
    protected let name: String

    public init(parent: JSObject, ctx: JSContext, name: String) {
        this.parentObj = parent
        this.ctx = ctx
        this.name = name
    }

    protected func getValue(): ?T {
        T.fromJSV(parentObj.tryGetProperty(name))
    }

    protected func setValue(value: ?T) {
        parentObj.setProperty(
            name,
            value.toJSV(ctx)
        )
    }
}

public class ArkTSOptionalReadOnlyProperty<T> <: ArkTSPropertyBase<T> where T <: JSConvertible<T> {
    public init(parent: JSObject, ctx: JSContext, name: String) {
        super(parent, ctx, name)
    }

    public prop value: ?T {
        get() {
            super.getValue()
        }
    }
}

public class ArkTSOptionalReadWriteProperty<T> <: ArkTSPropertyBase<T> where T <: JSConvertible<T> {
    public init(parent: JSObject, ctx: JSContext, name: String) {
        super(parent, ctx, name)
    }

    public mut prop value: ?T {
        get() {
            super.getValue()
        }

        set(value) {
            super.setValue(value)
        }
    }
}

public class ArkTSRequiredReadOnlyProperty<T> <: ArkTSPropertyBase<T> where T <: JSConvertible<T> {
    public init(parent: JSObject, ctx: JSContext, name: String) {
        super(parent, ctx, name)
    }

    public prop value: T {
        get() {
            super.getValue() ?? throw PropertyRequiredException(name)
        }
    }
}

public class ArkTSRequiredReadWriteProperty<T> <: ArkTSPropertyBase<T> where T <: JSConvertible<T> {
    public init(parent: JSObject, ctx: JSContext, name: String) {
        super(parent, ctx, name)
    }

    public mut prop value: T {
        get() {
            super.getValue() ?? throw PropertyRequiredException(name)
        }

        set(value) {
            super.setValue(value)
        }
    }
}
