/**
 * Created on 2025/4/28
 *
 * SilkHighLight 文本高亮组件
 *
 * 文本高亮组件用于在文本中突出显示特定的关键词，常用于搜索结果展示等场景。
 *
 * ## 基础用法
 * ```
 * SilkHighLight(props: SilkHighLightOptions(
 *   sourceString: "这是一段文本，包含关键词",
 *   keywords: ["关键词"]
 * ))
 * ```
 *
 * ## 自定义样式
 * ```
 * SilkHighLight(props: SilkHighLightOptions(
 *   sourceString: "这是一段文本，包含关键词",
 *   keywords: ["关键词"],
 *   color: Color(255, 0, 0, alpha: 1),
 *   fontSize: 16.vp,
 *   fontWeight: FontWeight.W500
 * ))
 * ```
 *
 * ## 区分大小写
 * ```
 * SilkHighLight(props: SilkHighLightOptions(
 *   sourceString: "This is a text with Keyword",
 *   keywords: ["keyword"],
 *   caseSensitive: true
 * ))
 * ```
 *
 * @module silkui/components/highlight
 */
package silkui.components.highlight

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.resource_manager.*
import ohos.state_macro_manage.*

import cj_res_silkui.*
import std.collection.*
import std.math.max
import silkui.ResourceColor
import silkui.utils.ResourceColorToColor

/**
 * 文本高亮组件
 *
 * 用于在文本中突出显示特定的关键词
 */
@Component
public class SilkHighLight {
    /**
     * 高亮配置选项
     *
     * 包含源文本、关键词、样式等配置
     */
    @Prop
    @Watch[initArray]
    var props: SilkHighLightOptions

    /**
     * 文本分块数组
     *
     * 存储分割后的文本块，每个块可能是高亮或非高亮状态
     */
    @State
    var chunks: ArrayList<SilkHighLightChunk> = ArrayList()

    /**
     * 组件即将出现时的生命周期方法
     *
     * 初始化文本分块
     */
    protected override func aboutToAppear() {
        // 组件初始化时调用 initArray 方法
        initArray()
    }

    /**
     * 构建组件UI
     *
     * 渲染高亮文本
     */
    func build () {
        // 显示高亮文本
        Row() {
            Text() {
            ForEach(
                chunks,
                itemGeneratorFunc: { chunk: SilkHighLightChunk, _: Int64 =>
                    if (chunk.high) {
                        // 高亮文本
                        Span(chunk.text)
                            .fontColor(ResourceColorToColor(props.color))
                            .fontSize(props.fontSize)
                            .fontWeight(props.fontWeight)
                    } else {
                        // 普通文本
                        Span(chunk.text)
                            .fontColor(ResourceColorToColor(props.defaultColor))
                            .fontSize(props.defaultFontSize)
                            .fontWeight(props.defaultFontWeight)
                    }
                }
            )
        }
        }
    }

    /**
     * 初始化文本分块数组
     *
     * 根据关键词将源文本分割成高亮和非高亮的文本块
     */
    func initArray () {
        // 如果没有关键词，整个文本作为非高亮块
        if (props.keywords.isNone() || props.keywords.getOrThrow().size == 0) {
            chunks = ArrayList([SilkHighLightChunk(high: false, text: props.sourceString)])
            return
        }

        // 获取属性值
        let autoEscape = props.autoEscape
        let caseSensitive = props.caseSensitive
        let sourceString = props.sourceString
        let keywordsArray = props.keywords.getOrThrow()

        // 存储分块信息的数组
        // 每个元素是一个元组，包含起始位置、结束位置和是否高亮
        var chunkInfos: ArrayList<(start: Int64, end: Int64, highlight: Bool)> = ArrayList()

        // 第一步：生成高亮块
        for (i in 0..keywordsArray.size) {
            var keyword = keywordsArray[i]
            if (keyword.isEmpty()) {
                continue
            }

            // 如果需要自动转义，则转义特殊正则表达式字符
            if (autoEscape) {
                // 转义特殊正则表达式字符: . * + ? ^ $ { } ( ) | [ ] \
                keyword = keyword.replace("\\", "\\\\")
                keyword = keyword.replace(".", "\\.")
                keyword = keyword.replace("*", "\\*")
                keyword = keyword.replace("+", "\\+")
                keyword = keyword.replace("?", "\\?")
                keyword = keyword.replace("^", "\\^")
                keyword = keyword.replace("$", "\\$")
                keyword = keyword.replace("{", "\\{")
                keyword = keyword.replace("}", "\\}")
                keyword = keyword.replace("(", "\\(")
                keyword = keyword.replace(")", "\\)")
                keyword = keyword.replace("|", "\\|")
                keyword = keyword.replace("[", "\\[")
                keyword = keyword.replace("]", "\\]")
            }

            // 创建正则表达式并查找所有匹配项
            // 注意：由于 Cangjie 可能没有完全支持 JavaScript 的正则表达式功能
            // 这里使用简单的字符串匹配来模拟正则表达式的功能

            var searchIndex = 0
            var sourceStringLower = sourceString
            var keywordLower = keyword

            // 如果不区分大小写，将源字符串和关键词都转换为小写
            if (!caseSensitive) {
                sourceStringLower = sourceString.toAsciiLower()
                keywordLower = keyword.toAsciiLower()
            }

            while (true) {
                // 查找下一个匹配项
                let foundIndex = sourceStringLower.indexOf(keywordLower, searchIndex)
                if (foundIndex.isNone()) {
                    // 没有找到更多匹配项
                    break
                }

                let start = foundIndex.getOrThrow()
                let end = start + keywordLower.size

                // 添加高亮块
                chunkInfos.append((start, end, true))

                // 更新搜索索引
                searchIndex = end

                // 防止无限循环
                if (start >= end) {
                    searchIndex = searchIndex + 1
                }
            }
        }

        // 第二步：合并块
        // 按起始位置排序
        chunkInfos.sortBy(stable: true, comparator: { a, b =>
            if (a[0] < b[0]) {
                return Ordering.LT
            } else if (a[0] > b[0]) {
                return Ordering.GT
            } else {
                return Ordering.EQ
            }
        })

        var mergedChunks: ArrayList<(start: Int64, end: Int64, highlight: Bool)> = ArrayList()

        // 合并重叠的块
        for (i in 0..chunkInfos.size) {
            let currentChunk = chunkInfos[i]

            if (mergedChunks.isEmpty()) {
                mergedChunks.append(currentChunk)
                continue
            }

            let prevChunk = mergedChunks[mergedChunks.size - 1]

            if (currentChunk[0] > prevChunk[1]) {
                // 添加非高亮块
                let unhighlightStart = prevChunk[1]
                let unhighlightEnd = currentChunk[0]

                if (unhighlightStart != unhighlightEnd) {
                    mergedChunks.append((unhighlightStart, unhighlightEnd, false))
                }

                // 添加当前高亮块
                mergedChunks.append(currentChunk)
            } else {
                // 合并重叠的块
                mergedChunks[mergedChunks.size - 1] = (
                    prevChunk[0],
                    max(prevChunk[1], currentChunk[1]),
                    true
                )
            }
        }

        // 第三步：处理边界情况
        if (mergedChunks.isEmpty()) {
            // 如果没有匹配项，则整个字符串为非高亮
            mergedChunks.append((0, sourceString.size, false))
        } else {
            let lastChunk = mergedChunks[mergedChunks.size - 1]

            // 如果最后一个块没有覆盖到字符串末尾，添加一个非高亮块
            if (lastChunk[1] < sourceString.size) {
                mergedChunks.append((
                    lastChunk[1],
                    sourceString.size,
                    false
                ))
            }

            // 如果第一个块没有从字符串开头开始，添加一个非高亮块
            if (mergedChunks[0][0] > 0) {
                mergedChunks.insert(0,(
                    0,
                    mergedChunks[0][0],
                    false
                ))
            }
        }

        // 第四步：将合并后的块转换为 SilkHighLightChunk 对象
        chunks.clear()
        for (i in 0..mergedChunks.size) {
            let chunk = mergedChunks[i]
            let text = String.fromUtf8(sourceString.toArray().clone(chunk[0]..chunk[1]))
            chunks.append(SilkHighLightChunk(high: chunk[2], text: text))
        }
    }
}