//
//  HWaitingView.m
//  HProjectModel1
//
//  Created by dqf on 2018/12/30.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HWaitingView.h"
#import "HTupleView.h"
#import <objc/runtime.h>

#define KImageWidth  130
#define KImageHeight 33

#define KTextWidth   130
#define KTextHeight  24

@interface HWaitingView ()
@property (nonatomic) HTupleView *tupleView;
@end

@implementation HWaitingView

@synthesize bgColor,style,desc,descFont;
@synthesize descColor,marginTop,isLoading;

- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:self.bounds];
        [_tupleView setScrollEnabled:NO];
        [_tupleView setUserInteractionEnabled:NO];
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
    CGFloat height = KImageHeight;
    if (self.desc.length > 0) height += KTextHeight;

    CGFloat tmpMarginTop = self.tupleView.height/2-height/2;
    if (self.marginTop > 0) tmpMarginTop -= self.marginTop;

    return UIEdgeInsetsMake(tmpMarginTop, self.tupleView.width/2-KImageWidth/2, self.tupleView.height - tmpMarginTop - height, self.tupleView.width/2-KImageWidth/2);
}

- (void)tupleView:(HTupleView *)tupleView tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = @"image";
    if (self.desc.length > 0) prefix = @"union";

    HTupleViewCell *cell = itemBlock(nil, HTupleViewCell.class, prefix, YES);
    if (self.bgColor) [cell setBackgroundColor:self.bgColor];

    CGRect frame = [cell layoutViewFrame];
    if (self.desc.length > 0) frame.size.height -= KTextHeight; //image和text都显示的情况

    [cell.imageView setFrame:frame];
    [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 1; i <= 16; i++) {
        NSString *imageName = [NSString stringWithFormat:@"loading_new_%d", i];
        UIImage *image = [UIImage imageNamed:imageName];
        switch (self.style) {
            case HWaitingTypeBlack:
                image = [self reDrawImage:image withColor:[UIColor blackColor]];
                break;
            case HWaitingTypeWhite:
                image = [self reDrawImage:image withColor:[UIColor whiteColor]];
                break;
            case HWaitingTypeGray:
                image = [self reDrawImage:image withColor:[UIColor lightGrayColor]];
                break;
            default:
                break;
        }
        if (image) [images addObject:image];
    }

    cell.imageView.animationImages = images;
    cell.imageView.animationDuration = 1.0f;
    [cell.imageView startAnimating];

    if (self.desc.length > 0) {//image和text都显示的情况

        frame.origin.y += KImageHeight;
        frame.size.height = KTextHeight;

        [cell.label setFrame:frame];
        //[cell.label setText:@"请稍候..."];
        [cell.label setText:self.desc];
        [cell.label setFont:[UIFont systemFontOfSize:14]];
        [cell.label setTextAlignment:NSTextAlignmentCenter];

        switch (self.style) {
            case HWaitingTypeBlack:
                [cell.label setTextColor:[UIColor blackColor]];
                break;
            case HWaitingTypeWhite:
                [cell.label setTextColor:[UIColor whiteColor]];
                break;
            case HWaitingTypeGray:
                [cell.label setTextColor:[UIColor lightGrayColor]];
                break;
            default:
                break;
        }
    }
}
- (void)removeFromSuperview {
    HTupleImageCell *cell = self.tupleView.cell(0, 0);
    if (cell.imageView.isAnimating) {
        [cell.imageView stopAnimating];
    }
    [self setIsLoading:NO];
    [super removeFromSuperview];
}
//重新绘制图片
- (UIImage *)reDrawImage:(UIImage *)image withColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
