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
        _table = [[HTableView alloc] initWithFrame:self.bounds];
        [_table setDelegate:(id<HTableViewDelegate>)self];
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
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView {
    return 1;
}
- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)heightForHeaderInSection:(NSInteger)section {
    return UIDevice.topBarHeight;
}
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableHeader:(HTableHeader)headerBlock inSection:(NSInteger)section {
    HTableLabelApex *cell = headerBlock(nil, HTableLabelApex.class, nil, YES);
    [cell.label setText:@"debug tool"];
    [cell.label setTextColor:UIColor.blackColor];
    [cell.label setFont:[UIFont systemFontOfSize:17]];
}
- (void)tableRow:(HTableRow)cellBlock atIndexPath:(NSIndexPath *)indexPath {
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
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.table deselectRowAtIndexPath:indexPath animated:YES];
}
@end
