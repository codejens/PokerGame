@echo off
set scriptPath=..\script
set luacPath=..\binary_out
set luacPathref=..\..\binary_out
set res_data=..\resource\data
set resourcePath=..\resource
set rescom_data=..\res_com\data
set androidAssets=AndroidRelease\assets\
set AndroidRelease=AndroidRelease\
set luacParam=

cd ..\..\AndroidPacket



del/s/q %luacPath%\
mkdir %luacPath%\
xcopy /E/y %scriptPath% %luacPath%\

rem 插入版本信息
cd ..\resourcePack
lua ZXVersion.lua ..\binary_out
rem 是否删除print和使用-s参数
if %1% == 1 lua RemoveDebugMessage.lua ..\binary_out
cd..\AndroidPacket

if %1% == 1 set luacParam=-s 
if %1% == 1 echo 发布360最终全包版本，删除print，清除debug信息
if %1% == 0 echo 发布360最终全包版本，debug版本
pause
@echo on
@echo off
echo 编译中
rem 编译
for /f "delims=" %%i in ('dir /a/b/s %luacPath%\ ^| findstr /iE "\.lua"') do luac %luacParam% -o  %%ic %%i & if errorlevel 1 ( echo Failure Reason Given is %errorlevel% exit /b %errorlevel%) & pause & exit
echo 加密中
rem 加密
for /f "delims=" %%i in ('dir /a/b/s %luacPath% ^| findstr /iE "\.luac"') do Encrypt %%i & if errorlevel 1 ( echo Failure Reason Given is %errorlevel% exit /b %errorlevel%) & pause & exit
@echo on
del /S/Q %luacPath%\*.lua
del /S/Q %luacPath%\*.luac

rem 复制resource\data 到 res_data
xcopy /E/y %res_data% %rescom_data%\

for /f "delims=" %%i in ('dir /a/b/s %rescom_data%\ ^| findstr /iE "\.lua"') do luac %luacParam% -o  %%ic %%i 
rem 加密
for /f "delims=" %%i in ('dir /a/b/s %rescom_data%\ ^| findstr /iE "\.luac"') do Encrypt %%i
del /S/Q %rescom_data%\*.lua
del /S/Q %rescom_data%\*.luac

rem 清空assets目录
del /S/q %androidAssets%
rd /S/q %androidAssets%
mkdir %androidAssets%

rem 复制resource 到 assets
xcopy /E/y %resourcePath%\chat_face %androidAssets%chat_face\
xcopy /E/y %resourcePath%\frame %androidAssets%frame\
xcopy /E/y %resourcePath%\icon %androidAssets%icon\
xcopy /E/y %resourcePath%\map %androidAssets%map\
xcopy /E/y %resourcePath%\nopack %androidAssets%nopack\
xcopy /E/y %resourcePath%\particle %androidAssets%particle\
xcopy /E/y %resourcePath%\scene %androidAssets%scene\
xcopy /E/y %resourcePath%\sound %androidAssets%sound\
xcopy /E/y %resourcePath%\ui %androidAssets%ui\
xcopy /E/y %resourcePath%\ui2 %androidAssets%ui2\
xcopy /E/y %resourcePath%\sui %androidAssets%sui\
rem xcopy /E/y %resourcePath%\cache.xml %androidAssets%

rem 删除assets的data目录
rem rd /s/q %androidAssets%cache

rem 删除assets的data目录
rd /s/q %androidAssets%data

rem 复制脚本目录
xcopy /E/y %luacPath% %androidAssets%binary\
rem 复制编译后的data内容
xcopy /E/y %rescom_data% %androidAssets%data\

rem 复制MSDK助手的AppConfig.xml到assets
xcopy /y %AndroidRelease%platform %androidAssets%
pause