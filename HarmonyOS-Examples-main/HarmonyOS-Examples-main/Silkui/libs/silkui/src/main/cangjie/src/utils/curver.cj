/**
 * Created on 2025/4/26
 */
package silkui.utils
import ohos.component.Curve

public class Curves {
    public static func initCurve(curve: Curve): ICurve {
        match (curve) {
        	case Curve.Linear => LinearCurve()
        	case Curve.EaseIn => EaseInCurve()
        	case Curve.EaseOut => EaseOutCurve()
        	case Curve.EaseInOut => EaseInOutCurve()
        	case _ => LinearCurve()
        }
    }
}
public interface ICurve {
    func interpolate(t: Float64): Float64;
}

class LinearCurve <: ICurve {
    public func interpolate(t: Float64): Float64 {
        // 限制t在0到1之间
        if (t <= 0.0) {
            return 0.0
        };
        if (t >= 1.0) {
            return 1.0
            };
        return t;
    }
}

class EaseInCurve <: ICurve {
    public func interpolate(t: Float64): Float64 {
        // 限制t在0到1之间
        if (t <= 0.0) {
            return 0.0
        };
        if (t >= 1.0) {
            return 1.0
            };
        // 三次方缓入
        return t * t * t;
    }
}

class EaseOutCurve <: ICurve {
    public func interpolate(t: Float64): Float64 {
        // 限制t在0到1之间
        if (t <= 0.0) {
            return 0.0
        };
        if (t >= 1.0) {
            return 1.0
            };
        // 三次方缓出
        let f = 1.0 - t;
        return 1.0 - f * f * f;
    }
}

class EaseInOutCurve <: ICurve {
    public func interpolate(t: Float64): Float64 {
        // 限制t在0到1之间
        if (t <= 0.0) {
            return 0.0
        };
        if (t >= 1.0) {
            return 1.0
            };

        // 前半段使用缓入，后半段使用缓出
        if (t < 0.5) {
            // 前半段：缓入 (t^3 * 4)
            return 4.0 * t * t * t;
        } else {
            // 后半段：缓出
            let f = t - 1.0;
            return 1.0 + 4.0 * f * f * f;
        }
    }
}