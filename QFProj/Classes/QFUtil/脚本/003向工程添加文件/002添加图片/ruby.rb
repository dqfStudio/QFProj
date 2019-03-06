

require 'xcodeproj'

fileNames = Array.new(1)

fileNames[0] = "001AMH澳门金沙"
#fileNames[1] = "002BLR澳门巴黎人"
#fileNames[2] = "003TYC太阳城黑版"
#fileNames[3] = "004JSG澳门金沙集团"
#fileNames[4] = "005BLL保利集团"
#fileNames[5] = "006AMJ澳门金沙"
#fileNames[6] = "008TYC太阳城红版"
#fileNames[7] = "009BYT亚泰国际娱乐城"
#fileNames[8] = "010HGF澳门皇冠"
#fileNames[9] = "011HGF新葡京"
#fileNames[10] = "012TYG太阳城集团"
#fileNames[11] = ""
#fileNames[12] = ""
#fileNames[13] = ""
#fileNames[14] = ""
#fileNames[15] = ""
#fileNames[16] = ""
#fileNames[17] = ""




j = fileNames.length - 1;

puts "共#{j+1}个项目"


#获取用户名
path = Pathname.new(__FILE__).realpath.to_s
pathArr = path.split("/") #生成数组
user = pathArr[2]


for i in 0..j

fileName = fileNames[i];

modelName = "模板2"
projPath = "/Users/#{user}/Documents/Workspace/code/ios_app_native/HHHH/#{modelName}/"
xcodeprojPath = "/HProjectModel1/HProjectModel1.xcodeproj"
filePath = "#{projPath}#{fileName}#{xcodeprojPath}"


#打开项目工程A.xcodeproj
project_path = filePath
project = Xcodeproj::Project.open(project_path)


#遍历target，找到需要操作的target
#targetIndex = 0
#target = project.targets[targetIndex]
target = project.targets.first


#找到要插入的group (参数中true表示如果找不到group，就创建一个group)
#group = project.main_group.find_subpath(File.join('HProjectModel1'),false)
group = project.main_group.find_subpath(File.join('HProjectModel1', 'Pod', 'Sources/icon'),false)
#group = project.main_group.find_subpath(File.join('HProjectModel1', 'Pod', 'Sources/icon', 'folder'),false)


#set一下sorce_tree
group.set_source_tree('SOURCE_ROOT')


#向group中增加文件引用（.h文件只需引用一下，.m引用后还需add一下）
sourcePath = "/HProjectModel1/HProjectModel1/Sources/icon/Icon-60.png"
filePath = "#{projPath}#{fileName}#{sourcePath}"


file_ref = group.new_reference(filePath)
ret = target.add_file_references([file_ref])


project.save

puts "第#{i+1}个完成"


end


