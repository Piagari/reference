import { IRecognizer } from "./IRecognizer";
import { AudioFileInfo, CustomLib } from "libark_interop_api.so";
import { requireCJLib } from 'libark_interop_loader.so';

let cjlib = requireCJLib("libohos_app_cangjie_entry.so") as CustomLib

export abstract class AbstractRecognizer implements IRecognizer {
  protected callBack: (info: AudioFileInfo) => void = null;

  abstract createEngine(): void;

  abstract start(): void;

  abstract shutdown(): void;

  abstract exportToCj(): (callback: (info: AudioFileInfo) => void) => void;

  public setCallBack(callBack: (info: AudioFileInfo) => void) {
    this.callBack = callBack;
  }

  public doCallBack(text: string) {
    if (this.callBack != null) {
      this.callBack(new cjlib.AudioFileInfo(text))
    }
  }
}