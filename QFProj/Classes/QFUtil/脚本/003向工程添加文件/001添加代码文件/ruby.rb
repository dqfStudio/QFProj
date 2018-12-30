

require 'xcodeproj'

names = Array.new(2)

names[0] = "001AMH澳门金沙"
names[1] = "002BLR澳门巴黎人"
#names[2] = "003TYC太阳城黑版"
#names[3] = "004JSG澳门金沙集团"
#names[4] = "005BLL保利集团"
#names[5] = "006AMJ澳门金沙"
#names[6] = "008TYC太阳城红版"
#names[7] = "009BYT亚泰国际娱乐城"
#names[8] = "010HGF澳门皇冠"
#names[9] = "011HGF新葡京"
#names[10] = "012TYG太阳城集团"
#names[11] = ""
#names[12] = ""
#names[13] = ""
#names[14] = ""
#names[15] = ""
#names[16] = ""
#names[17] = ""

j = names.length - 1;

puts "共#{j+1}个项目"

for i in 0..j

name2 = names[i];

name1 = "/Users/wind/Documents/Workspace/code/ios_app_native/HHHH/模板2/"
name3 = "/HProjectModel1/HProjectModel1.xcodeproj"
name4 = "#{name1}#{name2}#{name3}"

#打开项目工程A.xcodeproj
project_path =  name4
project = Xcodeproj::Project.open(project_path)

#遍历target，找到需要操作的target

targetIndex = 0

target = project.targets[targetIndex]

#找到要插入的group (参数中true表示如果找不到group，就创建一个group)
#group = project.main_group.find_subpath(File.join('HProjectModel1'),false)
group = project.main_group.find_subpath(File.join('HProjectModel1', 'Pod', 'Sources/icon'),false)
#group = project.main_group.find_subpath(File.join('HProjectModel1', 'Pod', 'Sources/icon', 'folder'),false)

#set一下sorce_tree
group.set_source_tree('SOURCE_ROOT')

#向group中增加文件引用（.h文件只需引用一下，.m引用后还需add一下）

name5 = "/Users/wind/Documents/Workspace/code/ios_app_native/HHHH/模板2/"
name6 = "/HProjectModel1/HProjectModel1/Sources/icon/testRuby.h"
name7 = "/HProjectModel1/HProjectModel1/Sources/icon/testRuby.m"
name8 = "#{name5}#{name2}#{name6}"
name9 = "#{name5}#{name2}#{name7}"


file_ref = group.new_reference(name8)
file_ref = group.new_reference(name9)

ret = target.add_file_references([file_ref])
                               
                               
project.save

puts "第#{i+1}个完成"

end
