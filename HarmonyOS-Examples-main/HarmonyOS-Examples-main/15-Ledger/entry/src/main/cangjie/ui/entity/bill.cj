package ohos_app_cangjie_entry.ui.entity

import ohos.component.*
import ohos.state_macro_manage.*
import ohos.state_manage.*
import ohos.base.*
import cj_res_entry.app
import std.collection.*
import std.time.*

public class BillDetail {
    public BillDetail(
        public var isIncome: Bool,
        public var title: String,
        public var amount: Float64,
        public var detail: String,
        public var icon: CJResource
    ) {}
}

public class BillCell {
    public var isSelected: Bool
    public var income: Float64
    public var expense: Float64
    public var flowDetails: ArrayList<BillDetail> = ArrayList<BillDetail>()

    public BillCell(public var day: Int64, public var isSupplemental: Bool) {
        this.isSelected = false
        this.income = Float64(0)
        this.expense = Float64(0)
    }

    public func addDetails(src: SourceData) {
        if (src.isIncome) { this.income += src.amount } else { this.expense += src.amount }
        let detailStr = "${src.paymentMethod} ${src.account} ${src.payDate.hour}:${src.payDate.minute}"
        this.flowDetails.append(BillDetail(src.isIncome, src.title, src.amount, detailStr, src.icon))
    }
}

public class SourceData {
    public SourceData(
        public var isIncome: Bool,
        public var title: String,
        public var amount: Float64,
        public var paymentMethod: String,
        public var account: String,
        public var payDate: DateTime,
        public var icon: CJResource
    ) {}
}
