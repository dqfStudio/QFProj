//
//  NSIndexPath+HUtil.h
//  QFProj
//
//  Created by wind on 2019/7/14.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSIndexPath (HUtil)
- (NSString *)getStringValue;
+ (NSString *(^)(NSInteger row, NSInteger section))getStringValue;
+ (NSIndexPath *(^)(NSInteger row, NSInteger section))getValue;
@end
