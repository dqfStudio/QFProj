//
//  HView+HLine.h
//  QFProj
//
//  Created by wind on 2020/2/8.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+HMessy.h"

@interface UIView (HLine)
@property (nonatomic) CGFloat topLineSize;       //上边高度，默认为1.0
@property (nonatomic) CGFloat bottomLineSize;    //下边高度，默认为1.0

@property (nonatomic) CGFloat leftLineSize;      //左边宽度，默认为1.0
@property (nonatomic) CGFloat rightLineSize;     //右边宽度，默认为1.0

@property (nonatomic) UIColor *topLineColor;     //上边颜色，默认233/255.0
@property (nonatomic) UIColor *bottomLineColor;  //下边颜色，默认233/255.0

@property (nonatomic) UIColor *leftLineColor;    //左边颜色，默认233/255.0
@property (nonatomic) UIColor *rightLineColor;   //右边颜色，默认233/255.0

@property (nonatomic) BOOL showTopLineView;      //是否显示上边
@property (nonatomic) BOOL showBottomLineView;   //是否显示下边

@property (nonatomic) BOOL showLeftLineView;     //是否显示左边
@property (nonatomic) BOOL showRightLineView;    //是否显示右边
@end
