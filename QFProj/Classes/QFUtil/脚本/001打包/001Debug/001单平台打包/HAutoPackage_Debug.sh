# !/bin/bash


user="$USER"
projPath="/Users/"${user}"/Documents/Workspace/code/ios_app_native/HHHH/"
#projName="001KFY永利澳门"
modelName="HProjectModel1"


#需要变动的部分
modelType="模板1"
projName="001KFY永利澳门"
packageName="iOS_KFY_永利澳门_原生测试包"


#/Users/wind/Documents/Workspace/code/ios_app_native/HHHH/模板1/001KFY永利澳门/HProjectModel1/
#/Users/wind/Documents/Workspace/code/ios_app_native/HHHH/模板1/001KFY永利澳门/HProjectModel1/Pods/Target Support Files/Pods-HProjectModel1


#获取相关路径
filePath=${projPath}${modelType}"/"${projName}"/"${modelName}"/"
packagePath="/Users/"${user}"/Desktop/iOS_DEVELOP_IPAS/"${packageName}"/"


#将相关环境置空
ifs=$IFS; IFS="";
IFS="$OLD_IFS"


#获取相关路径
basePath=$(cd `dirname $0`; pwd)
optionsPlistPath=${basePath}"/exportOptions.plist"


#进入相关目录
cd $filePath


#打包
#fastlane release
xcodebuild clean -workspace HProjectModel1.xcworkspace -scheme HProjectModel1 -configuration Release


xcarchivePath=${packagePath}"HProjectModel1.xcarchive"
xcodebuild archive -workspace HProjectModel1.xcworkspace -scheme HProjectModel1 -configuration Release -archivePath $xcarchivePath


xcodebuild  -exportArchive -archivePath $xcarchivePath -exportPath $packagePath -exportOptionsPlist $optionsPlistPath



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

