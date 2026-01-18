// 3rd_party_lib:mysqlclient-ffi/build/mysqlclient
// 3rd_party_lib_ohos:mysqlclient-ffi/build/aarch64-linux-ohos/mysqlclient
import std.database.sql.*
import std.io.*
import std.time.* 
import std.regex.*
import mysqlclient_ffi.*
import std.math.*
import std.collection.*

main() {
    println("TCS: mysqlclient-ffi, time elapsed: 1 ns, RESULT:")
    let threadCount = 100
    let loopCount = 10000
    let futures = ArrayList<Future<ArrayList<String>>>()
    let start = DateTime.now()
    for (_ in 0..threadCount) {
        let thread = spawn {
            let mysqlDriver: MysqlDriver = MysqlDriver("mysql")
            let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
            )
            let conn: MysqlConnection = mysqlDatasource.connect()
            var result=ArrayList<String>()
            for (_ in 0..loopCount) {
                try {
                    var prepareStatement = conn.prepareStatement("drop table if exists test")
                    prepareStatement=conn.prepareStatement("create table test(data text(20) NOT NULL, datanull text(20))")
                    prepareStatement=conn.prepareStatement("insert into test values(?,?)")
                    var str = ByteArrayStream(20)
                    str.write("12345678".toUtf8Array())
                    var rowCount = prepareStatement.update([SqlClob(str), SqlNullableClob(None)])
                    if(rowCount.rowCount == 1){
                        result.append("success")
                    }else{
                        result.append("fail")
                    }
                } catch (e: SqlException) {
                    println("e> ${e.toString()}")
                    result.append("fail")
                    continue
                }
            }
            conn.close()
            return result
        }
        futures.append(thread)
    }

    for (f in futures) {
        f.get()
    }

    let end = Duration.since(start).toSeconds()
    var count_fail=0
    for (f in futures){
        var temp_re=f.get()
        for (j in temp_re){
            if(j=="fail"){
                count_fail+=1
            }
        }
    }
    println("TestSuiteMysqlclient-ffi__${threadCount}*${loopCount}: TotalTime:${end} s  TPS: ${Int64((threadCount*loopCount)/end)}  FailRate: ${count_fail/(threadCount*loopCount)*100} %")

    return 0
}
