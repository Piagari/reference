import { fileIo } from '@kit.CoreFileKit';
import { AbstractCapturer } from '../AbstractCapturer';

export default class FileCapturer extends AbstractCapturer {

  protected TAG: string = 'FileCapturer';

  private mIsWriting: boolean = false;

  private mFilePath: string = '';

  private mFile: fileIo.File | null = null;

  private mIsReadFile: boolean = true;

  private static SEND_SIZE = 1280

  public setFilePath(filePath: string) {
    this.mFilePath = filePath;
  }

  protected async doInit(dataCallBack: (data: ArrayBuffer) => void) {
    this.mDataCallBack = dataCallBack;
  }

  protected async doStart(): Promise<void> {
    this.mIsWriting = true;
    this.mIsReadFile = true;
    this.mFile = fileIo.openSync(this.mFilePath, fileIo.OpenMode.READ_ONLY);
    let buf: ArrayBuffer = new ArrayBuffer(FileCapturer.SEND_SIZE);
    let offset: number = 0;
    while (FileCapturer.SEND_SIZE == fileIo.readSync(this.mFile.fd, buf,
      { offset: offset }) && this.mIsReadFile) {
      this.mDataCallBack(buf);
      await FileCapturer.sleep(40);
      offset = offset + FileCapturer.SEND_SIZE;
    }
  }

  protected async doStop() {
    this.mIsReadFile = false;
  }

  protected async doRelease() {
    this.mDataCallBack = null;
    this.mIsReadFile = false;
  }

  protected canInit(): boolean {
    if (null != this.mDataCallBack) {
      console.error(this.TAG, `already initialize`);
      return false;
    }
    if (!fileIo.accessSync(this.mFilePath)) {
      console.error(this.TAG, `file accessing fails`);
      return false;
    }
    return true;
  }

  protected canStart(): boolean {
    if (this.mIsWriting || null == this.mDataCallBack) {
      console.error(this.TAG, `AudioCapturerUtil havent init`);
      return false;
    }
    return true;
  }

  protected canStop(): boolean {
    if (null == this.mDataCallBack) {
      console.error(this.TAG, `AudioCapturerUtil havent init`);
      return false;
    }
    return true;
  }

  protected canRelease(): boolean {
    if (null == this.mDataCallBack) {
      console.error(this.TAG, `AudioCapturerUtil havent init`);
      return;
    }
    return true;
  }

  protected afterStart() {
    if (null != this.mFile) {
      fileIo.closeSync(this.mFile);
    }
    this.mIsWriting = false;
  }

  private static async sleep(ms: number): Promise<void> {
    return new Promise<void>(resolve => setTimeout(resolve, ms));
  }
}

