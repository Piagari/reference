package libentry;

foreign func run_mindspore_lite(
    model_buffer: CPointer<UInt8>,
    model_size: Int64,
    input_buffer: CPointer<Float32>,
    input_size: Int64,
    output_buffer: CPointer<Float32>,
    output_size: Int64
    ): Bool;