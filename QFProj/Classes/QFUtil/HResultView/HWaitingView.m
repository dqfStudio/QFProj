//
//  HWaitingView.m
//  QFProj
//
//  Created by dqf on 2018/12/30.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HWaitingView.h"
#import "HTupleView.h"

#define KWaitingImageSize  CGSizeMake(130, 33)
#define KWaitingTextSize   CGSizeMake(130, 24)

@interface HWaitingView ()
@property (nonatomic) HTupleView *tupleView;
@end

@implementation HWaitingView

- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:CGRectZero];
        [_tupleView bounceDisenable];
        [_tupleView setUserInteractionEnabled:NO];
        [_tupleView setTupleDelegate:(id<HTupleViewDelegate>)self];
        [self addSubview:_tupleView];
    }
    return _tupleView;
}
- (void)wakeup {
    //添加view
    CGFloat height = KWaitingImageSize.height;
    if (_make.desc.length > 0) height += KWaitingTextSize.height;
    
    CGRect frame = CGRectMake(0, 0, KWaitingImageSize.width, height);
    self.tupleView.frame = frame;
    self.tupleView.center = CGPointMake(self.center.x, self.center.y-_make.marginTop);
    
    [self.tupleView reloadData];
}
- (void)setMake:(HWaitingTransition *)make {
    if (_make != make) {
        _make = nil;
        _make = make;
        [self wakeup];
    }
}
- (NSInteger)numberOfSectionsInTupleView {
    return 1;
}
- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (CGSize)sizeForHeaderInSection:(NSInteger)section {
    return KWaitingImageSize;
}
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.tupleView.width, self.tupleView.height);
}

- (void)tupleHeader:(HTupleHeader)headerBlock inSection:(NSInteger)section {
    HTupleAnimatedImageApex *cell = headerBlock(nil, HTupleAnimatedImageApex.class, nil, YES);
    if (_make.bgColor) [cell.imageView setBackgroundColor:_make.bgColor];
    [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
    switch (_make.style) {
        case HWaitingTypeBlack:
            [cell.imageView setAnimatedGIFDataWithName:@"loading_gif_black"];
            break;
        case HWaitingTypeWhite:
            [cell.imageView setAnimatedGIFDataWithName:@"loading_gif_white"];
            break;
        case HWaitingTypeGray:
            [cell.imageView setAnimatedGIFDataWithName:@"loading_gif_lightGray"];
            break;
        default:
            break;
    }
}
- (void)tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
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
    }
}

@end
