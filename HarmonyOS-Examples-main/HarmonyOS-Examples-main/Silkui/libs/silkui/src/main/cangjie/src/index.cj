package silkui
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
internal import cj_res_silkui.app
import cj_res_silkui.*

public interface ResourceStr {}

extend String <: ResourceStr {}
extend CJResource <: ResourceStr {}

public interface ResourceColor {}
extend Color <: ResourceColor {}
extend CJResource <: ResourceColor {}

public interface ResourceFloat {}
extend Float64 <: ResourceFloat {}
extend CJResource <: ResourceFloat {}


public struct SilkUIBorderOptions {
    let width: Float64
    let color: ResourceColor
    let style: BorderStyle
    public init (
        width!: Float64 = 1.0,
        color!: ResourceColor = @r(app.color.border_color),
        style!: BorderStyle = BorderStyle.Solid
    ) {
        this.width = width
        this.color = color
        this.style = style
    }
}

public struct SilkUIPaddingOptions {
    let left: Length
    let right: Length
    let top: Length
    let bottom: Length
    public init (v: Length) {
        this.left = v
        this.right = v
        this.top = v
        this.bottom = v
    }

    public init (
        left!: Length = 16.0.vp,
        right!: Length = 16.0.vp,
        top!: Length = 0.0.vp,
        bottom!: Length = 0.0.vp
    ) {
        this.left = left
        this.right = right
        this.top = top
        this.bottom = bottom
    }
}

public struct SilkUILinearGradientOptions {
    public let angle: ?Float64
    public let colors: Array<(Color, Float64)>
    public let direction: GradientDirection
    public let repeating: Bool
    public init (
        angle!: ?Float64 = Option.None,
        colors!: Array<(Color, Float64)> = [(Color.TRANSPARENT, 0.0)],
        direction!: GradientDirection = GradientDirection.Bottom,
        repeating!: Bool = false
    ) {
        this.angle = angle
        this.colors = colors
        this.direction = direction
        this.repeating = repeating
    }
}

public struct SilkUIBorderRadiuses {
    public let topLeft: Length
    public let topRight: Length
    public let bottomLeft: Length
    public let bottomRight: Length
    public init (
        topLeft!: Length = 0.0.vp,
        topRight!: Length = 0.0.vp,
        bottomLeft!: Length = 0.0.vp,
        bottomRight!: Length = 0.0.vp
    ) {
        this.topLeft = topLeft
        this.topRight = topRight
        this.bottomLeft = bottomLeft
        this.bottomRight = bottomRight
    }
}

