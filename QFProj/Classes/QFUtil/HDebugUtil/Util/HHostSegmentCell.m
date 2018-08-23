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
        NSArray *array = [NSArray arrayWithObjects:@"debug",@"release", nil];
        _segment = [[UISegmentedControl alloc] initWithItems:array];
        _segment.frame = CGRectMake(15, 5, CGRectGetWidth(self.frame)-30, CGRectGetHeight(self.frame)-10);
        _segment.tintColor = [UIColor whiteColor];
        [_segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
