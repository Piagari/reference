import { photoAccessHelper } from "@kit.MediaLibraryKit"
import { camera, cameraPicker } from "@kit.CameraKit"
import { picker } from "@kit.CoreFileKit"
import { promptAction } from "@kit.ArkUI"


export class Constants {

  public static UPLOADING: number = 0

  public static PENDING: number = 1

  public static PARSING: number = 2

  public static FINISHED: number = 3

  public static FAILED: number = 4

  public static INVALID: number = -1

  public static photoOptions: photoAccessHelper.PhotoSelectOptions = {
    MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE,
    maxSelectNumber: 1
  }

  public static photoPickerProfile: cameraPicker.PickerProfile = {
    cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK
  };

  public static supportedDocTypes: Array<string> = [
    ".pdf", ".txt", ".docx", ".xlsx", ".pptx"
  ];


  public static documentOptions: picker.DocumentSelectOptions = {
    selectMode: picker.DocumentSelectMode.FILE,
    fileSuffixFilters: Constants.supportedDocTypes,
    maxSelectNumber: 3,
  }

  public static photoTakeProfile: cameraPicker.PickerProfile = {
    cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK
  };

  public static defaultShowToastOption(msg: string): promptAction.ShowToastOptions {
    return {
      message: msg,
      duration: 1500,
      offset: { dx: 0, dy: -80 }
    }
  }

}