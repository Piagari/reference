import { AbstractStrategyRouter } from "../AbstractStrategyRouter";
import { DynamicContext, RequestParams, ResponseParams } from "../Params"
import { StrUtil, ToastUtil } from "@pura/harmony-utils";
import { common } from "@kit.AbilityKit";
import { BusinessError } from "@kit.BasicServicesKit";
import { fileIo as fs, picker } from '@kit.CoreFileKit';
import { pdfService } from "@kit.PDFKit";
import { buffer } from '@kit.ArkTS';
import { hilog } from "@kit.PerformanceAnalysisKit";
import { Constants } from "../../constants/Constants";
import { FileUtils } from "../../utils/FileUtils";
import { LoadImageNode } from "./ImageSelectNodes";
import { OcrFileInfo } from "../../entryability/cjlib";
import { ICjObject } from "../ICjObject";

/*
 * 文件选择入口类
 * */
export class FileSelector implements ICjObject {
  private callback?: (info: OcrFileInfo, stage: number) => void;

  constructor(callback?: (info: OcrFileInfo, stage: number) => void) {
    this.callback = callback;
  }

  public exportToCj() {
    return (callback: (info: OcrFileInfo, stage: number) => void) => {
      this.callback = callback;
      this.apply();
    }
  }

  public async apply(): Promise<ResponseParams | null> {
    let startNode = new OpenFilesNode();
    return await startNode.apply(new RequestParams(), new DynamicContext(this.callback));
  }
}

/*
 * 责任链节点
 * */
export class OpenFilesNode extends AbstractStrategyRouter<RequestParams, DynamicContext, ResponseParams> {
  public get(requestParams: RequestParams, dynamicContext: DynamicContext):
    AbstractStrategyRouter<RequestParams, DynamicContext, ResponseParams> | null {
    return new TypeTransNode();
  }

  public async apply(requestParams: RequestParams, dynamicContext: DynamicContext): Promise<ResponseParams | null> {
    try {
      let context = getContext(this) as common.Context;
      let documentPicker = new picker.DocumentViewPicker(context);
      let arrSelectDocument: Array<string> = await documentPicker.select(Constants.documentOptions);
      for (let i = 0; i < arrSelectDocument.length; i++) {
        if (!StrUtil.isEmpty(arrSelectDocument[i])) {
          dynamicContext.uri = arrSelectDocument[i];
          console.info('OpenFilesNode', 'selectedDoc.uri: ' + dynamicContext.uri);
          break;
        }
      }
    } catch (error) {
      console.error('OpenFilesNode', 'DocumentViewPicker failed with err: ' + JSON.stringify(error as BusinessError));
    }
    return await this.router(requestParams, dynamicContext);
  }
}

export class TypeTransNode extends AbstractStrategyRouter<RequestParams, DynamicContext, ResponseParams> {
  private director: Map<string, AbstractStrategyRouter<RequestParams, DynamicContext, ResponseParams>> = new Map([
    ['pdf', new PdfNode()], ['txt', new TxtNode()],
    ['docx', new OfficeNode()], ['xlsx', new OfficeNode()],
    ['pptx', new OfficeNode()]
  ]);

  public get(requestParams: RequestParams, dynamicContext: DynamicContext):
    AbstractStrategyRouter<RequestParams, DynamicContext, ResponseParams> | null {
    let nextNode = this.director.get(dynamicContext.type);
    return nextNode === undefined ? null : nextNode;
  }

  public async apply(requestParams: RequestParams, dynamicContext: DynamicContext): Promise<ResponseParams | null> {
    if (dynamicContext.uri == '') {
      ToastUtil.showToast('没有选择文件')
      return null;
    }
    dynamicContext.execCallback(Constants.UPLOADING);
    let splits = dynamicContext.uri.split('.');
    dynamicContext.type = splits[splits.length - 1]
    dynamicContext.sandBoxPath = getContext().cacheDir + '/' + FileUtils.generateFileName(dynamicContext.type);
    console.info('TypeTransNode', `sandBoxPath: ${dynamicContext.sandBoxPath}`)
    // 复制文件到沙盒路径
    if (!FileUtils.copyFileToSandbox(dynamicContext.uri, dynamicContext.sandBoxPath)) {
      ToastUtil.showToast('复制文件到沙箱失败')
      return null;
    }
    return this.router(requestParams, dynamicContext);
  }
}

export class TxtNode extends AbstractStrategyRouter<RequestParams, DynamicContext, ResponseParams> {
  public get(requestParams: RequestParams, dynamicContext: DynamicContext):
    AbstractStrategyRouter<RequestParams, DynamicContext, ResponseParams> | null {
    return null;
  }

  public async apply(requestParams: RequestParams, dynamicContext: DynamicContext): Promise<ResponseParams | null> {
    try {
      dynamicContext.execCallback(Constants.PARSING);
      let file = fs.openSync(dynamicContext.sandBoxPath, fs.OpenMode.READ_ONLY);
      if (file) {
        let arrayBuffer = new ArrayBuffer(2048);
        let buf = buffer.from(arrayBuffer, 0, fs.readSync(file.fd, arrayBuffer));
        console.info(`The content of file读取TxT文件: ${buf.toString()}`);
        fs.closeSync(file);
        dynamicContext.result = buf.toString();
      }
    } catch (e) {
      console.error('TxtNode', 'exception: ' + JSON.stringify(e))
    }
    return this.router(requestParams, dynamicContext);
  }
}

export class PdfNode extends AbstractStrategyRouter<RequestParams, DynamicContext, ResponseParams> {
  public get(requestParams: RequestParams, dynamicContext: DynamicContext):
    AbstractStrategyRouter<RequestParams, DynamicContext, ResponseParams> | null {
    // 这里走了图像处理流程的责任链
    return new LoadImageNode();
  }

  public async apply(requestParams: RequestParams, dynamicContext: DynamicContext): Promise<ResponseParams | null> {
    try {
      dynamicContext.execCallback(Constants.PARSING);
      // 加载PDF文件
      const pdfDocument = new pdfService.PdfDocument();

      if (pdfDocument.loadDocument(dynamicContext.sandBoxPath)) {
        ToastUtil.showToast('加载PDF文件失败')
        return null;
      }
      // 将第一页转换为图像,转换后的路径为imagePath/1.png
      const imagePath = `${getContext().cacheDir}`;
      if (!pdfDocument.convertToImage(imagePath, 0)) {
        ToastUtil.showToast('转换PDF页面为图像失败');
        return null;
      }
      // 如果name为'' uri是默认的name
      // 这里pdf的uri变成图片的uri了 所以name设置为原本的uri 维持name不变
      dynamicContext.name = dynamicContext.uri;
      dynamicContext.uri = `${imagePath}/1.png`;
    } catch (e) {
      hilog.error(0, 'OcrWithPdf', 'exception: ' + JSON.stringify(e))
    }
    return this.router(requestParams, dynamicContext);
  }
}

export class OfficeNode extends AbstractStrategyRouter<RequestParams, DynamicContext, ResponseParams> {
  public get(requestParams: RequestParams, dynamicContext: DynamicContext):
    AbstractStrategyRouter<RequestParams, DynamicContext, ResponseParams> | null {
    throw new Error("Method not implemented.");
  }

  public apply(requestParams: RequestParams, dynamicContext: DynamicContext): Promise<ResponseParams | null> {
    return this.router(requestParams, dynamicContext);
  }
}
