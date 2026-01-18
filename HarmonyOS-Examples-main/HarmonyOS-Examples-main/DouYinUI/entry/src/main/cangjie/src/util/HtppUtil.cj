/**
 * Created on 2024/8/22
 */
package ohos_app_cangjie_entry.util

import ohos.net.http.*
import ohos.hilog.Hilog
import std.collection.HashMap
import ohos.image.*
import std.io.*

public class HttpUtil {
    private let httpRequest = createHttp()

    //private let option = HttpRequestOptions()
    private var httpRes:Array<UInt8> = Array<UInt8>()

    public func getHttpRequest(url: String) {
        httpRequest.request(
            url,
            {
                err, resp =>
                if (let Some(e) <- err) {
                    Hilog.error(0, "http请求", "exception: ${e.message}")
                    throw e
                }
                if (let Some(r) <- resp) {
                    if (r.responseCode.getValue() == 200) {
                        /**
                       this.httpRes = match (r.result) {
                        	case HttpData.STRING_DATA(x) => []
                            case HttpData.ARRAY_DATA(x) => x
                        }
                        **/
                        Hilog.error(0, "http请求", "${r.result}")
                    }
                    Hilog.error(0, "http请求", "${r}")
                } else {
                    Hilog.error(0, "http请求", "resp is none")
                }
                httpRequest.destroy()
            })
    }

    //通过ImageSourse转换为PixelMap
   /**public func getImageSource(value:Array<UInt8>) {
        var pixelMap: ?PixelMap = None
        let byteArrayStream = ByteArrayStream()
        byteArrayStream.write(value)
        var buf:Array<UInt8> = Array<UInt8>(25600,item:0)
        byteArrayStream.read(buf)
        let imageSource: ImageSource = createImageSource(buf)
        let imagePacker: ImagePacker = createImagePacker()
        let packingOption = PackingOption("image/png")
        let packRes = imagePacker.packing(imageSource, packingOption)
        let option = DecodingOptions(
                sampleSize: 1,
                rotate: 0,
                editable: false,
                desiredSize: Size(height: 80, width: 80),
                desiredRegion: Region(Size(height: 80, width: 80), 0, 0),
                desiredPixelFormat: PixelMapFormat.RGBA_8888,
                index: 0,
                fitDensity: 20)
        //pixelMap = imageSource.createPixelMap(options:option)
        //let pixelMap = createPixelMap(buf, opts)
        //return pixelMap.getOrThrow()
    }
    **/
}
