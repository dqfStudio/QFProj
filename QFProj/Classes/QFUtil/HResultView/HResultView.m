//
//  HResultView.m
//  QFProj
//
//  Created by dqf on 2018/12/30.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HResultView.h"
#import "HTupleView.h"
#import "AFNetworkReachabilityManager.h"

#define KResultImageSize     CGSizeMake(200, 140)
#define KResultTextSize      CGSizeMake(200, 25)
#define KResultDetlTextSize  CGSizeMake(200, 20)

@interface HResultView () <HTupleViewDelegate>
@property (nonatomic) HTupleView *tupleView;
@end

@implementation HResultView

- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:CGRectZero];
        [_tupleView bounceDisenable];
        [_tupleView setTupleDelegate:(id<HTupleViewDelegate>)self];
        [self addSubview:_tupleView];
    }
    return _tupleView;
}
- (void)wakeup {
    //添加view
    CGFloat height = KResultTextSize.height;
    if (!_make.hideImage) height += KResultImageSize.height;
    if (_make.detlDesc.length > 0) height += KResultDetlTextSize.height;
    
    CGRect frame = CGRectMake(0, 0, KResultImageSize.width, height);
    self.tupleView.frame = frame;
    self.tupleView.center = CGPointMake(self.center.x, self.center.y-_make.marginTop);
    
    [self.tupleView reloadData];
}
- (void)setMake:(HResultTransition *)make {
    if (_make != make) {
        _make = nil;
        _make = make;
        [self wakeup];
    }
}
- (NSInteger)numberOfSectionsInTupleView {
    if (![AFNetworkReachabilityManager sharedManager].isReachable) {
        _make.style = HResultTypeNoNetwork;
    }
    return 1;
}
- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return _make.detlDesc.length > 0 ? 2 : 1;
}

- (CGSize)sizeForHeaderInSection:(NSInteger)section {
    return _make.hideImage ? CGSizeZero : KResultImageSize;
}
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: return KResultTextSize;
        case 1: return KResultDetlTextSize;
        default:break;
    }
    return CGSizeZero;
}
- (void)tupleHeader:(HTupleHeader)headerBlock inSection:(NSInteger)section {
    HTupleImageApex *cell = headerBlock(nil, HTupleImageApex.class, nil, YES);
    [cell.imageView setBackgroundColor:UIColor.whiteColor];
    if (_make.bgColor) [cell.imageView setBackgroundColor:_make.bgColor];
    switch (_make.style) {
        case HResultTypeNoData:
            [cell.imageView setImage:[UIImage imageNamed:@"icon_load_nothing"]];
            break;
        case HResultTypeLoadError:
            [cell.imageView setImage:[UIImage imageNamed:@"icon_no_server"]];
            break;
        case HResultTypeNoNetwork:
            [cell.imageView setImage:[UIImage imageNamed:@"icon_no_network"]];
            break;
        default:
            break;
    }
    cell.imageView.pressed = ^(id sender, id data) {
        if (self->_make.clickedBlock) {
            self->_make.clickedBlock();
        }
    };
}
- (void)tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
            [cell.label setBackgroundColor:UIColor.whiteColor];
            [cell.label setTextColor:[UIColor blackColor]];
            [cell.label setFont:[UIFont systemFontOfSize:14]];
            [cell.label setTextAlignment:NSTextAlignmentCenter];
            if (_make.bgColor) [cell.label setBackgroundColor:_make.bgColor];
            if (_make.descFont) [cell.label setFont:_make.descFont];
            if (_make.descColor) [cell.label setTextColor:_make.descColor];
            if (_make.desc.length > 0) {
                [cell.label setText:_make.desc];
            }else {
                switch (_make.style) {
                    case HResultTypeNoData:
                        [cell.label setText:@"这里好像什么都没有呢⋯"];
                        break;
                    case HResultTypeLoadError:
                        [cell.label setText:@"服务器开小差了，请稍后再试~"];
                        break;
                    case HResultTypeNoNetwork:
                        [cell.label setText:@"网络已断开"];
                        break;
                    default:
                        break;
                }
            }
        }
            break;
        case 1: {
            HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
            [cell.label setBackgroundColor:UIColor.whiteColor];
            [cell.label setTextColor:[UIColor blackColor]];
            [cell.label setFont:[UIFont systemFontOfSize:14]];
            [cell.label setTextAlignment:NSTextAlignmentCenter];
            if (_make.bgColor) [cell.label setBackgroundColor:_make.bgColor];
            if (_make.detlDescFont) [cell.label setFont:_make.detlDescFont];
            if (_make.detlDescColor) [cell.label setTextColor:_make.detlDescColor];
            if (_make.detlDesc.length > 0) [cell.label setText:_make.detlDesc];
        }
            break;
            
        default:
            break;
    }
    
}
- (void)didSelectCell:(HTupleBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (_make.clickedBlock) {
        _make.clickedBlock();
    }
}

@end
