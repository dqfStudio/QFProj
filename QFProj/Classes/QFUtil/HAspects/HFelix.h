//
//  HFelix.h
//  HProj
//
//  Created by dqf on 2018/5/4.
//  Copyright © 2018年 socool. All rights reserved.
//

#import <Aspects/Aspects.h>

/**
 示例：
 
 @interface MightyCrash : NSObject
- (float)divideUsingDenominator:(NSInteger)denominator;
 @end
 
 @implementation MightyCrash
- (float)divideUsingDenominator:(NSInteger)denominator {
 return 1.f/denominator;
 }
 @end

 NSString *fixScriptString = @" \
 fixInstanceMethodReplace('MightyCrash', 'divideUsingDenominator:', function(instance, originInvocation, originArguments){ \
 if (originArguments[0] == 0) { \
 console.log('zero goes here'); \
 }else {\
 runInvocation(originInvocation); \
 } \
 }); \
 \
 ";
 
 [Felix evalString:fixScriptString];
 */

@interface HFelix : NSObject
+ (void)evalString:(NSString *)javascriptString;
@end
