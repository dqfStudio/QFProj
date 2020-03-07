# !/bin/bash


zipName="888.ipa"
bundleName="hall iOS"
framework="KKSnapshot"


bundleAPP=${bundleName}".app"
frameworkPath=${framework}".framework"


#将相关环境置空
ifs=$IFS; IFS="";
IFS="$OLD_IFS"

#删除已经存在的Payload文件夹
rm -rf Payload/
rm -rf Payload.ipa
rm -rf Payload2.ipa

#解压zip包
unzip $zipName
rm -rf __MACOSX/

#进入Payload包
cd Payload/${bundleAPP}/

#创建Frameworks文件夹
mkdir Frameworks

#删除Frameworks文件夹已经存在的相同文件
cd Frameworks/
rm -rf ${bundleAPP}/

cd ..
cd ..
cd ..

#拷贝响应framework文件夹到Payload的Frameworks文件夹中
cp  -r $frameworkPath Payload/${bundleAPP}/Frameworks/

#再次进入Payload文件夹
cd Payload/${bundleAPP}/

#注入代码
yololib $bundleName Frameworks/${frameworkPath}/${framework}


cd ..
cd ..

#打包文件
zip -ry Payload.ipa Payload

#删除Payload文件夹
rm -rf Payload/
