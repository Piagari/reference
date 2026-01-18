/**
 * Created on 2025/4/24
 */
package silkui.components.toast
import silkui.ResourceStr

public class SilkToastDynamicController {
    public var setMessage: Option<(ResourceStr) -> Unit> = Option.None
}