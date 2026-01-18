'use strict';

import { audio } from '@kit.AudioKit';
import { Constants } from '../../constant/Cosntant';
import { AbstractCapturer } from '../AbstractCapturer'

export default class AudioCapturer extends AbstractCapturer {

  protected TAG: string = "AudioCapturer"

  private mAudioCapturer: audio.AudioCapturer | null = null;

  protected mCanWrite: boolean = true;

  protected async doInit(dataCallBack: (data: ArrayBuffer) => void): Promise<void> {
    this.mDataCallBack = dataCallBack;
    this.mAudioCapturer = await audio.createAudioCapturer(Constants.AUDIO_CAPTURER_OPTIONS)
  }

  protected async doStart() {
    this.mCanWrite = true;
    await this.mAudioCapturer.start();
    while (this.mCanWrite) {
      let bufferSize = await this.mAudioCapturer.getBufferSize();
      let buffer = await this.mAudioCapturer.read(bufferSize, true);
      this.mDataCallBack(buffer)
    }
  }

  protected async doStop() {
    this.mCanWrite = false;
    await this.mAudioCapturer.stop();
  }

  protected async doRelease() {
    await this.mAudioCapturer.release();
    this.mAudioCapturer = null;
  }

  protected canInit(): boolean {
    if (this.mDataCallBack != null) {
      console.warn(`${this.TAG} already initialize`);
      return false;
    }
  }

  protected canStart(): boolean {
    if (null === this.mAudioCapturer) {
      console.error(this.TAG, `AudioCapturerUtil havent init`);
      return false;
    }
    let state = this.mAudioCapturer.state
    if (state != audio.AudioState.STATE_PREPARED && state != audio.AudioState.STATE_PAUSED && state != audio.AudioState.STATE_STOPPED) {
      console.error(this.TAG, `AudioCapturerUtil start failed`);
      return false;
    }
    return true;
  }

  protected canStop(): boolean {
    if (null === this.mAudioCapturer) {
      console.error(this.TAG, `AudioCapturerUtil havent init`);
      return false;
    }
    let state = this.mAudioCapturer.state
    if (state !== audio.AudioState.STATE_RUNNING && state !== audio.AudioState.STATE_PAUSED) {
      console.error(this.TAG, `AudioCapturerUtil stop Capturer is not running or paused`);
      return false;
    }
    return true;
  }

  protected canRelease(): boolean {
    if (null === this.mAudioCapturer) {
      console.error(this.TAG, `AudioCapturerUtil havent init`);
      return false;
    }
    let state = this.mAudioCapturer.state
    if (state === audio.AudioState.STATE_RELEASED || state === audio.AudioState.STATE_NEW) {
      console.error(this.TAG, `Capturer already released`);
      return false;
    }
    return true;
  }

  protected afterStop() {
    if (Number(this.mAudioCapturer.state) == audio.AudioState.STATE_STOPPED) {
      console.info(this.TAG, `AudioCapturerUtil Capturer stopped`);
    } else {
      console.error(this.TAG, `Capturer stop failed`);
    }
  }

  protected afterRelease() {
    if (this.mAudioCapturer === null) {
      console.info(this.TAG, `Capturer released`);
    } else {
      console.error(this.TAG, `Capturer release failed`);
    }
  }

}