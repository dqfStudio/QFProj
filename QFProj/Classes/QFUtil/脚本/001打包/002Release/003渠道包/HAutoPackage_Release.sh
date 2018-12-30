# !/bin/bash


user="$USER"
projPath="/Users/"${user}"/Documents/Workspace/code/ios_app_native/HHHH/"
#projName="001KFY永利澳门"
modelName="HProjectModel1"


#需要变动的部分
modelType="模板1"
projName="001KFY永利澳门"


#/Users/wind/Documents/Workspace/code/ios_app_native/HHHH/模板1/001KFY永利澳门/HProjectModel1/
#/Users/wind/Documents/Workspace/code/ios_app_native/HHHH/模板1/001KFY永利澳门/HProjectModel1/Pods/Target Support Files/Pods-HProjectModel1



#将相关环境置空
ifs=$IFS; IFS="";
IFS="$OLD_IFS"


#获取相关路径
basePath=$(cd `dirname $0`; pwd)
optionsPlistPath=${basePath}"/exportOptions.plist"


#进入相关目录
filePath=${projPath}${modelType}"/"${projName}"/"${modelName}"/"
cd $filePath


#进入相关目录
cd "HProjectModel1/"


substitute="HPackageName_Release"
#substitute="HPackageName_Develop"
substitute2="HChannelName"


packageName=""
oldChannelName=""


#填写新的渠道号，如果没有新的渠道号，则不改动下述值
newChannelName="mainChannel"


while read myline
do

    result=$(echo $myline | grep "${substitute}")
    result2=$(echo $myline | grep "${substitute2}")

    if [[ "$result" != "" ]]; then
        #echo $myline

        #截取字符串
        myline=${myline##*=}

        #去掉字符串中的空格
        myline=`echo "${myline}" |sed s/[[:space:]]//g`

        #保存相关信息
        packageName=$myline

    elif [[ "$result2" != "" ]]; then

        #截取字符串
        myline=${myline##*=}

        #去掉字符串中的空格
        myline=`echo "${myline}" |sed s/[[:space:]]//g`

        #保存相关信息
        oldChannelName=$myline

    fi

done < HXCConfig


#修改HXCConfig的文件
#保留空格和换行符
ifs=$IFS; fileData=$(cat HXCConfig)
#echo $fileData
fileData=${fileData//$oldChannelName/$newChannelName}
echo $fileData > HXCConfig





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


#进入相关目录
cd ".."


#获取包路径
packagePath="/Users/"${user}"/Desktop/iOS_RELEASE_IPAS/"${packageName}"/"


#打包
xcodebuild clean -workspace HProjectModel1.xcworkspace -scheme HProjectModel1 -configuration Release


xcarchivePath=${packagePath}"HProjectModel1.xcarchive"
xcodebuild archive -workspace HProjectModel1.xcworkspace -scheme HProjectModel1 -configuration Release -archivePath $xcarchivePath


xcodebuild  -exportArchive -archivePath $xcarchivePath -exportPath $packagePath -exportOptionsPlist $optionsPlistPath




#进入相关目录
cd "HProjectModel1/"


#/****原内容，保留空格和换行符****/
ifs=$IFS; IFS="\n";
IFS="$OLD_IFS"
fileData=$(cat HXCConfig)


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



#进入相关目录
cd ".."


#复制README.H.md到对应iPA文件夹下
readMeFile="README.H.md"
cp -p $readMeFile $packagePath


#对应iPA文件目录
cd $packagePath


summaryPlistFile="DistributionSummary.plist"
optionsPlistFile="ExportOptions.plist"
xcarchiveFile="HProjectModel1.xcarchive"
logFile="Packaging.log"
ipaFile=${packageName}".ipa"



rm -f $summaryPlistFile
rm -f $optionsPlistFile
rm -rf $xcarchiveFile
rm -f $logFile
mv "HProjectModel1.ipa" $ipaFile

