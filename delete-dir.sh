#!/bin/bash
# 在指定文件夹下保留n个文件，删除其他文件夹(含内部文件)

# 指定要执行删除的父文件夹路径
src=backup

# 需要保存文件的个数
survive=3

# 文件夹个数
n=`ls $src -l |grep "^d"|wc -l`
echo $src have $n dir

# 删除函数
function del_dir(){
echo "run del_dir()..."
count=0
for file in `ls $1 -lt` # 按创建日期排序 遍历所有输出（后期可改进）
do
 if [ -d $1"/"$file ] # 是否存在该文件夹
 then
	if [ $count -ge $2 ]
	then
		echo del $1"/"$file
		rm -rf $1"/"$file # 删除
	fi
	let count++
 fi
done
} 

if ((n > survive-1)) # 超出指定文件夹个数才执行
then
	del_dir $src $survive
fi


