import { speechRecognizer } from '@kit.CoreSpeechKit';
import { RecognitionEngineFactory } from './RecognitionEngineFactory';
import { Constants } from '../../constant/Cosntant';
import AudioCapturer from './AudioCapturer';
import { AbstractRecognizer } from '../AbstractRecoginizer';
import { AudioListener } from './AudioListener';
import { AudioFileInfo } from 'libark_interop_api.so';

export class AudioRecognizer extends AbstractRecognizer {
  private mAudioCapturer = new AudioCapturer();
  private asrEngine: speechRecognizer.SpeechRecognitionEngine = null;

  public async createEngine() {
    this.asrEngine = await RecognitionEngineFactory.build();
    this.asrEngine.setListener(new AudioListener(this));
  }

  // 麦克风语音转文本
  public async start() {
    this.asrEngine.startListening(Constants.recognizerParams);
    let data: ArrayBuffer;
    this.mAudioCapturer.init((dataBuffer: ArrayBuffer) => {
      data = dataBuffer
      let uint8Array: Uint8Array = new Uint8Array(data);
      this.asrEngine.writeAudio("1234567", uint8Array);
    });
  }

  public shutdown() {
    RecognitionEngineFactory.shutdown(null);
    this.asrEngine = null;
  }

  public exportToCj(): (callback: (info: AudioFileInfo) => void) => void {
    let startAudioRecording = (callback: (info: AudioFileInfo) => void) => {
      this.setCallBack(callback);
      this.start();
    }
    return startAudioRecording;
  }
}