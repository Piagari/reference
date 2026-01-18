package ohos_app_cangjie_entry

import ohos_app_cangjie_entry.components.*
import ohos.component.*
import ohos.hybrid_base.*
import ohos.state_macro_manage.*
import ohos.state_manage.*

@HybridComponentEntry
@Component
class AudioTransform {

    func build() {
        Column {
            Background()
            Recording()
        }
        .justifyContent(FlexAlign.Center)

    }
}