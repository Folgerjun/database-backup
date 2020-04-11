@echo off
rem 添加环境变量 方便下面调用指令
set path="C:\Program Files\MySQL\MySQL Server 5.7\bin";"C:\Program Files\7-Zip";%PATH%

call :format - %date%
set dt1=%a%

call :Date2Day %dt1% 1 Day
set dt=%Day%
call :format _ %dt%
::-------database-------
rem 源数据库
set sourceDataSource_ip=1.2.3.4
set sourceDataSource_port=3306
set sourceDataSource_userName=source-username
set sourceDataSource_password=source-password
set sourceDataSource_database=source-database

rem 目标数据库
set targetDataSource_userName=target-username
set targetDataSource_password=target-password
set targetDataSource_database=target-database
::--------------
rem 最终时间
set dt=%a%

rem 数据库表 根据现场环境进行更改

rem exp table 按照指定规则选择备份
set table[0]=exp_10026_%dt%
set table[1]=exp_10027_%dt%
set table[2]=exp_10033_%dt%
set table[3]=exp_10036_%dt%
set table[4]=exp_10068_%dt%
set table[5]=exp_10085_%dt%
set table[6]=exp_10087_%dt%
set table[7]=exp_10108_%dt%
set table[8]=exp_10113_%dt%
set table[9]=exp_10115_%dt%
set table[10]=exp_10125_%dt%
set table[11]=exp_10129_%dt%
set table[12]=exp_10130_%dt%
set table[13]=exp_10131_%dt%
set table[14]=exp_10160_%dt%
set table[15]=exp_10181_%dt%
set table[16]=exp_10198_%dt%
set table[17]=exp_10496_%dt%
set table[18]=exp_14080_%dt%
set table[19]=exp_20992_%dt%
set table[20]=exp_22531_%dt%
set table[21]=exp_705_%dt%
set table[22]=em_instrument_info

rem gps table
set table[24]=gsp_101_%dt%
set table[23]=gps_instrument_info

rem crack table
set table[26]=crack_15000_51
set table[27]=crack_15000_52
set table[28]=crack_15000_53
set table[25]=crack_instrument_info

rem temperture table
set table[30]=temperture_41_11
set table[31]=temperture_42_12
set table[32]=temperture_43_13
set table[33]=temperture_44_15
set table[34]=temperture_45_14
set table[29]=temperature_instrument_info

rem vibration table
set table[35]=dvw16_instrument_info
set table[36]=vibration_10_31
set table[37]=vibration_11_39
set table[38]=vibration_12_109
set table[39]=vibration_12_43
set table[40]=vibration_13_46
set table[41]=vibration_14_183
set table[42]=vibration_15_138
set table[43]=vibration_16_118
set table[44]=vibration_16_172
set table[45]=vibration_16_41
set table[46]=vibration_16_86
set table[47]=vibration_17_128
set table[48]=vibration_17_132
set table[49]=vibration_18_107
set table[50]=vibration_18_142
set table[51]=vibration_18_155
set table[52]=vibration_18_36
set table[53]=vibration_18_53
set table[54]=vibration_18_66
set table[55]=vibration_18_68

rem relationtable
set table[56]=relationtable
set table[57]=user

rem 设置文件夹 ./backup/2020_4_8
SET BASEDIR=backup
set FolderName="%BASEDIR%/%dt%"
set zipDir="%BASEDIR%/zip"
set logDir="%BASEDIR%/log"

rem 开始备份数据
echo /=====begin backup data at [%dt%] data======/

rem 创建文件夹
if not exist %FolderName% md %FolderName%
if not exist %logDir% md %logDir%

echo start backup...
setlocal enabledelayedexpansion rem 延迟变量
for /l %%t in (0,1,57) do ( rem 下标循环
	echo /=====start backup %%tst table !table[%%t]! ...=====/
	mysqldump --host %sourceDataSource_ip% -P %sourceDataSource_port% -u%sourceDataSource_userName% -p%sourceDataSource_password% -C -R --log-error="%logDir%/err_%dt%.log" --single-transaction --databases %sourceDataSource_database% --tables !table[%%t]! > "%FolderName%\db_backup_!table[%%t]!.sql"
)

echo /=====backup is complete! =====/


rem 执行sql
echo /=====begin recover... %FolderName%=====/
for /f "delims=\" %%a in ('dir /b /a-d /o-d %FolderName%\*.sql') do (
  echo /=====start recover table %%a=====/
  mysql -u%targetDataSource_userName% -p%targetDataSource_password% -D%targetDataSource_database% < "%FolderName%\%%a"
)

rem 根据不同的压缩软件选择对应的指令
rem 压缩备份 7z
echo /=====zip file=====/
7z a -tzip "%zipDir%/%dt%.zip" %FolderName%

rem 删除源文件
rd /s /q %FolderName%

rem 删除之前的文件
FORFILES /p "%BASEDIR%" /D -5 /C "cmd /c echo deleting @file ... && IF @isdir == TRUE (rd /S /Q @path) else (del /f @path)"
echo /=====COMPLETE! =====/
pause

rem 使用方法：call :Date2Day 2007-11-12 2 Day
rem 变量 Day 就是2007-11-12 减2的结果。计算指定天数 前/后 的日期 （封装）
rem ====================================计算指定天数之前的日期
:Date2Day
setlocal
for /f "tokens=1-3 delims=/-:\, " %%a in ('echo/%~1') do (
set /a yy=%%a,mm=100%%b%%100,dd=100%%c%%100)
set /a z=14-mm,z/=12,y=yy+4800-z,m=mm+12*z-3,j=153*m+2
set /a j=j/5+dd+y*365+y/4-y/100+y/400-2472633
set /a i=j-%~2,a=i+2472632,b=4*a+3,b/=146097,c=-b*146097,c/=4,c+=a
set /a d=4*c+3,d/=1461,e=-1461*d,e/=4,e+=c,m=5*e+2,m/=153,dd=153*m+2,dd/=5
set /a dd=-dd+e+1,mm=-m/10,mm*=12,mm+=m+3,yy=b*100+d-4800+m/10
(if %mm% LSS 10 set mm=0%mm%)&(if %dd% LSS 10 set dd=0%dd%)
endlocal&set %~3=%yy%%f%_%mm%%f%_%dd%&EXIT /B
rem ====================================计算指定天数之前的日期


:format
setlocal
set date=%2
set y=%date:~0,4%
set m=%date:~5,2%
set d=%date:~8,2%
if %m:~0,1%==0 (set m=%m:~1,1%)
if %d:~0,1%==0 (set d=%d:~1,1%)
endlocal&set a=%y%%1%m%%1%d%&EXIT /B
