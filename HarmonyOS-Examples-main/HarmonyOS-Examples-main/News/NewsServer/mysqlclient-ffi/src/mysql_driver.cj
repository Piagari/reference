/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package mysqlclient_ffi

// 自动注册驱动
let _ = {
     => DriverManager.register("mysql", MysqlDriver("mysql"))
}()

/*
 * 数据库驱动
 */
public class MysqlDriver <: Driver {
    private var driverNmae: String

    /*
     * 初始化驱动
     *
     * 参数 name - 驱动名称
     * 异常 SqlException - 内存不足导致初始化失败
     */
    public init(name: String) {
        this.driverNmae = name
    }

    /**
     * 驱动名称
     */
    public override prop name: String {
        get() {
            unsafe {
                return driverNmae
            }
        }
    }

    /**
     * 驱动版本
     *
     * 异常 SqlException - 获取版本失败
     */
    public override prop version: String {
        get() {
            unsafe {
                // 服务器版本号（字符串）
                let version: CString = mysql_get_client_info()
                if (version.isNull()) {
                    throw SqlException("Mysql Version Failed!")
                } else {
                    return version.toString()
                }
            }
        }
    }

    /**
     * 指示驱动程序是否与连接池亲和。
     * 如果否，则不建议使用连接池。
     * 比如sqlite驱动连接池化的收益不明显，不建议使用连接池
     */
    public override prop preferredPooling: Bool {
        get() {
            return true
        }
    }

    /*
     * 通过connectionString和选项打开数据源
     *
     * 参数 connectionString - 数据库连接字符串
     * 参数 _ - key,value的tuple数组，打开数据源的选项
     * 返回值 Datasource - 数据源实例
     * 异常 SqlException - connectionString连接内容不正确会导致异常
     */
    public override func open(connectionString: String, _: Array<(String, String)>): MysqlDatasource {
        var arrList: Array<String> = openString(connectionString)
        return MysqlDatasource(arrList)
    }

    /*
     * 对传入参数格式化处理
     *
     * 参数 connectionString - 数据库连接字符串
     * 返回值 Array<String> - 格式化之后的列表
     */
    private func openString(connectionString: String): Array<String> {
        var arr: Array<String> = connectionString.split(";", removeEmpty: false)
        if (arr.size != 7) {
            throw SqlException("Url is error!")
        }
        var hostString: String = ""
        var userString: String = ""
        var pwdString: String = ""
        var dbString: String = ""
        var portString: String = ""
        var unixSocketString: String = ""
        var clientFlagString: String = ""
        for (i in 0..7) {
            var list = arr[i].split("=", removeEmpty: false)
            if (list.size != 2) {
                throw SqlException("Url is error!")
            }
            if (list[0] == "HOST") {
                hostString = list[1]
            } else if (list[0] == "USER") {
                userString = list[1]
            } else if (list[0] == "PASSWD") {
                pwdString = list[1]
            } else if (list[0] == "DB") {
                dbString = list[1]
            } else if (list[0] == "PORT") {
                portString = list[1]
            } else if (list[0] == "UNIX_SOCKET") {
                unixSocketString = list[1]
            } else if (list[0] == "CLIENT_FLAG") {
                clientFlagString = list[1]
            } else {
                throw SqlException("Url is error!")
            }
        }
        var arrList: Array<String> = Array<String>(7, item: "")
        arrList[0] = hostString
        arrList[1] = userString
        arrList[2] = pwdString
        arrList[3] = dbString
        arrList[4] = portString
        arrList[5] = unixSocketString
        arrList[6] = clientFlagString
        try {
            UInt32.parse(arrList[4])
            UInt64.parse(arrList[6])
        } catch (e: IllegalArgumentException) {
            (e)
            throw SqlException("Url is error!")
        }
        return arrList
    }
}
