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
@property (nonatomic) HTupleView *tuple;
@end

@implementation HDebugView
- (HTupleView *)tuple {
    if (!_tuple) {
        _tuple = [[HTupleView alloc] initWithFrame:self.bounds];
        [_tuple setTupleDelegate:(id<HTupleViewDelegate>)self];
    }
    return _tuple;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imgView = [[UIImageView alloc] init];
        [imgView setFrame:self.frame];
        [imgView setImage:[UIImage imageNamed:@"HLaunchImage.jpg"]];
        [self addSubview:imgView];
        [self addSubview:self.tuple];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTupleView {
    return 1;
}
- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (CGSize)sizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(UIScreen.width, UIDevice.topBarHeight);
}
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(UIScreen.width, 50);
}

- (UIEdgeInsets)edgeInsetsForHeaderInSection:(NSInteger)section {
    return UIEdgeInsetsMake(UIDevice.statusBarHeight, 0, 0, 0);
}
- (UIEdgeInsets)edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(0, 10, 0, 0);
}
- (void)tupleHeader:(HTupleHeader)headerBlock inSection:(NSInteger)section {
    HTupleLabelApex *cell = headerBlock(nil, HTupleLabelApex.class, nil, YES);
    cell.backgroundColor = UIColor.whiteColor;
    [cell.label setText:@"DEBUG TOOL"];
    [cell.label setTextColor:UIColor.blackColor];
    [cell.label setFont:[UIFont systemFontOfSize:17]];
    cell.label.textAlignment = NSTextAlignmentCenter;
}
- (void)tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
            case 0: {
                HTableCellInitBlock initBlock = ^(id cell) {
                    NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:KHostURLModelKey];
                    if (index >= 0) [cell setSelectedIndex:index];
                };
                HHostSegmentCell *cell = itemBlock(initBlock, HHostSegmentCell.class, nil, YES);
                [cell setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.35]];
                [cell.label setText:@"是否打开调试工具"];
                [cell.label setTextColor:UIColor.whiteColor];
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
                HHostSegmentCell *cell = itemBlock(initBlock, HHostSegmentCell.class, nil, YES);
                [cell setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.35]];
                [cell.label setText:@"是否打开调试工具"];
                [cell.label setTextColor:UIColor.whiteColor];
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

- (void)didSelectCell:(HTupleBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [self.tuple deselectItemAtIndexPath:indexPath animated:YES];
}

@end
