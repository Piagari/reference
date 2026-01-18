import { ToastUtil } from "@pura/harmony-utils";
import { fileIo as fs } from '@kit.CoreFileKit';
import { hilog } from "@kit.PerformanceAnalysisKit";

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
          ToastUtil.showToast('failed to copy file into sandbox')
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
  public static copyFileToSandbox(sourcePath: string, sandboxPath: string): boolean {
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

  public static isInSandbox(path: string) {
    return path.startsWith(getContext().cacheDir);
  }

  public static getExt(uri: string) {
    return uri.substring(uri.lastIndexOf('.') + 1);
  }

  public static generateFileName(extension = "txt") {
    // 获取当前时间的时间戳（单位为毫秒）
    const timestamp = Date.now();
    // 构造文件名，格式为 "timestamp.extension"
    const fileName = `${timestamp}.${extension}`;
    return fileName;
  }

}
