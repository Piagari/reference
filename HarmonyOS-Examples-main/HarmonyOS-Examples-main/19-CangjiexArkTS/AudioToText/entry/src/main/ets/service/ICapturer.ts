'use strict';

export interface ICapturer {

  init(dataCallBack: (data: ArrayBuffer) => void);

  start();

  stop();

  release();
}