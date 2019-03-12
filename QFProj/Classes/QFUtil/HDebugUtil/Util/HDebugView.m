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
@property (nonatomic) KTableView *tableView;
@end

@implementation HDebugView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imgView = [[UIImageView alloc] init];
        [imgView setFrame:self.frame];
        [imgView setImage:[UIImage imageNamed:@"HLaunchImage.jpg"]];
        [self addSubview:imgView];
        
        [self addSubview:self.tableView];
        
        NSArray *arr = @[[NSIndexModel indexModelForRow:0 andSection:0 inSection:0]];

        [self.tableView refreshView:self withArr:arr];
        
        _lineView = [[UIControl alloc] init];
        [_lineView setFrame:CGRectMake(0, CGRectGetHeight(self.frame)-40, CGRectGetWidth(self.frame), 40)];
        [_lineView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.35]];
        [self addSubview:_lineView];
    }
    return self;
}

- (KTableView *)tableView {
    if (!_tableView) {
        _tableView = [[KTableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-40)];
        [_tableView setBackgroundColor:[UIColor clearColor]];
    }
    return _tableView;
}

- (void)sectionMode0:(HSM)model {
    model.headerHeight = KStatusBarHeight;
}

- (void)cellMode0:(HCM)model {
    model.height = 50;
    model.renderBlock = [self renderBlock];
    model.selectionBlock = [self selectionBlock];
}

- (HCellRenderBlock)renderBlock {
    return ^UITableViewCell *(NSIndexPath *indexPath, KTableView *table) {
        switch (indexPath.row) {
            case 0: {
                HHostSegmentCell *cell = [table registerCell:HHostSegmentCell.class indexPath:indexPath initBlock:^(id cell) {
                    NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:KHostURLModelKey];
                    if (index >= 0) [cell setSelectedIndex:index];
                }];
                [cell setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.35]];
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
                return cell;
            }
                break;
            default:
                break;
        }
        return UITableViewCell.new;
    };
}

- (HCellSelectionBlock)selectionBlock {
    return ^(NSIndexPath *indexPath, KTableView *table) {
        [table deselectRowAtIndexPath:indexPath animated:YES];
    };
}

@end
