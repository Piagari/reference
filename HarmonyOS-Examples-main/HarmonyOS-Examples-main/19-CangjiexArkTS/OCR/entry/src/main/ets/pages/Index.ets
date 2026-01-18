import { requireCJLib } from "libark_interop_loader.so";
import { CJHybridComponentV2 } from 'cjhybridview';
import { ImageSelector } from "../service/nodes/ImageSelectNodes";
import { ICjObject } from "../service/ICjObject";
import { FileSelector } from "../service/nodes/FileSelectNodes";
import { PhotoTaker } from "../service/nodes/PhotoTakeNodes";
import { CustomLib } from "libark_interop_api.so";
import { promptAction } from "@kit.ArkUI";
import { Constants } from "../constants/Constants";

let cjlib = requireCJLib("libohos_app_cangjie_entry.so") as CustomLib

@Entry
@Component
struct Index {
  private cjObjects:[ICjObject, string][]  = [
    [new PhotoTaker(), 'takePhoto'],
    [new ImageSelector(), 'selectImage'],
    [new FileSelector(), 'selectFile']
  ]

  aboutToAppear(): void {
    for (const cjObjectsTuple of this.cjObjects) {
      cjlib.registerJSFunc(cjObjectsTuple[1], cjObjectsTuple[0].exportToCj());
    }
    // 该函数传参和其他函数不同 需要单独注册
    cjlib.registerShowToast((msg: string) => { promptAction.showToast(Constants.defaultShowToastOption(msg)); })
  }

  aboutToDisappear(): void {
    for (const cjObjectsTuple of this.cjObjects) {
      cjlib.unregisterJSFunc(cjObjectsTuple[1]);
    }
  }

  build() {
    Column() {
      CJHybridComponentV2({
        library: 'ohos_app_cangjie_entry',
        component: 'Index'
      })
        .height('100%')
        .width('100%')
    }
    .height('100%')
    .width('100%')
  }
}