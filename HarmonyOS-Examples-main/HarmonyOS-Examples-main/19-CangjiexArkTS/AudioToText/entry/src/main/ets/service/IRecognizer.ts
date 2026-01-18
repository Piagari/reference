import { AudioFileInfo } from "libark_interop_api.so";

export interface IRecognizer {
  createEngine();

  start();

  shutdown();

  exportToCj(): (callback: (info: AudioFileInfo) => void) => void;
}