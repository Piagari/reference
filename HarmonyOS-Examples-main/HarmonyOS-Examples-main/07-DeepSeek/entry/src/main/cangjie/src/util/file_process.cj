/**
 * Created on 2025/2/21
 */
package ohos_app_cangjie_entry.util

import ohos.ability.AbilityContext
import ohos.base.*
import ohos.file_picker.*
import ohos.state_macro_manage.*
import cj_res_entry.*
import std.collection.ArrayList
import std.fs.*
import ohos.hilog.*

public var g_abilityContext: Option<AbilityContext> = None

public enum FileType {
    Image | Document
    public func icon(): CJResource {
        match (this) {
            case Image => @r(app.media.picture)
            case Document => @r(app.media.file)
        }
    }
}

public func getImages() {
    let uriList = ArrayList<String>()
    let picker = PhotoViewPicker(g_abilityContext.getOrThrow())
    let callback = { error: ?AsyncError, result: ?PhotoSelectResult =>
        if (let Some(result) <- result) {
            // Todo: 获取选择的图片路径并处理
            AppLog.info("select images: ${result.photoUris}")
        } else if (let Some(error) <- error) {
            AppLog.info("photo select error: ${error.code}")
        }
    }
    picker.select(callback, option:
        PhotoSelectOptions(MIMEType: PhotoViewMIMETypes.IMAGE_TYPE, maxSelectNumber: 20))
}

public func getFiles() {
    let picker = DocumentViewPicker(g_abilityContext.getOrThrow())
    let callback = { error: ?AsyncError, uris: ?Array<String> =>
        if (let Some(uris) <- uris) {
            // Todo: 获取选择的文件路径并处理
            AppLog.info("select files: ${uris}")
        } else if (let Some(error) <- error) {
            AppLog.info("file select error: ${error.code}")
        }
    }
    picker.select(callback, option:
        DocumentSelectOptions(selectMode: DocumentSelectMode.FILE, maxSelectNumber:10))
}