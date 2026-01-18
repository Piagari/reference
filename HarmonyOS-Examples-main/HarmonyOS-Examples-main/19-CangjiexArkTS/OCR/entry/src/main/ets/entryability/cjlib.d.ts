export declare class OcrFileInfo {
}

export declare interface CustomLib {
  OcrFileInfo: {new (uri: string, size: number, ocrResult: string): OcrFileInfo}
  registerJSFunc(name: string, fn: (funcArg0: (funcArgfuncArg0: OcrFileInfo, funcArgfuncArg1: number) => void) => void): void
  unregisterJSFunc(name: string): void
  registerShowToast(fn: (funcArg0: string) => void): void
}
