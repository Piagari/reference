import { DynamicContext, RequestParams, ResponseParams } from "../Params"
import { AbstractStrategyRouter } from "../AbstractStrategyRouter";
import { Constants } from "../../constants/Constants";
import { LoadImageNode } from "./ImageSelectNodes";
import { OcrFileInfo } from "../../entryability/cjlib";
import { ICjObject } from "../ICjObject";
import { cameraPicker } from "@kit.CameraKit";


/*
 * 照相入口类
 * */
export class PhotoTaker implements ICjObject {
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
    let startNode = new TakePhotoNode();
    return await startNode.apply(new RequestParams(), new DynamicContext(this.callback));
  }
}

/*
 * 责任链节点
 * */
export class TakePhotoNode extends AbstractStrategyRouter<RequestParams, DynamicContext, ResponseParams> {
  public get(requestParams: RequestParams,dynamicContext: DynamicContext):
     AbstractStrategyRouter<RequestParams, DynamicContext, ResponseParams> | null {
    return new LoadImageNode();
  }

  public async apply(requestParams: RequestParams, dynamicContext: DynamicContext): Promise<ResponseParams | null> {
    let result = await cameraPicker.pick(getContext(), [cameraPicker.PickerMediaType.PHOTO], Constants.photoPickerProfile);
    console.info(`picker resultCode: ${result.resultCode}, resultUri: ${result.resultUri}, mediaType: ${result.mediaType}`);
    if (result.resultCode == 0) {
      dynamicContext.uri = result.resultUri;
      console.info('photo uri:' + dynamicContext.uri);
      dynamicContext.execCallback(Constants.UPLOADING);
    }
    return this.router(requestParams, dynamicContext);
  }
}
