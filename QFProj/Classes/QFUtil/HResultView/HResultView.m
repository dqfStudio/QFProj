//
//  HResultView.m
//  HProjectModel1
//
//  Created by wind on 2018/12/30.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HResultView.h"
#import "HTupleView.h"
#import <objc/runtime.h>
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
        _tupleView = [[HTupleView alloc] initWithFrame:self.bounds];
        [_tupleView setScrollEnabled:NO];
        [_tupleView setTupleDelegate:(id<HTupleViewDelegate>)self];
    }
    return _tupleView;
}
- (void)wakeup {
    //添加view
    [self addSubview:self.tupleView];
}

- (NSInteger)numberOfSectionsInTupleView:(HTupleView *)tupleView {
    return 1;
}
- (NSInteger)tupleView:(HTupleView *)tupleView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (CGSize)tupleView:(HTupleView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.tupleView.width, self.tupleView.height);
}

- (UIEdgeInsets)tupleView:(HTupleView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.f;
    if (!self.hideImage) height += KImageHeight;
    height += KTextHeight;
    if (self.detlDesc.length > 0) height += KTextHeight2;

    CGFloat tmpMarginTop = self.tupleView.height/2-height/2;
    if (self.marginTop > 0) tmpMarginTop -= self.marginTop;

    return UIEdgeInsetsMake(tmpMarginTop, self.tupleView.width/2-KImageWidth/2, self.tupleView.height - tmpMarginTop - height, self.tupleView.width/2-KImageWidth/2);
}

- (void)tupleView:(HTupleView *)tupleView tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = @"image";
    if (self.desc.length > 0) prefix = @"text";
    if (self.detlDesc.length > 0) prefix = @"union";

    HTupleViewCell *cell = itemBlock(nil, HTupleViewCell.class, prefix, YES);
    if (self.bgColor) [cell setBackgroundColor:self.bgColor];

    CGRect frame = [cell getContentFrame];

    if (![AFNetworkReachabilityManager sharedManager].isReachable) {
        self.style = HResultTypeNoNetwork;
    }

    if (!self.hideImage) {

        frame.origin.x += 35/2;
        frame.size.width -= 35;
        frame.size.height -= KTextHeight; //image和text都显示的情况
        if (self.detlDesc.length > 0) frame.size.height -= KTextHeight2; //image和text都显示的情况

        [cell.imageView setFrame:frame];

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
    }

    frame.origin.x -= 35/2;
    frame.size.width += 35;
    if (!self.hideImage) frame.origin.y += KImageHeight;
    frame.size.height = KTextHeight;
    [cell.label setFrame:frame];

    [cell.label setTextColor:[UIColor blackColor]];
    [cell.label setFont:[UIFont systemFontOfSize:14]];
    [cell.label setTextAlignment:NSTextAlignmentCenter];

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

    if (self.detlDesc.length > 0) {//image和text都显示的情况

        frame.origin.y += KTextHeight;
        frame.size.height = KTextHeight2;
        [cell.detailLabel setFrame:frame];

        [cell.detailLabel setText:self.detlDesc];
        [cell.detailLabel setTextColor:[UIColor blackColor]];
        [cell.detailLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.detailLabel setTextAlignment:NSTextAlignmentCenter];
    }

}

- (void)tupleView:(HTupleView *)tupleView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.clickedBlock) {
        self.clickedBlock();
    }
}

- (void)removeFromSuperview {
    [self setIsLoading:NO];
    [super removeFromSuperview];
}

@end
