# !/bin/bash


user="$USER"
packageName="iOS_乐播_测试包"
packagePath="/Users/"${user}"/Desktop/"${packageName}"/"


#将相关环境置空
ifs=$IFS; IFS="";
IFS="$OLD_IFS"


#获取相关路径
basePath=$(cd `dirname $0`; pwd)
optionsPlistPath=${basePath}"/ExportOptions_Debug.plist"


#进入相关目录
cd ..


#打包
#fastlane Debug
xcodebuild clean -workspace yunbaolive.xcworkspace -scheme yunbaolive -configuration Debug


xcarchivePath=${packagePath}"yunbaolive.xcarchive"
xcodebuild archive -workspace yunbaolive.xcworkspace -scheme yunbaolive -configuration Debug -archivePath $xcarchivePath


xcodebuild  -exportArchive -archivePath $xcarchivePath -exportPath $packagePath -exportOptionsPlist $optionsPlistPath



#对应iPA文件目录
cd $packagePath


summaryPlistFile="DistributionSummary.plist"
optionsPlistFile="ExportOptions.plist"
xcarchiveFile="yunbaolive.xcarchive"
logFile="Packaging.log"
ipaFile=${packageName}".ipa"



rm -f $summaryPlistFile
rm -f $optionsPlistFile
rm -rf $xcarchiveFile
rm -f $logFile
mv "PhoneLive.ipa" $ipaFile

