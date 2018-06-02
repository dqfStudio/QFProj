//
//  HTableViewCell.m
//  MGMobileMusic
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HTableViewCell.h"

@implementation HTableViewCell

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.backgroundColor = [UIColor clearColor];
    }
    return _leftImageView;
}

- (void)setLeftImageEdgeInsets:(HCellEdgeInsets)leftImageEdgeInsets {
    if (!HCellEdgeEqualToEdge(_leftImageEdgeInsets, leftImageEdgeInsets)) {
        _leftImageEdgeInsets = leftImageEdgeInsets;
        CGRect frame = CGRectZero;
        frame.size.width = leftImageEdgeInsets.width;
        frame.size.height = leftImageEdgeInsets.height;
        [self.imageView setFrame:frame];
        [self.leftImageView setFrame:frame];
        [self layoutSubviews];
    }
}

- (void)setFilletedCorner:(BOOL)filletedCorner {
    if (_filletedCorner != filletedCorner) {
        _filletedCorner = filletedCorner;
        [self layoutSubviews];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //解决用系统iamgeView控件，异步加载网络图片显示不出来的问题
    if (self.leftImageView.image) {

        //调整leftImageView的坐标
        CGRect tmpFrame = self.imageView.frame;
        tmpFrame.origin.x = self.leftImageEdgeInsets.left;
        tmpFrame.origin.y = self.frame.size.height/2-tmpFrame.size.height/2;
        if (!CGRectEqualToRect(self.leftImageView.frame, tmpFrame)) {
            self.imageView.frame = tmpFrame;
            self.leftImageView.frame = tmpFrame;
        }
        
        //设置leftImageView为圆角
        if (self.filletedCorner) {
            self.leftImageView.layer.masksToBounds = YES;
            self.leftImageView.layer.cornerRadius = self.leftImageView.frame.size.width/2;
        }
        
        //释放上下文
        @autoreleasepool {
            UIGraphicsBeginImageContext(tmpFrame.size);
            self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        //隐藏系统的imageView
        [self.imageView setHidden:YES];
    }
    
    //解决当过style为UITableViewCellStyleValue1时，给detailTextLabel添加图片,
    //textLabel文字不居中的问题
    if (self.style == UITableViewCellStyleValue1) {
        CGRect tmpFrame = self.textLabel.frame;
        tmpFrame.origin.y = self.frame.size.height/2-tmpFrame.size.height/2;
        self.textLabel.frame = tmpFrame;
    }
}

- (void)initUI {
    [self addSubview:self.leftImageView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end

