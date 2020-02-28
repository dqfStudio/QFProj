//
//  HRegularExpression.m
//  QFProj
//
//  Created by dqf on 2018/8/4.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HRegularExpression.h"
#import "HPrinterManager.h"

@implementation HRegularExpression

- (instancetype)init {
    self = [super init];
    if (self) {
        [self test:nil test2:nil ];
        //查找命令
        //test:(.*) test2:(.*)\]
        //替换命令
        //test:$1    test2:$2 completion:nil]
        
        
        //查找命令
        //addSubview:(.*);
        //替换命令
//        addSubview:$1;
//        NSLog(@"class:%@ function:%s line:%d", NSStringFromClass([self class]), __FUNCTION__, __LINE__);
        
//        addSubview:$1;
//        [[HPrinterManager share] setObject:[NSString stringWithFormat:@"function:%s line:%d", __FUNCTION__, __LINE__] forKey:[NSString stringWithFormat:@"%p", [HPrinterManager share].view]];
        
        //查找所有方法
        //(\n[ ]*[-+]+[ ]*[()].*\{[ ]*\n)
        //方法里面添加一个打印信息, 此处需要注意”NSLog(@"");“后台还有换行符
        /*
        $1    printf("\\nfunction:%s line:%d\\n", __FUNCTION__, __LINE__);

        */
        
        //第一步
        //查找
        //(\n[ ]*[-+]+[ ]*[()].*[ ]*)\n[ ]*\{
        //替换
        //$1 {
        
    }
    return self;
}

-  (void)test:(NSString *)test test2:(NSString *)test2 {
    NSLog(@"ff");
    NSLog(@"ff");
    NSLog(@"ff");
    NSLog(@"ff");
}

-  (void)test:(NSString *)test test22:(NSString *)test2 test3:(NSString *)test3  {
    NSLog(@"ff");
    NSLog(@"ff");
    NSLog(@"ff");
    NSLog(@"ff");
}

- (void)fsf {
    //搜索NSLog方法
    //(.+?)NSLog(.+?)([\n\r])
    
    //搜索@""形式的字符串，例如@"fsf"
    //@"[^"]*[\u4E00-\u9FA5]+[^"\n]*?"
    
    //两个{}之间的内容，包括换行符
    //\{[\s\S]*?\n\}
}

@end
