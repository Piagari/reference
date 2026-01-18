import { OcrFileInfo } from "libark_interop_api.so";

/*
 * 暴露给仓颉的接口
 * */
export interface ICjObject {
  exportToCj(): (callback: (info: OcrFileInfo, stage: number) => void) => void;
}