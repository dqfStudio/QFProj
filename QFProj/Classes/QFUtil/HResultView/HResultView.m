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

//#define KImageWidth  165
#define KImageWidth  200
#define KImageHeight 140

#define KTextWidth   200
#define KTextHeight  25
#define KTextHeight2 20

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
    }
    return _tupleView;
}
- (void)wakeup {
    //添加view
    CGFloat height = KTextHeight;
    if (!self.hideImage) height += KImageHeight;
    if (self.detlDesc.length > 0) height += KTextHeight2;
    
    CGRect frame = CGRectMake(0, 0, KImageWidth, height);
    self.tupleView.frame = frame;
    self.tupleView.center = CGPointMake(self.center.x, self.center.y-self.marginTop);
    [self addSubview:self.tupleView];
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
    return self.hideImage ? CGSizeZero : CGSizeMake(KImageWidth, KImageHeight);
}
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: return CGSizeMake(KTextWidth, KTextHeight);
        case 1: return CGSizeMake(KTextWidth, KTextHeight2);
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
            [cell.imageView setImage:[UIImage imageNamed:@"mgf_icon_load_nothing"]];
            break;
        case HResultTypeLoadError:
            [cell.imageView setImage:[UIImage imageNamed:@"mgf_icon_no_server"]];
            break;
        case HResultTypeNoNetwork:
            [cell.imageView setImage:[UIImage imageNamed:@"mgf_icon_no_network"]];
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
            HTupleViewCell *cell = itemBlock(nil, HTupleViewCell.class, nil, YES);
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
            HTupleViewCell *cell = itemBlock(nil, HTupleViewCell.class, nil, YES);
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
