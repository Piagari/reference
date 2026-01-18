/**
 * Created on 2024/9/6
 */
package ohos_app_cangjie_entry.utils

import ohos.base.*
import ohos.component.*

public let animation = AnimateParam(
    duration: 300,
    curve: Curve.EaseOut,
    iterations: 1,
    playMode: PlayMode.Normal,
    expectedFrameRateRange: ExpectedFrameRateRange(
        min: 20,
        max: 120,
        expected: 90
    )
)
