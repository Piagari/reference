#! /bin/bash
lib_path=$(cd `dirname $0`; pwd)


# check libmysqlclient.so
if [ ! -d "${lib_path}/lib/" ];then
    mkdir ${lib_path}/lib
    echo "Please copy libmysqlclient.so to the folder ${lib_path}/lib."
    exit 1
fi

if [ ! -f "${lib_path}/lib/libmysqlclient.so" ];then
    echo "Please copy libmysqlclient.so to the folder ${lib_path}/lib."
    exit 1
fi

# libmysqlclient_cj.so
cd ${lib_path}/libmysqlclient_c
if [ -f "Makefile" ];then
    make clean
fi

if [[ -n $(uname -a|grep "aarch64") ]];then
    ./configure
else
    ./configure --cc="aarch64-linux-gnu-gcc" --cross-prefix="aarch64-linux-gnu-"
fi
make

# mysqlclient
cd  ${lib_path}/

echo start build mysqlclient

echo start cjpm clean
cjpm clean
echo end cjpm clean

echo start cjpm build -V
cjpm build -V
echo end cjpm build -V

cp ${lib_path}/lib/*.so ${lib_path}/target/release/mysqlclient_ffi/
cp ${lib_path}/lib/*.so.21 ${lib_path}/target/release/mysqlclient_ffi/
cp ${lib_path}/lib/*.so.21.2.33 ${lib_path}/target/release/mysqlclient_ffi/
echo end build mysqlclient
