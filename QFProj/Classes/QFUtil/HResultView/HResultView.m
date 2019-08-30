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

#define KImageWidth  165
#define KImageHeight 140

#define KTextWidth   200
#define KTextHeight  20

#define KNoNetwork  1000

@interface HResultView () <HTupleViewDelegate>
@property (nonatomic) HTupleView *tupleView;
@end

@implementation HResultView

@synthesize bgColor,style,marginTop,hideImage;
@synthesize desc,descFont,descColor;
@synthesize detlDesc,detlDescFont,detlDescColor;
@synthesize clickedBlock;

- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:self.bounds];
        [_tupleView setScrollEnabled:NO];
    }
    return _tupleView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup {
    
    //添加view
    [self addSubview:self.tupleView];

    @www
    //section
    [self.tupleView tupleWithSections:^CGFloat{
        return 1;
    } items:^CGFloat(NSInteger section) {
        return 1;
    } color:^UIColor * _Nullable(NSInteger section) {
        return nil;
    } inset:^UIEdgeInsets(NSInteger section) {
        return UIEdgeInsetsZero;
    }];

    //item
    [self.tupleView itemWithSize:^CGSize(NSIndexPath * _Nonnull indexPath) {
        @sss
        return CGSizeMake(self.tupleView.width, self.tupleView.height);
    } edgeInsets:^UIEdgeInsets(NSIndexPath * _Nonnull indexPath) {
        @sss
        CGFloat height = 0.f;
        if (!self.hideImage) height += KImageHeight;
        height += KTextHeight;
        if (self.detlDesc.length > 0) height += KTextHeight;
        
        CGFloat tmpMarginTop = self.tupleView.height/2-height/2;
        if (self.marginTop > 0) tmpMarginTop -= self.marginTop;
        
        return UIEdgeInsetsMake(tmpMarginTop, self.tupleView.width/2-KImageWidth/2, self.tupleView.height - tmpMarginTop - height, self.tupleView.width/2-KImageWidth/2);
    } tupleItem:^(HTupleItem  _Nonnull itemBlock, NSIndexPath * _Nonnull indexPath) {
        @sss
        
        NSString *prefix = @"image";
        if (self.desc.length > 0) prefix = @"text";
        if (self.detlDesc.length > 0) prefix = @"union";
        
        HTupleViewCell *cell = itemBlock(nil, HTupleViewCell.class, prefix, YES);
        if (self.bgColor) [cell setBackgroundColor:self.bgColor];
        
        CGRect frame = [cell getContentFrame];
        
        if (![AFNetworkReachabilityManager sharedManager].isReachable) {
            self.style = KNoNetwork;
        }
        
        if (!self.hideImage) {
            
            if (self.desc.length > 0) frame.size.height -= KTextHeight; //image和text都显示的情况
            if (self.detlDesc.length > 0) frame.size.height -= KTextHeight; //image和text都显示的情况
            
            [cell.imageView setFrame:frame];
            
            switch (self.style) {
                case HResultTypeNoData:
                    [cell.imageView setImage:[UIImage imageNamed:@"mgf_icon_load_nothing"]];
                    break;
                case HResultTypeLoadError:
                    [cell.imageView setImage:[UIImage imageNamed:@"mgf_icon_no_server"]];
                    break;
                case KNoNetwork:
                    [cell.imageView setImage:[UIImage imageNamed:@"mgf_icon_no_network"]];
                    break;
                default:
                    break;
            }
        }
        
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
                case KNoNetwork:
                    [cell.label setText:@"网络已断开"];
                    break;
                default:
                    break;
            }
        }
        
        if (self.detlDesc.length > 0) {//image和text都显示的情况
            
            frame.origin.y += KTextHeight;
            frame.size.height = KTextHeight;
            [cell.detailLabel setFrame:frame];
            
            [cell.detailLabel setText:self.detlDesc];
            [cell.detailLabel setTextColor:[UIColor blackColor]];
            [cell.detailLabel setFont:[UIFont systemFontOfSize:14]];
            [cell.detailLabel setTextAlignment:NSTextAlignmentCenter];
        }
        
    }];
    
    [self.tupleView didSelectItem:^(NSIndexPath * _Nonnull indexPath) {
        if (self.clickedBlock) {
            self.clickedBlock();
        }
    }];
}

@end
