//
//  HHostSegmentCell.m
//  QFProj
//
//  Created by dqf on 2018/8/23.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HHostSegmentCell.h"

@interface HHostSegmentCell ()
@property (nonatomic) UISegmentedControl *segment;
@end

@implementation HHostSegmentCell

- (UISegmentedControl *)segment {
    if (!_segment) {
        NSArray *array = [NSArray arrayWithObjects:@"关闭",@"开启", nil];
        _segment = [[UISegmentedControl alloc] initWithItems:array];
        _segment.tintColor = [UIColor whiteColor];
        _segment.backgroundColor = UIColor.grayColor;
        [_segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        _segment.selectedSegmentIndex = 0;
    }
    return _segment;
}

- (void)segmentAction:(id)sender {
    if (self.segmentBlock) {
        _selectedIndex = self.segment.selectedSegmentIndex;
        self.segmentBlock(self.segment.selectedSegmentIndex);
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex != selectedIndex && selectedIndex < self.segment.numberOfSegments) {
        _selectedIndex = selectedIndex;
        self.segment.selectedSegmentIndex = selectedIndex;
    }
}

- (void)initUI {
    [self addSubview:self.segment];
}

- (void)relayoutSubviews {
    [super relayoutSubviews];
    CGRect frame1 = [self layoutViewBounds];
    CGRect frame2 = CGRectMake(CGRectGetWidth(frame1)-130-10, 5, 130, CGRectGetHeight(frame1)-10);
    if (!CGRectEqualToRect(self.segment.frame, frame2)) {
        [self.segment setFrame:frame2];
    }
}

@end
