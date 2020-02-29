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
        //替换
        //$1 $2 {
        
        //函数隔3行"{"查找
        //(\n[ ]*[-+]+[ ]*[(]+[^()]*[)]+[^\\\n/{]*)(\n[^\\\n/]*)(\n[^\\\n/]*)\n[ ]*\{
        //替换
        //$1 $2 $3 {
        
        //查找函数前缀，如“- (BOOL)”
        //[ ]*([-+]+)[ ]*[(]+[ ]*([^() ]*)[ ]*[)][ ]*
        //替换
        //$1 ($2)
        
        //查找函数前缀，如“- (NSString * )”
        //[ ]*([-+]+)[ ]*[(]+[ ]*([^() ]*)[ ]*\*[ ]*[)][ ]*
        //替换
        //$1 ($2 *)
        
        
        //查找只有一行没有参数函数方法名末尾没有空格的{
        //(\n[ ]*[-+]+[ ]*[(]+[^()]*[)]+[^\\\n/ ]*)[^ ]*\{
        //替换
        //$1 {
        
        
        
        
        
        
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
        
        
        //查找所有类似" =  "这样的，这个正则表达使用比较局限，不能全平台一概替换
        //[ ]*=[ ]*
        //替换,等号前后有个空格，“”这个符号不要
        //" = "
        
        
        
        
        
        
        
        //查找if语句隔行{
        /*
        if (1)
        {
        */
        //(.*)if[ ]*\((.*)\)[ ]*\n[ ]*\{
        //替换
        //$1if ($2) {
        
        
        //查找else语句，如
        /*
         }else if (1)
         {
         */
        //(.*)\}[ ]*else[ ]*if[ ]*(.*)\n[ ]*\{[ ]*
        //替换
        //$1}else if $2 {
        
        
        //查找else if语句，如
        /*
         }
         else if([type isEqual:@KSCrashExcType_CPPException])
         {
         */
        //(.*)\}[ ]*\n[ ]*else[ ]*if[ ]*\((.*)\)[ ]*\n[ ]*\{[ ]*
        //替换
        //$1}else if ($2) {
        
        
        //查找else语句，如
        /*
         }
         else
         {
         */
        //(.*)\}[ ]*\n[ ]*else[ ]*\n[ ]*\{[ ]*
        //替换
        //$1}else {
        
        
        //查找else语句，如
        /*
         }else
         {
         */
        //(.*)\}[ ]*else[ ]*\n[ ]*\{[ ]*
        //替换
        //$1}else {
        
        
        //查找if语句，如
        /*
         if([type isEqual:@KSCrashExcType_CPPException]){
         */
        //([ ]*)if[ ]*\((.*)\)[ ]*\{
        //替换
        //$1if ($2) {
        
        
        //查找else if语句，如
        /*
         else if([type isEqual:@KSCrashExcType_CPPException]){
         */
        //([ ]*)else[ ]*if[ ]*\((.*)\)[ ]*\{
        //替换
        //$1else if ($2) {
        
        
        
        //查找else语句，如
        /*
         }else {
         */
        //(.*)\}[ ]*else[ ]*\{[ ]*
        //替换
        //$1}else {
        

    }
    return self;
}

-  (void)test:(NSString *)test test2:(NSString *)test2 {
    
    //[ ]*@property[ ]*\([ ]*nonatomic[ ]*,[ ]*strong[ ]*\)[ ]*
    //替换，注意")"后面有个空格
    //"@property (nonatomic, strong) "
    
    
    //[ ]*@property[ ]*\([ ]*strong[ ]*,[ ]*nonatomic[ ]*\)[ ]*
    //替换，注意")"后面有个空格
    //"@property (nonatomic, strong) "
    
    
    
    
    
    
    //[ ]*@property[ ]*\([ ]*nonatomic[ ]*,[ ]*strong[ ]*,[ ]*nullable[ ]*\)[ ]*
    //替换，注意")"后面有个空格
    //"@property (nonatomic, strong, nullable) "
    
    //[ ]*@property[ ]*\([ ]*nonatomic[ ]*,[ ]*copy[ ]*,[ ]*nullable[ ]*\)[ ]*
    //替换，注意")"后面有个空格
    //"@property (nonatomic, copy, nullable) "
    
    //[ ]*@property[ ]*\([ ]*nonatomic[ ]*,[ ]*nullable[ ]*\)[ ]*
    //替换，注意")"后面有个空格
    //"@property (nonatomic, nullable) "
    
    
    
    
    
    //[ ]*@property[ ]*\([ ]*nonatomic[ ]*,[ ]*assign[ ]*\)[ ]*
    //替换，注意")"后面有个空格
    //"@property (nonatomic, assign) "
    
    
    //[ ]*@property[ ]*\([ ]*assign[ ]*,[ ]*nonatomic[ ]*\)[ ]*
    //替换，注意")"后面有个空格
    //"@property (nonatomic, assign) "
    
    
    
    
    //[ ]*@property[ ]*\([ ]*nonatomic[ ]*,[ ]*copy[ ]*\)[ ]*
    //替换，注意")"后面有个空格
    //"@property (nonatomic, copy) "
    
    
    //[ ]*@property[ ]*\([ ]*copy[ ]*,[ ]*nonatomic[ ]*\)[ ]*
    //替换，注意")"后面有个空格
    //"@property (nonatomic, copy) "
    
    
    
    
    //[ ]*@property[ ]*\([ ]*nonatomic[ ]*,[ ]*weak[ ]*\)[ ]*
    //替换，注意")"后面有个空格
    //@"property (nonatomic, weak) "
    
    //[ ]*@property[ ]*\([ ]*weak[ ]*,[ ]*nonatomic[ ]*\)[ ]*
    //替换，注意")"后面有个空格
    //"@property (nonatomic, weak) "
    
    
    
    //[ ]*@property[ ]*\([ ]*nonatomic[ ]*,[ ]*readwrite[ ]*\)[ ]*
    //替换，注意")"后面有个空格
    //"@property (nonatomic, readwrite) "
    
    //[ ]*@property[ ]*\([ ]*readwrite[ ]*,[ ]*nonatomic[ ]*\)[ ]*
    //替换，注意")"后面有个空格
    //"@property (nonatomic, readwrite) "
    
    
}

-  (void)test:(NSString *)test test22:(NSString *)test2 test3:(NSString *)test3  {
    
    //查找switch
    /*
     switch (1)
     {
     */
    //([ ]*)switch[ ]*(.*)[ ]*\n[ ]*\{
    //替换
    //$1switch $2 {
    
    
    //查找case
    /*
     case 3:
     {
     */
    //([ ]*)case[ ]*(.*)[ ]*:[ ]*\n[ ]*\{
    //替换
    //$1case $2: {
    
    
    //查找case
    /*
     case 3:
     
     {
     */
    //([ ]*)case[ ]*(.*)[ ]*:[ ]*\n[ ]*\n[ ]*\{
    //替换
    //$1case $2: {
    
    
    
    
    //查找case
    /*
     }
         
         break;
     */
    //([ ]*\}[ ]*\n)([ ]*\n){1}([ ]*)break[ ]*;
    //替换
    //$1$3break;
    
    
    
    //查找case
    /*
     }
         
         break;
     */
    //([ ]*\}[ ]*\n)([ ]*\n){2}([ ]*)break[ ]*;
    //替换
    //$1$3break;
    
    
    
    //查找case
    /*
     }break;
     */
    //([ ]*)\}[ ]*break[ ]*;
    //替换
    /*
    $1}
$1    break;
     */
    
    
    
    //查找case
    /*
     case 2: {
         return 0;
     }
         break;
     */
    //([ ]*)case[ ]*(.*)[ ]*:[ ]*\{[ ]*\n[ ]*return[ ]*(.*)[ ]*\n[ ]*\}[ ]*\n[ ]*break[ ]*;[ ]*
    //替换
    //$1case $2: return $3
    
    
    
    //查找case
    /*
     case 2: {
         makeRect.origin.x = CGRectGetWidth(self.frame)/2.0f;
     }
         break;
     */
    //([ ]*)case[ ]*(.*)[ ]*:[ ]*\{[ ]*\n[ ]*((?:(?!return).)*)[ ]*\n[ ]*\}[ ]*\n[ ]*break[ ]*;[ ]*
    //替换
    //$1case $2: $3 break;
    
    
    
    //查找case
    /*
     case 2:
         return 0;
         break;
     */
    //([ ]*)case[ ]*(.*)[ ]*:[ ]*\n[ ]*return[ ]*(.*)[ ]*\n[ ]*break[ ]*;[ ]*
    //替换
    //$1case $2: return $3
    
    
    
    //查找case
    /*
     case 2:
         makeRect.origin.x = CGRectGetWidth(self.frame)/2.0f;
         break;
     */
    //([ ]*)case[ ]*(.*)[ ]*:[ ]*\n[ ]*((?:(?!return).)*)[ ]*\n[ ]*break[ ]*;[ ]*
    //替换
    //$1case $2: $3 break;
    
    
    
    
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
