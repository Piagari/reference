/**
 * Created on 2025/8/4
 */
package ohos_app_cangjie_entry.ui.entity

import ohos_app_cangjie_entry.constant.*
import ohos_app_cangjie_entry.utils.*

import cj_res_entry.app
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import std.collection.*
import std.time.DateTime
import std.time.TimeZone

// 专门用来管理动态组件样式
@Observed
public class DynamicStyle {
    @Publish
    public var selectedIdx: Int64 = -1
    @Publish
    public var flowCells: ArrayList<BillCell> = ArrayList<BillCell>()
    @Publish
    public var showPicker: Bool = false

    public var dynamicTime: ?DynamicTime = None

    public func getFontColor(cell: BillCell, idx: Int64) {
        if (idx == this.selectedIdx) {
            @r(app.color.selected_date_font_color)
        } else {
            if (cell.isSupplemental) {
                @r(app.color.supplemental_date_font_color)
            } else {
                @r(app.color.scoped_date_font_color)
            }
        }
    }

    public func getBackgroundColor(cell: BillCell, idx: Int64) {
        if (idx == this.selectedIdx) {
            @r(app.color.selected_date_cell_background)
        } else {
            if (cell.isSupplemental) {
                @r(app.color.background_color)
            } else {
                @r(app.color.background_color)
            }
        }
    }

    public func getHeight() {
        if (this.flowCells.size > 35) { 360 } else { 300 }
    }

    public func getColumnsTemplateStr() {
        "1fr 1fr 1fr 1fr 1fr 1fr 1fr"
    }

    public func getRowsTemplateStr() {
        if (this.flowCells.size > 35) { "1fr 1fr 1fr 1fr 1fr 1fr" } else { "1fr 1fr 1fr 1fr 1fr" }
    }

    public func getForegroundBlurStyle() {
        return if (showPicker) { ForegroundBlurStyle.BACKGROUND_THIN } else { ForegroundBlurStyle.NONE }
    }

    public func handleCellClick(cell: BillCell, idx: Int64) {
        if (!cell.isSupplemental) {
            this.selectedIdx = idx
        }
    }

    public func update(sourceData: ArrayList<SourceData>) {
        (this.flowCells, this.selectedIdx) = dynamicTime.getOrThrow().updateCellAndIdx(sourceData)
    }
}