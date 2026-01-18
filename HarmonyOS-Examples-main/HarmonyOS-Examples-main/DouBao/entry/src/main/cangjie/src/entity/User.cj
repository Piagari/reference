/**
 * Created on 2024/8/26
 */
package ohos_app_cangjie_entry.entity

import encoding.json.*
import ohos.base.*

public class User {
  public User(
    public let id: Int64,
    public let username: String,
    public let chats: Array<Int64>,
    public let friends: Array<Int64>,
    public let groups: Array<Int64>,
    public let avatar: CJResource,
    public let about: String,
    public let author: String,
    public let readnum: String,
    public let introduce: String
  ) { }
}