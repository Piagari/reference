package ohos_app_cangjie_entry.mindspore


public type OH_AI_TensorHandle = CPointer<Unit>;
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_tensorhandle
// typedef void* OH_AI_TensorHandle
// 功能：指向张量对象句柄

public type OH_AI_AllocatorHandle = CPointer<Unit>;
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_allocatorhandle
// typedef void *OH_AI_AllocatorHandle
// 功能：指向内存分配器对象句柄。


foreign func OH_AI_TensorCreate(
  name: CString,
  data_type: OH_AI_DataType,
  shape: CPointer<Int64>,
  shape_num: UIntNative,
  data: CPointer<Unit>,
  data_len: UIntNative
): OH_AI_TensorHandle;
public func oh_ai_tensor_create(
  name: CString,
  data_type: OH_AI_DataType,
  shape: CPointer<Int64>,
  shape_num: UIntNative,
  data: CPointer<Unit>,
  data_len: UIntNative
): OH_AI_TensorHandle {
  unsafe{OH_AI_TensorCreate(name, data_type, shape, shape_num, data, data_len)}   
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_tensorcreate
// OH_AI_API OH_AI_TensorHandle OH_AI_TensorCreate (const char * name, OH_AI_DataType type, const int64_t * shape, size_t shape_num, const void * data, size_t data_len )
// 功能：创建一个张量对象。
// 参数1 name	张量名称
// 参数2 data_type	张量的数据类型
// 参数3 shape	张量的维度数组。
// 参数4 shape_num	张量维度数组长度。
// 参数5 data	指向数据的指针。
// 参数6 data_len	数据的长度。

foreign func OH_AI_TensorDestroy(tensor: CPointer<OH_AI_TensorHandle>): Unit;
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_tensordestroy
// OH_AI_API void OH_AI_TensorDestroy (OH_AI_TensorHandle * tensor)
// 功能：释放张量对象。

foreign func OH_AI_TensorClone(tensor: OH_AI_TensorHandle): OH_AI_TensorHandle;
public func oh_ai_tensor_clone(tensor: OH_AI_TensorHandle): OH_AI_TensorHandle {
  unsafe {OH_AI_TensorClone(tensor)}
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_tensorclone
// OH_AI_API OH_AI_TensorHandle OH_AI_TensorClone (OH_AI_TensorHandle tensor)
// 功能：深拷贝一个张量。
// 返回：拷贝后的张量

foreign func OH_AI_TensorSetName(tensor: OH_AI_TensorHandle, name: CString): Unit;
public func oh_ai_tensor_set_name(tensor: OH_AI_TensorHandle, name: CString): Unit {
  unsafe {OH_AI_TensorSetName(tensor, name)}
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_tensorsetname
// OH_AI_API void OH_AI_TensorSetName (OH_AI_TensorHandle tensor, const char * name )
// 功能：设置张量的名称。
// 参数：tensor	张量对象句柄。
// 参数：name	张量名称。

foreign func OH_AI_TensorGetName(tensor: OH_AI_TensorHandle): CString;
public func oh_ai_tensor_get_name(tensor: OH_AI_TensorHandle): CString {
  unsafe {OH_AI_TensorGetName(tensor)}
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_tensorgetname
// OH_AI_API const char* OH_AI_TensorGetName (const OH_AI_TensorHandle tensor)
// 功能：获取张量的名称。
// 参数：tensor	张量对象句柄。

foreign func OH_AI_TensorSetDataType(tensor: OH_AI_TensorHandle, data_type: OH_AI_DataType): Unit;
public func oh_ai_tensor_set_data_type(tensor: OH_AI_TensorHandle, data_type: OH_AI_DataType): Unit {
  unsafe {OH_AI_TensorSetDataType(tensor, data_type)}
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_tensorsetdatatype
// OH_AI_API void OH_AI_TensorSetDataType (OH_AI_TensorHandle tensor, OH_AI_DataType type )
// 设置张量的数据类型。
// 参数1：tensor	张量对象句柄。
// 参数2：data_type	数据类型，具体见OH_AI_DataType。


foreign func OH_AI_TensorGetDataType(tensor: OH_AI_TensorHandle): OH_AI_DataType;
public func oh_ai_tensor_get_data_type(tensor: OH_AI_TensorHandle): OH_AI_DataType {
  unsafe {OH_AI_TensorGetDataType(tensor)}
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_tensorgetdatatype
// OH_AI_API OH_AI_DataType OH_AI_TensorGetDataType (const OH_AI_TensorHandle tensor)
// 功能：获取张量类型。
// 参数：tensor	张量对象句柄。
// 返回：张量的数据类型。


foreign func OH_AI_TensorSetShape(tensor: OH_AI_TensorHandle, shape: CPointer<Int64>, shape_num: UIntNative): Unit;
public func oh_ai_tensor_set_shape(tensor: OH_AI_TensorHandle, shape: CPointer<Int64>, shape_num: UIntNative): Unit {
  unsafe {OH_AI_TensorSetShape(tensor, shape, shape_num)}
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_tensorsetshape
// OH_AI_API void OH_AI_TensorSetShape (OH_AI_TensorHandle tensor, const int64_t * shape, size_t shape_num )
// 功能：设置张量的形状。
// 参数1：tensor	张量对象句柄。
// 参数2：shape	形状数组。
// 参数3：shape_num	张量形状数组长度。


foreign func OH_AI_TensorGetShape(tensor: OH_AI_TensorHandle, shape_num: CPointer<UIntNative>): CPointer<Int64>;
public func oh_ai_tensor_get_shape(tensor: OH_AI_TensorHandle, shape_num: CPointer<UIntNative>): CPointer<Int64> {
  unsafe {OH_AI_TensorGetShape(tensor, shape_num)}
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_tensorgetshape
// OH_AI_API const int64_t* OH_AI_TensorGetShape (const OH_AI_TensorHandle tensor, size_t * shape_num )
// 功能：获取张量的形状。
// 参数1：tensor	张量对象句柄。
// 参数2：shape_num	该参数是输出参数，形状数组的长度会写入该变量。
// 返回：形状数组。

foreign func OH_AI_TensorSetFormat(tensor: OH_AI_TensorHandle, format: OH_AI_Format): Unit;
public func oh_ai_tensor_set_format(tensor: OH_AI_TensorHandle, format: OH_AI_Format): Unit {
  unsafe {OH_AI_TensorSetFormat(tensor, format)}
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_tensorsetformat
// OH_AI_API void OH_AI_TensorSetFormat (OH_AI_TensorHandle tensor, OH_AI_Format format )
// 功能：设置张量数据的排列方式。 
// 参数1：tensor	张量对象句柄。
// 参数2：format	张量数据排列方式。

foreign func OH_AI_TensorGetFormat(tensor: OH_AI_TensorHandle): OH_AI_Format;
public func oh_ai_tensor_get_format(tensor: OH_AI_TensorHandle): OH_AI_Format {
  unsafe {OH_AI_TensorGetFormat(tensor)}
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_tensorgetformat
// OH_AI_API OH_AI_Format OH_AI_TensorGetFormat (const OH_AI_TensorHandle tensor)
// 功能：获取张量数据的排列方式。
// 参数：tensor	张量对象句柄。
// 返回：张量数据的排列方式。

foreign func OH_AI_TensorSetData(tensor: OH_AI_TensorHandle, data: CPointer<Unit>): Unit;
public func oh_ai_tensor_set_data(tensor: OH_AI_TensorHandle, data: CPointer<Unit>): Unit {
  unsafe {OH_AI_TensorSetData(tensor, data)}
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_tensorsetdata
// OH_AI_API void OH_AI_TensorSetData (OH_AI_TensorHandle tensor, void * data )
// 功能：设置张量的数据。
// 参数1：tensor	张量对象句柄。
// 参数2：data	指向数据的指针。

foreign func OH_AI_TensorGetData(tensor: OH_AI_TensorHandle): CPointer<Unit>;
public func oh_ai_tensor_get_data(tensor: OH_AI_TensorHandle): CPointer<Unit> {
  unsafe {OH_AI_TensorGetData(tensor)}
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_tensorgetdata
// OH_AI_API const void* OH_AI_TensorGetData (const OH_AI_TensorHandle tensor)
// 功能：获取张量数据的指针。
// 参数：tensor	张量对象句柄。
// 返回：张量数据的指针。

foreign func OH_AI_TensorGetMutableData(tensor: OH_AI_TensorHandle): CPointer<Unit>;
public func oh_ai_tensor_get_mutable_data(tensor: OH_AI_TensorHandle): CPointer<Unit> {
  unsafe {OH_AI_TensorGetMutableData(tensor)}
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_tensorgetmutabledata
// OH_AI_API void* OH_AI_TensorGetMutableData (const OH_AI_TensorHandle tensor)
// 功能：获取可变的张量数据指针。如果数据为空则会开辟内存。
// 输入：tensor	张量对象句柄。
// 返回：张量数据的指针。


foreign func OH_AI_TensorGetElementNum(tensor: OH_AI_TensorHandle): Int64;
public func oh_ai_tensor_get_element_num(tensor: OH_AI_TensorHandle): Int64 {
  unsafe {OH_AI_TensorGetElementNum(tensor)}
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_tensorgetelementnum
// OH_AI_API int64_t OH_AI_TensorGetElementNum (const OH_AI_TensorHandle tensor)
// 功能：获取张量元素数量。
// 输入：tensor	张量对象句柄。
// 返回：张量的元素数量。

foreign func OH_AI_TensorGetDataSize(tensor: OH_AI_TensorHandle): Int64;
public func oh_ai_tensor_get_data_size(tensor: OH_AI_TensorHandle): Int64 {
  unsafe {OH_AI_TensorGetDataSize(tensor)}
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_tensorgetdatasize
// OH_AI_API size_t OH_AI_TensorGetDataSize (const OH_AI_TensorHandle tensor)
// 功能：获取张量中的数据的字节数大小。
// 输入：tensor	张量对象句柄。
// 返回：张量数据的字节数大小。

foreign func OH_AI_TensorSetUserData(tensor: OH_AI_TensorHandle, data: CPointer<Unit>, data_size: UIntNative): OH_AI_Status
public func oh_ai_tensor_set_user_data(tensor: OH_AI_TensorHandle, data: CPointer<Unit>, data_size: UIntNative): OH_AI_Status {
  unsafe{OH_AI_TensorSetUserData(tensor, data, data_size)}
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_tensorsetuserdata
// OH_AI_API OH_AI_Status OH_AI_TensorSetUserData (OH_AI_TensorHandle tensor, void * data, size_t data_size )
// 功能：设置张量为用户自行管理的数据。此接口常用于复用用户数据作为模型输入，可减少一次数据拷贝。
// 注意：此数据对于张量来说是外部数据，张量销毁时不会主动释放，由调用者负责释放。另外，在此张量 使用过程中，调用者须确保此数据有效。
// 参数1：tensor	张量对象句柄。
// 参数2：data	用户数据首地址。
// 参数3：data_size	用户数据长度。
// 返回：执行状态码。若成功返回OH_AI_STATUS_SUCCESS，否则返回具体错误码。


foreign func OH_AI_TensorGetAllocator(tensor: OH_AI_TensorHandle): OH_AI_AllocatorHandle;
public func oh_ai_tensor_get_allocator(tensor: OH_AI_TensorHandle): OH_AI_AllocatorHandle {
  unsafe {OH_AI_TensorGetAllocator(tensor)}
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_tensorgetallocator
// OH_AI_API OH_AI_AllocatorHandle OH_AI_TensorGetAllocator(OH_AI_TensorHandle tensor)
// 功能：获取内存分配器。此接口主要是提供一种获取张量的内存分配器的方法。
// 参数：tensor	张量对象句柄。
// 返回：内存分配器的句柄。

foreign func OH_AI_TensorSetAllocator(tenosr: OH_AI_TensorHandle, allocator: OH_AI_AllocatorHandle): OH_AI_Status;
public func oh_ai_tensor_set_allocator(tenosr: OH_AI_TensorHandle, allocator: OH_AI_AllocatorHandle): OH_AI_Status {
  unsafe {OH_AI_TensorSetAllocator(tenosr, allocator)}
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_tensorsetallocator
// OH_AI_API OH_AI_Status OH_AI_TensorSetAllocator(OH_AI_TensorHandle tensor, OH_AI_AllocatorHandle allocator)
// 功能：设置内存分配器。此接口主要是提供一种设置内存分配器的方法，tensor的内存将由这个分配器分配。
// 参数1：tensor	张量对象句柄。
// 参数2：allocator	内存分配器对象句柄。
// 返回：执行状态码。若成功返回OH_AI_STATUS_SUCCESS，否则返回具体错误码。

