//
//  UIViewController+HPrinter.h
//  QFProj
//
//  Created by dqf on 2020/3/6.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#if DEBUG

@interface UIViewController (HPrinter)
@property (nonatomic) NSMutableArray *allVCViews;
@end

#endif
