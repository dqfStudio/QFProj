//
//  HDebugView.m
//  TestProject
//
//  Created by dqf on 2017/7/19.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "HDebugView.h"
#import "HHostSegmentCell.h"
#import "HHostUrlManager.h"
#ifdef DEBUG
#import <FLEX/FLEX.h>
#import <FLEXManager.h>
#endif

@interface HDebugView ()
@property (nonatomic) HTableView *table;
@end

@implementation HDebugView
- (HTableView *)table {
    if (!_table) {
        _table = [[HTableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-40)];
        [_table setTableDelegate:(id<HTableViewDelegate>)self];
    }
    return _table;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imgView = [[UIImageView alloc] init];
        [imgView setFrame:self.frame];
        [imgView setImage:[UIImage imageNamed:@"HLaunchImage.jpg"]];
        [self addSubview:imgView];
        
        [self addSubview:self.table];
        
        _lineView = [[UIControl alloc] init];
        [_lineView setFrame:CGRectMake(0, CGRectGetHeight(self.frame)-40, CGRectGetWidth(self.frame), 40)];
        [_lineView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.35]];
        [self addSubview:_lineView];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(HTableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(HTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(HTableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return UIDevice.topBarHeight;
}
- (CGFloat)tableView:(HTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(HTableView *)tableView tableHeader:(HTableHeader)headerBlock inSection:(NSInteger)section {
    HTableLabelApex *cell = headerBlock(nil, HTableLabelApex.class, nil, YES);
    [cell.label setText:@"debug tool"];
    [cell.label setTextColor:UIColor.blackColor];
    [cell.label setFont:[UIFont systemFontOfSize:17]];
}
- (void)tableView:(HTableView *)tableView tableRow:(HTableRow)cellBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            HTableCellInitBlock initBlock = ^(id cell) {
                NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:KHostURLModelKey];
                if (index >= 0) [cell setSelectedIndex:index];
            };
            HHostSegmentCell *cell = cellBlock(initBlock, HHostSegmentCell.class, nil, YES);
            [cell setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.35]];
            [cell setShouldShowSeparator:YES];
            [cell setSegmentBlock:^(NSInteger index) {
                switch (index) {
                    case 0:
                        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:KHostURLModelKey];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        break;
                    case 1:
                        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:KHostURLModelKey];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        break;

                    default:
                        break;
                }
            }];
        }
            break;
        case 1: {
            HTableCellInitBlock initBlock = ^(id cell) {
                NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:KHostURLModelKey];
                if (index >= 0) [cell setSelectedIndex:index];
            };
            HHostSegmentCell *cell = cellBlock(initBlock, HHostSegmentCell.class, nil, YES);
            [cell setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.35]];
            [cell setShouldShowSeparator:YES];
            [cell setSegmentBlock:^(NSInteger index) {
                switch (index) {
                    case 0: {
#ifdef DEBUG
                        [[FLEXManager sharedManager] showExplorer];
#endif
                    }
                        break;
                    case 1: {
#ifdef DEBUG
                        [[FLEXManager sharedManager] hideExplorer];
#endif
                    }
                        break;

                    default:
                        break;
                }
            }];
        }
            break;
        default:
            break;
    }
}
- (void)tableView:(HTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.table deselectRowAtIndexPath:indexPath animated:YES];
}
@end
