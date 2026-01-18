package ohos_app_cangjie_entry.utils
import std.io.StringReader
import std.time.Duration
import encoding.json.*
import net.http.*
import net.tls.*

public enum Role <: ToString {
    I | AI | System
    public func toString() {
        match (this) {
            case I => 'user'
            case AI => 'assistant'
            case System => 'system'
        }
    }
}

public class LLM {
    let client: Client
    let history = StringBuilder()
    public LLM(let url!: String, let key!: String, let model!: String,
        let memory!: Bool = false) {
        var config = TlsClientConfig()
        config.verifyMode = TrustAll
        client = ClientBuilder()
            .tlsConfig(config)
            .readTimeout(Duration.Max)
            .build()
    }

    func encode(role: Role, content: String) {
        '{"role":"${role}","content":${JsonString(content)}}'
    }

    func send(input: String, stream!: Bool = false) {
        let message = encode(I, input)
        let content =
            '{"model":"${model}","messages":[${history}${message}],"stream":${stream}}'
        if (memory) { history.append(message) }
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

    func parse(text: String, stream!: Bool = false) {
        let json = JsonValue.fromStr(text).asObject()
        let choices = json.getFields()['choices'].asArray()
        // 流式和非流式情况下，这个字段名称不同
        let key = if (stream) { 'delta' } else { 'message' }
        let message = choices[0].asObject().getFields()[key].asObject()
        let content = message.getFields()['content'].asString().getValue()
        return content
    }

    // 流式对话
    public func chats(input: String, task: (String) -> Unit) {
        const INDEX = 6
        let response = send(input, stream: true)
        let output = StringBuilder()
        let buffer = Array<Byte>(1024 * 8, item: 0)
        var length = response.body.read(buffer)
        while (length != 0) {
            let text = String.fromUtf8(buffer[..length])
            for (line in text.split('\n', removeEmpty: true)) {
                if (line.size > INDEX && line[INDEX] == b'{') {
                    let json = line[INDEX..line.size]
                    let slice = parse(json, stream: true)
                    if (memory) { output.append(slice) }
                    task(slice)
                }
            }
            length = response.body.read(buffer)
        }
        if (memory) {
            history.append(',${encode(AI, output.toString())},')
        }
    }

    // 非流式
    public func chat(input: String) {
        let response = send(input)
        let output = StringReader(response.body).readToEnd() |> parse
        if (memory) {
            history.append(',${encode(AI, output)},')
        }
        return output
    }

    public func preset(memory: Array<(Role, String)>) {
        history.reset()
        for ((role, message) in memory) {
            history.append(encode(role, message) + ',')
        }
    }

    public func reset() {
        history.reset()
    }
}

