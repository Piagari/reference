import { image } from '@kit.ImageKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = 'UTILS';

export async function copyImg2Sandbox(src: string, path: string): Promise<string> {
  let srcImage = fs.openSync(src, fs.OpenMode.READ_ONLY);
  let destImage = fs.openSync(path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.copyFileSync(srcImage.fd, destImage.fd);
  fs.closeSync(srcImage);
  fs.closeSync(destImage);
  return path;
}


export function pixelMap2File(pixelMap: image.PixelMap | undefined, path: string): Promise<void> {
  const imagePacker = image.createImagePacker();
  let file = fs.openSync(path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  let packOpts : image.PackingOption = { format: 'image/jpeg', quality: 98 };
  return imagePacker.packToFile(pixelMap, file.fd, packOpts).then(() => {
    hilog.info(0x0000, TAG, 'packToFile succeed!');
    fs.closeSync(file.fd);
  }).catch((error: BusinessError) => {
    hilog.error(0x0000, TAG, 'packToFile failed, error: ' + JSON.stringify(error));
  });
}