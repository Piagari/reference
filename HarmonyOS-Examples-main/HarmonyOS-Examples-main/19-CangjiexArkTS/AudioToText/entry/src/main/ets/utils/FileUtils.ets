import { fileIo as fs, picker } from '@kit.CoreFileKit';
import { hilog } from "@kit.PerformanceAnalysisKit";
import { Constants } from '../constant/Cosntant';
import { BusinessError } from '@kit.BasicServicesKit';

export class FileUtils {
  public static getFileName(path: string) {
    let pos = path.lastIndexOf('/');
    return path.substring(pos + 1);
  }

  public static getFileSize(path: string): number {
    try {
      if (!FileUtils.isInSandbox(path)) {
        const sandboxPath = getContext().cacheDir + '/' + Date.now() + '.copy'; // 定义沙盒路径
        // 复制文件到沙盒路径
        const copySuccess = FileUtils.copyFileToSandbox(path, sandboxPath);
        if (!copySuccess) {
          // ToastUtil.showToast('failed to copy file into sandbox')
          return 0;
        }
        path = sandboxPath;
      }
      // 获取文件大小
      let fileStat = fs.statSync(path);
      let fileSize = fileStat.size;
      hilog.info(0, 'FileUtils', `file read successfully. total size: ${fileSize}`);
      return fileSize;
    } catch (e) {
      hilog.error(0, 'FileUtils', 'exception: ' + JSON.stringify(e))
      return 0;
    }
  }

  /**
   * 将源文件文件复制到沙箱路径
   */
  private static copyFileToSandbox(sourcePath: string, sandboxPath: string): boolean {
    try {
      let originFile: fs.File = fs.openSync(sourcePath, fs.OpenMode.READ_ONLY);
      let newFile: fs.File =
        fs.openSync(sandboxPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      let buf = new ArrayBuffer(fs.statSync(originFile.fd).size);
      fs.readSync(originFile.fd, buf)
      fs.writeSync(newFile.fd, buf)
      fs.closeSync(newFile);
      fs.closeSync(originFile);
      return true;
    } catch (error) {
      hilog.error(0, 'FileUtils', 'failed to copy file: ' + error);
      return false;
    }
  }

  // 新增：专门处理音频文件的沙箱复制
  public static async copyAudioToSandbox(sourcePath: string): Promise<string> {
    try {
      const context = getContext();
      const ext = sourcePath.substring(sourcePath.lastIndexOf('.') + 1);
      const sandboxPath = context.cacheDir + '/audio_' + Date.now() + '.' + ext;

      const originFile = fs.openSync(sourcePath, fs.OpenMode.READ_ONLY);
      const newFile = fs.openSync(sandboxPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);

      const buf = new ArrayBuffer(fs.statSync(originFile.fd).size);
      fs.readSync(originFile.fd, buf);
      fs.writeSync(newFile.fd, buf);

      fs.closeSync(newFile);
      fs.closeSync(originFile);
      return sandboxPath;
    } catch (error) {
      // ToastUtil.showToast('复制音频文件失败');
      console.error('AudioCopyError', JSON.stringify(error));
      return '';
    }
  }

  public static isInSandbox(path: string) {
    return path.startsWith(getContext().cacheDir);
  }

  public static getExt(uri: string) {
    return uri.substring(uri.lastIndexOf('.') + 1);
  }

  // 新增：检查是否为支持的音频格式
  public static isSupportedAudioType(uri: string): boolean {
    const ext = uri.substring(uri.lastIndexOf('.') + 1).toLowerCase();
    return Constants.supportedAudioTypes.includes(ext);
  }

  public static async openAudioPicker(ctx: object): Promise<string[]> {
    let uris: string[] = [];
    try {
      const context = getContext(ctx);
      const audioPicker = new picker.DocumentViewPicker(context);

      const selectedFiles = await audioPicker.select({
        selectMode: picker.DocumentSelectMode.FILE,
        fileSuffixFilters: Constants.supportedAudioTypes,
        maxSelectNumber: 1 // 每次只允许选择一个文件
      });

      uris = selectedFiles.filter(uri => uri?.length > 0);
      console.info('AudioPicker', 'Selected files: ' + uris);
    } catch (error) {
      console.error('AudioPickerError', JSON.stringify(error as BusinessError));
    }
    return uris;
  }

  public static getAudioType(fileUri: string): string {
    if (fileUri.endsWith('.wav')) return 'wav';
    if (fileUri.endsWith('.mp3')) return 'mp3';
    if (fileUri.endsWith('.aac')) return 'aac';
    return 'pcm'; // 默认PCM格式
  }
}