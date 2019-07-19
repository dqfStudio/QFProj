//
//  HKeyboardManager+HToolBar.h
//
//  Created by Guangquan Yu on 2018/4/13.
//  Copyright © 2018年 YUGQ. All rights reserved.
//

#import "HKeyboardManager.h"

@interface HKeyboardManager (HToolBar)

@property(nonatomic, assign) NSInteger sortType;

- (void)h_addToolbarIfRequired;

- (void)h_removeToolbarIfRequired;

- (void)h_reloadInputViews;
@end
