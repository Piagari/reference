import encoding.json.stream.*
import std.io.ByteArrayStream
import net.tls.*
import crypto.x509.{X509Certificate, PrivateKey}
import net.http.*
import std.fs.*
import std.convert.*


main () {

    println("--------------------------")
    println("---新闻信息管理系统---")
    println("--------------------------")

    // tcp 配置
    var transportCfg = TransportConfig()
    transportCfg.readBufferSize = 8192 
    // tls 配置 需要传入配套的证书与私钥文件路径
    let pem0 = String.fromUtf8(File("./key.crt", OpenOption.Open(true, false)).readToEnd())
    let pem02 = String.fromUtf8(File("./key.key", OpenOption.Open(true, false)).readToEnd())
    var tlsConfig = TlsServerConfig(X509Certificate.decodeFromPem(pem0), PrivateKey.decodeFromPem(pem02))
    tlsConfig.supportedAlpnProtocols = ["h2"]

    // 构建 Server 实例
    let server = ServerBuilder()
                        .addr("192.168.3.11")
                        .port(8080)
                        .transportConfig(transportCfg)
                        // .tlsConfig(tlsConfig)
                        .build()

    // 获取所有的新闻信息
    server.distributor.register("/news/all", FuncHandler({ httpContext =>
        // 新建ByteArrayStream对象
        let stream = ByteArrayStream()
        // 创建 JsonWriter对象
        let writer = JsonWriter(stream) 
        // 输出新闻数组
        NewsManager.getInstance().getAllNews(writer)
        // 更新 JsonWriter对象
        writer.flush()
        // 设置返回的类型和字符编码
        httpContext.responseBuilder.header("content-type", "text/html;charset=utf-8")
        // 设置返回Body的主体
        httpContext.responseBuilder.body(String.fromUtf8(stream.readToEnd()))
    }))

    // 录入新闻信息
    server.distributor.register("/news/input", FuncHandler({ httpContext =>
        let stream = ByteArrayStream() 
        let writer = JsonWriter(stream) 
        // 开始写入JsonObject
        writer.startObject()
        // 是否录入成功
        var result = false
        try {
            // 获取新闻的各个属性
            let id = UInt32.tryParse(httpContext.request.form.get("id").getOrThrow()).getOrThrow()
            let cover = httpContext.request.form.get("cover").getOrThrow()
            let title = httpContext.request.form.get("title").getOrThrow()
            let content = httpContext.request.form.get("content").getOrThrow()
            let like_num = UInt32.tryParse(httpContext.request.form.get("like_num").getOrThrow()).getOrThrow()
            let hot = httpContext.request.form.get("hot").getOrThrow()
            let publish_time = httpContext.request.form.get("publish_time").getOrThrow()
            
            // 创新新闻对象
            let news = News(id, cover, title, content, like_num, hot, publish_time)
            // 插入新闻到数据表
            result = NewsManager.getInstance().insertNews(news)

        }catch (e : Exception) {
            // 录入失败
            writer.writeName("error").writeValue(e.toString()) 
        }
        // 写入录入结果（是否成功）
        writer.writeName("result").writeValue(result) 
        // 停止写入JsonObject
        writer.endObject()

        writer.flush()
        httpContext.responseBuilder.header("content-type", "text/html;charset=utf-8")
        httpContext.responseBuilder.body(String.fromUtf8(stream.readToEnd()))
    }))

    // 查询新闻信息
    server.distributor.register("/news/query", FuncHandler({ httpContext =>
        let stream = ByteArrayStream() 
        let writer = JsonWriter(stream) 

        writer.startObject()

        try {
            // 获取新闻编号
            let id = UInt32.tryParse(httpContext.request.form.get("id").getOrThrow()).getOrThrow()
            // 通过编号查询新闻
            if (let Some(news) <- NewsManager.getInstance().queryNews(id)) {
                // 输出新闻信息
                writer.writeName("news")
                news.toJson(writer)
                // 查询成功 
                writer.writeName("result").writeValue(true) 
            } else {
                // 查询失败
                writer.writeName("result").writeValue(false) 
                writer.writeName("error").writeValue("未找到新闻!") 
            }

        }catch (e : Exception) {
            // 查询失败
            writer.writeName("error").writeValue(e.toString()) 
        }

        writer.endObject()

        writer.flush()
        httpContext.responseBuilder.header("content-type", "text/html;charset=utf-8")
        httpContext.responseBuilder.body(String.fromUtf8(stream.readToEnd()))
    }))

    // 查询新闻信息
    server.distributor.register("/news/querytitle", FuncHandler({ httpContext =>
        let stream = ByteArrayStream() 
        let writer = JsonWriter(stream) 

        try {
            // 获取新闻关键字
            let key = httpContext.request.form.get("title").getOrThrow()                        
            NewsManager.getInstance().queryNews(writer,key)

        }catch (e : Exception) {
            // 查询失败
            writer.writeName("error").writeValue(e.toString()) 
        }
        writer.flush()
        httpContext.responseBuilder.header("content-type", "text/html;charset=utf-8")
        httpContext.responseBuilder.body(String.fromUtf8(stream.readToEnd()))
    }))


    // 删除新闻信息
    server.distributor.register("/news/delete", FuncHandler({ httpContext =>
        // 
        let stream = ByteArrayStream() 
        let writer = JsonWriter(stream) 

        writer.startObject()

        try {
            // 获取新闻编号
            let id = UInt32.tryParse(httpContext.request.form.get("id").getOrThrow()).getOrThrow()

            // 通过编号删除新闻
            if (NewsManager.getInstance().deleteNews(id)) {
                // 删除成功 
                writer.writeName("result").writeValue(true) 
            } else {
                // 删除失败
                writer.writeName("result").writeValue(false) 
                writer.writeName("error").writeValue("未找到新闻!") 
            }

        }catch (e : Exception) {
            writer.writeName("error").writeValue(e.toString()) 
        }

        writer.endObject()

        writer.flush()
        httpContext.responseBuilder.header("content-type", "text/html;charset=utf-8")
        httpContext.responseBuilder.body(String.fromUtf8(stream.readToEnd()))
    }))

    // 修改新闻信息
    server.distributor.register("/news/update", FuncHandler({ httpContext =>
        let stream = ByteArrayStream() 
        let writer = JsonWriter(stream) 

        writer.startObject()

        var result = false
        try {

            let id = UInt32.tryParse(httpContext.request.form.get("id").getOrThrow()).getOrThrow()

            if (let Some(_news) <- NewsManager.getInstance().queryNews(id)) {
                // 查询到新闻   
                if (let Some(cover) <- httpContext.request.form.get("cover")) {
                    _news.cover = cover
                }
                if (let Some(title) <- httpContext.request.form.get("title")) {
                    _news.title = title
                }
                if (let Some(content) <- httpContext.request.form.get("content")) {
                    _news.content = content
                }

                if (let Some(like_num) <- UInt32.tryParse(httpContext.request.form.get("like_num").getOrThrow())) {
                    _news.like_num = like_num
                }
                if (let Some(hot) <- httpContext.request.form.get("hot")) {
                    _news.hot = hot
                }
                if (let Some(publish_date) <- httpContext.request.form.get("publish_date")) {
                    _news.publish_date = publish_date
                }
                
                // 修改新闻
                result = NewsManager.getInstance().updateNews(_news)
                if (result) {
                } else {
                    writer.writeName("error").writeValue("修改失败!") 
                }

            } else {
                // 未查询到新闻
                writer.writeName("error").writeValue("未查询到新闻!") 
            }

        }catch (e : Exception) {
            writer.writeName("error").writeValue(e.toString()) 
        }

        writer.writeName("result").writeValue(result) 

        writer.endObject()

        writer.flush()
        httpContext.responseBuilder.header("content-type", "text/html;charset=utf-8")
        httpContext.responseBuilder.body(String.fromUtf8(stream.readToEnd()))
    }))

    // 启动服务
    server.serve()
}