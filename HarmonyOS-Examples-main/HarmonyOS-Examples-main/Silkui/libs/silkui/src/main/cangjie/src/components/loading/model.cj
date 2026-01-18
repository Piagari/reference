/**
 * Created on 2025/4/25
 *
 * SilkLoading 加载组件
 *
 * 加载组件用于展示加载状态，提示用户等待，支持多种样式。
 *
 * @module silkui/components/loading
 */
package silkui.components.loading
import silkui.macros.EnumExtend

/**
 * 加载图标类型
 *
 * 定义加载组件的图标样式
 */
@EnumExtend
public enum SilkLoadingType {
    | CIRCULAR  // 环形加载图标，表现为一个旋转的圆环
    | SPINNER   // 菊花加载图标，表现为一个旋转的放射状图形
}
