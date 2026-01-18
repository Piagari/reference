/**
 * Created on 2025/4/25
 */
package silkui.utils

import ohos.animator.*
import ohos.system_date_time.SystemDateTime
import ohos.component.ExpectedFrameRateRange

public class ValueAnimator {
    private var _animator: ?AnimatorResult = Option.None
    public var easing: String = "ease"
    public var startValue: Float64 = 0.0
    public var endValue: Float64 = 1.0
    public var duration: Int32 = 3000
    private var _loops: Int32 = -1
    public mut prop loops: Int32 {
        get () { _loops }
        set (v) {
            if (v < 0) {
                _loops = -1
            } else {
                _loops = v
            }
        }
    }
    public var fillRule: AnimatorFill = AnimatorFill.Forwards
    public var onStart: () -> Unit = {=>}
    public var onUpdate: (Float64) -> Unit = {currentValue=>}
    public var onEnd: () -> Unit = {=>}

    public func start(currentValue!: ?Int32 = Option.None) {
        if (_animator.isNone()) {
            _animator = AnimatorResult(
                AnimatorOptions(
                    duration: duration,
                    easing: easing,
                    delay: 0,
                    fill: AnimatorFill.Forwards,
                    direction: AnimatorDirection.Normal,
                    iterations: loops,
                    begin: startValue,
                    end: endValue
                    ));
            _animator?.play()
        }

        _animator.getOrThrow().onframe = {
                    value => onUpdate(value)
                }
        _animator.getOrThrow().onfinish = {
                    => onEnd()
        }
    }

    public func stop () {
        _animator?.cancel()
        _animator = Option.None
    }
}