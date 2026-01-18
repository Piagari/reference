package ohos_app_cangjie_entry
import encoding.json.stream.JsonReader
internal import std.collection.ArrayList
internal import std.collection.HashMap
internal import std.collection.HashSet
import std.core.Equatable
import std.core.Hashable
import std.core.ToString
import std.fs.File
import std.fs.Path
import std.io.ByteArrayStream
import std.regex.*
import std.math.*

public enum TokenizerType {
  SENTENCEPIECE |      // 句子片段分词器
  TIKTOIKEN |          // TikTok分词器
  BERT |               // BERT模型分词器
  HUGGINGFACE          // HuggingFace分词器
}

public open class Tokenizer {
  protected var specialTokens: ArrayList<UInt32> = ArrayList<UInt32>()      // 存储特殊标记的数组
  protected var stopTokens: ArrayList<UInt32> = ArrayList<UInt32>()         // 存储停用词标记的数组
  protected var PrefixTokens_: ArrayList<UInt32> = ArrayList<UInt32>()       // 存储前缀标记的数组

  public static const MAGIC_NUMBER:UInt32 = 430
  public static func createTokenizer(file_path: String, Tokenizer_Type: TokenizerType): Tokenizer {
    match (Tokenizer_Type) {
      case TokenizerType.HUGGINGFACE =>
        let tokenizer = HuggingfaceTokenizer()
        tokenizer.load_vocab(file_path: file_path)
        println("Tokenizer loaded successfully")
        return tokenizer
      case other => throw Exception("unsupport tokenizer type")
    }
  }

  public func isStopToken(token:UInt32): Bool {
    return stopTokens.contains(token)
  }

  public func isSpecial(token:UInt32): Bool {
    return specialTokens.contains(token)
  }

  public open func encode(_: String, add_specialTokens!: Bool): Array<UInt32> {
    if (add_specialTokens) {
      // todo
    }
    return Array<UInt32>()
  }

  public open func decode(_: Array<UInt32>, skip_specialTokens!: Bool): String {
    if (skip_specialTokens) {
      // todo
    }
    return ""
  }

  protected open func load_special(_: String) {
  }

  public open func load_vocab(file_path!: String, buffer!:Array<UInt8>) {
    if (!File.exists(file_path) && buffer.size == 0) {
      throw Exception("${file_path} not exists and buffer is empty")
    }
  }
}

public class Tiktoken <: Tokenizer {
  public override func decode(_: Array<UInt32>, skip_specialTokens!: Bool = false): String {
    if (skip_specialTokens) {
    }
    return ""
  }

  public override func load_vocab(file_path!: String = "", buffer!: Array<UInt8> = Array<UInt8>()){
    if (!File.exists(file_path) && buffer.size == 0) {
      throw Exception("${file_path} not exists and buffer is empty")
    }
  }

  public override func encode(str: String, add_specialTokens!: Bool = false): Array<UInt32> {
    if (add_specialTokens) {
      // todo
    }
    var token_ids: ArrayList<UInt32> = ArrayList<UInt32>()
    if (str.isEmpty()) {
      return token_ids.toArray()
    }
    var i: Int64 = 0
    while (i < str.size) {
      var len = str.size - i
      var longest_match_len: Int64 = 0
      var longest_match: String = ""
      while(len > 0) {
        let token = str[i..i + len]
        if (this.vocab_.contains(token) && len > longest_match_len) {
          longest_match_len = len
          longest_match = token
        }
        len--
      }
      if (!longest_match.isEmpty()) {
        token_ids.append(this.vocab_[longest_match])
        i += longest_match_len
      } else {
        eprintln("Error: No encoding found for the sequence starting at position ${i}")
      }
    }
    return token_ids.toArray()
  }

  protected var vocab_: HashMap<String,UInt32> = HashMap<String,UInt32>()
  protected var decoder_: ArrayList<String> = ArrayList<String>()
}

class HashPairString <: Hashable & Equatable<HashPairString> {
  public var first: String
  public var second: String
  public init(p: (String, String)) {
    this.first = p[0]
    this.second = p[1]
  }

  public func hashCode(): Int64 {
    let hash1: Int64 = this.first.hashCode()
    let hash2: Int64 = this.second.hashCode()
    if (hash1 != hash2) {
      return hash1 ^ hash2
    } else {
      return hash1
    }
  }

  public operator func == (other: HashPairString): Bool {
    return this.first == other.first && this.second == other.second
  }

  public operator func != (other: HashPairString): Bool {
    return !(this == other)
  }
}

public class HashPairUInt32 <: Hashable & Equatable<HashPairUInt32> & ToString{
  public var first: UInt32
  public var second: UInt32

  public init(p: (UInt32, UInt32)) {
    this.first = p[0]
    this.second = p[1]
  }

  public func toString(): String {
    return "(${this.first}, ${this.second})"
  }

  public func hashCode(): Int64 {
    let hash1: Int64 = this.first.hashCode()
    let hash2: Int64 = this.second.hashCode()
    // If hash1 == hash2, their XOR is zero.
    if (hash1 != hash2) {
      return hash1 ^ hash2
    } else {
      return hash1
    }
  }

  public operator func == (other: HashPairUInt32): Bool {
    return this.first == other.first && this.second == other.second
  }

  public operator func != (other: HashPairUInt32): Bool {
    return !(this == other)
  }

}

type BPERanks = HashMap<HashPairString, UInt32>
public type MergeMap = HashMap<HashPairUInt32, (UInt32, UInt32)>

public class HuggingfaceTokenizer <: Tokenizer {
  public var vocab: HashMap<String, UInt32> = HashMap<String, UInt32>()
  public var vocab_r: HashMap<UInt32, String> = HashMap<UInt32, String>()
  public var merges: MergeMap = MergeMap()
  public var dropout: Option<Float32> = None
  public var unk_token: Option<String> = None
  public var unk_token_id: Option<UInt32> = None
  public var continuing_subword_prefix: Option<String> = None
  public var end_of_word_suffix: Option<String> = None
  public var fuse_unk: Bool = false
  public var byte_fallback: Bool = false
  public var ignore_merges: Bool = false
  private let cache: HashMap<String, Array<String>> = HashMap<String, Array<String>>()
  private var bpe_ranks_: BPERanks = BPERanks()
  private let special_id_set: HashSet<String> = HashSet<String>()
  private var byte2rune: HashMap<UInt8, Rune> = HashMap<UInt8, Rune>()
  private var rune2byte: HashMap<Rune, UInt8> = HashMap<Rune, UInt8>()

  public init(
    vocab! : HashMap<String, UInt32> = HashMap<String, UInt32>(),
    merge_list!: ArrayList<(String, String)> = ArrayList<(String, String)>(),
    dropout!: Option<Float32> = None,
    unk_token!: Option<String> = None,
    continuing_subword_prefix!: Option<String> = None,
    end_of_word_suffix!: Option<String> = None,
    fuse_unk!: Bool = false,
    byte_fallback!: Bool = false,
    ignore_merges!: Bool = false
  ) {
    this.vocab = vocab
    for ((token, id) in this.vocab) {
      this.vocab_r.put(id, token)
    }
    (this.byte2rune, this.rune2byte) = this.get_byte_char()
    let prefix_len = continuing_subword_prefix.getOrDefault({=>""}).size
    var i: UInt32 = 0
    for ((a, b) in merge_list) {
      let a_id: UInt32 = this.vocab.get(a).getOrThrow()
      let b_id: UInt32 = this.vocab.get(b).getOrThrow()
      let new_token: String = "${a}${b[prefix_len..]}"
      let new_id: UInt32 = this.vocab.get(new_token).getOrThrow()
      this.merges.put(HashPairUInt32((a_id, b_id)), (i, new_id))
      this.bpe_ranks_.put(HashPairString((a, b)), i)
      i++
    }
    this.merges = merges
    this.dropout = dropout
    this.unk_token = unk_token
    this.continuing_subword_prefix = continuing_subword_prefix
    this.end_of_word_suffix = end_of_word_suffix
    this.fuse_unk = fuse_unk
    this.byte_fallback = byte_fallback
    this.ignore_merges = ignore_merges
  }

  public func get_byte_char(): (HashMap<UInt8, Rune>, HashMap<Rune, UInt8>) {
    var bs: ArrayList<UInt8> = ArrayList<UInt8>()
    var cs: ArrayList<UInt32> = ArrayList<UInt32>()
    var ranges: ArrayList<(Rune, Rune)> = ArrayList<(Rune, Rune)>()
    ranges.append((r'.', r'.')) // Example placeholder; replace with actual values
    ranges.append((r'!',r'~'))
    ranges.append((r"\u{A1}", r"\u{AC}"))
    ranges.append((r"\u{AE}", r"\u{FF}"))
    for ((start, end) in ranges) {
        for (x in UInt32(start)..=UInt32(end)) {
            bs.append(UInt8(x))
            cs.append(x)
        }
    }
    var n: UInt32 = 0
    for (b in 0_u8..=255_u8) {
      if (!bs.contains(b)) {
        bs.append(b)
        cs.append(UInt32(pow(2.0, 8)) + n)
        n += 1
      }
    }
    var result: HashMap<UInt8, Rune> = HashMap<UInt8, Rune>()
    var result_r: HashMap<Rune, UInt8> = HashMap<Rune, UInt8>()
    for ((k, v) in bs.iterator().zip(cs.iterator())) {
      result.put(k, Rune(v))
      result_r.put(Rune(v), k)
    }
    return (result, result_r)
  }

  public override func load_vocab(file_path!: String = "", buffer!: Array<UInt8> = Array<UInt8>()) {
    let json_buffer: Array<UInt8> = if (!File.exists(file_path) && buffer.size == 0) {
      throw Exception("${file_path} not exists and buffer is empty")
    } else if (File.exists(file_path)) {
      let file = File.openRead(file_path)
      let temp_buffer = file.readToEnd()
      file.close()
      temp_buffer
    } else {
      buffer
    }
    var byte_stream = ByteArrayStream()
    byte_stream.write(json_buffer)
    let json_reader = JsonReader(byte_stream)
    let tokenizer_config = TokenizerJson.fromJson(json_reader)
    (this.byte2rune, this.rune2byte) = this.get_byte_char()
    this.vocab = tokenizer_config.model.vocab
    for (add_token in tokenizer_config.added_tokens) {
      this.vocab.put(add_token.content, add_token.id)
      this.special_id_set.put(add_token.content)
    }
    if (this.unk_token.isSome()) {
      this.unk_token_id = this.vocab.get(this.unk_token.getOrThrow())
    }
    for ((token, id) in tokenizer_config.model.vocab) {
      this.vocab_r.put(id, token)
    }
    var str_list: Array<String> = Array<String>()
    var merge_list: ArrayList<(String, String)> = ArrayList<(String, String)>()
    for (line in tokenizer_config.model.merges) {
      str_list = line.split(" ")
      if (str_list.size != 2) {
        throw Exception("merge line size must be 2")
      }
      merge_list.append((str_list[0], str_list[1]))
    }
    let prefix_len = tokenizer_config.model.continuing_subword_prefix.size
    var i: UInt32 = 0
    for ((a, b) in merge_list) {
      let a_id: UInt32 = this.vocab.get(a).getOrThrow()
      let b_id: UInt32 = this.vocab.get(b).getOrThrow()
      let new_token: String = "${a}${b[prefix_len..]}"
      let new_id: UInt32 = this.vocab.get(new_token).getOrThrow()
      this.merges.put(HashPairUInt32((a_id, b_id)), (i, new_id))
      this.bpe_ranks_.put(HashPairString((a, b)), i)
      i++
    }
    this.dropout = tokenizer_config.model.dropout
    this.unk_token = tokenizer_config.model.unk_token
    this.continuing_subword_prefix = tokenizer_config.model.continuing_subword_prefix
    this.end_of_word_suffix = tokenizer_config.model.end_of_word_suffix
    this.fuse_unk = tokenizer_config.model.fuse_unk
    this.byte_fallback = tokenizer_config.model.byte_fallback
  }


  public func token_to_id(token: String): Option<UInt32> {
    return this.vocab.get(token)
  }

  public func id_to_token(id: UInt32) {
    return this.vocab_r.get(id)
  }

  public func apply_chat_template(
    messages: ArrayList<Message>,
    add_generation_prompt!: Bool = false
  ): String {
    var result_str = ""
    if (messages.size == 0) {
      return result_str
    }
    match (messages[0].role) {
      case RoleType.System =>
        result_str += "<|im_start|>system\n${messages[0].content}<|im_end|>\n"
        messages.remove(0)
      case _ => ()
    }
    if (messages.size % 2 != 1) {
      throw Exception("input times - assistant times must = 1")
    }
    for (i in 0..messages.size) {
      if (i % 2 == 0) {
        result_str += "<|im_start|>user\n${messages[i].content}<|im_end|>\n"
      } else {
        result_str += "<|im_start|>assistant\n${messages[i].content}<|im_end|>\n"
      }
    }
    if (add_generation_prompt) {
      result_str += "<|im_start|>assistant\n"
    }
    return result_str
  }

  public override func decode(token_ids: Array<UInt32>, skip_specialTokens!: Bool = false): String {
    let data_array = ArrayList<UInt8>()
    let special_set = this.special_id_set   //缓存局部变量
    let rune_map = this.rune2byte           // 缓存局部变量

    for (token_id in token_ids) {
        let token_str = this.id_to_token(token_id).getOrThrow()
        if (skip_specialTokens && special_set.contains(token_str))  {
            continue
        }
        for (rune in token_str.toRuneArray())  {
            data_array.append(rune_map[rune])   //假设rune_map是数组
        }
    }
    return String.fromUtf8(data_array.toArray())
}

  public override func encode(str: String, add_specialTokens!: Bool = false): Array<UInt32> {
    if (add_specialTokens) {
      // todo
    }
    var special_pattern: String = "("
    for ((idx, special_str) in this.special_id_set.iterator().enumerate()) {
      if (idx < this.special_id_set.size - 1) {
        special_pattern += special_str.replace("|", "\\|") + "|"
      } else {
        special_pattern += special_str.replace("|", "\\|") + ")"
      }
    }
    let special_re: Regex = Regex(special_pattern)
    let special_token_map = HashMap<Int64, UInt32>()
    let special_index_list = ArrayList<(Int64, Int64)>()
    let added_special_index = HashSet<Int64>()
    let special_array = special_re.matcher(str).findAll() ?? Array<MatchData>()
    var text = str
    for (special in special_array) {
      let special_token = special.matchStr()
      println("special token: ${special_token}")
      special_token_map.put(
        special.matchPosition().start,
        this.vocab.get(special_token).getOrThrow()
      )
      special_index_list.append((
        special.matchPosition().start,
        special.matchPosition().end
      ))
      var empty_token = ""
      var temp_i = 0
      while(temp_i < special_token.size) {
        empty_token += " "
        temp_i++
      }
      text = text.replace(special_token, empty_token)
    }
    let text_re: Regex = Regex("('s|'t|'re|'ve|'m|'ll|'d| ?[[:alpha:]]+| ?[[:digit:]]+| ?[^\\s\\w]+|\\s+)")
    let match_array = text_re.matcher(text).findAll() ?? Array<MatchData>()
    var ids = ArrayList<UInt32>()
    var special_index = 0
    for (token in match_array) {
      let temp_start = token.matchPosition().start
      let temp_end = token.matchPosition().end
      var temp_si = special_index
      var isSpecial = false
      while (temp_si < special_index_list.size) {
        let (s_start, s_end) = special_index_list[temp_si]
        if (temp_end <= s_start) {
          break
        }
        if (temp_start >= s_start && temp_start < s_end) {
          if (!added_special_index.contains(temp_si)) {
            let special_token_id = special_token_map[s_start]
            ids.append(special_token_id)
            special_index = max(temp_si - 1, 0)
            added_special_index.put(temp_si)
          }
          isSpecial = true
          break
        }
        temp_si ++
      }
      if (isSpecial) {
        continue
      }
      let token_str = token.matchStr()
      var temp_str: String = ""
      var token_list = ArrayList<String>()
      for (b in token_str.toArray()) {
        let char = this.byte2rune[b]
        temp_str += char.toString()
        token_list.append(char.toString())
      }
      if (this.cache.contains(temp_str)) {
        let result_str_list = this.cache[temp_str]
        for (result_str in result_str_list) {
          ids.append(this.vocab[result_str])
        }
        continue
      }
      let str_list = this.bpe(token_list.toArray())
      this.cache.put(temp_str, str_list)
      for (temp_str in str_list) {
        let new_token = this.token_to_id(temp_str).getOrDefault({=>this.unk_token_id.getOrThrow()})
        ids.append(new_token)
      }
    }
    return ids.toArray()
  }


  private func get_pairs(tokens: Array<String>): Array<HashPairString> {
    var pairs: ArrayList<HashPairString> = ArrayList<HashPairString>()
    if (tokens.size > 1) {
      var previous: String = tokens[0]
      var next: String = " "
      var i: Int64 = 1
      while (i < tokens.size) {
        next = tokens[i]
        pairs.append(HashPairString((previous.toString(), next.toString())))
        previous = next
        i++
      }
    }
    return pairs.toArray()
  }

  private func bpe(token_list: Array<String>): Array<String> {
    var word = token_list
    if (word.isEmpty())  {
        return word
    }
    // var pairs = self.get_pairs(word)
    var pairs: Array<HashPairString> = this.get_pairs(word)
    while (true) {
        var merged: HashSet<Int32> = HashSet<Int32>()
        var min_score:UInt32 =UInt32.Max
        var to_merge: Int = -1
        var l: Int64 = 0
        while (l < pairs.size) {
          if (!merged.contains(Int32(l))) {
            let score = if (this.bpe_ranks_.contains(pairs[l])) {
              this.bpe_ranks_[pairs[l]]
            } else {
             UInt32.Max
            }
            if (score < min_score) {
              min_score = score
              to_merge = l
            }
          }
          l++
      }
        if (to_merge == -1) {
            break
        }
        let first = pairs[to_merge].first
        let second = pairs[to_merge].second
        var new_word: ArrayList<String> = ArrayList<String>()
        var i = 0
        while (i < word.size)  {
            if (i < word.size  - 1 && word[i] == first && word[i + 1] == second) {
                new_word.append(first  + second)
                i += 2
            } else {
                new_word.append(word[i])
                i += 1
            }
        }
        word = new_word.toArray()
        if (word.size  == 1) {
            break
        } else {
            pairs = this.get_pairs(word)
        }
    }
    return word
}
}