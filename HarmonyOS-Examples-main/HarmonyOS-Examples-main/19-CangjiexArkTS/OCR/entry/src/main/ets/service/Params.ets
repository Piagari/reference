import { CustomLib, OcrFileInfo } from "libark_interop_api.so";
import { requireCJLib } from "libark_interop_loader.so";
import { FileUtils } from "../utils/FileUtils";

let cjlib = requireCJLib("libohos_app_cangjie_entry.so") as CustomLib

export class RequestParams {
}

export class DynamicContext {

  public callback?: (info: OcrFileInfo, stage: number) => void;

  public uri: string;

  public name: string = '';

  public pixelMap?: PixelMap;

  public type = 'txt';

  public sandBoxPath = ''

  public result = '';

  constructor(callback?: (info: OcrFileInfo, stage: number) => void, uri: string = '', name: string = '') {
    this.callback = callback;
    this.uri = uri;
    this.name = name;
  }

  public getName() {
    return this.name === '' ? this.uri : this.name;
  }

  public newOcrFileInfo(ocrResult: string = '') {
    if (this.uri === '') {
      console.error('dynamicContext', 'uri is null');
    }
    return new cjlib.OcrFileInfo(this.getName(), FileUtils.getFileSize(this.uri), ocrResult);
  }

  public execCallback(state: number, ocrResult: string = '') {
    if (this.callback != null) {
      this.callback(this.newOcrFileInfo(ocrResult), state);
    }
  }
}

export class ResponseParams {
  public result: string = '';

  constructor(result: string) {
    this.result = result;
  }
}