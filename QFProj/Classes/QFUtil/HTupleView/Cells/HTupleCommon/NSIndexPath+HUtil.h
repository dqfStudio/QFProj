//
//  NSIndexPath+HUtil.h
//  QFProj
//
//  Created by wind on 2019/7/14.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSIndexPath (HUtil)
- (NSString *)stringValue;
+ (NSIndexPath *(^)(NSInteger row, NSInteger section))returnValue;
@end
