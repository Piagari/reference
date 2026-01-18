/**
 * Created on 2025/4/24
 */
package silkui.components.toast
import std.collection.HashMap
public class SilkToastConstants {
    private static var _inited: Bool = false
    private static var _isSingleton: Bool = true
    private static var _controller: Option<CustomDialogController> = Option.None
    private static var _controllerMap: HashMap<String, CustomDialogController> = HashMap()
    public static mut prop inited: Bool {
        get() {
            _inited
        }
        set(value) {
            _inited = value
        }
    }
    public static mut prop isSingleton: Bool {
        get() {
            _isSingleton
        }
        set(value) {
            _isSingleton = value
        }
    }
    public static mut prop controller: Option<CustomDialogController> {
        get() {
            _controller
        }
        set(value) {
            _controller = value
        }
    }
    public static mut prop controllerMap: HashMap<String, CustomDialogController> {
        get() {
            _controllerMap
        }
        set(value) {
            _controllerMap = value
        }
    }
}