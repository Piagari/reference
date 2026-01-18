import { OcrFileInfo } from "../../entryability/cjlib";
import { AbstractStrategyRouter } from "../AbstractStrategyRouter"
import { DynamicContext, RequestParams, ResponseParams } from "../Params"
import { ICjObject } from "../ICjObject";
import { Constants } from "../../constants/Constants";
import { fileIo } from "@kit.CoreFileKit";
import { image } from '@kit.ImageKit';
import { photoAccessHelper } from "@kit.MediaLibraryKit";
import { textRecognition } from "@kit.CoreVisionKit";

/*
 * 图像选择入口类
 * */
export class ImageSelector implements ICjObject {
  private callback?: (info: OcrFileInfo, stage: number) => void;

  constructor(callback?: (info: OcrFileInfo, stage: number) => void) {
    this.callback = callback;
  }

  public exportToCj() {
    return (callback: (info: OcrFileInfo, stage: number) => void) => {
      this.callback = callback;
      this.apply();
    }
  }

  public async apply(): Promise<ResponseParams | null> {
    let startNode = new OpenPhotoNode();
    return await startNode.apply(new RequestParams(), new DynamicContext(this.callback));
  }
}

/*
 * 责任链节点
 * */
export class OpenPhotoNode extends AbstractStrategyRouter<RequestParams, DynamicContext, ResponseParams> {

  public get(requestParams: RequestParams, dynamicContext: DynamicContext):
  AbstractStrategyRouter<RequestParams, DynamicContext, ResponseParams> | null {
    if (dynamicContext.uri === undefined || dynamicContext.uri === '') {
      console.error('OCR', "failed to get uri.");
    } else {
      console.info('OCR', 'image uri: ' + dynamicContext.uri)
    }
    return new LoadImageNode();
  }

  public async apply(requestParams: RequestParams, dynamicContext: DynamicContext):
    Promise<ResponseParams | null> {
    let photoPicker: photoAccessHelper.PhotoViewPicker = new photoAccessHelper.PhotoViewPicker();
    let result = await photoPicker.select(Constants.photoOptions);
    dynamicContext.uri = result.photoUris[0];
    console.info(`OpenPhotoNode', 'uri: ${dynamicContext.uri}`)
    return await this.router(requestParams, dynamicContext);
  }
}

export class LoadImageNode extends AbstractStrategyRouter<RequestParams, DynamicContext, ResponseParams> {

  public get(requestParams: RequestParams, dynamicContext: DynamicContext):
    AbstractStrategyRouter<RequestParams, DynamicContext, ResponseParams> | null {
    if (!dynamicContext.pixelMap) {
      console.info("OCR", "undefined pixelMap");
    }
    return new OCRNode();
  }

  public async apply(requestParams: RequestParams, dynamicContext: DynamicContext):
    Promise<ResponseParams | null> {
    if (dynamicContext.callback === null) {
      console.warn("dynamicContext.callback is null")
    }
    dynamicContext.execCallback(Constants.UPLOADING);
    let fileSource = await fileIo.open(dynamicContext.uri, fileIo.OpenMode.READ_ONLY);
    let imageSource = image.createImageSource(fileSource.fd);
    dynamicContext.pixelMap = await imageSource.createPixelMap();
    return await this.router(requestParams, dynamicContext);
  }
}

export class OCRNode extends AbstractStrategyRouter<RequestParams, DynamicContext, ResponseParams> {
  public get(requestParams: RequestParams, dynamicContext: DynamicContext):
    AbstractStrategyRouter<RequestParams, DynamicContext, ResponseParams> | null {
    return null;
  }

  public async apply(requestParams: RequestParams, dynamicContext: DynamicContext):
    Promise<ResponseParams | null> {
    if (dynamicContext.pixelMap === undefined) {
      console.error("OCRNode", "pixelMap is undefined");
      return null;
    }
    // 调用文本识别接口
    let data = await textRecognition.recognizeText({ pixelMap: dynamicContext.pixelMap }, { isDirectionDetectionSupported: false });
    dynamicContext.pixelMap.release();
    // 将结果更新到Text中显示
    // 图片文案
    let dataValues = data.value;
    console.info('OcrWithImage', "ocr result: " + dataValues);
    dynamicContext.execCallback(Constants.FINISHED, dataValues);
    return new ResponseParams(dataValues);
  }
}