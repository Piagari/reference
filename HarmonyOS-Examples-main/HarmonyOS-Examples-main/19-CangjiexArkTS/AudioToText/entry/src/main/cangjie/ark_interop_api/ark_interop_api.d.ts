export declare class AudioFileInfo {
}


export declare interface CustomLib {
    AudioFileInfo: {new (recognitionResult: string): AudioFileInfo}
    registerJSFunc(name: string, fn: (funcArg0: (funcArgfuncArg0: AudioFileInfo) => void) => void): void
    unregisterJSFunc(name: string): void
}