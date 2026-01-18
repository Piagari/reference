package ohos_app_cangjie_entry

internal import encoding.json.stream.*

public struct TokenJson <: JsonDeserializable<TokenJson> {
  let id: UInt32
  let content: String
  let single_word: Bool
  let lstrip: Bool
  let rstrip: Bool
  let normalized: Bool
  let special: Bool

  public init(
    id: UInt32,
    content: String,
    single_word: Bool,
    lstrip: Bool,
    rstrip: Bool,
    normalized: Bool,
    special: Bool
  ) {
    this.id = id
    this.content = content
    this.single_word = single_word
    this.lstrip = lstrip
    this.rstrip = rstrip
    this.normalized = normalized
    this.special = special
  }

  public static func fromJson(r: JsonReader): TokenJson {
    r.startObject();
    let (id, content, single_word, lstrip, rstrip, normalized, special) = JsonHelper.readFields(r);
    r.endObject();
    return TokenJson(
      id,
      content,
      single_word,
      lstrip,
      rstrip,
      normalized,
      special
    );
}

}

public struct NormalizerJson <: JsonDeserializable<NormalizerJson> {
  let p_type: String

  public init(p_type: String) {
    this.p_type = p_type
  }

  public static func fromJson(r: JsonReader): NormalizerJson {
    r.startObject();
    let p_type = JsonHelper.readField<String>(r, "type")
    r.endObject();
    return NormalizerJson(p_type)
  }
}

public struct PatternJson <: JsonDeserializable<PatternJson> {
  let p_regex: String

  public init(p_regex: String) {
    this.p_regex = p_regex
  }

  public static func fromJson(r: JsonReader): PatternJson {
    r.startObject();
    let p_regex = JsonHelper.readField<String>(r, "Regex")
    r.endObject();
    return PatternJson(p_regex)
  }

}


public struct ProcessJson <: JsonDeserializable<ProcessJson> {
  // Union ByteLevel and SplitTokenizer
  let p_type: String
  // use for ByteLevel: decoder/post_processor
  let add_prefix_space: Option<Bool>
  let trim_offsets: Option<Bool>
  let use_regex: Option<Bool>
  // actived when split tokenizer
  let pattern: Option<PatternJson>
  let behavior: Option<String>
  let invert: Option<Bool>

  // construct for decode/post_preprossor
  public init(
    p_type: String,
    add_prefix_space: Bool,
    trim_offsets: Bool,
    use_regex: Bool
  ) {
    this.p_type = p_type
    if (this.p_type != "ByteLevel") {
      throw Exception("this construction function only suppport ByteLevel type")
    }
    this.add_prefix_space = Some(add_prefix_space)
    this.trim_offsets = Some(trim_offsets)
    this.use_regex = Some(use_regex)
    this.pattern = None
    this.behavior = None
    this.invert = None
  }

  public init(
    p_type: String,
    pattern: PatternJson,
    behavior: String,
    invert: Bool
  ) {
    this.p_type = p_type
    if (p_type != "Split") {
      throw Exception("this construction function only support Split type")
    }
    this.add_prefix_space = None
    this.trim_offsets = None
    this.use_regex = None
    this.pattern = Some(pattern)
    this.behavior = Some(behavior)
    this.invert = Some(invert)
  }

  public static func fromJson(r: JsonReader): ProcessJson {
    r.startObject();
    let p_type = JsonHelper.readField<String>(r, "type")
    if (p_type == "ByteLevel") {
      let add_prefix_space = JsonHelper.readField<Bool>(r, "add_prefix_space")
      let trim_offsets = JsonHelper.readField<Bool>(r, "trim_offsets")
      let use_regex = JsonHelper.readField<Bool>(r, "use_regex")
      r.endObject();
      return ProcessJson(p_type, add_prefix_space, trim_offsets, use_regex)
    } else if (p_type == "Split") {
      let pattern = JsonHelper.readField<PatternJson>(r, "pattern")
      let behavior = JsonHelper.readField<String>(r, "behavior")
      let invert = JsonHelper.readField<Bool>(r, "invert")
      r.endObject();
      return ProcessJson(p_type, pattern, behavior, invert)
    } else {
      r.endObject();
      throw Exception("unkonw process type ${p_type}")
    }
  }
}

public struct PreTokenizerJson <: JsonDeserializable<PreTokenizerJson> {
  let p_type: String
  let pretokenizers: ArrayList<ProcessJson>
  public init(p_type: String, pretokenizers: ArrayList<ProcessJson>) {
    this.p_type = p_type
    this.pretokenizers = pretokenizers
  }

  public init() {
    // default
    this.p_type = ""
    this.pretokenizers = ArrayList<ProcessJson>()
  }

  public static func fromJson(r: JsonReader): PreTokenizerJson {
    r.startObject();
    let p_type = JsonHelper.readField<String>(r, "type")
    let pretokenizers = JsonHelper.readField<ArrayList<ProcessJson>>(r, "pretokenizers")
    r.endObject();
    return PreTokenizerJson(p_type, pretokenizers)
  }

}

public struct ModelJson <: JsonDeserializable<ModelJson> {
  let p_type: String
  let dropout: Option<Float32>
  var unk_token: Option<String> = None
  var continuing_subword_prefix: String = ""
  var end_of_word_suffix: String = ""
  var fuse_unk: Bool = false
  var byte_fallback: Bool = false
  let vocab: HashMap<String, UInt32>
  let merges: ArrayList<String>
  public init(
    p_type: String,
    dropout: Option<Float32>,
    vocab: HashMap<String, UInt32>,
    merges: ArrayList<String>,
    unk_token!: Option<String> = None,
    continuing_subword_prefix!: String = "",
    end_of_word_suffix!: String = "",
    fuse_unk!: Bool = false,
    byte_fallback!: Bool = false
  ) {
    this.p_type = p_type
    if (dropout.isSome()) {
      let dropout_value = dropout.getOrThrow()
      if (dropout_value < 0.0 || dropout_value > 1.0) {
        throw Exception("dropout can only between 0~1")
      }
    }
    this.dropout = dropout
    this.unk_token = unk_token
    this.continuing_subword_prefix = continuing_subword_prefix
    this.end_of_word_suffix = end_of_word_suffix
    this.fuse_unk = fuse_unk
    this.byte_fallback = byte_fallback
    this.vocab = vocab
    this.merges = merges
  }

  public static func fromJson(r: JsonReader): ModelJson {
    r.startObject();
    var temp_p_type: String = ""
    var temp_dropout: Option<Float32> = None
    var temp_unk_token: Option<String> = None
    var temp_continuing_subword_prefix: String = ""
    var temp_end_of_word_suffix: String = ""
    var temp_fuse_unk: Bool = false
    var temp_byte_fallback: Bool = false
    var temp_vocab: HashMap<String, UInt32> = HashMap<String, UInt32>()
    var temp_merges: ArrayList<String> = ArrayList<String>()
    while (r.peek() != EndObject) {
      let n = r.readName()
      match (n) {
        case "type" => temp_p_type = r.readValue<String>()
        case "dropout" => temp_dropout = r.readValue<Option<Float32>>()
        case "unk_token" => temp_unk_token = r.readValue<Option<String>>()
        case "continuing_subword_prefix" => temp_continuing_subword_prefix = r.readValue<String>()
        case "end_of_word_suffix" => temp_end_of_word_suffix = r.readValue<String>()
        case "fuse_unk" => temp_fuse_unk = r.readValue<Bool>()
        case "byte_fallback" => temp_byte_fallback = r.readValue<Bool>()
        case "vocab" => temp_vocab = r.readValue<HashMap<String, UInt32>>()
        case "merges" => temp_merges = r.readValue<ArrayList<String>>()
        case unkow => println("未知键: ${unkow}")
      }
    }
    r.endObject();
    return ModelJson(
      temp_p_type,
      temp_dropout,
      temp_vocab,
      temp_merges,
      unk_token: temp_unk_token,
      continuing_subword_prefix: temp_continuing_subword_prefix,
      end_of_word_suffix: temp_end_of_word_suffix,
      fuse_unk: temp_fuse_unk,
      byte_fallback: temp_byte_fallback
    )
  }
}

public struct TokenizerJson <: JsonDeserializable<TokenizerJson> {
  let version: String
  let truncation: Option<String>
  let padding: Option<String>
  let added_tokens: ArrayList<TokenJson>
  let normalizer: NormalizerJson
  let pre_tokenizer: PreTokenizerJson
  let post_processor: ProcessJson
  let decoder: ProcessJson
  let model: ModelJson

  public init(
    version: String,
    truncation: Option<String>,
    padding: Option<String>,
    added_tokens: ArrayList<TokenJson>,
    normalizer: NormalizerJson,
    pre_tokenizer: PreTokenizerJson,
    post_processor: ProcessJson,
    decoder: ProcessJson,
    model: ModelJson
  ) {
    this.version = version
    this.truncation = truncation
    this.padding = padding
    this.added_tokens = added_tokens
    this.normalizer = normalizer
    this.pre_tokenizer = pre_tokenizer
    this.post_processor = post_processor
    this.decoder = decoder
    this.model = model
  }

  public static func fromJson(r: JsonReader): TokenizerJson {
    r.startObject();
    var temp_version: String = ""
    var temp_truncation: Option<String> = None
    var temp_padding: Option<String> = None
    var temp_added_tokens: ArrayList<TokenJson> = ArrayList<TokenJson>()
    var temp_normalizer: NormalizerJson = NormalizerJson("")
    var temp_pre_tokenizer: PreTokenizerJson = PreTokenizerJson()
    var temp_post_processor: Option<ProcessJson> = None
    var temp_decoder: Option<ProcessJson> = None
    var temp_model: Option<ModelJson> = None
    while (r.peek() != EndObject) {
      let n = r.readName()
      match (n) {
        case "version" => temp_version = r.readValue<String>()
        case "truncation" => temp_truncation = r.readValue<Option<String>>()
        case "padding" => temp_padding = r.readValue<Option<String>>()
        case "added_tokens" => temp_added_tokens = r.readValue<ArrayList<TokenJson>>()
        case "normalizer" => temp_normalizer = r.readValue<NormalizerJson>()
        case "pre_tokenizer" => temp_pre_tokenizer = r.readValue<PreTokenizerJson>()
        case "post_processor" => temp_post_processor = Some(r.readValue<ProcessJson>())
        case "decoder" => temp_decoder = Some(r.readValue<ProcessJson>())
        case "model" => temp_model = Some(r.readValue<ModelJson>())
        case unkow => println("未知键: ${unkow}")
      }
    }
    r.endObject();
    return TokenizerJson(
      temp_version,
      temp_truncation,
      temp_padding,
      temp_added_tokens,
      temp_normalizer,
      temp_pre_tokenizer,
      temp_post_processor.getOrThrow(),
      temp_decoder.getOrThrow(),
      temp_model.getOrThrow(),
    )
  }
}
// 辅助模块，用于JSON反序列化工具
public struct JsonHelper {
  // 泛型函数，添加类型约束以确保与 r.readValue<T>() 兼容
  public static func readField<T>(r: JsonReader, fieldName: String): T where T <: JsonDeserializable<T> {
  while (r.peek() != EndObject) {
    let n = r.readName();
    if (n == fieldName) {
      return r.readValue<T>();
    }
  }
  throw Exception("Field not found: ${fieldName}");
}

  // 用于从JSON对象中读取多个字段的函数
  public static func readFields(r: JsonReader): (UInt32, String, Bool, Bool, Bool, Bool, Bool) {
    var id: UInt32 = 0;
    var content: String = "";
    var single_word: Bool = false;
    var lstrip: Bool = false;
    var rstrip: Bool = false;
    var normalized: Bool = false;
    var special: Bool = false;

    while (r.peek() != EndObject) {
      let n = r.readName();
      match (n) {
        case "id" => id = r.readValue<UInt32>();
        case "content" => content = r.readValue<String>();
        case "single_word" => single_word = r.readValue<Bool>();
        case "lstrip" => lstrip = r.readValue<Bool>();
        case "rstrip" => rstrip = r.readValue<Bool>();
        case "normalized" => normalized = r.readValue<Bool>();
        case "special" => special = r.readValue<Bool>();
        case _ => println("未知键: $(n)");
      }
    }
    return (id, content, single_word, lstrip, rstrip, normalized, special);
  }
}