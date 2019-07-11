//
//  HTupleController.h
//  QFProj
//
//  Created by dqf on 2019/7/7.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HViewController.h"
#import "UIDevice+HUtil.h"
#import "HTupleView.h"

@interface HTupleController : HViewController <HTupleViewDelegate>
@property (nonatomic) HTupleView *tupleView;
@property (nonatomic) BOOL autoLayout;  //default YES
@property (nonatomic) BOOL topExtendedLayout; //default YES
@property (nonatomic) CGFloat bottomExtendedHeight; //default 0.f
@property (nonatomic) UIEdgeInsets extendedInset; //default UIEdgeInsetsZero
@end
