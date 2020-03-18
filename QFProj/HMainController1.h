//
//  HMainController1.h
//  QFProj
//
//  Created by dqf on 2019/9/4.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HViewController.h"
#import "HTupleView.h"
#import "HTupleViewCellVertValue1.h"
#import "HTupleViewCellHoriValue1.h"
#import "UIViewController+HAnimation.h"
#import "HSheetController.h"
#import "HAlertController.h"
#import "UIView+HAlert.h"

typedef NS_OPTIONS(NSUInteger, HMainCtrl1Type) {
    HMainCtrl1Type1 = 0,
    HMainCtrl1Type2
};

NS_ASSUME_NONNULL_BEGIN

@interface HMainController1 : HViewController
@property (nonatomic) HTupleView *tupleView;
@end

NS_ASSUME_NONNULL_END
