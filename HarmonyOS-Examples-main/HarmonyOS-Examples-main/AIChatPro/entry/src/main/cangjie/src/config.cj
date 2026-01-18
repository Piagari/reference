package ohos_app_cangjie_entry
internal import encoding.json.stream.*
import std.io.ByteArrayStream
import std.collection.HashMap
import std.fs.OpenOption
import std.fs.File
import std.fs.Path
import std.fs.Directory

public struct ModelConfig <: JsonDeserializable<ModelConfig> {
  public let architectures: Array<String>;
  public let attention_dropout: Option<Float32>;
  public let auto_map: HashMap<String, String>;
  public let bos_token_id: UInt32;
  public let eos_token_id: UInt32;
  public let hidden_act: String;
  public let hidden_size: UInt32;
  public let initializer_range: Float32;
  public let intermediate_size: UInt32;
  public let max_position_embeddings: UInt32;
  public let max_window_layers: UInt32;
  public let model_type: String;
  public let num_attention_heads: UInt32;
  public let num_hidden_layers: UInt32;
  public let num_key_value_heads: UInt32;
  public let rms_norm_eps: Float64;
  public let rope_theta: Float64;
  public let sliding_window: UInt32;
  public let tie_word_embeddings: Bool;
  public let torch_dtype: Option<String>;
  public let transformers_version: String;
  public let use_cache: Bool;
  public let use_sliding_window: Bool;
  public let vocab_size: UInt32;

  public init(
    architectures: Array<String>,
    attention_dropout: Option<Float32>,
    auto_map: HashMap<String, String>,
    bos_token_id: UInt32,
    eos_token_id: UInt32,
    hidden_act: String,
    hidden_size: UInt32,
    initializer_range: Float32,
    intermediate_size: UInt32,
    max_position_embeddings: UInt32,
    max_window_layers: UInt32,
    model_type: String,
    num_attention_heads: UInt32,
    num_hidden_layers: UInt32,
    num_key_value_heads: UInt32,
    rms_norm_eps: Float64,
    rope_theta: Float64,
    sliding_window: UInt32,
    tie_word_embeddings: Bool,
    torch_dtype: Option<String>,
    transformers_version: String,
    use_cache: Bool,
    use_sliding_window: Bool,
    vocab_size: UInt32
  ) {
    this.architectures =  architectures;
    this.attention_dropout = attention_dropout;
    this.auto_map = auto_map;
    this.bos_token_id = bos_token_id;
    this.eos_token_id = eos_token_id;
    this.hidden_act = hidden_act;
    this.hidden_size = hidden_size;
    this.initializer_range = initializer_range;
    this.intermediate_size = intermediate_size;
    this.max_position_embeddings = max_position_embeddings;
    this.max_window_layers = max_window_layers;
    this.model_type = model_type;
    this.num_attention_heads = num_attention_heads;
    this.num_hidden_layers = num_hidden_layers;
    this.num_key_value_heads = num_key_value_heads;
    this.rms_norm_eps = rms_norm_eps;
    this.rope_theta = rope_theta;
    this.sliding_window = sliding_window;
    this.tie_word_embeddings = tie_word_embeddings;
    this.torch_dtype = torch_dtype;
    this.transformers_version = transformers_version;
    this.use_cache = use_cache;
    this.use_sliding_window = use_sliding_window;
    this.vocab_size = vocab_size;
  }

  public static func fromJson(r: JsonReader): ModelConfig {
    var temp_architectures: Array<String> = Array<String>();
    var temp_attention_dropout: Option<Float32> = None;
    var temp_auto_map: HashMap<String, String> = HashMap<String, String>();
    var temp_bos_token_id: UInt32 = 0;
    var temp_eos_token_id: UInt32 = 0;
    var temp_hidden_act: String = "";
    var temp_hidden_size: UInt32 = 0;
    var temp_initializer_range: Float32 = 0.0;
    var temp_intermediate_size: UInt32 = 0;
    var temp_max_position_embeddings: UInt32 = 0;
    var temp_max_window_layers: UInt32 = 0;
    var temp_model_type: String = "";
    var temp_num_attention_heads: UInt32 = 0;
    var temp_num_hidden_layers: UInt32 = 0;
    var temp_num_key_value_heads: UInt32 = 0;
    var temp_rms_norm_eps: Float64 = 0.0;
    var temp_rope_theta: Float64 = 0.0;
    var temp_sliding_window: UInt32 = 0;
    var temp_tie_word_embeddings: Bool = false;
    var temp_torch_dtype: Option<String> = None;
    var temp_transformers_version: String = "";
    var temp_use_cache: Bool = true;
    var temp_use_sliding_window: Bool = false;
    var temp_vocab_size: UInt32 = 0;
    while (let Some(v) <- r.peek()) {
      match(v) {
        case BeginObject =>
          r.startObject();
          while(r.peek() != EndObject) {
            let n = r.readName()
            match (n) {
              case "architectures" => temp_architectures = r.readValue<Array<String>>();
              case "attention_dropout" => temp_attention_dropout = r.readValue<Option<Float32>>();
              case "auto_map" => temp_auto_map = r.readValue<HashMap<String, String>>();
              case "bos_token_id" => temp_bos_token_id = r.readValue<UInt32>();
              case "eos_token_id" => temp_eos_token_id = r.readValue<UInt32>();
              case "hidden_act" => temp_hidden_act = r.readValue<String>();
              case "hidden_size" => temp_hidden_size = r.readValue<UInt32>();
              case "initializer_range" => temp_initializer_range = r.readValue<Float32>();
              case "intermediate_size" => temp_intermediate_size = r.readValue<UInt32>();
              case "max_position_embeddings" => temp_max_position_embeddings = r.readValue<UInt32>();
              case "max_window_layers" => temp_max_window_layers = r.readValue<UInt32>();
              case "model_type" => temp_model_type = r.readValue<String>();
              case "num_attention_heads" => temp_num_attention_heads = r.readValue<UInt32>();
              case "num_hidden_layers" => temp_num_hidden_layers = r.readValue<UInt32>();
              case "num_key_value_heads" => temp_num_key_value_heads = r.readValue<UInt32>();
              case "rms_norm_eps" => temp_rms_norm_eps = r.readValue<Float64>();
              case "rope_theta" => temp_rope_theta = r.readValue<Float64>();
              case "sliding_window" => temp_sliding_window = r.readValue<UInt32>();
              case "tie_word_embeddings" => temp_tie_word_embeddings = r.readValue<Bool>();
              case "torch_dtype" => temp_torch_dtype = r.readValue<Option<String>>();
              case "transformers_version" => temp_transformers_version = r.readValue<String>();
              case "use_cache" => temp_use_cache = r.readValue<Bool>();
              case "use_sliding_window" => temp_use_sliding_window = r.readValue<Bool>();
              case "vocab_size" => temp_vocab_size = r.readValue<UInt32>();
              case unkow => println("unkow key ${unkow}");
            }
          }
          r.endObject();
          break;
        case _ => throw Exception("can't deserialize for ModelConfig");
      }
    }

    return ModelConfig(
      temp_architectures,
      temp_attention_dropout,
      temp_auto_map,
      temp_bos_token_id,
      temp_eos_token_id,
      temp_hidden_act,
      temp_hidden_size,
      temp_initializer_range,
      temp_intermediate_size,
      temp_max_position_embeddings,
      temp_max_window_layers,
      temp_model_type,
      temp_num_attention_heads,
      temp_num_hidden_layers,
      temp_num_key_value_heads,
      temp_rms_norm_eps,
      temp_rope_theta,
      temp_sliding_window,
      temp_tie_word_embeddings,
      temp_torch_dtype,
      temp_transformers_version,
      temp_use_cache,
      temp_use_sliding_window,
      temp_vocab_size
    )
  }
}

public func read_config(model_buffer: Array<UInt8>): ModelConfig {
  var byte_stream = ByteArrayStream();
  byte_stream.write(model_buffer);
  let json_reader = JsonReader(byte_stream);
  return ModelConfig.fromJson(json_reader);
}