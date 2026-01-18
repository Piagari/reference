/**
 * Created on 2025/4/21
 */
package silkui.types
internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*

@Builder
public func DefaultBuilder() {
}

public class EqualFuncClass {
    public static func equal(flag: Bool): Bool {
        return flag
    }
}