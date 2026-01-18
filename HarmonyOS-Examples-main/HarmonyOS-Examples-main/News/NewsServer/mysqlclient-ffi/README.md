<div align="center">
<h1>mysqlclient-ffi</h1>
</div>

<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v0.0.1-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v0.53.4-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjcov-91.2%25-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/project-open-brightgreen" style="display: inline-block;" />
</p>

## 介绍

依照CDBC标准封装的mysql的c语言libmysqlclient库

### 特性

- 连接数据库
- 创建删除数据表
- 对数据库内容增删改查

### 支持

| System            | Supported          |
|-------------------|--------------------|
| Windows           | Y                  |
| Linux-arrch64     | Y                  |
| Linux-x86         | Y                  |

## 软件架构

### 源码目录

```shell
.
├─ .gitee
│   └─ PULL_REQUEST_TEMPLATE.zh-CN.md
├─ .gitignore
├─ CHANGELOG.md
├─ gitee_gate.cfg
├─ module.json
├─ LICENSE
├─ README.md
├─ README.OpenSource
├─ doc
│   ├─ assets
│   └─ feature_api.md
├─ libmysqlclient_c
├─ src
│  └─ mysqlclient
└─ test
    ├─ DOC
    ├─ FUZZ
    ├─ Reliability
    ├─ HLT
    └─ LLT
```

- `doc`  文档目录，用于存放API接口等文档
- `libmysqlclient_c`  需要自行编译的c文件
- `src`  源码目录
- `test` 测试目录
- `test DOC` 演示样例
- `test FUZZ` FUZZ用例
- `test Reliability` 并发用例
- `test HLT` HLT用例
- `test LLT` LLT用例

### 接口说明

主要是核心类和成员函数说明，详情见 [API](./doc/feature_api.md)

## 使用说明

### 编译

编译静态库方法请参考： [编译静态库](./doc/编译静态库.md)

1、本项目基于 mysqlclient8.0.33 开发，需要依赖 mysqlclient，下载地址 https://downloads.mysql.com/archives/community/

windows环境下需要msys2、mingw64、cmake

下载msys2和mingw64

msys2：https://github.com/msys2/msys2-installer/releases/download/2023-03-18/msys2-x86_64-20230318.exe

mingw64：https://github.com/niXman/mingw-builds-binaries/releases/download/12.2.0-rt_v10-rev2/x86_64-12.2.0-release-posix-seh-msvcrt-rt_v10-rev2.7z

将mingw64解压到msys2的根目录

下载cmake：https://github.com/Kitware/CMake/releases/download/v3.26.3/cmake-3.26.3-windows-x86_64.zip

将cmake解压到D盘

2、克隆 mysqlclient-ffi 项目

```shell
git clone https://gitcode.com/Cangjie-TPC/mysqlclient-ffi.git
```

3、切换目录

```shell
cd mysqlclient-ffi
```

4、在当前目录新建 lib 文件夹

5、迁移lib

linux 环境下 将 libmysqlclient.so libmysqlclient.so.21 libmysqlclient.so.21.2.33三个so复制到lib中,目录结构如下

```shell
├─ lib
│   ├─ libmysqlclient.so
│   ├─ libmysqlclient.so.21
│   └─ libmysqlclient.so.21.2.33
```

libmysqlclient.so libmysqlclient.so.21 libmysqlclient.so.21.2.33 三个文件通常在 /usr/lib/mysql/ 目录下或者在 /usr/lib/x86_64-linux-gnu/ 目录下

如果没有运行如下指令，再去目录下寻找so包

```shell
sudo apt-get install libmysqlclient-dev
```

window 环境下 将 libmysql.dll复制两份到lib中，一份保持原样，一份修改名称为libmysqlclient.dll,目录结构如下

```shell
├─ lib
│   ├─ libmysql.dll
│   └─ libmysqlclient.dll
```

libmysql.dll 通常在mysql安装目录 lib 目录下

6、编译mysqlclient_cj和项目

linux-x86 环境下运行 build_linux.sh 文件,linux-arrch64 环境运行 build_aarch64.sh 文件

最终目录结构如下

```shell
├─ lib
│   ├─ libmysqlclient_cj.so
│   ├─ libmysqlclient.so
│   ├─ libmysqlclient.so.21
│   └─ libmysqlclient.so.21.2.33
```

window 环境下运行 build_win.bat 文件

最终目录结构如下

```shell
├─ lib
│   ├─ libmysql.dll
│   ├─ libmysqlclient.dll
│   └─ libmysqlclient_cj.dll
```

7、编译示例文件

示例文件在 test/DOC/mysql_examples.cj  
${path}修改成用户自己项目本地路径

linux 编译指令

```shell
cd target/release/mysqlclient_ffi

cjc  --import-path ${path}/mysqlclient-ffi/target/release -L ${path}/mysqlclient-ffi/target/release/mysqlclient_ffi -l mysqlclient -l mysqlclient_cj -l mysqlclient_ffi${path}/mysqlclient-ffi/test/DOC/mysql_examples.cj -O0 -Woff all
```

windows 编译指令

```cmd
cd target/release/mysqlclient_ffi

cjc  --import-path ${path}/mysqlclient-ffi/target/release -L ${path}/mysqlclient-ffi/target/release/mysqlclient_ffi -l mysqlclient -l mysqlclient_cj -l mysqlclient_ffi${path}/mysqlclient-ffi/test/DOC/mysql_examples.cj -O0 -Woff all
```

8、运行执行文件

linux 运行

```shell
./main
```

windows 运行

```cmd
./main.exe
```

### 功能示例

```cangjie
import mysqlclient_ffi.*
import std.database.sql.*
import std.time.*

main(): Int64 {
    // 初始化数据库驱动
    let mysqlDriver: MysqlDriver = MysqlDriver("mysql")
    if (mysqlDriver.name == "mysql") {
        println("pass1")
    }
    if (mysqlDriver.version.size > 0) {
        println("pass2")
    }
    let arr: Array<(String, String)> = Array<(String, String)>()

    // 通过connectionString和选项打开数据源
    let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
        "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
        arr
    )

    // 返回一个可用的链接
    let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

    // 删除t_test名称数据表
    var mysqlStatement: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test")
    mysqlStatement.update()

    // 创建t_test名称数据表
    mysqlStatement = mysqlConnection.prepareStatement("create table t_test(id bigint, name varchar(50))")
    mysqlStatement.update()

    // 插入数据预执行语句
    mysqlStatement = mysqlConnection.prepareStatement("insert into  t_test(id,name)  VALUES(?,?)")
    if (mysqlStatement.parameterCount == 2) {
        println("pass3")
    }

    var id: SqlBigInt = SqlBigInt(1)
    var name: SqlVarchar = SqlVarchar("lihao111")
    var arrDb: Array<SqlDbType> = [id, name]

    // 执行插入语句插入数据
    var mysqlUpdateResult: MysqlUpdateResult = mysqlStatement.update(arrDb)
    if (mysqlUpdateResult.rowCount == 1) {
        println("pass4")
    }

    id = SqlBigInt(2)
    name = SqlVarchar("lihao222")
    arrDb = [id, name]

    // 执行插入语句插入数据
    mysqlUpdateResult = mysqlStatement.update(arrDb)
    if (mysqlUpdateResult.rowCount == 1) {
        println("pass5")
    }

    // 查询语句预执行语句
    mysqlStatement = mysqlConnection.prepareStatement("select * from t_test where id = ?")
    if (mysqlStatement.parameterCount == 1) {
        println("pass6")
    }

    id = SqlBigInt(2)
    arrDb = [id]

    // 执行查询语句
    var mysqlQueryResult: MysqlQueryResult = mysqlStatement.query(arrDb)
    let mysqlColumnInfos: Array<MysqlColumnInfo> = mysqlQueryResult.mysqlColumnInfos
    if (mysqlColumnInfos.size == 2) {
        println("pass7")
    }
    if (mysqlColumnInfos[0].name == "id") {
        println("pass8")
    }
    if (mysqlColumnInfos[0].typeName == "SqlNullableBigInt") {
        println("pass9")
    }
    if (mysqlColumnInfos[0].displaySize == 0) {
        println("pass10")
    }
    if (mysqlColumnInfos[0].length == 20) {
        println("pass11")
    }
    if (mysqlColumnInfos[0].scale == 0) {
        println("pass12")
    }
    if (!mysqlColumnInfos[0].nullable) {
        println("pass13")
    }
    if (mysqlColumnInfos[1].name == "name") {
        println("pass14")
    }
    if (mysqlColumnInfos[1].typeName == "SqlNullableVarchar") {
        println("pass15")
    }
    if (mysqlColumnInfos[1].displaySize == 0) {
        println("pass16")
    }
    if (mysqlColumnInfos[1].length == 200) {
        println("pass17")
    }
    if (mysqlColumnInfos[1].scale == 0) {
        println("pass18")
    }
    if (!mysqlColumnInfos[1].nullable) {
        println("pass19")
    }

    id = SqlBigInt(0)
    name = SqlVarchar("")
    arrDb = [id, name]

    // 获取数据
    var isBool: Bool = mysqlQueryResult.next(arrDb)

    if (isBool) {
        println("pass20")
    }
    if ((arrDb[0] as SqlBigInt).getOrThrow().value == 2) {
        println("pass21")
    }
    if ((arrDb[1] as SqlVarchar).getOrThrow().value == "lihao222") {
        println("pass22")
    }

    // 删除语句预执行语句
    mysqlStatement = mysqlConnection.prepareStatement("delete from t_test where name = ?")
    if (mysqlStatement.parameterCount == 1) {
        println("pass23")
    }

    name = SqlVarchar("lihao222")
    arrDb = [name]

    // 执行删除语句
    mysqlUpdateResult = mysqlStatement.update(arrDb)
    if (mysqlUpdateResult.rowCount == 1) {
        println("pass24")
    }

    // 查询语句预执行语句
    mysqlStatement = mysqlConnection.prepareStatement("select * from t_test where id = ?")
    if (mysqlStatement.parameterCount == 1) {
        println("pass25")
    }

    id = SqlBigInt(2)
    arrDb = [id]

    // 执行查询语句
    mysqlQueryResult = mysqlStatement.query(arrDb)

    // 获取数据
    arrDb = [id, name]
    isBool = mysqlQueryResult.next(arrDb)
    if (!isBool) {
        println("pass26")
    }

    // 更新语句预执行语句
    mysqlStatement = mysqlConnection.prepareStatement("update t_test set name = ? where id = ?")
    if (mysqlStatement.parameterCount == 2) {
        println("pass27")
    }

    name = SqlVarchar("lihao333")
    id = SqlBigInt(1)
    arrDb = [name, id]

    // 执行更新语句
    mysqlUpdateResult = mysqlStatement.update(arrDb)
    if (mysqlUpdateResult.rowCount == 1) {
        println("pass28")
    }

    // 查询语句预执行语句
    mysqlStatement = mysqlConnection.prepareStatement("select * from t_test where id = ?")
    if (mysqlStatement.parameterCount == 1) {
        println("pass29")
    }

    id = SqlBigInt(1)
    arrDb = [id]

    // 执行查询语句
    mysqlQueryResult = mysqlStatement.query(arrDb)
    if (mysqlColumnInfos.size == 2) {
        println("pass30")
    }

    id = SqlBigInt(1)
    name = SqlVarchar("")
    arrDb = [id, name]

    // 获取数据
    isBool = mysqlQueryResult.next(arrDb)
    if (isBool) {
        println("pass31")
    }
    if ((arrDb[0] as SqlBigInt).getOrThrow().value == 1) {
        println("pass32")
    }
    if ((arrDb[1] as SqlVarchar).getOrThrow().value == "lihao333") {
        println("pass33")
    }

    // 删除t_test名称数据表
    mysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test")
    mysqlStatement.update()

    // 释放预执行语句内存
    mysqlStatement.close()

    // 关闭链接
    mysqlConnection.close()

    return 0
}
```

执行结果如下：

```shell
pass1
pass2
pass3
pass4
pass5
pass6
pass7
pass8
pass9
pass10
pass11
pass12
pass13
pass14
pass15
pass16
pass17
pass18
pass19
pass20
pass21
pass22
pass23
pass24
pass25
pass26
pass27
pass28
pass29
pass30
pass31
pass32
pass33
```

## 约束与限制

本项目基于 mysqlclient8.0.33 开发

## 开源协议

本项目基于 [GPLv2](./LICENSE) ，请自由的享受和参与开源。

## 参与贡献

欢迎给我们提交PR，欢迎给我们提交Issue，欢迎参与任何形式的贡献。
