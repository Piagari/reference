@echo off

set project_path=%~dp0

rem "D:\msys64"为msys2路径，请自行替换
set "MSYS2_PATH_TYPE=inherit" & set "MSYSTEM=MINGW64" & C:\msys64\usr\bin\bash --login -i -c 'sh "%~dp0/build_win.sh"'
