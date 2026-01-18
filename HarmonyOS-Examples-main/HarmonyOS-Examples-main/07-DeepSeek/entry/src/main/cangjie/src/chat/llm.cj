
package ohos_app_cangjie_entry.chat

import std.io.StringReader
import std.time.Duration
import encoding.json.*
import net.http.*
import net.tls.*

public class LLM {
    let client: Client
    let history = StringBuilder()
    public LLM(let url!: String, let key!: String, var model!: String,
        let context!: Bool = false) {
        var config = TlsClientConfig()
        config.verifyMode = TrustAll
        client = ClientBuilder()
            .tlsConfig(config)
            .readTimeout(Duration.Max) // AI 服务响应有时候比较慢，这里设置为无限等待
            .build()
    }

    public func changeModel(model: String) {
        this.model = model
    }

    func encode(role: Role, content: String) {
        '{"role":"${role}","content":${JsonString(content)}}'
    }

    func record(role: Role, message: String) {
        if (!context) {
            return
        }
        let text = if (let AI <- role) {
            ',' + encode(role, message) + ','
        } else {
            encode(role, message)
        }
        history.append(text)
    }

    func send(input: String, stream!: Bool = false) {
        let message = encode(I, input)
        let content =
            '{"model":"${model}","messages":[${history}${message}],"stream":${stream}}'
        record(I, input)
        let request = HttpRequestBuilder()
            .url(url)
            .header('Authorization', 'Bearer ${key}')
            .header('Content-Type', 'application/json')
            .header('Accept', if (stream) {
                'text/event-stream'
            } else {
                'application/json'
            })
            .body(content)
            .post()
            .build()
        client.send(request)
    }

    func parse(text: String, stream!: Bool = true, reason!: Bool = false) {
        let json = JsonValue.fromStr(text).asObject()
        let choices = json.getFields()['choices'].asArray()
        // 流式和非流式情况下，这个字段名称不同
        let key = if (stream) { 'delta' } else { 'message' }
        let message = choices[0].asObject().getFields()[key].asObject()
        let value = if (reason) { 'reasoning_content' } else { 'content' }
        let content = message.getFields()[value].asString().getValue()
        return content
    }

    // 流式对话
    public func chat(input: String, task: (String, Bool) -> Bool) {
        const INDEX = 6
        var slice = ''
        let output = StringBuilder()
        let buffer = Array<Byte>(1024 * 8, item: 0)
        let response = send(input, stream: true)
        var length = response.body.read(buffer)
        while (length != 0) {
            let text = String.fromUtf8(buffer[..length])
            for (line in text.split('\n', removeEmpty: true)) {
                if (line.size > INDEX && line[INDEX] == b'{') {
                    let json = line[INDEX..line.size]
                    let reason = !json.contains('"reasoning_content":null')
                    slice = parse(json, reason: reason)
                    if (!reason && context) {
                        if (output.size == 0) {
                            slice = slice.trimLeft('\n')
                        }
                        output.append(slice)
                    }
                    if (!task(slice, reason)) {
                        record(AI, output.toString())
                        return
                    }
                }
            }
            length = response.body.read(buffer)
        }
        record(AI, output.toString())
    }

    public func preset(context: Array<(Role, String)>) {
        history.reset()
        for ((role, message) in context) {
            history.append(encode(role, message) + ',')
        }
    }

    public func reset() {
        history.reset()
    }
}