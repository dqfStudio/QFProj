//
//  HDebugView.m
//  TestProject
//
//  Created by dqf on 2017/7/19.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "HDebugView.h"
#import "HHostSegmentCell.h"
#import "MGHostUrlManager.h"

@interface HDebugView ()
@property (nonatomic) HTableView *table;
@end

@implementation HDebugView
- (HTableView *)table {
    if (!_table) {
        _table = [[HTableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-40)];
        [_table setBackgroundColor:[UIColor clearColor]];
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
        
        [self.table tableWithSections:^CGFloat{
            return 1;
        } cells:^CGFloat(NSInteger section) {
            return 2;
        }];
        
        [self.table headerWithHeight:^CGFloat(NSInteger section) {
            return KStatusBarHeight;
        } tuple:^(HHeaderTable  _Nonnull headerBlock, NSInteger section) {
            headerBlock(nil, HTableHeaderFooterView.class, nil, YES);
        }];
        
        [self.table cellWithHeight:^CGFloat(NSIndexPath * _Nonnull indexPath) {
            return 50;
        } tuple:^(HCellTable  _Nonnull cellBlock, NSIndexPath * _Nonnull indexPath) {
            HTableCellInitBlock initBlokc = ^(id cell) {
                NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:KHostURLModelKey];
                if (index >= 0) [cell setSelectedIndex:index];
            };
            HHostSegmentCell *cell = cellBlock(initBlokc, HHostSegmentCell.class, nil, YES);
            [cell setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.35]];
            switch (indexPath.row) {
                case 0: {
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
                default:
                    break;
            }
        }];
        
        [self.table didSelectCell:^(NSIndexPath * _Nonnull indexPath) {
            [self.table deselectRowAtIndexPath:indexPath animated:YES];
        }];
        
        _lineView = [[UIControl alloc] init];
        [_lineView setFrame:CGRectMake(0, CGRectGetHeight(self.frame)-40, CGRectGetWidth(self.frame), 40)];
        [_lineView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.35]];
        [self addSubview:_lineView];
    }
    return self;
}
@end
