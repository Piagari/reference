/**
 * Created on 2025/7/17
 *
 * SilkUI 日志工具类
 *
 * 提供统一的日志输出功能，支持不同级别的日志记录
 *
 * ## 基础用法
 * ```
 * AppLog.debug("调试信息")
 * AppLog.info("普通信息")
 * AppLog.warn("警告信息")
 * AppLog.error("错误信息")
 * ```
 *
 * ## 格式化输出
 * ```
 * AppLog.info("用户ID: ${userId}, 用户名: ${userName}")
 * ```
 *
 * @module silkui/utils
 */
package silkui.utils

import ohos.hilog.*

/**
 * 日志工具类
 *
 * 封装了HiLog的基础功能，提供统一的日志输出接口
 */
public class Logger {
    /**
     * 日志域标识
     * 用于标识日志来源
     */
    private let domain: UInt32

    /**
     * 日志标签前缀
     * 用于标识日志模块
     */
    private let prefix: String

    /**
     * 日志格式化字符串
     * 默认格式为公共字符串输出
     */
    private let format: String = "%{public}s"

    /**
     * 构造函数
     *
     * @param prefix 日志标签前缀
     * @param domain 日志域标识，默认为0xFF00
     */
    public init(prefix: String, domain: UInt32) {
        this.prefix = prefix
        this.domain = domain
    }

    /**
     * 构造函数（使用默认域）
     *
     * @param prefix 日志标签前缀
     */
    public init(prefix: String) {
        this.prefix = prefix
        this.domain = 0xFF00
    }

    /**
     * 输出调试级别日志
     *
     * @param message 日志内容
     */
    public func debug(message: String): Unit {
        Hilog.debug(domain, prefix, "${prefix} ${message}")
    }

    /**
     * 输出信息级别日志
     *
     * @param message 日志内容
     */
    public func info(message: String): Unit {
        Hilog.info(domain, prefix, "${prefix} ${message}")
    }

    /**
     * 输出警告级别日志
     *
     * @param message 日志内容
     */
    public func warn(message: String): Unit {
        Hilog.warn(domain, prefix, "${prefix} ${message}")
    }

    /**
     * 输出错误级别日志
     *
     * @param message 日志内容
     */
    public func error(message: String): Unit {
        Hilog.error(domain, prefix, "${prefix} ${message}")
    }
}

/**
 * 默认应用日志实例
 *
 * 使用SilkUI作为标签前缀的全局日志实例
 */
public let SilkUILog: Logger = Logger("[SilkUI]")