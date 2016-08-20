=====================================代码=================================
@echo off&setlocal enabledelayedexpansion&title Copy file folder to local
color 0A
echo                ===========Start to copy data===========
:start
cls
echo.请输入你要拷贝的源文件地址，比如：C:\dept\shared
set /p input_source=
echo.!input_source!
echo.请输入目的文件地址，如：D:\1
set /p input_dist=
if not exist "!input_source!" echo.你输入路径不存在！！&goto :start
if not exist "!input_dist!" echo.你输入路径不存在！！&goto :start 
xcopy !input_source! !input_dist! /s/d/y 1>nul 2>nul&&echo 拷贝完成！||echo 拷贝失败！
pause
===============================代码结束===================================