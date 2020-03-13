//
//  HResultView.m
//  QFProj
//
//  Created by dqf on 2018/12/30.
//  Copyright © 2018年 dqf. All rights reserved.
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

@synthesize bgColor,style,marginTop,hideImage;
@synthesize desc,descFont,descColor;
@synthesize detlDesc,detlDescFont,detlDescColor;
@synthesize clickedBlock,isLoading;

- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:CGRectZero];
        [_tupleView setScrollEnabled:NO];
        [_tupleView setTupleDelegate:(id<HTupleViewDelegate>)self];
        [self addSubview:self.tupleView];
    }
    return _tupleView;
}
- (void)wakeup {
    //添加view
    CGFloat height = KResultTextSize.height;
    if (!self.hideImage) height += KResultImageSize.height;
    if (self.detlDesc.length > 0) height += KResultDetlTextSize.height;
    
    CGRect frame = CGRectMake(0, 0, KResultImageSize.width, height);
    self.tupleView.frame = frame;
    self.tupleView.center = CGPointMake(self.center.x, self.center.y-self.marginTop);
}

- (NSInteger)numberOfSectionsInTupleView {
    if (![AFNetworkReachabilityManager sharedManager].isReachable) {
        self.style = HResultTypeNoNetwork;
    }
    return 1;
}
- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return self.detlDesc.length > 0 ? 2 : 1;
}

- (CGSize)sizeForHeaderInSection:(NSInteger)section {
    return self.hideImage ? CGSizeZero : KResultImageSize;
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
    if (self.bgColor) [cell.imageView setBackgroundColor:self.bgColor];
    switch (self.style) {
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
        if (self.clickedBlock) {
            self.clickedBlock();
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
            if (self.bgColor) [cell.label setBackgroundColor:self.bgColor];
            if (self.descFont) [cell.label setFont:self.descFont];
            if (self.descColor) [cell.label setTextColor:self.descColor];
            if (self.desc.length > 0) {
                [cell.label setText:self.desc];
            }else {
                switch (self.style) {
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
            if (self.bgColor) [cell.label setBackgroundColor:self.bgColor];
            if (self.detlDescFont) [cell.label setFont:self.detlDescFont];
            if (self.detlDescColor) [cell.label setTextColor:self.detlDescColor];
            if (self.detlDesc.length > 0) [cell.label setText:self.detlDesc];
        }
            break;
            
        default:
            break;
    }
    
}
- (void)didSelectCell:(HTupleBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (self.clickedBlock) {
        self.clickedBlock();
    }
}

- (void)removeFromSuperview {
    [self setIsLoading:NO];
    [super removeFromSuperview];
}

@end
