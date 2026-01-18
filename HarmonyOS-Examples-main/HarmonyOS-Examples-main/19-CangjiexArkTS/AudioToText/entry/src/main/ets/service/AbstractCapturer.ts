'use strict';
import { audio } from '@kit.AudioKit';
import { ICapturer } from "./ICapturer";

export abstract class AbstractCapturer implements ICapturer {

  protected TAG = 'DEFAULT_CAPTURER_NAME'

  protected mDataCallBack: ((data: ArrayBuffer) => void) | null = null;

  protected canInit(): boolean { return true; }

  protected canStart(): boolean { return true; }

  protected canStop(): boolean { return true; }

  protected canRelease(): boolean { return true; }

  protected abstract doInit(dataCallBack: (data: ArrayBuffer) => void);

  protected abstract doStart();

  protected abstract doStop();

  protected abstract doRelease();

  protected afterInit() {}

  protected afterStart() {}

  protected afterStop() {}

  protected afterRelease() {}

  public async init(dataCallBack: (data: ArrayBuffer) => void) {
    try {
      console.info(this.TAG, `init`);
      if (this.canInit()) {
        await this.doInit(dataCallBack);
      }
    } catch (error) {
      console.error(this.TAG, `AudioCapturerUtil init createAudioCapturer failed, code is ${error.code}, message is ${error.message}`);
    } finally {
      this.afterInit();
    }
  }

  public async start() {
    try {
      console.info(`${this.TAG} start`);
      if (this.canStart()) {
        await this.doStart();
      }
    } catch (error) {
      console.error(this.TAG, `AudioCapturerUtil start createAudioCapturer failed, code is ${error.code}, message is ${error.message}`);
    } finally {
      this.afterStart();
    }
  }

  public async stop() {
    try {
      console.info(`${this.TAG} stop`);
      if (this.canStop()) {
        await this.doStop();
      }
    } catch (error) {
      console.error(this.TAG, `AudioCapturerUtil start createAudioCapturer failed, code is ${error.code}, message is ${error.message}`);
    } finally {
      this.afterStop();
    }
  }

  public async release() {
    try {
      console.info(`${this.TAG} release`);
      if (this.canRelease()) {
        await this.doRelease();
      }
    } catch (error) {
      console.error(this.TAG, `AudioCapturerUtil release createAudioCapturer failed, code is ${error.code}, message is ${error.message}`);
    } finally {
      this.afterRelease();
    }
  }
}