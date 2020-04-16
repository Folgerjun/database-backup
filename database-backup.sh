#!/bin/bash

# 设置环境变量
#mysql_home=$PATH:C:/Program Files/MySQL/MySQL Server 5.7/bin
#export $mysql_home

#======日期获取 n天以前========
n=1
thatDay=`date -d "$n day ago" +%y%y_%-m_%-d`
echo $thatDay

#------database-------
sourceDataSource_ip=1.2.3.4
sourceDataSource_port=3565
sourceDataSource_userName=root
sourceDataSource_password=root
sourceDataSource_database=tt

targetDataSource_userName=root
targetDataSource_password=123456
targetDataSource_database=tt

# exp table
table[0]=exp_10026_$thatDay
table[1]=exp_10027_$thatDay
table[2]=exp_10033_$thatDay
table[3]=exp_10036_$thatDay
table[4]=exp_10068_$thatDay
table[5]=exp_10085_$thatDay
table[6]=exp_10087_$thatDay
table[7]=exp_10108_$thatDay
table[8]=exp_10113_$thatDay
table[9]=exp_10115_$thatDay
table[10]=exp_10125_$thatDay
table[11]=exp_10129_$thatDay
table[12]=exp_10130_$thatDay
table[13]=exp_10131_$thatDay
table[14]=exp_10160_$thatDay
table[15]=exp_10181_$thatDay
table[16]=exp_10198_$thatDay
table[17]=exp_10496_$thatDay
table[18]=exp_14080_$thatDay
table[19]=exp_20992_$thatDay
table[20]=exp_22531_$thatDay
table[21]=exp_705_$thatDay
table[22]=exp_instrument_info

# gps table
table[24]=gsp_101_$thatDay
table[23]=gps_instrument_info

# crack table
table[26]=crack_15000_51
table[27]=crack_15000_52
table[28]=crack_15000_53
table[25]=crack_instrument_info

# temperture table
table[30]=temperture_41_11
table[31]=temperture_42_12
table[32]=temperture_43_13
table[33]=temperture_44_15
table[34]=temperture_45_14
table[29]=temperature_instrument_info

# vibration table
table[35]=dvw16_instrument_info
table[36]=vibration_10_31
table[37]=vibration_11_39
table[38]=vibration_12_109
table[39]=vibration_12_43
table[40]=vibration_13_46
table[41]=vibration_14_183
table[42]=vibration_15_138
table[43]=vibration_16_118
table[44]=vibration_16_172
table[45]=vibration_16_41
table[46]=vibration_16_86
table[47]=vibration_17_128
table[48]=vibration_17_132
table[49]=vibration_18_107
table[50]=vibration_18_142
table[51]=vibration_18_155
table[52]=vibration_18_36
table[53]=vibration_18_53
table[54]=vibration_18_66
table[55]=vibration_18_68

# relationtable
table[56]=relationtable
table[57]=user

# 设置文件夹
FolderName="./backup/$thatDay"
## sql 存放位置
sqlDir="$FolderName/data"
## 日志 存放位置
logDir="$FolderName/log"
# 备份数据
echo =====begin backup data at [$thatDay] data======
# 创建文件夹
echo mkdir $FolderName

if [ ! -d $sqlDir ];
then
mkdir -p $sqlDir
fi

if [ ! -d $logDir ];
then
mkdir -p $logDir
fi

# 开始备份
echo =====start backup...=====
# arr=(22 23 0) 数组

# 遍历所有表
for i in ${table[@]}; do
  echo =====start backup $i st table [ ${table[$i]} ] ...======
  mysqldump --host $sourceDataSource_ip -P $sourceDataSource_port -u$sourceDataSource_userName -p$sourceDataSource_password -C -R --log-error="$logDir/error.log" --databases $sourceDataSource_database --tables ${table[$i]} | gzip > "$sqlDir/db_backup_${table[$i]}.sql.gz"
done
echo =====backup is complete! =====

# 开始恢复
echo =====begin recover... $sqlDir=====
files=$(ls $sqlDir)
for filename in $files
do
  echo =====start recover table $filename====
  gunzip < "$sqlDir/$filename" | mysql -u$targetDataSource_userName -p$targetDataSource_password -D$targetDataSource_database
done

# 备份成功

echo run complete!!
exit


