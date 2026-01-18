import { speechRecognizer } from '@kit.CoreSpeechKit';
import { RecognitionEngineFactory } from './RecognitionEngineFactory';
import FileCapturer from "./FileCapturer";
import { AbstractRecognizer } from "../AbstractRecoginizer";
import { FileListener } from './FileListener';
import { AudioFileInfo } from 'libark_interop_api.so';
import { FileUtils } from '../../utils/FileUtils';
import { fileIo } from '@kit.CoreFileKit';
import {  CommonUtils } from '../../utils/CommonUtils';

export class FileRecognizer extends AbstractRecognizer {

  private TAG = 'FileRecognizer'
  private mFileCapturer =  new FileCapturer();
  private asrEngine: speechRecognizer.SpeechRecognitionEngine | null = null;
  private activeSessionId: string | null = null;

  public async createEngine() {
    this.asrEngine = await RecognitionEngineFactory.build();
    this.asrEngine.setListener(new FileListener(this));
  }

  public async start() {
    console.info(this.TAG, "start")
    const selectedFiles = await FileUtils.openAudioPicker(this);
    if (selectedFiles.length === 0) return;
    const fileUri = selectedFiles[0];
    if (!FileUtils.isSupportedAudioType(fileUri)) {
      console.error('This file type is not supported');
      return;
    }

    const sandboxPath = await FileUtils.copyAudioToSandbox(fileUri);
    if (!sandboxPath) {
      console.error('This file processing fails');
      return;
    }
    // 开始识别会话
    const audioType = FileUtils.getAudioType(sandboxPath);
    const audioParams: speechRecognizer.AudioInfo = {
      audioType: audioType,
      sampleRate: 16000,
      soundChannel: 1,
      sampleBit: 16
    };

    const startParams: speechRecognizer.StartParams = {
      sessionId: "1234",
      audioInfo: audioParams
    };

    this.asrEngine?.startListening(startParams);
    this.doCallBack('识别中...')

    // 读取并发送音频数据
    let file = fileIo.openSync(fileUri,fileIo.OpenMode.READ_WRITE)
    try {
      let buf: ArrayBuffer = new ArrayBuffer(1280);
      let offset : number = 0;
      while( 1280 == fileIo.readSync(file.fd,buf,{
        offset : offset
      })) {
        let uint8Array: Uint8Array = new Uint8Array(buf);
        this.asrEngine?.writeAudio("1234", uint8Array);
        await CommonUtils.countDownLatch(1);
        offset = offset + 1280;
      }

      await this.mFileCapturer.start();

      // 发送结束标志
      this.asrEngine?.writeAudio("1234", new Uint8Array(0));

    } catch (err) {
      console.error('FileRecognizer', `File recognition error: ${err.message}`);
      this.doCallBack(`错误: ${err.message}`);
    } finally {
      if (null != file) {
        fileIo.closeSync(file);
      }
    }
  }

  public shutdown() {
    RecognitionEngineFactory.shutdown(this.activeSessionId)
    this.asrEngine = null;
  }

  public exportToCj(): (callback: (info: AudioFileInfo) => void) => void {
    let startFileRecording = (callback: (info: AudioFileInfo) => void) => {
      this.setCallBack(callback);
      this.start();
    }
    return startFileRecording;
  }


}