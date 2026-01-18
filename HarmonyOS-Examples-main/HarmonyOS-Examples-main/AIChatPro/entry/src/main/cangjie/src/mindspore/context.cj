package ohos_app_cangjie_entry.mindspore

// c function
foreign func malloc(size: UIntNative): CPointer<Unit>
foreign func memset(p: CPointer<Unit>, value: Int32, size: UIntNative): CPointer<Unit>
foreign func memcpy(dst:CPointer<Unit>, src:CPointer<Unit>, size: UIntNative): CPointer<Unit>
foreign func free(ptr: CPointer<Unit>): Unit

public type OH_AI_ContextHandle = CPointer<Unit>;
// 原文档: https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_contexthandle
// typedef void* OH_AI_ContextHandle
// MindSpore的上下文信息的指针，该指针会指向Context。

public type OH_AI_DeviceInfoHandle = CPointer<Unit>;
// 原文档: https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_deviceinfohandle
// typedef void* OH_AI_DeviceInfoHandle
// MindSpore的运行设备信息的指针。

foreign func OH_AI_ContextCreate(): OH_AI_ContextHandle;
public func oh_ai_context_create(): OH_AI_ContextHandle {
  unsafe {OH_AI_ContextCreate()}
}
// 原文档： https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_contextcreate
// OH_AI_API OH_AI_ContextHandle OH_AI_ContextCreate ()
// 功能：创建一个上下文的对象。
// 返回：指向上下文信息的OH_AI_ContextHandle。

foreign func OH_AI_ContextDestroy(p_context: CPointer<OH_AI_ContextHandle>): Unit;
public func oh_ai_context_destroy(context: OH_AI_ContextHandle) {
  unsafe {
    // 创建一个p_context指针指向context,用于context释放
    var p_unit_context: CPointer<Unit> = malloc(sizeOf<OH_AI_ContextHandle>());
    var p_context: CPointer<OH_AI_ContextHandle> = CPointer<OH_AI_ContextHandle>(p_unit_context);
    p_context.write(context); // 相当于：*p_conetxt = context;
    OH_AI_ContextDestroy(p_context);
    // 执行完上面的不确定下面还有没有，保险起见判断一下再决定是否释放
    if (!p_unit_context.isNull()) {
      free(CPointer<Unit>(p_unit_context));
    }
  }

}
// 原文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_contextdestroy
// OH_AI_API void OH_AI_ContextDestroy (OH_AI_ContextHandle * context)
// 功能：释放上下文对象。
// 参数：context，指向OH_AI_ContextHandle的二级指针，上下文销毁后会对context置为空指针。

foreign func OH_AI_ContextAddDeviceInfo(context: OH_AI_ContextHandle, device_info: OH_AI_DeviceInfoHandle): Unit;
public func oh_ai_context_add_device_info(context: OH_AI_ContextHandle, device_info: OH_AI_DeviceInfoHandle): Unit {
  unsafe{OH_AI_ContextAddDeviceInfo(context, device_info)}
}
// 原文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_contextadddeviceinfo
// OH_AI_API void OH_AI_ContextAddDeviceInfo (OH_AI_ContextHandle context, OH_AI_DeviceInfoHandle device_info )
// 功能：将一个用户定义的运行设备信息附加到推理上下文中。
// 参数1：context，指向上下文信息实例的OH_AI_ContextHandle。
// 参数2：device_info，指向设备信息实例的OH_AI_DeviceInfoHandle。

foreign func OH_AI_DeviceInfoCreate(device_type: OH_AI_DeviceType): OH_AI_DeviceInfoHandle;
public func oh_ai_device_info_create(device_info: OH_AI_DeviceType): OH_AI_DeviceInfoHandle {
  unsafe{OH_AI_DeviceInfoCreate(device_info)}
}
// 原文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_deviceinfocreate
// OH_AI_API OH_AI_DeviceInfoHandle OH_AI_DeviceInfoCreate (OH_AI_DeviceType device_type)
// 功能：创建一个设备信息对象。
// 参数：device_type，设备类型, 具体见OH_AI_DeviceType。
// 返回：指向设备信息实例的OH_AI_DeviceInfoHandle。

foreign func OH_AI_DeviceInfoDestroy(device_info: CPointer<OH_AI_DeviceInfoHandle>): Unit
// 原文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_deviceinfodestroy
// OH_AI_API void OH_AI_DeviceInfoDestroy (OH_AI_DeviceInfoHandle * device_info)
// 功能：指向设备信息实例的OH_AI_DeviceInfoHandle。
// 注意：释放设备信息实例。注意：设备信息实例被添加到context后，无须调用者手动释放。
// 参数：device_info，指向设备信息实例的OH_AI_DeviceInfoHandle。

foreign func OH_AI_DeviceInfoSetEnableFP16(device_info: OH_AI_DeviceInfoHandle, is_fp16: Bool): Unit
public func oh_ai_device_info_set_enable_fp16(device_info: OH_AI_DeviceInfoHandle, is_fp16: Bool): Unit {
  unsafe{OH_AI_DeviceInfoSetEnableFP16(device_info, is_fp16)}
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_deviceinfosetenablefp16
// OH_AI_API void OH_AI_DeviceInfoSetEnableFP16 (OH_AI_DeviceInfoHandle device_info, bool is_fp16 )
// 功能：设置是否开启float16推理模式，仅CPU/GPU设备可用。
// 参数1：device_info 指向设备信息实例的OH_AI_DeviceInfoHandle。
// 参数2：是否开启float16推理模式。

foreign func OH_AI_DeviceInfoGetEnableFP16(device_info: OH_AI_DeviceInfoHandle): Bool;
public func oh_ai_device_info_get_enable_fp16(device_info: OH_AI_DeviceInfoHandle): Bool {
  unsafe{OH_AI_DeviceInfoGetEnableFP16(device_info)}
}
// 原文档: https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_deviceinfogetenablefp16
// OH_AI_API bool OH_AI_DeviceInfoGetEnableFP16 (const OH_AI_DeviceInfoHandle device_info)
// 功能：获取是否开启float16推理模式, 仅CPU/GPU设备可用。
// 参数：device_info 指向设备信息实例的OH_AI_DeviceInfoHandle。
// 返回：设置是否开启float16推理模式。



