/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package mysqlclient_ffi

/*
 * 数据源
 */
public class MysqlDatasource <: Datasource {
    private var arrList: Array<String>
    private var optionList: HashMap<Int32, CPointer<Unit>> = HashMap<Int32, CPointer<Unit>>()

    /*
     * 初始化数据源
     *
     * 参数 mysql - 初始化的mysql
     * 参数 arrList - 格式化之后的参数
     */
    init(arrList: Array<String>) {
        this.arrList = arrList
    }

    /*
     * 设置连接选项(不支持)
     *
     * 参数 key - key
     * 参数 value - value
     */
    public override func setOption(_: String, _: String): Unit {
    }

    /*
     * 连接前设置选项
     *
     * 参数 key - C中枚举 enum mysql_option
     * 参数 value - 值
     */
    public func setOption(key: MysqlOption, value: String): Unit {
        unsafe {
            let sqlCString: CString = LibC.mallocCString(value)
            let valueCPointer: CPointer<Unit> = CPointer<Unit>(sqlCString.getChars())
            optionList.put(key.toInt32(), valueCPointer)
        }
    }

    /*
     * 连接前设置选项
     *
     * 参数 key - C中枚举 enum mysql_option
     * 参数 value - 值
     */
    public func setOption(key: MysqlOption, value: UInt32): Unit {
        unsafe {
            let valueCPointer: CPointer<UInt32> = LibC.malloc<UInt32>()
            valueCPointer.write(value)
            let valueCPointer1: CPointer<Unit> = CPointer<Unit>(valueCPointer)
            optionList.put(key.toInt32(), valueCPointer1)
        }
    }

    /*
     * 连接前设置选项
     *
     * 参数 key - C中枚举 enum mysql_option
     * 参数 value - 值
     */
    public func setOption(key: MysqlOption, value: UInt64): Unit {
        unsafe {
            let valueCPointer: CPointer<UInt64> = LibC.malloc<UInt64>()
            valueCPointer.write(value)
            let valueCPointer1: CPointer<Unit> = CPointer<Unit>(valueCPointer)
            optionList.put(key.toInt32(), valueCPointer1)
        }
    }

    /*
     * 连接前设置选项
     *
     * 参数 key - C中枚举 enum mysql_option
     * 参数 value - 值
     */
    public func setOption(key: MysqlOption, value: Bool): Unit {
        unsafe {
            let valueCPointer: CPointer<Byte> = LibC.malloc<Byte>()
            if (value) {
                valueCPointer.write(1)
            } else {
                valueCPointer.write(0)
            }
            let valueCPointer1: CPointer<Unit> = CPointer<Unit>(valueCPointer)
            optionList.put(key.toInt32(), valueCPointer1)
        }
    }

    /*
     * 返回一个可用的连接
     *
     * 返回值 Connection - 数据库连接实例
     * 异常 SqlException - 和mysql server连接失败会导致异常
     */
    public override func connect(): MysqlConnection {
        let portUInt32: UInt32 = UInt32.parse(arrList[4])
        let clientFlagUInt32: UInt64 = UInt64.parse(arrList[6])
        unsafe {
            let tCPointer: CPointer<Unit> = CPointer<Unit>()
            // 获取或初始化结构MYSQL
            var mysql: CPointer<Unit> = mysql_init(tCPointer)

            if (mysql.isNull()) {
                // 内存不足返回NULL
                throw SqlException("Mysql Initialization Failed!")
            }

            // 对保存的设置内容进行处理设置
            for (_ in 0..optionList.size) {
                var hashMapIterator: HashMapIterator<Int32, CPointer<Unit>> = optionList.iterator()
                var optionValue: Option<(Int32, CPointer<Unit>)> = hashMapIterator.next()
                while (true) {
                    match (optionValue) {
                        case Some(v) =>
                            mysql_options(mysql, v[0], v[1])
                            LibC.free<Unit>(v[1])
                        case None => break
                    }
                }
            }

            var hostCString: CString = CString(CPointer<UInt8>())
            if (arrList[0].size != 0) {
                hostCString = LibC.mallocCString(arrList[0])
            }
            var userCString: CString = CString(CPointer<UInt8>())
            if (arrList[1].size != 0) {
                userCString = LibC.mallocCString(arrList[1])
            }
            var pwdCString: CString = CString(CPointer<UInt8>())
            if (arrList[2].size != 0) {
                pwdCString = LibC.mallocCString(arrList[2])
            }
            var dbCString: CString = CString(CPointer<UInt8>())
            if (arrList[3].size != 0) {
                dbCString = LibC.mallocCString(arrList[3])
            }
            var unixSocketCString: CString = CString(CPointer<UInt8>())
            if (arrList[5].size != 0) {
                unixSocketCString = LibC.mallocCString(arrList[5])
            }

            // 	连接到MySQL服务器
            mysql = mysql_real_connect(
                mysql,
                hostCString,
                userCString,
                pwdCString,
                dbCString,
                portUInt32,
                unixSocketCString,
                clientFlagUInt32
            )
            if (arrList[0].size != 0) {
                LibC.free(hostCString)
            }
            if (arrList[1].size != 0) {
                LibC.free(userCString)
            }
            if (arrList[2].size != 0) {
                LibC.free(pwdCString)
            }
            if (arrList[3].size != 0) {
                LibC.free(dbCString)
            }
            if (arrList[5].size != 0) {
                LibC.free(unixSocketCString)
            }
            if (mysql.isNull()) {
                throw SqlException("Connect Failed!")
            }
            return MysqlConnection(mysql)
        }
    }

    /*
     * 关闭资源 （不支持）
     */
    public override func close(): Unit {}

    /*
     * 判断资源是否关闭（不支持）
     *
     * 返回值 Bool - 如果已经关闭返回true，否则返回false
     */
    public override func isClosed(): Bool {
        return false
    }
}
