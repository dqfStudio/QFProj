//
//  NSIndexPath+HUtil.h
//  QFProj
//
//  Created by dqf on 2019/7/14.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSIndexPath (HUtil)
- (NSString *)stringValue;
+ (NSString *(^)(NSInteger row, NSInteger section))stringValue;
+ (NSIndexPath *(^)(NSInteger row, NSInteger section))getValue;
@end
