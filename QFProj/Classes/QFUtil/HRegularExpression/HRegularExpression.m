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
        //函数隔行"{"查找
        //(\n[ ]*[-+]+[ ]*[(]+[^()]*[)]+[^\\\n/]*)\n[ ]*\{
        //替换
        //$1 {
        
        //函数隔2行"{"查找
        //(\n[ ]*[-+]+[ ]*[(]+[^()]*[)]+[^\\\n/{]*)(\n[^\\\n/]*){1}\n[ ]*\{
        
        //查找函数前缀，如“- (BOOL)”
        //[ ]*([-+]+)[ ]*[(]+([^()]*)[)][ ]*
        //替换
        //$1 ($2)
        
        
        //查找只有一行没有参数函数方法名末尾没有空格的{
        //(\n[ ]*[-+]+[ ]*[(]+[^()]*[)]+[^\\\n/ ]*)[^ ]*\{
        //替换
        //$1 {
        
        
        //查找if语句隔行{
        //(.*)if[ ]*\((.*)\)[ ]*\n[ ]*\{
        //替换
        //$1if ($2) {
        
        
        //查找else语句，如
        /*
         }
         else
         {
         */
        //(.*)\}[ ]*\n[ ]*else[ ]*\n[ ]*\{[ ]*
        //替换
        //$1}else {
        
        
        //查找else if语句，如
        /*
         }
         else if([type isEqual:@KSCrashExcType_CPPException])
         {
         */
        //(.*)\}[ ]*\n[ ]*else[ ]*if[ ]*\((.*)\)[ ]*\n[ ]*\{[ ]*
        //替换
        //$1}else if ($2) {
        
        
        //查找函数参数中的空格，去掉“:”前后空格；去掉reportStyle之前的空格
        /*
         initWithReportStyle : (KSAppleReportStyle ) reportStyle
         */
        //[ ]*:[ ]*\((.*)\)[ ]*
        //替换
        //:($1)
        
        
        //查找函数参数中的空格，去掉“:”前后空格；去掉reportStyle前后的空格，去掉括号中的空格
        //此方法不用于括号中带*的，如(NSDictionary *) report，括号中的空格不会被干掉
        /*
         initWithReportStyle : (KSAppleReportStyle ) reportStyle
         */
        //[ ]*:[ ]*\([ ]*([\S]*)[ ]*\)[ ]*
        //替换
        //:($1)
        
        
        //查找函数参数中的空格，去掉“:”前后空格；去掉NSString前后的空格，调整*前后空格
        //此方法主要用于括号中带*的
        /*
         toCompactUUID:(NSString*)uuid
         */
        //[ ]*:[ ]*\([ ]*([\S]*)[ ]*\*[ ]*\)[ ]*
        //替换
        //:($1 *)
        
        
        //查找所有类似" NSString* "这样的
        //([ ]*)([a-zA-Z]+)[ ]*\*[ ]*
        //替换
        //$1$2 *
        
        
        
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
