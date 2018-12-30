# !/bin/bash

oldVersion=""
newVersion=""
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

    done < Pods-HProjectModel1.release.xcconfig


    #修改RELEASE的文件
    #保留空格和换行符
    ifs=$IFS; fileData=$(cat Pods-HProjectModel1.release.xcconfig)
    #echo $fileData
    fileData=${fileData//$oldVersion/$newVersion}
    echo $fileData > Pods-HProjectModel1.release.xcconfig

    #修改DEBUG的文件
    ifs=$IFS; fileData=$(cat Pods-HProjectModel1.debug.xcconfig)
    #echo $fileData
    fileData=${fileData//$oldVersion/$newVersion}
    echo $fileData > Pods-HProjectModel1.debug.xcconfig

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






    #此处添加更细的内容
    str5="1、增加SW电子功能";
    str6="2、增加SW电子功能";
    str7="3、增加SW电子功能";


    echo $str5 >> README.H.md
    echo $str6 >> README.H.md
    echo $str7 >> README.H.md






    str111="#############\n";
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


    done < README.H.md

    modifyRecord=`expr $count + 1`
}

projNames[0]="001KFY永利澳门"
#projNames[0]="001AMH澳门金沙"
#projNames[1]="002QYG千亿国际"
#projNames[2]="003AMJ澳门美高梅"


packageNames[0]="iOS_KFY_永利澳门_原生正式包"
#packageNames[1]="iOS_QYG_千亿国际_原生正式包"
#packageNames[2]="iOS_AMJ_美高梅_原生正式包"



user="$USER"
projPath="/Users/"${user}"/Documents/Workspace/code/ios_app_native/HHHH/"
modelType="模板1"
#projName="001KFY永利澳门"
modelName="HProjectModel1"


#将相关环境置空
ifs=$IFS; IFS="";
IFS="$OLD_IFS"


#获取相关目录
basePath=$(cd `dirname $0`; pwd)
optionsPlistPath=${basePath}"/exportOptions.plist"


#/Users/wind/Documents/Workspace/code/ios_app_native/HHHH/模板1/001KFY永利澳门/HProjectModel1/
#/Users/wind/Documents/Workspace/code/ios_app_native/HHHH/模板1/001KFY永利澳门/HProjectModel1/Pods/Target Support Files/Pods-HProjectModel1


for i in ${!projNames[@]}
do

    projName=${projNames[i]}
    filePath=${projPath}${modelType}"/"${projName}"/"${modelName}"/"
    podPath=${filePath}"Pods/Target Support Files/Pods-HProjectModel1/"


    #将相关环境置空
    ifs=$IFS; IFS="";
    IFS="$OLD_IFS"

    #进入相关目录,根据顺序调用相关函数
    cd $podPath
    modifyConfigFile



    #将相关环境置空
    ifs=$IFS; IFS="";
    IFS="$OLD_IFS"

    #进入相关目录
    cd $filePath
    modifyReadMeFile



    #获取相关路径
    packageName=${packageNames[i]}
    #/Users/wind/Desktop/iOS_RELEASE_IPAS/iOS_KFY_永利澳门_原生正式包/
    packagePath="/Users/"${user}"/Desktop/iOS_RELEASE_IPAS/"${packageName}"/"
    #echo $packageName
    #echo $packagePath


    #打包
    #fastlane release
    xcodebuild clean -workspace HProjectModel1.xcworkspace -scheme HProjectModel1 -configuration Release


    xcarchivePath=${packagePath}"HProjectModel1.xcarchive"
    xcodebuild archive -workspace HProjectModel1.xcworkspace -scheme HProjectModel1 -configuration Release -archivePath $xcarchivePath


    xcodebuild  -exportArchive -archivePath $xcarchivePath -exportPath $packagePath -exportOptionsPlist $optionsPlistPath



    #复制README.H.md到对应iPA文件夹下
    readMeFile="README.H.md"
    cp -p $readMeFile $packagePath


    #对应iPA文件目录
    cd $packagePath

    #删除对应DSYM文件
    #iOS_KFY_永利澳门_原生正式包.app.dSYM.zip
#    dsymFile=${packageName}".app.dSYM.zip"
#    rm -f $dsymFile


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


done





#if [ $? -eq 0 ]; then
#echo "sucessed"
#else
#echo "failed"
#fi

#if [ $? -ne 0 ]; then
#echo "failed"
#else
#echo "sucessed"
#fi
