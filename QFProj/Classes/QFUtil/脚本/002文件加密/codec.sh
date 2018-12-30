# !/bin/bash



#/****原内容，保留空格和换行符****/
ifs=$IFS; IFS="\n";
IFS="$OLD_IFS"
fileData=$(cat HXCConfig)




#/******以下内容为编码*******/

#原内容反向输出
fileData=`echo ${fileData} | rev`

#对原内容反向输出的结果进行BASE64位编码
fileData=`echo ${fileData} | base64`

#对BASE64编码的结果进行反向输出
fileData=`echo ${fileData} | rev`

#输出到文件
echo $fileData > HXCConfig

#提示
echo "编码成功！"



#/******以下内容为解码*******/

#对编码内容反向输出
fileData=`echo ${fileData} | rev`

#进行BASE64解码
fileData=`echo ${fileData} | base64 -D`

#对解码内容反向输出
fileData=`echo ${fileData} | rev`

#输出到文件
echo $fileData > HXCConfig

#提示
echo "解码成功！"
