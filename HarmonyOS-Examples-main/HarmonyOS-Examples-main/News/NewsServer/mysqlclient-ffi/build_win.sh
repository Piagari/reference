#! /bin/bash
lib_path=$(cd `dirname $0`; pwd)


# check libmysqlclient.dll
if [ ! -d "${lib_path}/lib/" ];then
    mkdir ${lib_path}/lib
    echo "Please copy libmysqlclient.dll to the folder ${lib_path}/lib."
    exit 1
fi

if [ ! -f "${lib_path}/lib/libmysqlclient.dll" ];then
    echo "Please copy libmysqlclient.dll to the folder ${lib_path}/lib."
    exit 1
fi

# libmysqlclient_cj.dll
cd ${lib_path}/libmysqlclient_c
if [ -f "Makefile" ];then
    make clean
fi

./configure
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

cp ${lib_path}/lib/*.dll ${lib_path}/target/release/mysqlclient_ffi/
echo end build mysqlclient
