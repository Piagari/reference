/**
 * Created on 2025/4/23
 */
package silkui.components.collapse
import std.collection.ArrayList
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Observed
public class SilkCollapseController {
//    @Publish public var count: Int64 = 1
    @Publish public var activeNames: ObservedArrayList<String> = ObservedArrayList<String>()
    private var accordion: Bool = false
    private var names: ArrayList<String> = ArrayList<String>()
//    public init (
//        activeNames!: ArrayList<String> = ArrayList<String>(),
//        accordion!: Bool = false,
//        names!: ArrayList<String> = ArrayList<String>()
//    ) {
//        this.accordion = accordion
//        this.activeNames = activeNames
//        this.names = names
//    }

    public func add(name: String) {
        if (!names.contains(name)) {
            names.append(name)
        }
    }
    public func setAccordion (accordion: Bool) {
        this.accordion = accordion
    }
    public func change(name: String) {
            if (activeNames.get().contains(name)) {
                if (accordion) {
                    activeNames.clear()
                } else {
                    activeNames.removeIf({p => p == name })
                }
            } else {
                if (accordion) {
                    activeNames.clear()
                }
                activeNames.append(name)
            }
//            count += 1

    }
    public func toggleAll (flag!: Option<Bool> = Option.None): Unit {
        // 手风琴模式不支持全部切换
        if (accordion) {
            return;
        };
        if (names.isEmpty()) {
            // TODO 提示不能为空
        }
        if (flag.isNone()) {
            // 全部切换
            for (name in names) {
                if (activeNames.get().contains(name)) {
                    activeNames.removeIf({p => p == name })
                } else {
                    activeNames.append(name)
                }
            }
        } else if (flag.getOrThrow()) {
            activeNames.clear()
            activeNames.appendAll(names)
        } else {
            activeNames.clear()
        }
//        count += 1

    }

}