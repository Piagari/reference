#! /bin/bash
lib_path=$(cd `dirname $0`; pwd)

# 将.c文件生成.o文件
g++ -std=c++17 -O2 -c ${lib_path}/libmysqlclient_c/mysqlclient_cj.cpp -o libmysqlclient_c/mysqlclient_cj.o
echo "Successfully generated .o file."

#将.o文件生成.a文件
ar qc ${lib_path}/lib/libmysqlclient_cj.a ${lib_path}/libmysqlclient_c/*.o
echo "Successfully generated .a file."

# 将cjpm.toml的16行修改成静态编译
sed -i -e '16 s/  output-type = "dynamic"/  output-type = "static"/' ${lib_path}/cjpm.toml

cd  ${lib_path}/
echo start build mysqlclient

# 清理缓存
echo start cjpm clean
cjpm clean
echo end cjpm clean

# 开始编译
echo start cjpm build -V
cjpm build -V
echo end cjpm build -V

# 将lib下依赖包copy到运行环境下
cp ${lib_path}/lib/*.a ${lib_path}/target/release/mysqlclient_ffi/
echo end build mysqlclient

# 将cjpm.toml的16行修改还原
sed -i -e '16 s/  output-type = "static"/  output-type = "dynamic"/' ${lib_path}/cjpm.toml