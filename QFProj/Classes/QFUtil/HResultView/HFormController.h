//
//  HFormController.h
//  HProjectModel1
//
//  Created by wind on 2018/12/31.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HFormCell.h"

@interface HFormController : NSObject
+ (instancetype)formControllerWithModel:(NSArray<HFormModel *> *)models
                           numberOfRows:(NSInteger)rows
                               rowItems:(NSInteger)items
                            buttonBlock:(HFormCellBlock)buttonBlock;
@end
