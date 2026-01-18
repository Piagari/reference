/**
 * Created on 2025/1/24
 */
package ohos_app_cangjie_entry.pages
import std.time.*
import std.io.*
import net.http.*
import net.tls.*
import encoding.json.*

const DEEPSEEK_API_KEY = 'sk-00ec69e9df0e49389215c2b37063f67a' // 示例自带的密钥可能失效
extend Client {
  public func chat(question: String) {
    let info = """
    {
      "model": "deepseek-chat",
      "messages": [
        ${question}
      ],
      "stream": true
    }
    """
    let request = HttpRequestBuilder()
      .url('https://api.deepseek.com/chat/completions')
      .header('Authorization', 'Bearer ${DEEPSEEK_API_KEY}')
      .header('Content-Type', 'application/json')
      .header("Accept", "text/event-stream")
      .body(info)
      .readTimeout(Duration.second * 5)
      .post()
      .build()
    var response =  this.send(request)
    return response
  }
}

func parseContent(text: String) {
  let json = JsonValue.fromStr(text).asObject()
  let choices = json.getFields()['choices'].asArray()
  let message = choices[0].asObject().getFields()['delta'].asObject()
  let content = message.getFields()['content'].asString().getValue()
  return content
}