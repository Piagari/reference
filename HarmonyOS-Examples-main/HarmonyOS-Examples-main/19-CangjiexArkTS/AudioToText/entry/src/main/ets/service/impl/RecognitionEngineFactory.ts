import { speechRecognizer } from '@kit.CoreSpeechKit';
import { BusinessError } from '@kit.BasicServicesKit';

export class RecognitionEngineFactory {

  private static TAG = 'RecognitionEngineFactory';

  private static engine: speechRecognizer.SpeechRecognitionEngine | null = null;

  // 单例
  public static async build(): Promise<speechRecognizer.SpeechRecognitionEngine> {
    if (RecognitionEngineFactory.engine == null) {
      await RecognitionEngineFactory.create();
    }
    return RecognitionEngineFactory.engine;
  }

  public static shutdown(activeSessionId: string) {
    if (RecognitionEngineFactory.engine == null) {
      console.warn(RecognitionEngineFactory.TAG, 'The engine is not created.');
      return;
    }
    try {
      if (activeSessionId != null && activeSessionId != '') {
        RecognitionEngineFactory.engine.cancel(activeSessionId);
      }
      RecognitionEngineFactory.engine.shutdown();
      RecognitionEngineFactory.engine = null;
      console.info('The engine is released.');
    } catch (err) {
      console.error(`Failed to release engine. message: ${err.message}.`);
    }
  }

  private static async create() {
    let extraParam: Record<string, Object> = {"locate": "CN", "recognizerMode": "short"};
    let initParamsInfo: speechRecognizer.CreateEngineParams = {
      language: 'zh-CN',
      online: 1,
      extraParams: extraParam
    };
    speechRecognizer.createEngine(initParamsInfo, (err: BusinessError, speechRecognitionEngine:
      speechRecognizer.SpeechRecognitionEngine) => {
      if (!err) {
        console.info(RecognitionEngineFactory.TAG, 'succeededed in creating engine.');
        RecognitionEngineFactory.engine = speechRecognitionEngine;
      } else {
        console.error(RecognitionEngineFactory.TAG, `Failed to create engine. Message: ${err.message}.`);
      }
    });
    await RecognitionEngineFactory.sleep(500);
  }

  private static sleep(ms: number):Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }


}