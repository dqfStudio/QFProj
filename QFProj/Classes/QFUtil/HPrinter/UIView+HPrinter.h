//
//  UIView+HPrinter.h
//  QFProj
//
//  Created by dqf on 2018/8/7.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPrinterManager.h"

#if DEBUG
#define addSubview addString:[NSString stringWithFormat:@"function:%s line:%d", __FUNCTION__, __LINE__] withView
#endif

@interface UIView (HPrinter)
- (void)addString:(NSString *)aString withView:(UIView *)view;
- (void)logMark;
@end
