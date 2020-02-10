
#import <UIKit/UIKit.h>

@interface NSObject (HHH)

@end

void import_NSObject_HHH (void);

//方法一
/*
 搜索：other link flags
 添加 -ObjC 来引用静态库路径
 此时上述 “void import_NSObject_HHH (void);” 这段代码可删掉
*/

//方法二
/*
 //工程中任何一个.m文件需添加此方法
 //此时上述 “void import_NSObject_HHH (void);” 这段代码必须要有
 __attribute__((used)) static void importCategories ()
 {
     import_NSObject_HHH();
 }
*/
