import { speechRecognizer } from '@kit.CoreSpeechKit';

export abstract class AbstractListener implements speechRecognizer.RecognitionListener {
  private TAG = 'Listener'

  protected doStart(sessionId: string, eventMessage: string) {}

  protected doEvent(sessionId: string, eventCode: number, eventMessage: string) {}

  protected doResult(sessionId: string, result: speechRecognizer.SpeechRecognitionResult) {}

  protected doComplete(sessionId: string, eventMessage: string) {}

  protected doError(sessionId: string, errorCode: number, errorMessage: string) {}


  onStart(sessionId: string, eventMessage: string): void {
    console.info(this.TAG, `onStart, sessionId: ${sessionId} eventMessage: ${eventMessage}`);
    this.doStart(sessionId, eventMessage);
  }

  onEvent(sessionId: string, eventCode: number, eventMessage: string): void {
    console.info(this.TAG, `onEvent, sessionId: ${sessionId} eventCode: ${eventCode} eventMessage: ${eventMessage}`);
    this.doEvent(sessionId, eventCode, eventMessage);
  }

  onResult(sessionId: string, result: speechRecognizer.SpeechRecognitionResult): void {
    console.info(this.TAG, `onResult, sessionId: ${sessionId} sessionId: ${JSON.stringify(result)}`);
    this.doResult(sessionId, result);
  }

  onComplete(sessionId: string, eventMessage: string): void {
    console.info(this.TAG, `onComplete, sessionId: ${sessionId} eventMessage: ${eventMessage}`);
    this.doComplete(sessionId, eventMessage);
  }

  onError(sessionId: string, errorCode: number, errorMessage: string): void {
    console.error(this.TAG, `onError, sessionId: ${sessionId} errorCode: ${errorCode} errorMessage: ${errorMessage}`);
    this.doError(sessionId, errorCode, errorMessage);
  }

}