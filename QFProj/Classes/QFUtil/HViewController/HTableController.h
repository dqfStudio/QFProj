//
//  HTableController.h
//  QFProj
//
//  Created by dqf on 2019/7/7.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HViewController.h"
#import "UIDevice+HUtil.h"
#import "HTableView.h"

@interface HTableController : HViewController <HTableViewDelegate>
@property (nonatomic) HTableView *tableView;
@property (nonatomic) BOOL autoLayout;  //default YEs
@property (nonatomic) BOOL topExtendedLayout; //default YEs
@property (nonatomic) BOOL bottomExtendedLayout;  //default NO
@property (nonatomic) UIEdgeInsets extendedInset; //default UIEdgeInsetsZero
@end
