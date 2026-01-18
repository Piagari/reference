import { CJHybridComponentV2 } from 'cjhybridview';
import { requireCJLib } from 'libark_interop_loader.so';
import { CustomLib } from 'libark_interop_api.so';
import { AudioRecognizer } from '../service/impl/AudioRecognizer';
import { IRecognizer } from '../service/IRecognizer';
import { FileRecognizer } from '../service/impl/FileRecognizer';

let cjlib = requireCJLib("libohos_app_cangjie_entry.so") as CustomLib

@Entry
@Component
struct Index {
  private recognizers:[IRecognizer, string][]  = [
    [new AudioRecognizer(), 'startAudioRecognize'],
    [new FileRecognizer(), 'startFileRecognize']
  ]

  aboutToAppear(): void {
    for (const recognizerTuple of this.recognizers) {
      recognizerTuple[0].createEngine();
      cjlib.registerJSFunc(recognizerTuple[1], recognizerTuple[0].exportToCj());
    }
  }

  aboutToDisappear(): void {
    for (const recognizerTuple of this.recognizers) {
      recognizerTuple[0].shutdown();
      cjlib.unregisterJSFunc(recognizerTuple[1])
    }
  }

  build() {
    Column() {
      CJHybridComponentV2({
        library: 'ohos_app_cangjie_entry',
        component: 'AudioTransform'
      })
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
  }
}