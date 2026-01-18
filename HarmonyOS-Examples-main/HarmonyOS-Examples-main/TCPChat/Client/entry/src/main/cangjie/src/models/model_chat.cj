/**
 * Created on 2024/8/21
 */
package ohos_app_cangjie_entry.models

public class ChatModel {
    private var _name: String
    private var _msg: String
    private var _sendOrReceive: Int8

    public init(name: String, msg: String, sendOrReceive: Int8) {
        this._name = name
        this._msg = msg
        this._sendOrReceive = sendOrReceive
    }

    public func getMsg(): String {
        this._msg
    }

    public func getName(): String {
        this._name
    }

    public func getSendOrReceive(): Int8 {
        this._sendOrReceive
    }
}
