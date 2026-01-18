package silkui.components.cell
//
//internal import ohos.base.*
//internal import ohos.component.*
//internal import ohos.state_manage.*
//import ohos.resource_manager.*
//import ohos.state_macro_manage.*
//
//import cj_res_silkui.*
//import silkui.SilkUIBorderOptions
//import silkui.SilkUIPaddingOptions
//import silkui.types.*
//
//
//
///* ===== Emitted by MacroCall @Component in cell.cj:16:1 ===== */
///* 16.1 */public class SilkCell1 <: CustomView {
///* 16.2 */
///* 16.3 */
///* 16.4 */    private var Title: Option<(CustomView) -> ViewBuilder> = None
///* 16.5 */
///* 16.6 */
///* 16.7 */    private var Value: Option<(CustomView) -> ViewBuilder> = None
///* 16.8 */
///* 16.9 */
///* 16.10 */    private var Label: Option<(CustomView) -> ViewBuilder> = None
///* 16.11 */
///* 16.12 */
///* 16.13 */    private var Icon: Option<(CustomView) -> ViewBuilder> = None
///* 16.14 */
///* 16.15 */
///* 16.16 */    private var RightIcon: Option<(CustomView) -> ViewBuilder> = None
///* 16.17 */
///* 16.18 */
///* 16.19 */    private var stateVarDecl_props_: ObservedProperty < SilkCellOptions >
///* 16.20 */
///* 16.21 */
///* 16.22 */    private mut prop props: SilkCellOptions {
///* 16.23 */        get() {
///* 16.24 */            return this.stateVarDecl_props_.get()
///* 16.25 */        }
///* 16.26 */        set(v) {
///* 16.27 */            this.stateVarDecl_props_.set(v)
///* 16.28 */        }
///* 16.29 */    }
///* 16.30 */
///* 16.31 */
///* 16.43 */
///* 16.44 */
///* 16.45 */    protected func aboutToAppear() {
///* 16.46 */    }
///* 16.47 */
///* 16.48 */
///* 16.49 */
///* 16.50 */    public func build() {
///* 16.51 */
///* 16.52 */        this.observeComponentCreation({ elmtId, isInitialRender =>
///* 16.53 */            Column() { this.observeComponentCreation({ elmtId, isInitialRender => Row() { this.observeComponentCreation({ elmtId, isInitialRender => Column(4) { this.observeComponentCreation({ elmtId, isInitialRender => If { if(Title.isSome()) {
///* 16.54 */                this.ifElseBranchUpdateFunction(0, { => Title.getOrThrow()(this).build() })
///* 16.55 */            }
///* 16.56 */            else {
///* 16.57 */                this.ifElseBranchUpdateFunction(1, { => this.observeComponentCreation({ elmtId, isInitialRender => Row() { this.observeComponentCreation({ elmtId, isInitialRender => If { if(Icon.isSome()) {
///* 16.58 */                    this.ifElseBranchUpdateFunction(0, { => Icon.getOrThrow()(this).build() })
///* 16.59 */                }
///* 16.60 */                else if(props.icon.isSome()) {
///* 16.61 */                    this.ifElseBranchUpdateFunction(1, { => this.observeComponentCreation({ elmtId, isInitialRender => Image(props.icon.getOrThrow()).height(16).fillColor(__GenerateResource__("", "", "", app.color.gray_6, "app.color.gray_6",[], 10001)).margin(right: 4.vp) }) })
///* 16.62 */                }
///* 16.63 */                else {
///* 16.64 */                    If.branchId(2)
///* 16.65 */                }
///* 16.66 */            } })
///* 16.67 */            this.observeComponentCreation({ elmtId, isInitialRender => Text(props.title).fontSize(match(props.size) {
///* 16.68 */                case SilkCellSize.Large => __GenerateResource__("", "", "", app.float.font_size_lg, "app.float.font_size_lg",[], 10002)
///* 16.69 */                case SilkCellSize.Normal => __GenerateResource__("", "", "", app.float.font_size_md, "app.float.font_size_md",[], 10002)
///* 16.70 */            }).fontColor(props.titleColor) }) }.alignItems(VerticalAlign.Center).height(__GenerateResource__("", "", "", app.float.cell_line_height, "app.float.cell_line_height",[], 10002)) }) })
///* 16.71 */        }
///* 16.72 */    } })
///* 16.73 */    this.observeComponentCreation({ elmtId, isInitialRender => If { if(Label.isSome()) {
///* 16.74 */        this.ifElseBranchUpdateFunction(0, { => Label.getOrThrow()(this).build() })
///* 16.75 */    }
///* 16.76 */    else if(props.label.isSome()) {
///* 16.77 */        this.ifElseBranchUpdateFunction(1, { => this.observeComponentCreation({ elmtId, isInitialRender => Text(props.label.getOrThrow()).fontSize(match(props.size) {
///* 16.78 */            case SilkCellSize.Large => __GenerateResource__("", "", "", app.float.font_size_md, "app.float.font_size_md",[], 10002)
///* 16.79 */            case SilkCellSize.Normal => __GenerateResource__("", "", "", app.float.font_size_sm, "app.float.font_size_sm",[], 10002)
///* 16.80 */        }).fontColor(__GenerateResource__("", "", "", app.color.text_color_2, "app.color.text_color_2",[], 10001)) }) })
///* 16.81 */    }
///* 16.82 */    else {
///* 16.83 */        If.branchId(2)
///* 16.84 */    }
///* 16.85 */} }) }.alignItems(HorizontalAlign.Start) })
///* 16.86 */this.observeComponentCreation({ elmtId, isInitialRender => Blank() })
///* 16.87 */this.observeComponentCreation({ elmtId, isInitialRender => Row() { this.observeComponentCreation({ elmtId, isInitialRender => If { if(Value.isSome()) {
///* 16.88 */    this.ifElseBranchUpdateFunction(0, { => Value.getOrThrow()(this).build() })
///* 16.89 */}
///* 16.90 */else if(props.value.isSome()) {
///* 16.91 */    this.ifElseBranchUpdateFunction(1, { => this.observeComponentCreation({ elmtId, isInitialRender => Text(props.value.getOrThrow()).fontSize(__GenerateResource__("", "", "", app.float.font_size_md, "app.float.font_size_md",[], 10002)).fontColor(props.valueColor) }) })
///* 16.92 */}
///* 16.93 */else {
///* 16.94 */    If.branchId(2)
///* 16.95 */}
///* 16.96 */} })
///* 16.97 */this.observeComponentCreation({ elmtId, isInitialRender => If { if(RightIcon.isSome()) {
///* 16.98 */this.ifElseBranchUpdateFunction(0, { => RightIcon.getOrThrow()(this).build() })
///* 16.99 */}
///* 16.100 */else if(props.isLink) {
///* 16.101 */this.ifElseBranchUpdateFunction(1, { => this.observeComponentCreation({ elmtId, isInitialRender => Image(__GenerateResource__("", "", "", app.media.arrow, "app.media.arrow",[], 20000)).height(16).fillColor(__GenerateResource__("", "", "", app.color.gray_6, "app.color.gray_6",[], 10001)).margin(left: 4.vp).rotate(x: 0.0, y: 0.0, z: 1.0, angle: this.getRotate()) }) })
///* 16.102 */}
///* 16.103 */else {
///* 16.104 */If.branchId(2)
///* 16.105 */}
///* 16.106 */} }) }.alignItems(VerticalAlign.Center).height(__GenerateResource__("", "", "", app.float.cell_line_height, "app.float.cell_line_height",[], 10002)) }) }.width(100.percent).borderWidth(getBorderWidth()).borderColor(getBorderColor()).borderStyle(getBorderStyle()).padding(top: match(props.size) {
///* 16.107 */case SilkCellSize.Large => 12
///* 16.108 */case SilkCellSize.Normal => 10
///* 16.109 */}, bottom: match(props.size) {
///* 16.110 */case SilkCellSize.Large => 12
///* 16.111 */case SilkCellSize.Normal => 10
///* 16.112 */}).alignItems(if(props.center) {
///* 16.113 */VerticalAlign.Center
///* 16.114 */}
///* 16.115 */else {
///* 16.116 */VerticalAlign.Top
///* 16.117 */}
///* 16.118 */) }) }.backgroundColor(props.backgroundColor).padding(top: props.padding.top, right: props.padding.right, bottom: props.padding.bottom, left: props.padding.left)
///* 16.119 */})
///* 16.120 */
///* 16.121 */()
///* 16.122 */
///* 16.123 */}
///* 16.124 */
///* 16.125 */private func getBorderWidth(): EdgeWidths {
///* 16.126 */if(props.border) {
///* 16.127 */return EdgeWidths(left: 0.vp, right: 0.vp, top: 0.vp, bottom: 1.0.vp)
///* 16.128 */}
///* 16.129 */else {
///* 16.130 */return match(props.customBorder) {
///* 16.131 */case Some(v) => EdgeWidths(left: v.width.vp, right: v.width.vp, top: v.width.vp, bottom: v.width.vp)
///* 16.132 */case _ => EdgeWidths(left: 0.vp, right: 0.vp, top: 0.vp, bottom: 0.vp)
///* 16.133 */}
///* 16.134 */}
///* 16.135 */}
///* 16.136 */
///* 16.137 */
///* 16.138 */private func getBorderColor() {
///* 16.139 */if(props.border) {
///* 16.140 */return __GenerateResource__("", "", "", app.color.border_color, "app.color.border_color",[], 10001)
///* 16.141 */}
///* 16.142 */else {
///* 16.143 */return match(props.customBorder) {
///* 16.144 */case Some(v) => v.color
///* 16.145 */case _ => __GenerateResource__("", "", "", app.color.border_color, "app.color.border_color",[], 10001)
///* 16.146 */}
///* 16.147 */}
///* 16.148 */}
///* 16.149 */
///* 16.150 */
///* 16.151 */private func getBorderStyle() {
///* 16.152 */if(props.border) {
///* 16.153 */return BorderStyle.Solid
///* 16.154 */}
///* 16.155 */else {
///* 16.156 */return match(props.customBorder) {
///* 16.157 */case Some(v) => v.style
///* 16.158 */case _ => BorderStyle.Solid
///* 16.159 */}
///* 16.160 */}
///* 16.161 */}
///* 16.162 */
///* 16.163 */
///* 16.164 */private func getRotate(): Float32 {
///* 16.165 */match(props.arrowDirection) {
///* 16.166 */case Some(v) => match(v) {
///* 16.167 */case SilkCellArrowDirection.UP => 270.0
///* 16.168 */case SilkCellArrowDirection.DOWN => 90.0
///* 16.169 */case SilkCellArrowDirection.LEFT => 180.0
///* 16.170 */case SilkCellArrowDirection.RIGHT => 0.0
///* 16.171 */case _ => 0.0
///* 16.172 */}
///* 16.173 */case _ => 0.0
///* 16.174 */}
///* 16.175 */}
///* 16.176 */
///* 16.177 */
///* 16.178 */
///* 16.179 */public init(parent: Option < CustomView >, Title!: Option < ObservedProperty <(CustomView) -> ViewBuilder >>= None, Value!: Option < ObservedProperty <(CustomView) -> ViewBuilder >>= None, Label!: Option < ObservedProperty <(CustomView) -> ViewBuilder >>= None, Icon!: Option < ObservedProperty <(CustomView) -> ViewBuilder >>= None, RightIcon!: Option < ObservedProperty <(CustomView) -> ViewBuilder >>= None, props!: ObservedProperty < SilkCellOptions >, localStorage!: Option < LocalStorage >= None) {
///* 16.180 */super(parent, localStorage)
///* 16.181 */
///* 16.182 */
///* 16.183 */match(Title) {
///* 16.184 */case Some(v) => this.Title = v.get()
///* 16.185 */case _ =>()
///* 16.186 */}
///* 16.187 */
///* 16.188 */match(Value) {
///* 16.189 */case Some(v) => this.Value = v.get()
///* 16.190 */case _ =>()
///* 16.191 */}
///* 16.192 */
///* 16.193 */match(Label) {
///* 16.194 */case Some(v) => this.Label = v.get()
///* 16.195 */case _ =>()
///* 16.196 */}
///* 16.197 */
///* 16.198 */match(Icon) {
///* 16.199 */case Some(v) => this.Icon = v.get()
///* 16.200 */case _ =>()
///* 16.201 */}
///* 16.202 */
///* 16.203 */match(RightIcon) {
///* 16.204 */case Some(v) => this.RightIcon = v.get()
///* 16.205 */case _ =>()
///* 16.206 */}
///* 16.207 */
///* 16.208 */this.stateVarDecl_props_ = props.createProp("stateVarDecl_props_")
///* 16.209 */
///* 16.211 */
///* 16.212 */
///* 16.213 */this.stateVarDecl_props_.subscribeEx(this)
///* 16.214 */
///* 16.216 */
///* 16.217 */SubscriberManager.getInstance().add(this)
///* 16.218 */
///* 16.219 */
///* 16.220 */registerSelf()
///* 16.221 */parent?.addChildById(id(), this)
///* 16.222 */}
///* 16.223 */
///* 16.224 */
///* 16.225 */public override func aboutToBeDeleted() {
///* 16.226 */
///* 16.227 */this.stateVarDecl_props_.unsubscribeEx(this)
///* 16.228 */
///* 16.230 */
///* 16.231 */SubscriberManager.getInstance().delete(this)
///* 16.232 */this.aboutToBeDeletedInternal()
///* 16.233 */}
///* 16.234 */
///* 16.235 */
///* 16.236 */func updateWithValueParams(Title!: Option <(CustomView) -> ViewBuilder >= Option <(CustomView) -> ViewBuilder >.None, Value!: Option <(CustomView) -> ViewBuilder >= Option <(CustomView) -> ViewBuilder >.None, Label!: Option <(CustomView) -> ViewBuilder >= Option <(CustomView) -> ViewBuilder >.None, Icon!: Option <(CustomView) -> ViewBuilder >= Option <(CustomView) -> ViewBuilder >.None, RightIcon!: Option <(CustomView) -> ViewBuilder >= Option <(CustomView) -> ViewBuilder >.None, props!: Option < SilkCellOptions >= Option < SilkCellOptions >.None, customParam!: Option < SilkCellCustomParams >= Option < SilkCellCustomParams >.None): Unit {
///* 16.237 */
///* 16.238 */match(props) {
///* 16.239 */case Some(v) => this.props = v
///* 16.240 */case _ =>()
///* 16.241 */}
///* 16.242 */
///* 16.247 */
///* 16.248 */}
///* 16.249 */
///* 16.250 */
///* 16.251 */public func rerender() {
///* 16.252 */this.updateDirtyElements()
///* 16.253 */}
///* 16.254 */
///* 16.255 */
///* 16.256 */public func purgeVariableDependenciesOnElmtId(rmElmtId: Int64) {
///* 16.257 */
///* 16.258 */this.stateVarDecl_props_.purgeDependencyOnElmtId(rmElmtId)
///* 16.259 */
///* 16.261 */
///* 16.262 */}
///* 16.263 */
///* 16.264 */
///* 16.265 */public func forceRerender(deep!: Bool = false) {
///* 16.266 */this.forceCompleteRerender(deep)
///* 16.267 */}
///* 16.268 */
///* 16.269 */
///* 16.270 */}
///* 16.271 */
///* ===== End of the Emit ===== */
