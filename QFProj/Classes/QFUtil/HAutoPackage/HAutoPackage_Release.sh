# !/bin/bash

user="$USER"
appName=""
appAgent=""
oldVersion=""
newVersion=""
modifyContent=""
modifyRecord=0


function modifyConfigFile () {
    substitute="H_BUNDLE_VERSION"

    while read myline
    do

        result=$(echo $myline | grep "${substitute}")

        if [[ "$result" != "" ]]; then
            #echo $myline

            #截取字符串
            myline=${myline##*=}

            #去掉字符串中的空格
            myline=`echo "${myline}" |sed s/[[:space:]]//g`

            #保存原来的版本号
            oldVersion=$myline

            #切割成数组
            OLD_IFS="$IFS"
            IFS="."
            arr=($myline)
            IFS="$OLD_IFS"

            str1=${arr[0]}
            str2=${arr[1]}
            str3=${arr[2]}
            str4=8;

            #版本号递增
            if (($str3 <= str4)); then
                str3=$((10#${str3}+1))
                newVersion=${str1}"."${str2}"."${str3}
            else
                if (($str2 <= str4)); then
                    str2=$((10#${str2}+1))
                    str3=0;
                    newVersion=${str1}"."${str2}"."${str3}
                else
                    if (($str1 <= str4)); then
                    str1=$((10#${str1}+1))
                    str2=0;
                    str3=0;
                    newVersion=${str1}"."${str2}"."${str3}
                fi
            fi
        fi

        #echo $oldVersion
        #echo $newVersion

    #else
        #echo "不包含"
    fi

    done < HProjectDRConfig.xcconfig


    #修改RELEASE的文件
    #保留空格和换行符
    ifs=$IFS; fileData=$(cat HProjectDRConfig.xcconfig)
    #echo $fileData
    fileData=${fileData//$oldVersion/$newVersion}
    echo $fileData > HProjectDRConfig.xcconfig

#    #修改DEBUG的文件
#    ifs=$IFS; fileData=$(cat Pods-QFProj.debug.xcconfig)
#    #echo $fileData
#    fileData=${fileData//$oldVersion/$newVersion}
#    echo $fileData > Pods-QFProj.debug.xcconfig

}


function modifyReadMeFile () {

    #调用函数获取记录次数
    readRecordFile


    str1=$modifyRecord
    str1="######第"${str1}"次记录######"

    time=$(date "+%Y-%m-%d")
    str2="一、记录时间："${time}""

    str3="二、更新版本："${newVersion}
    str4="三、更新记录：";

    echo "\n" >> README.H.md
    echo $str1 >> README.H.md
    echo $str2 >> README.H.md
    echo $str3 >> README.H.md
    echo $str4 >> README.H.md



    #此处添加更新的内容
    str5=$modifyContent;
#    str6="2、增加SW电子功能";
#    str7="3、增加SW电子功能";


    echo $str5 >> README.H.md
#    echo $str6 >> README.H.md
#    echo $str7 >> README.H.md






    str111="#############";
    echo $str111 >> README.H.md

}

function readRecordFile () {

    count=0

    while read myline
    do

        result=$(echo $myline | grep "次记录######")
        if [[ "$result" != "" ]]; then
            count=`expr $count + 1`
            #echo $count
        fi


        result2=$(echo $myline | grep "名称：")
        if [[ "$result2" != "" ]]; then
            #截取字符串
            appName=${myline##*：}
            #去掉字符串中的空格
            appName=`echo "${appName}" |sed s/[[:space:]]//g`
        fi


        result3=$(echo $myline | grep "代理号：")
        if [[ "$result3" != "" ]]; then
            #截取字符串
            appAgent=${myline##*：}
            #去掉字符串中的空格
            appAgent=`echo "${appAgent}" |sed s/[[:space:]]//g`
        fi


    done < README.H.md

    modifyRecord=`expr $count + 1`
}

#选择打包方式
echo "\033[36;1m请选择打包方式(输入序号,按回车即可) \033[0m"
echo "\033[33;1m1. 版本号不递增       \033[0m"
echo "\033[33;1m2. 版本号递增    \033[0m"
# 读取用户输入并存到变量里
read parameter
sleep 0.5
method="$parameter"


#判断版本号是否递增
if [[ $method == "2" ]]; then
echo "\033[36;1m请在文本编辑器中输入更新内容 \033[0m"

sleep 1.0

touch tmp.txt
vim tmp.txt

modifyContent=$(cat tmp.txt)
echo $modifyContent

rm -f tmp.txt

fi


#进入相关目录,根据顺序调用相关函数
filePath=$(cd `dirname $0`; pwd)
#脚本文件夹名称
HAutoPackage="HAutoPackage"


#去掉字符串中的空格
filePath=`echo "${filePath}" |sed s/${HAutoPackage}//g`
#podPath=${filePath}"Pods/Target Support Files/Pods-QFProj/"


#进入相关目录,根据顺序调用相关函数
optionsPlistPath=${filePath}${HAutoPackage}"/exportOptions.plist"


if [[ $method == "2" ]]; then

##将相关环境置空
#ifs=$IFS; IFS="";
#IFS="$OLD_IFS"

#cd $podPath
modifyConfigFile

fi


#将相关环境置空
ifs=$IFS; IFS="";
IFS="$OLD_IFS"

#进入相关目录
cd $filePath

if [[ $method == "2" ]]; then
    modifyReadMeFile
else
    readRecordFile
fi



#获取相关路径
packageName="iOS_"${appAgent}"_"${appName}"_原生正式包"
packagePath="/Users/"${user}"/Desktop/"${packageName}"/"


#打包
xcodebuild clean -workspace QFProj.xcworkspace -scheme QFProj -configuration Release


xcarchivePath=${packagePath}"QFProj.xcarchive"
xcodebuild archive -workspace QFProj.xcworkspace -scheme QFProj -configuration Release -archivePath $xcarchivePath


xcodebuild  -exportArchive -archivePath $xcarchivePath -exportPath $packagePath -exportOptionsPlist $optionsPlistPath



#复制README.H.md到对应iPA文件夹下
readMeFile="README.H.md"
cp -p $readMeFile $packagePath


#对应iPA文件目录
cd $packagePath


summaryPlistFile="DistributionSummary.plist"
optionsPlistFile="ExportOptions.plist"
xcarchiveFile="QFProj.xcarchive"
logFile="Packaging.log"
ipaFile=${packageName}".ipa"



rm -f $summaryPlistFile
rm -f $optionsPlistFile
rm -rf $xcarchiveFile
rm -f $logFile
mv "QFProj.ipa" $ipaFile

