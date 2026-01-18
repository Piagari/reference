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

foreign func OH_AI_ContextSetThreadNum (context: OH_AI_ContextHandle, thread_num: Int32): Unit;
public func oh_ai_context_set_threadnum(context: OH_AI_ContextHandle, thread_num: Int32): Unit {
  unsafe {OH_AI_ContextSetThreadNum(context, thread_num)}
}
// 原文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_contextsetthreadnum
// OH_AI_API void OH_AI_ContextSetThreadNum (OH_AI_ContextHandle context, int32_t thread_num )
// 功能：设置运行时的线程数量。
// 参数1：context 指向上下文信息实例的OH_AI_ContextHandle
// 参数2：thread_num  运行时的线程数量。

foreign func OH_AI_ContextGetThreadNum(context: OH_AI_ContextHandle): Int32;
public func oh_ai_context_get_thread_num(context: OH_AI_ContextHandle) {
  unsafe {OH_AI_ContextGetThreadNum(context)}
}
// 原文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_contextgetthreadnum
// OH_AI_API int32_t OH_AI_ContextGetThreadNum (const OH_AI_ContextHandle context)
// 功能：获取线程数量。
// 参数：context  指向上下文信息实例的OH_AI_ContextHandle
// 返回：当前的线程数量。

foreign func OH_AI_ContextSetThreadAffinityMode(context: OH_AI_ContextHandle, mode: Int32): Unit;
public func oh_ai_context_set_thread_affinity_mode(context: OH_AI_ContextHandle, mode: Int32): Unit {
  unsafe {OH_AI_ContextSetThreadAffinityMode(context, mode)}
}
// 原文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_contextsetthreadaffinitymode
// OH_AI_API void OH_AI_ContextSetThreadAffinityMode (OH_AI_ContextHandle context, int mode )
// 参数1：context	指向上下文信息实例的OH_AI_ContextHandle。
// 参数2： mode	绑核策略。一共有三种策略，0为不绑核, 1为大核优先, 2为中核优先。

foreign func OH_AI_ContextGetThreadAffinityMode(context: OH_AI_ContextHandle): Int32;
public func oh_ai_context_get_thread_affinity_mode(context: OH_AI_ContextHandle): Int32 {
  unsafe {OH_AI_ContextGetThreadAffinityMode(context)}
}
// 原文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_contextgetthreadaffinitymode
// OH_AI_API int OH_AI_ContextGetThreadAffinityMode (const OH_AI_ContextHandle context)
// 功能：获取运行时线程绑定CPU核心的策略。
// 参数：context	指向上下文信息实例的OH_AI_ContextHandle。
// 返回：绑核策略。一共有三种策略，0为不绑核, 1为大核优先, 2为中核优先。

foreign func OH_AI_ContextSetThreadAffinityCoreList(context: OH_AI_ContextHandle, core_list: CPointer<Int32>, core_num: UIntNative): Unit;
public func oh_ai_context_set_thread_affinity_core_list(context: OH_AI_ContextHandle, core_list: Array<Int32>): Unit {
  let void_core_list: CPointer<Unit> = unsafe{malloc(sizeOf<Int32>() * UIntNative(core_list.size))};
  let p_core_list: CPointer<Int32> = unsafe{CPointer<Int32>(void_core_list)};
  let core_num = UIntNative(core_list.size);
  unsafe {
    var temp_p: CPointer<Int32> = p_core_list;
    for (i in 0..core_list.size) {
      temp_p.write(core_list[i]);
      temp_p = temp_p + 1;
    }
    OH_AI_ContextSetThreadAffinityCoreList(context, p_core_list, core_num);
    free(void_core_list);
  }
}
// 原文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_contextsetthreadaffinitycorelist
// OH_AI_API void OH_AI_ContextSetThreadAffinityCoreList (OH_AI_ContextHandle context, const int32_t * core_list, size_t core_num )
// 功能：设置运行时线程绑定CPU核心的列表。
// 例如：当core_list=[2,6,8]时，则线程会在CPU的第2,6,8个核心上运行。 如果对于同一个上下文对象，
// 调用了OH_AI_ContextSetThreadAffinityMode和OH_AI_ContextSetThreadAffinityCoreList 这两个函数，
// 则仅OH_AI_ContextSetThreadAffinityCoreList的core_list参数生效，
// 而OH_AI_ContextSetThreadAffinityMode的 mode参数不生效。
// 参数1：context	指向上下文信息实例的OH_AI_ContextHandle。
// 参数2：core_list	CPU绑核的列表。
// 参数3：core_num	核的数量，它就代表core_list的长度。


foreign func OH_AI_ContextGetThreadAffinityCoreList(context: OH_AI_ContextHandle, core_num: CPointer<UIntNative> ): CPointer<Int32>;
public func oh_ai_context_get_thread_affinity_core_list(context: OH_AI_ContextHandle): Array<Int32> {
  let void_core_num: CPointer<Unit> = unsafe{malloc(sizeOf<UIntNative>())};
  let p_core_num: CPointer<UIntNative> = unsafe{CPointer<UIntNative>(void_core_num)};
  let p_core_list: CPointer<Int32> = unsafe {
    OH_AI_ContextGetThreadAffinityCoreList(context, p_core_num)
  };
  var temp_p: CPointer<Int32> = p_core_list;
  let data_size: Int64 = Int64(unsafe{p_core_num.read()})
  let result_array: Array<Int32> = Array<Int32>(data_size, {_=>0});
  unsafe {
    for (i in 0..data_size) {
      result_array[i] = temp_p.read();
      temp_p = temp_p + 1;
    }
  }
  // destory p
  unsafe{
    free(void_core_num);
  }
  return result_array;
}
// 原文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_contextgetthreadaffinitycorelist
// OH_AI_API const int32_t* OH_AI_ContextGetThreadAffinityCoreList (const OH_AI_ContextHandle context, size_t * core_num )
// 获取CPU绑核列表。
// 参数1：context	指向上下文信息实例的OH_AI_ContextHandle。
// 参数2：core_num	该参数是输出参数，表示核的数量。
// CPU绑核列表。此列表对象由OH_AI_ContextHandle管理，调用者无须手动释放。

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
public func oh_ai_device_info_destory(device_info: OH_AI_DeviceInfoHandle): Unit {
  let temp_p: CPointer<OH_AI_DeviceInfoHandle> = unsafe{
    CPointer<OH_AI_DeviceInfoHandle>(malloc(sizeOf<OH_AI_DeviceInfoHandle>()))
  };
  unsafe {
    // *temp_p = device_info
    temp_p.write(device_info);
    OH_AI_DeviceInfoDestroy(temp_p);
    free(CPointer<Unit>(temp_p));
  }
}
// 原文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_deviceinfodestroy
// OH_AI_API void OH_AI_DeviceInfoDestroy (OH_AI_DeviceInfoHandle * device_info)
// 功能：指向设备信息实例的OH_AI_DeviceInfoHandle。
// 注意：释放设备信息实例。注意：设备信息实例被添加到context后，无须调用者手动释放。
// 参数：device_info，指向设备信息实例的OH_AI_DeviceInfoHandle。

foreign func OH_AI_DeviceInfoSetProvider(device_info: OH_AI_DeviceInfoHandle, provider: CString): Unit;
public func oh_ai_device_info_set_provider(device_info: OH_AI_DeviceInfoHandle, provider: CString): Unit {
  unsafe {OH_AI_DeviceInfoSetProvider(device_info, provider)}
}
// 原文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_deviceinfosetprovider
// OH_AI_API void OH_AI_DeviceInfoSetProvider (OH_AI_DeviceInfoHandle device_info, const char * provider )
// 功能：设置生产商的名称。
// 参数1：device_info	指向设备信息实例的OH_AI_DeviceInfoHandle。
// 参数2：provider	生产商的名称。

foreign func OH_AI_DeviceInfoGetProvider(device_info: OH_AI_DeviceInfoHandle): CString;
public func oh_ai_device_info_get_provider(device_info: OH_AI_DeviceInfoHandle) {
  unsafe {OH_AI_DeviceInfoGetProvider(device_info)}
}
// 原文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_deviceinfogetprovider
// OH_AI_API const char* OH_AI_DeviceInfoGetProvider (const OH_AI_DeviceInfoHandle device_info)
// 功能：获取生产商的名称。
// 参数：device_info	指向设备信息实例的OH_AI_DeviceInfoHandle。
// 返回：生产商的名称。

foreign func OH_AI_DeviceInfoSetProviderDevice(device_info: OH_AI_DeviceInfoHandle, device: CString): Unit;
public func oh_ai_device_info_set_provider_device(device_Info: OH_AI_DeviceInfoHandle, device: CString): Unit {
  unsafe {OH_AI_DeviceInfoSetProviderDevice(device_Info, device)}
}
// 原文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_deviceinfosetproviderdevice
// OH_AI_API void OH_AI_DeviceInfoSetProviderDevice (OH_AI_DeviceInfoHandle device_info, const char * device )
// 参数1：device_info	指向设备信息实例的OH_AI_DeviceInfoHandle。
// 参数2：device	生产商设备名称。例如: CPU。

foreign func OH_AI_DeviceInfoGetProviderDevice(device_info: OH_AI_DeviceInfoHandle): CString;
public func oh_ai_device_info_get_provider_device(device_info: OH_AI_DeviceInfoHandle): CString {
  unsafe {OH_AI_DeviceInfoGetProvider(device_info)}
}
// 原文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_deviceinfogetproviderdevice
// OH_AI_API const char* OH_AI_DeviceInfoGetProviderDevice (const OH_AI_DeviceInfoHandle device_info)
// 参数：device_info	指向设备信息实例的OH_AI_DeviceInfoHandle。
// 返回：生产商设备的名称。

foreign func OH_AI_DeviceInfoGetDeviceType(device_info: OH_AI_DeviceInfoHandle): OH_AI_DeviceType;
public func oh_ai_device_info_get_device_type(device_info: OH_AI_DeviceInfoHandle): OH_AI_DeviceType {
  unsafe {OH_AI_DeviceInfoGetDeviceType(device_info)}
}
// 原文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_deviceinfogetdevicetype
// OH_AI_API OH_AI_DeviceType OH_AI_DeviceInfoGetDeviceType (const OH_AI_DeviceInfoHandle device_info)
// 参数：device_info	指向设备信息实例的OH_AI_DeviceInfoHandle。
// 返回：生产商设备类型。

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

foreign func OH_AI_DeviceInfoSetFrequency(device_info: OH_AI_DeviceInfoHandle, frequency: Int32): Unit;
public func oh_ai_device_info_set_frequency(device_info: OH_AI_DeviceInfoHandle, frequency: Int32): Unit {
  unsafe{OH_AI_DeviceInfoSetFrequency(device_info, frequency)}
}
// 原文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_deviceinfosetfrequency
// OH_AI_API void OH_AI_DeviceInfoSetFrequency (OH_AI_DeviceInfoHandle device_info, int frequency )
// 功能：设置NPU的频率，仅NPU设备可用。
// 参数1：device_info	指向设备信息实例的OH_AI_DeviceInfoHandle。
// 参数2：frequency	频率类型，取值范围为0-4，默认是3。1表示低功耗，2表示平衡，3表示高性能，4表示超高性能。

foreign func OH_AI_DeviceInfoGetFrequency(device_info: OH_AI_DeviceInfoHandle): Int32;
public func oh_ai_device_info_get_frequency(device_info: OH_AI_DeviceInfoHandle): Int32 {
  unsafe {OH_AI_DeviceInfoGetFrequency(device_info)}
}
// 原文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_deviceinfogetfrequency
// 功能：获取NPU的频率类型，仅NPU设备可用。
// OH_AI_API int OH_AI_DeviceInfoGetFrequency (const OH_AI_DeviceInfoHandle device_info)
// device_info	指向设备信息实例的OH_AI_DeviceInfoHandle。
// 返回：NPU的频率类型。取值范围为0-4，1表示低功耗，2表示平衡，3表示高性能，4表示超高性能。


foreign func OH_AI_CreateNNRTDeviceInfoByName(name: CString): OH_AI_DeviceInfoHandle;
public func oh_ai_create_nnrt_device_info_by_name(name: CString): OH_AI_DeviceInfoHandle {
  unsafe {OH_AI_CreateNNRTDeviceInfoByName(name)}
}
// 原文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_creatennrtdeviceinfobyname
// OH_AI_API OH_AI_DeviceInfoHandle OH_AI_CreateNNRTDeviceInfoByName (const char * name)
// 功能：查找指定名称的NNRt设备，根据找到的第一个设备信息，创建NNRt设备信息。
// 参数：name	目标NNRt设备名。
// 返回：指向设备信息实例的OH_AI_DeviceInfoHandle。


foreign func OH_AI_CreateNNRTDeviceInfoByType(device_type: OH_AI_NNRTDeviceType): OH_AI_DeviceInfoHandle;
public func oh_ai_create_nnrt_device_info_by_type(device_type: OH_AI_NNRTDeviceType): OH_AI_DeviceInfoHandle {
  unsafe {OH_AI_CreateNNRTDeviceInfoByType(device_type)}
}
// 原文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_creatennrtdeviceinfobytype
// OH_AI_API OH_AI_DeviceInfoHandle OH_AI_CreateNNRTDeviceInfoByType (OH_AI_NNRTDeviceType type)
// 功能：查找指定类型的NNRt设备，根据找到的第一个设备信息，创建NNRt设备信息。
// 参数：type	OH_AI_NNRTDeviceType 目标NNRt设备类型。
// 返回：指向设备信息实例的OH_AI_DeviceInfoHandle。

foreign func OH_AI_DeviceInfoSetDeviceId(device_info: OH_AI_DeviceInfoHandle, device_id: UIntNative): Unit;
public func oh_ai_device_info_set_device_id(device_info: OH_AI_DeviceInfoHandle, device_id: UIntNative): Unit {
  unsafe {OH_AI_DeviceInfoSetDeviceId(device_info, device_id)}
}
// 原文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_deviceinfosetdeviceid
// OH_AI_API void OH_AI_DeviceInfoSetDeviceId (OH_AI_DeviceInfoHandle device_info, size_t device_id )
// 功能：设置NNRt设备ID，仅NNRt设备可用。
// 参数1：device_info	指向设备信息实例的OH_AI_DeviceInfoHandle。
// 参数2：hdevice_id	NNRt设备ID。

foreign func OH_AI_DeviceInfoGetDeviceId(device_info: OH_AI_DeviceInfoHandle): UIntNative;
public func oh_ai_device_info_get_device_id(device_info: OH_AI_DeviceInfoHandle): UIntNative {
  unsafe {OH_AI_DeviceInfoGetDeviceId(device_info)}
}
// 原文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_deviceinfogetdeviceid
// OH_AI_API size_t OH_AI_DeviceInfoGetDeviceId (const OH_AI_DeviceInfoHandle device_info)
// 功能：获取NNRt设备ID，仅NNRt设备可用。
// 参数：device_info	指向设备信息实例的OH_AI_DeviceInfoHandle。
// 返回：NNRt设备ID。

foreign func OH_AI_DeviceInfoSetPerformanceMode(device_info: OH_AI_DeviceInfoHandle, mode: OH_AI_PerformanceMode): Unit;
public func oh_ai_device_info_set_performance_mode(device_info: OH_AI_DeviceInfoHandle, mode: OH_AI_PerformanceMode): Unit {
  unsafe {OH_AI_DeviceInfoSetPerformanceMode(device_info, mode)}
}
// // 原文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_deviceinfosetperformancemode
// // OH_AI_API void OH_AI_DeviceInfoSetPerformanceMode (OH_AI_DeviceInfoHandle device_info, OH_AI_PerformanceMode mode )
// // 功能：设置NNRt性能模式，仅NNRt设备可用。
// // 参数1：device_info	指向设备信息实例的OH_AI_DeviceInfoHandle。
// // 参数2：mode	OH_AI_PerformanceMode NNRt性能模式。
//
foreign func OH_AI_DeviceInfoGetPerformanceMode (device_info: OH_AI_DeviceInfoHandle): OH_AI_PerformanceMode;
public func oh_ai_device_info_get_performance_mode (device_info: OH_AI_DeviceInfoHandle): OH_AI_PerformanceMode {
  unsafe {OH_AI_DeviceInfoGetPerformanceMode(device_info)}
}
// 原文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_deviceinfogetperformancemode
// OH_AI_API OH_AI_PerformanceMode OH_AI_DeviceInfoGetPerformanceMode (const OH_AI_DeviceInfoHandle device_info)
// 功能：获取NNRt性能模式，仅NNRt设备可用。
// 参数：device_info	指向设备信息实例的OH_AI_DeviceInfoHandle。
// 返回：获取NNRt性能模式，仅NNRt设备可用。

foreign func OH_AI_DeviceInfoSetPriority (device_info: OH_AI_DeviceInfoHandle, priority: OH_AI_Priority): Unit;
public func oh_ai_device_info_set_priority(device_info: OH_AI_DeviceInfoHandle, priority: OH_AI_Priority): Unit {
  unsafe {OH_AI_DeviceInfoSetPriority(device_info, priority)}
}
// 原文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_deviceinfosetpriority
// OH_AI_API void OH_AI_DeviceInfoSetPriority (OH_AI_DeviceInfoHandle device_info, OH_AI_Priority priority )
// 功能：设置NNRt任务优先级，仅NNRt设备可用。
// 参数1：device_info	指向设备信息实例的OH_AI_DeviceInfoHandle。
// 参数2：priority	OH_AI_Priority NNRt任务优先级。

foreign func OH_AI_DeviceInfoGetPriority (device_info: OH_AI_DeviceInfoHandle): OH_AI_Priority;
public func oh_ai_device_info_get_priority (device_info: OH_AI_DeviceInfoHandle): OH_AI_Priority {
  unsafe {OH_AI_DeviceInfoGetPriority(device_info)}
}
// 原文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_deviceinfogetpriority
// OH_AI_API OH_AI_Priority OH_AI_DeviceInfoGetPriority (const OH_AI_DeviceInfoHandle device_info)
// 功能：获取NNRt任务优先级，仅NNRt设备可用。
// 参数：device_info	指向设备信息实例的OH_AI_DeviceInfoHandle。
// OH_AI_Priority NNRt任务优先级。

foreign func OH_AI_DeviceInfoAddExtension(
  device_info: OH_AI_DeviceInfoHandle,
  name: CString,
  value: CString,
  value_size: UIntNative
  ): OH_AI_Status;
public func oh_ai_device_info_add_extension(
  device_info: OH_AI_DeviceInfoHandle,
  name: CString,
  value: CString,
  value_size: UIntNative
  ): OH_AI_Status {
    unsafe{OH_AI_DeviceInfoAddExtension(device_info, name, value, value_size)}
  }
// 原文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_deviceinfoaddextension
// OH_AI_API OH_AI_Status OH_AI_DeviceInfoAddExtension (OH_AI_DeviceInfoHandle device_info, const char * name, const char * value, size_t value_size )
// 功能：向设备信息中添加键/值对形式的扩展配置。只对NNRt设备信息有效。
// 注意：当前仅支持
// {"CachePath": "YourCachePath"}，
// {"CacheVersion": "YouCacheVersion"}，
// {"QuantBuffer": "YourQuantBuffer"}，
// {"ModelName": "YourModelName"}，
// {"isProfiling": "YourisProfiling"}，
// {"opLayout": "YouropLayout"}，
// {"InputDims": "YourInputDims"}，
// {"DynamicDims": "YourDynamicDims"}
// 八种键值对配置，用户根据使用情况替换具体的值。
// OH_AI_Status 执行状态码，若成功返回OH_AI_STATUS_SUCCESS，失败则返回具体错误码。
