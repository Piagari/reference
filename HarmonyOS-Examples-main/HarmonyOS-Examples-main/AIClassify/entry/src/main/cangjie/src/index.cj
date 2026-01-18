package ohos_app_cangjie_entry

internal import ohos.base.AsyncError
internal import ohos.base.LengthProp
internal import ohos.base.CJResource
internal import ohos.base.__GenerateResource__
internal import ohos.base.Length
internal import ohos.base.Color
internal import ohos.concurrency.launch
internal import ohos.component.Blank
internal import ohos.component.Button
internal import ohos.component.Column
internal import ohos.component.CustomView
internal import ohos.component.CJEntry
internal import ohos.component.FontWeight
internal import ohos.component.ForEach
internal import ohos.component.FlexAlign
internal import ohos.component.ListItem
internal import ohos.component.List
internal import ohos.component.If
internal import ohos.component.Image
internal import ohos.component.ImageFit
internal import ohos.component.loadNativeView
internal import ohos.component.LegalCallCheck
internal import ohos.component.Row
internal import ohos.component.Text
internal import ohos.component.TextAlign
internal import ohos.file_picker.PhotoViewPicker
internal import ohos.file_picker.PhotoViewMIMETypes
internal import ohos.file_picker.PhotoSelectOptions
internal import ohos.file_picker.PhotoSelectResult
internal import ohos.file_fs.*
internal import ohos.file_fileuri.FileUri
internal import ohos.image.AlphaType
internal import ohos.image.createImageSource
internal import ohos.image.createPixelMap
internal import ohos.image.PixelMap
internal import ohos.image.PixelMapFormat
internal import ohos.image.ImageInfo
internal import ohos.image.InitializationOptions
internal import ohos.image.Region
internal import ohos.image.ScaleMode
internal import ohos.image.Size
internal import ohos.prompt_action.*
internal import ohos.resource_manager.ResourceManager
internal import ohos.state_manage.LocalStorage
internal import ohos.state_manage.ObservedProperty
internal import ohos.state_manage.ObservedArrayList
internal import ohos.state_manage.SubscriberManager
internal import ohos.state_manage.ViewStackProcessor
internal import ohos.ability_access_ctrl.*

import ohos.state_macro_manage.Entry
import ohos.state_macro_manage.Component
import std.random.Random

import ohos.state_macro_manage.State
import ohos.state_macro_manage.r
import ohos.state_macro_manage.rawfile
import ohos.hilog.Hilog
import std.collection.ArrayList

internal import ohos.bundle_manager.BundleManager
internal import ohos.bundle_manager.BundleFlag
internal import ohos.bundle_manager.BundleInfo

// custom import
import ohos_app_cangjie_entry.common.CommonConstants


@Entry
@Component
class MyView {
  @State
  var photo_url_list: ObservedArrayList<String> = ObservedArrayList<String>([])
  @State
  var max_value: Float32 = 0.0
  @State
  var max_array: ArrayList<Int64> = ArrayList<Int64>([])  // 前n个最大值
  @State
  var max_index_array: ArrayList<Int64> = ArrayList<Int64>([]) // 前n个最大值所在索引
  @State
  var model_status: Bool = false
  // 随机图片地址
  @State
  var random_image_path: Option<CJResource> = Option<CJResource>.None
  // 是否使用随机图片，记录一下这个状态
  private var use_random_image: Bool = false
  // 是否选择了图片，记录一下这个状态
  // private var has_select_image: Bool = false;
  // 计算单通道图片面积
  private let image_area = Int64(CommonConstants.MODEL_INPUT_HEIGHT) * Int64(CommonConstants.MODEL_INPUT_WIDTH)
  // 储存图片选择结果
  private var image_buffer: Option<Array<UInt8>> = Option<Array<UInt8>>.None
  // 由于真机只能选一次图片，再选就会挂掉，所以加一个参数来记录
  private var is_first_select = true
  // 准备模型
  let ms_model = Model()

  func logInfo(tag: String, message: String) {
    Hilog.info(0, tag, message)
  }

  func handleErrorAndUseRandomImage() {
    this.use_random_image = true
    this.image_buffer = Some(this.get_random_pixel_map())
    launch {
      PromptAction.showToast(message: "image read failed, use random image replace it\n 图片读取失败，使用随机图片")
    }
  }

  func request_permission_callback(error_code: Option<AsyncError>, data: Option<PermissionRequestResult>) {
    match (error_code) {
      case Some(e) => Hilog.info(0, "request permission" ,"===== permissionResultCallBack request error: errcode is ${e.code} =====")
      case _ =>
        match (data) {
          case Some(value) =>
            for (i in (0..value.permissions.size)) {
              Hilog.info(0, "request permission", "===== permissionResultCallBack: ${value.permissions[i]} - ${value.authResults[i]}=====")
            }
          case _ => Hilog.error(0, "request permission","===== permissionResultCallBack request error: data is null ===== ")
      }
    }
	}

  func check_permission() {
    let atManager = AbilityAccessCtrl.createAtManager()
    let bundle_info: BundleInfo = BundleManager.getBundleInfoForSelf(BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION.getValue())
    let token_id = bundle_info.appInfo.accessTokenId

    let permissions = [
      "ohos.permission.READ_IMAGEVIDEO",
      "ohos.permission.READ_MEDIA",
      "ohos.permission.FILE_ACCESS_PERSIST"
    ]

    let stage_context = getStageContext(get_context())

    for (perm in permissions) {
      match (atManager.checkAccessToken(token_id, perm)) {
        case PERMISSION_DENIED =>
          Hilog.error(0, "check", "====== ${perm} PERMISSION_DENIED =====")
          let permission_list = Array<String>([perm])
          atManager.requestPermissionsFromUser(stage_context, permission_list, this.request_permission_callback)
        case PERMISSION_GRANTED =>
          Hilog.info(0, "check", "====== ${perm} PERMISSION_GRANTED =====")
      }
    }
  }

  protected func aboutToAppear() {
    this.ms_model.malloc_input_buffer()
    this.logInfo("aboutToAppear", "==== mallloc input buffer ok =====")
    this.ms_model.load_model_buffer()
    this.logInfo("aboutToAppear", "==== load model buffer ok =====")
  }

  protected func onPageShow() {
    this.check_permission()
  }

  protected func aboutToDisappear() {
    this.ms_model.free()
  }

  func get_random_pixel_map(): Array<UInt8> {
    // 使用rawfile下面的随机图片，以及对应图片提前解码好的数组来解决模拟器图库读取失败的问题
    this.logInfo("get_image", "==== get_random_pixel_map =====")
    let stage_context = getStageContext(get_context())
    let resource_manager = ResourceManager.getResourceManager(stage_context)
    // 从https://www.pexels.com/zh-cn/ 无版权网站，随机拿一张图片
    let image_id = Random().nextUInt8() % 12 + 1
    let file_name = if (image_id >= 10) {"0${image_id}"} else {"00${image_id}"}
    let image_name = "${file_name}.jpg"
    let image_data = "${file_name}.bin"
    let image_path = match (image_id) {
      case 1 => @rawfile("001.jpg")
      case 2 => @rawfile("002.jpg")
      case 3 => @rawfile("003.jpg")
      case 4 => @rawfile("004.jpg")
      case 5 => @rawfile("005.jpg")
      case 6 => @rawfile("006.jpg")
      case 7 => @rawfile("007.jpg")
      case 8 => @rawfile("008.jpg")
      case 9 => @rawfile("009.jpg")
      case 10 => @rawfile("010.jpg")
      case 11 => @rawfile("011.jpg")
      case _ => @rawfile("012.jpg")
    }
    this.random_image_path = Some(image_path)
    let image_buffer = resource_manager.getRawFileContent(image_data)
    return image_buffer
  }

  func process_image(pixel_map: PixelMap): Array<UInt8> {
    // 处理图片
    this.logInfo("read_image","===== MS_LITE_LOG: prepare get image info =====")
    // 获取图片信息
    let image_info: ImageInfo = pixel_map.getImageInfo()
    this.logInfo("read_image","===== MS_LITE_LOG: image_info.width is: ${image_info.size.width} =====")
    this.logInfo("read_image","===== MS_LITE_LOG: image_info.height is: ${image_info.size.height} =====")
    // 图片缩放到指定尺寸
    pixel_map.scale(
      CommonConstants.MAX_ZOOM_VALUE / Float32(image_info.size.width),
      CommonConstants.MAX_ZOOM_VALUE / Float32(image_info.size.height),
    )
    // 裁剪图片到模型需要的尺寸
    pixel_map.crop(
      Region(
        Size(height: CommonConstants.MODEL_INPUT_HEIGHT, width: CommonConstants.MODEL_INPUT_WIDTH),
        CommonConstants.X_COORDINATE,
        CommonConstants.Y_COORDINATE,
      )
    )
    // 创建一个4通道图片的buffer，用于以后图片数据读入(因为不确定用户上传的是jpg还是png,以4通道做数据读入）
    let input_uint8_buffer: Array<UInt8> = Array<UInt8>(image_area * 4, {_: Int64 => 0})
    // 再次获取图片数据，看看其尺寸对不对
    let image_info2 = pixel_map.getImageInfo()
    this.logInfo("read_image","===== MS_LITE_LOG: image_info2 width is: ${image_info2.size.width} =====")
    this.logInfo("read_image","===== MS_LITE_LOG: image_info2 height is: ${image_info2.size.height} =====")
    pixel_map.readPixelsToBuffer(input_uint8_buffer)
    this.logInfo("read_iamge", "===== MS_LITE_LOG: Succeeded in reading image pixel; buffer byte size: ${input_uint8_buffer.size} =====")
    return input_uint8_buffer
  }

  func photo_result_callback(errorCode: Option<AsyncError>, data: Option<PhotoSelectResult>): Unit {
    match (errorCode) {
      case Some(e) => Hilog.error(0, "select_image", "===== photo select error: errcode is ${e.code} =====")
      case _ =>
        match (data) {
          case Some(value) =>
            Hilog.info(0, "select_image", "===== photoUris is ${value.photoUris} =====")
            Hilog.info(0, "select_iamge", "===== isOriginalPhoto is ${value.isOriginalPhoto} =====")

            let temp_image_buffer: Array<UInt8> = try {
              let file = FileFs.open(value.photoUris[0], mode: OpenMode.READ_ONLY.mode)
              let image_source = createImageSource(file.fd)
              let pixel_map = image_source.createPixelMap()

                    launch { PromptAction.showToast(message: "select image success\n 图片选择成功") }

              let image_buffer = this.process_image(pixel_map)
              this.use_random_image = false
              image_buffer
            } catch (e: Exception) {
              this.use_random_image = true
              this.get_random_pixel_map()
            }

            this.image_buffer = Some(temp_image_buffer)
            this.photo_url_list.clear()
            for (photo_url in value.photoUris) {
              this.photo_url_list.append(photo_url)
            }

            launch {
              if (this.use_random_image) {
                PromptAction.showToast(message: "image read failed, use random image replace it\n 图片读取失败，使用随机图片")
              } else {
                PromptAction.showToast(message: "image select ok\n 图片选择成功")
              }
            }
          case _ => Hilog.info(0, "select_image", "===== photo select error: data is null =====")
        }
    }
  }


  func photo_picker() {
    // 第一次调用图片选择器，其他时间调用随机图片
    if (is_first_select) {
      // 调用图片选择器
      let actualContext: AbilityContext = get_context()
      // 创建图片文件选择实例
      let picker = PhotoViewPicker(actualContext)
      // 只允许选择图片，且只能选取一张图片
      let option = PhotoSelectOptions(MIMEType: PhotoViewMIMETypes.IMAGE_TYPE, maxSelectNumber: 1)
      picker.select(photo_result_callback, option: option)
      this.is_first_select = false
    } else {
      this.image_buffer = Some(this.get_random_pixel_map())
      this.use_random_image = true
      launch {
        PromptAction.showToast(message: "image read failed, use random image replace it\n 图片读取失败，使用随机图片")
      }
    }
  }

  func load_model() {
    // 加载模型
    // 先选择图片再编译模型，防止上下文切换导致闪退
    // 如果未加载过模型，才对模型进行编译和加载
    if (model_status || !ms_model.is_empty_model()) {return}

    let success = ms_model.build_model()
    model_status = success

    if (success) {
      ms_model.bind_io()
      launch { PromptAction.showToast(message: "编译模型成功！绑定输入输出完成") }
    } else {
      launch { PromptAction.showToast(message: "编译模型失败，请退出应用重试") }
    }
  }

  func run_model_inference() {
    if (this.image_buffer.isNone()) {
      launch {PromptAction.showToast(message: "No selected image\n未选择图片")}
      return
    }
    // 功能：模型推理
    // 先编译一下模型（如果模型已经编译，则会自动跳过）
    this.load_model()
    if (this.model_status && this.image_buffer.isSome()) {
      let res = this.ms_model.inference(this.image_buffer.getOrThrow())
      launch {
        this.max_value = res[0]
        this.max_array.clear()
        this.max_index_array.clear()
        this.max_array.appendAll(res[1])
        this.max_index_array.appendAll(res[2])
      }
    } else if(!this.model_status) {
      PromptAction.showToast(message: "build model failed! please quit APP and retry\n 编译模型失败！请退出应用重试")
      this.logInfo("aboutToAppear", "==== bind model failed =====")
    } else {
      PromptAction.showToast(message: "No selected image\n未选择图片")
    }
  }

  func build() {
     Column() {
       Text(@r(app.string.EntryAbility_label))
        .width(CommonConstants.FULL_PERCENT)
        .fontSize(32)
        .fontWeight(FontWeight.W700)
        .margin(
          top: 32.vp,
          left: 16.vp,
          bottom: 16.vp
        )

       if (this.photo_url_list.size > 0 && this.random_image_path.isNone()){
         Image(this.photo_url_list[0])
           .height(@r(app.float.image_height))
           .objectFit(ImageFit.Contain)
           .borderRadius(10)
           .margin(
             bottom: 16.vp,
             left: 16.vp,
             right: 16.vp
           )
       }
       // 使用随机图片
       if (this.random_image_path.isSome()) {
          Image(this.random_image_path.getOrThrow())
           .height(@r(app.float.image_height))
           .objectFit(ImageFit.Contain)
           .borderRadius(10)
           .margin(
             bottom: 16.vp,
             left: 16.vp,
             right: 16.vp
           )
       }
       if (this.max_value > 0.0) {
          List() {
            ForEach(this.max_index_array, itemGeneratorFunc: {
              item: Int64, index: Int64 =>
                ListItem() {
                  Row() {
                    Text("${CommonConstants.LABELS_NAME_MAP[item]}（${CommonConstants.LABELS_ZH_NAME_MAP[item]}）: ")
                      .fontSize(@r(app.float.common_font_size))
                      .fontWeight(FontWeight.W500)
                      .fontFamily(@r(app.string.Font_family_black))
                    Text("${this.max_array[index] / 100} %")
                      .fontSize(@r(app.float.common_font_size))
                      .fontWeight(FontWeight.W500)
                      .fontFamily(@r(app.string.Font_family_black))
                      .textAlign(TextAlign.End)
                  }.width(CommonConstants.FULL_PERCENT).justifyContent(FlexAlign.SpaceBetween)
                }.height(@r(app.float.list_item_height))
            })
          }
           .backgroundColor(@r(app.color.list_background))
           .borderRadius(8)
           // 下面两行任意一行会崩溃，不知道为啥（新版貌似正常了）
           // .divider(strokeWidth: 0.5.vp, color: Color.GRAY)
           .divider(strokeWidth: 0.5.vp, color: @r(app.color.five_black))
           .padding(left: 12, right: 12)
           .width(@r(app.float.list_width))
           .height(@r(app.float.list_height))
       } else {
         Blank()
           .width(@r(app.float.blank_width))
           .height(@r(app.float.blank_height))
       }
       Row{
         // 选择图片
         Button(@r(app.string.select_photo_button))
           .width(@r(app.float.button_width))
           .height(@r(app.float.button_height))
           .margin(
             top: 24.vp, left: 24.vp, right: 12.vp
           )
           .onClick({ =>
             this.max_value = 0.0
             this.image_buffer = Option<Array<UInt8>>.None
             this.photo_picker()
           })
         // 运行模型
         Button(@r(app.string.run_model_button))
             .width(@r(app.float.button_width))
             .height(@r(app.float.button_height))
             .margin(
               top: 24.vp, left: 12.vp, right: 24.vp
             )
             .onClick({=>
                this.run_model_inference()
                // 模型推理后，清空图片缓存
                this.image_buffer = Option<Array<UInt8>>.None
             })
       }
     }
  }
}