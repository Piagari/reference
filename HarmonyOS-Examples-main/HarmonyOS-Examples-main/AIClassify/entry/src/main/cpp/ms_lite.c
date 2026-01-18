//
// Created on 2024年9月3日.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <hilog/log.h>
#include <mindspore/types.h>
#include <mindspore/model.h>
#include <mindspore/context.h>
#include <mindspore/status.h>
#include <mindspore/tensor.h>


#define LOGI(...) ((void)OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, "[MSLiteNapi]", __VA_ARGS__))
#define LOGD(...) ((void)OH_LOG_Print(LOG_APP, LOG_DEBUG, LOG_DOMAIN, "[MSLiteNapi]", __VA_ARGS__))
#define LOGW(...) ((void)OH_LOG_Print(LOG_APP, LOG_WARN, LOG_DOMAIN, "[MSLiteNapi]", __VA_ARGS__))
#define LOGE(...) ((void)OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, "[MSLiteNapi]", __VA_ARGS__))



bool run_mindspore_lite(
    uint8_t * model_buffer,
    int64_t model_size,
    float * input_buffer,
    int64_t input_size,
    float * output_buffer,
    int64_t output_size
) {
    // param input_buffer: 输入数据的buffer指针
    // param input_size: 输入数据的个数
    // param model_model: 模型文件的buffer指针
    // param model_size: 模型文件大小
    // param output_buffer: 输出数据的buffer指针
    // param output_size: 输出数据的个数

    // ================== 第一步, 创建上下文 =====================
    // 设置执行上下文，优先NPU，其次CPU
    OH_AI_ContextHandle context = OH_AI_ContextCreate();
    if (context == NULL) {
        OH_AI_ContextDestroy(&context);
        LOGE("===== MS_LITE_ERR: Create MSLite context failed.===== \n");
        return false;
    }
#ifdef USE_NNRT    
    // 先创建一个NPU上下文(即NNRT)
    OH_AI_DeviceInfoHandle nnrt_device_info = OH_AI_CreateNNRTDeviceInfoByType(OH_AI_NNRTDEVICE_ACCELERATOR);
    if (nnrt_device_info == NULL) {
       LOGE("===== MS_LITE_ERR: Create MSLite NNRT context failed.======\n");
        OH_AI_ContextDestroy(&context);
        return false;
    }
    OH_AI_DeviceInfoSetPerformanceMode(nnrt_device_info, OH_AI_PERFORMANCE_HIGH);
    // 将npu加入到上下文
    OH_AI_ContextAddDeviceInfo(context, nnrt_device_info);
#endif    
    
    // 再创建一个CPU上下文作为备选方案
    OH_AI_DeviceInfoHandle cpu_device_info = OH_AI_DeviceInfoCreate(OH_AI_DEVICETYPE_CPU);
    if (cpu_device_info == NULL) {
       LOGE("===== MS_LITE_ERR: Create MSLite CPU context failed. =====");
        OH_AI_ContextDestroy(&context);
        return false;
    }
    // 开启fp16推理
    OH_AI_DeviceInfoSetEnableFP16(cpu_device_info, true);
    // 将cpu加入到上下文
    OH_AI_ContextAddDeviceInfo(context, cpu_device_info);

    // ============================= 第二步，读取模型文件，创建模型 ======================================
    OH_AI_ModelHandle model = OH_AI_ModelCreate();
    if (model == NULL) {
        OH_AI_ContextDestroy(&context);
        LOGE("==== MS_LITE_ERR: Allocate MSLite Model failed.===== \n");
        return false;
    }
    // 加载并编译模型
    int build_ret = OH_AI_ModelBuild(model, model_buffer, model_size, OH_AI_MODELTYPE_MINDIR, context);
    if (build_ret != OH_AI_STATUS_SUCCESS) {
        OH_AI_ModelDestroy(&model);
        LOGE("===== MS_LITE_ERR: Build MSLite model failed. ======\n");
        return false;
    }
    LOGI("===== MS_LITE_LOG: Build MSLite model success. ====\n");

    // ================== 第三步，获取模型输入数据，然后填充输入数据 =======================
    OH_AI_TensorHandleArray inputs = OH_AI_ModelGetInputs(model);
    LOGI("===== MS_LITE_LOG: get model inputs success. ====\n");
    if (inputs.handle_list == NULL) {
        LOGE("===== OH_AI_ModelGetInputs failed, ret: ===== \n");
        OH_AI_ModelDestroy(&model);
        return false;
    }
    // 将输入数据的buffer拷贝给它(这里拷贝数据有点麻烦，后期看看能不能直接传指针咯）
    // 这里输入应该只有一个
    assert(inputs.handle_num == 1);
    LOGI("===== MS_LITE_LOG: assert inputs.handle_num success. ====\n");
    for (size_t i = 0; i < inputs.handle_num; ++i) {
       // 获取输入数据的可变指针
       void * input_data = OH_AI_TensorGetMutableData(inputs.handle_list[i]);
       int64_t input_number = OH_AI_TensorGetElementNum(inputs.handle_list[i]);
       // 模型输入数据和提供的输入数据个数必须一样
       assert(input_size == input_number);
       // 拷贝数据
       memcpy(input_data, (void *)input_buffer, input_size * sizeof(float));
    }
    LOGI("===== MS_LITE_LOG: prepared inputs data ====\n");
    // =================== 第四步，准备输出数据，执行推理 =============================
    OH_AI_TensorHandleArray outputs;
    int ret = OH_AI_ModelPredict(model, inputs, &outputs, NULL, NULL);
    if (ret != OH_AI_STATUS_SUCCESS) {
        OH_AI_ModelDestroy(&model);
        OH_AI_ContextDestroy(&context);
        LOGE("===== MS_LITE_ERR: RunMSLiteModel failed.=====\n");
        return false;
    } 
    // =================== 第五步，拷贝输出数据 =====================================
    // 输出数据也应该是一个
    assert(outputs.handle_num == 1);
    LOGI("===== MS_LITE_LOG: assert outputs.handle_num ok ====\n");
    for (size_t i = 0; i < inputs.handle_num; ++i) {
       // 获取输出数据的不可变指针
       const void * output_data = OH_AI_TensorGetData(outputs.handle_list[i]);
       int64_t output_number = OH_AI_TensorGetElementNum(outputs.handle_list[i]);
       assert(output_size == output_number);
       // 拷贝数据
       memcpy((void *)output_buffer, output_data, output_size * sizeof(float));
    } 
    LOGI("===== MS_LITE_LOG: copy output data ok ====\n");
    // 释放模型
    OH_AI_ModelDestroy(&model);
    LOGI("===== MS_LITE_LOG: destroyed model =====\n");
    // 释放上下文 (上面释放模型的时候已经将上下文也释放了，所以下面的语句如果执行会造成二次释放而导致程序奔溃）
    // OH_AI_ContextDestroy(&context);
    // LOGI("===== MS_LITE_LOG: destroyed context =====\n");
    return true;
}