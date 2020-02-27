//
//  HTextLoopView.h
//  QFProj
//
//  Created by dqf on 2020/1/31.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HSelectTextBlock)(NSString *selectString, NSInteger index);

@interface HTextLoopView : UIView
/**
 @param frame 控件大小
 @param dataSource 数据源
 @param interval 时间间隔,默认是1.0秒
 @param selectBlock 选中回调方法
 */
+ (instancetype)textLoopViewWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource interval:(NSTimeInterval)interval selectBlock:(HSelectTextBlock)selectBlock;

@end
