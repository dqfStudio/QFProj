//
//  HFPickerView.h
//  QFProj
//
//  Created by dqf on 2019/3/23.
//  Copyright © 2019年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HFPickerBlock)(NSString *title);

@interface HFPickerView : UIView

/** array */
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSArray *selectedArray;
/** title */
@property (nonatomic, strong) NSString *title;

@property (nonatomic, copy) HFPickerBlock selectionBlock;

//快速创建
+ (instancetype)pickerView;

//弹出
- (void)show;


@end
