package ohos_app_cangjie_entry
import std.core.Comparable
import std.collection.ArrayList
import std.random
import std.math.*

public func sample_logists(
  logits: Array<Float32>,
  sampling_method: SamplingMethod,
  sampling_value: Float32,
  temperature: Float32
): Array<UInt32> {
  let result_array = ArrayList<UInt32>(1, {_ => 0}).toArray();
  // 对logits做采样，得到下一个token
  if (temperature == 0.0) {
    var max_value: Float32 = Float32.Min;
    var max_index: Int64 = 0;
    for (i in 0..logits.size) {
      if (logits[i] > max_value) {
        max_value = logits[i];
        max_index = i;
      }
    }
    let new_token = UInt32(max_index);
    result_array[0] = new_token;
    return result_array;
  }
  match(sampling_method) {
    case SamplingMethod.Greedy =>
      var max_value: Float32 = Float32.Min;
      var max_index: Int64 = 0;
      for (i in 0..logits.size) {
        if (logits[i] > max_value) {
          max_value = logits[i];
          max_index = i;
        }
      }
      let new_token = UInt32(max_index);
      result_array[0] = new_token;
      return result_array;
    case _ =>
      //1. logits /= temperature
      //2. probs = np.exp(logits) / np.sum(np.exp(logits))
      var data_sum: Float32 = 0.0;
      for (i in 0..logits.size) {
        // 1. logits /= temperature
        logits[i] = logits[i] / temperature;
        // 2.1 np.exp(logits)
        logits[i] = exp(logits[i]);
        // 2.2 np.sum(np.exp(logits))
        data_sum += logits[i];
      }
      for (i in 0..logits.size) {
        // 2.3 np.exp(logits) / np.sum(np.exp(logits))
        logits[i] = logits[i] / data_sum;
      }
      // 3. sorted_probs = np.sort(probs)[:, ::-1]
      //    sorted_indices = np.argsort(probs)[:, ::-1]
      let (sorted_probs, sorted_indices)  = sort_with_indices<Float32>(logits);
      var index_of_interest: Int64 = 0;
      match (sampling_method) {
        case SamplingMethod.Top_k => index_of_interest = Int64(sampling_value)
        case SamplingMethod.Top_p =>
          let p  = sampling_value
          // 4. cumulative_probs = np.cumsum(sorted_probs, axis=-1)
          let cumulative_probs: Array<Float32> = Array<Float32>(sorted_probs.size, {_=>0.0});
          var temp_sum: Float32 = 0.0;
          for (i in 0..sorted_probs.size) {
            temp_sum += sorted_probs[i];
            cumulative_probs[i] = temp_sum;
            index_of_interest = i;
            if (cumulative_probs[i] > p) {
              break;
            }
          }
        case other => println("do agained for Greedy");
      }
      let probs_of_interest = sorted_probs[..index_of_interest + 1];
      let indices_of_interest = sorted_indices[..index_of_interest + 1];
      // 5. probs_of_interest /= np.sum(probs_of_interest)
      var temp_sum2: Float32 = 0.0;
      for (i in 0..probs_of_interest.size) {
        temp_sum2 += probs_of_interest[i];
      }
      for (i in 0..probs_of_interest.size) {
        probs_of_interest[i] =  probs_of_interest[i] / temp_sum2;
      }
      let next_token: Int64 = random_choice(indices_of_interest, probs_of_interest);
      result_array[0] = UInt32(next_token);
      return result_array;
  }
  return result_array;
}

func swap<T>(array: Array<T>, i: Int64, j: Int64) {
    // 交换空间，由于Array本身就是引用类型，所以没有内存损耗问题
    let temp: T = array[i];
    array[i] = array[j];
    array[j] = temp;
}

// 快速排序的辅助函数，用于分区
func partition<T>(arr: Array<T>, indices: Array<Int64>, low: Int64, high: Int64): Int64 where T <: Comparable<T> {
  let pivot: T = arr[high];
  var i = low - 1;
  var j = low;
  while (j <= high - 1) {
    if (arr[j] > pivot) { // 修改比较逻辑，从大到小排序
        i++;
        swap(arr, i, j)
        swap(indices, i, j);
    }
    j ++;
  }
  swap(arr, i + 1, high);
  swap(indices, i + 1, high)
  return i + 1;
}

// 快速排序的主函数
func quick_sort<T>(arr: Array<T>, indices: Array<Int64>, low: Int64, high: Int64): Unit where T <: Comparable<T> {
  if (low < high) {
    let pi: Int64 = partition<T>(arr, indices, low, high);

    quick_sort(arr, indices, low, pi - 1);
    quick_sort(arr, indices, pi + 1, high);
  }
}

// 主函数，返回排序后的数组和对应的索引
public func sort_with_indices<T>(arr: Array<T>): (Array<T>, Array<Int64>) where T <: Comparable<T> {
  let sorted_arr: Array<T> = arr.clone();
  let indices: Array<Int64> = Array<Int64>(arr.size, {index => index});
  quick_sort<T>(sorted_arr, indices, 0, arr.size - 1);
  return (sorted_arr, indices);
}


// 手动计算累积概率分布
public func cumsum(p: Array<Float32>): Array<Float32> {
  let cumsum_p: Array<Float32> = Array<Float32>(p.size, {_=>0.0})
  cumsum_p[0] = p[0];
  for(i in 1..p.size) {
    cumsum_p[i] = cumsum_p[i-1] + p[i];
  }
  return cumsum_p;
}

// 从 indices 中根据概率 p 随机选择一个元素
public func random_choice(indices: Array<Int64>, p: Array<Float32>): Int64 {
    // 检查输入的有效性
    if (indices.size != p.size) {
      throw Exception("indices size must be same of p");
    }
    // 计算累积概率分布
    let cumsum_p = cumsum(p);
    // 生成一个随机数(位于0～1之间)
    let rand_num: Float32 = random.Random().nextFloat32();

    // 根据累积概率分布选择一个元素
    for (i in 0..cumsum_p.size) {
      if (rand_num < cumsum_p[i]) {
        return indices[i];
      }
    }
    // 如果所有概率都为0，返回最后一个元素（理论上不应该发生）
    return indices[indices.size - 1];
}