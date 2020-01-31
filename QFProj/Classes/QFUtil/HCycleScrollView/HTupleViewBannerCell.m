//
//  HTupleViewBannerCell.m
//  QFProj
//
//  Created by wind on 2020/1/31.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HTupleViewBannerCell.h"
#import "HCycleScrollView.h"

#define KCellHeight 180

@interface HTupleViewBannerCell () <HCycleScrollViewDelegate>
@property (nonatomic) HCycleScrollView *cycleScrollView;
@end

@implementation HTupleViewBannerCell

- (HCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [HCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.frame.size.width, KCellHeight) delegate:self placeholderImage:[UIImage imageNamed:@"HCyclePlaceholder"]];
        _cycleScrollView.pageControlAliment = HCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    }
    return _cycleScrollView;
}

- (void)setImageUrlArr:(NSArray *)imageUrlArr {
    if (_imageUrlArr != imageUrlArr) {
        _imageUrlArr = nil;
        _imageUrlArr = imageUrlArr;
        [self.cycleScrollView setImageURLStringsGroup:_imageUrlArr];
    }
}

- (void)relayoutSubviews {
    CGRect frame = self.layoutViewFrame;
    frame.size.height = KCellHeight;
    [self.cycleScrollView setFrame:frame];
}

- (void)initUI {
    [self addSubview:self.cycleScrollView];
}

#pragma mark - HCycleScrollViewDelegate

- (void)cycleScrollView:(HCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.selectedBannerBlock) {
        self.selectedBannerBlock(index);
    }
}

@end

