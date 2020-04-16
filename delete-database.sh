#!/bin/sh

# 数据库信息
targetDataSource_userName=root
targetDataSource_password=root
targetDataSource_database=tt

# 删除指定天数前数据
day_ago=3

tables=`mysql -u$targetDataSource_userName -p$targetDataSource_password -D$targetDataSource_database -e "show tables;"`
that_date=`date -d "$day_ago day ago" +%y%y-%-m-%-d`
echo $that_date
that_date_timestamp=`date -d $that_date +%s` # 转换成时间戳
# echo $that_date_timestamp

for table in ${tables[@]}; do
result=$(echo $table | grep "exp") # 过滤操作 删除指定数据表
if [[ "$result" != "" && "$result" != "exp_instrument_info" ]]
then
	echo $table
	s=${table#*_}
	table_date_tmp=${s#*_}
	# echo $table_date_tmp
	table_date=${table_date_tmp//_/-}
	# echo $table_date
	table_date_timestamp=`date -d $table_date +%s`
	# echo $table_date_timestamp
	if [ $that_date_timestamp -gt $table_date_timestamp ]; then
    echo "delete $table"
	mysql -u$targetDataSource_userName -p$targetDataSource_password -D$targetDataSource_database -e "DROP TABLE $table;"
	fi
fi
done