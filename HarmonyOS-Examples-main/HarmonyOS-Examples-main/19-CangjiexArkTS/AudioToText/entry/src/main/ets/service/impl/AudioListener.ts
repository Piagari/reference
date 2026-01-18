import { AbstractListener } from "../AbstractListener";
import { speechRecognizer } from "@kit.CoreSpeechKit";
import { AbstractRecognizer } from "../AbstractRecoginizer";

export class AudioListener extends AbstractListener {
  private recognizer: AbstractRecognizer;

  constructor(recognizer: AbstractRecognizer) {
    super();
    this.recognizer = recognizer;
  }

  protected doResult(sessionId: string, result: speechRecognizer.SpeechRecognitionResult): void {
    if (this.recognizer != null) {
      this.recognizer.doCallBack(result.result);
    }
  }
}