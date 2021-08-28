//
//  HLiveRoomExchangeVC.m
//  QFProj
//
//  Created by dqf on 2021/8/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HLiveRoomExchangeVC.h"
#import "HLiveBackgroundCell.h"
#import "HTupleLiveCell.h"

@interface HLiveRoomExchangeVC ()

@end

@implementation HLiveRoomExchangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.topExtendedLayout = NO;
    self.tupleView.pagingEnabled = YES;
    [self.tupleView setTupleDelegate:self];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tupleView.contentSize = CGSizeMake(0, self.tupleView.height*3);
    self.tupleView.contentOffset = CGPointMake(0, self.tupleView.height);
}

- (BOOL)prefersNavigationBarHidden {
    return YES;
}

- (void)tupleScrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= 2*self.view.viewHeight) {//向上滚动
        [scrollView setContentOffset:CGPointMake(0, self.view.viewHeight) animated:NO];
        [self tupleScrollViewDidScrollToTop:scrollView];
    }else if (offsetY <= 0) {//向下滚动
        [scrollView setContentOffset:CGPointMake(0, self.view.viewHeight) animated:NO];
        [self tupleScrollViewDidScrollToBottom:scrollView];
    }
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return 3;
}
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.tupleView.size;
}
- (void)tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            HLiveBackgroundCell *cell = itemBlock(nil, HLiveBackgroundCell.class, nil, YES);
            [cell setSignalBlock:nil];
        }
            break;
        case 2: {
            HLiveBackgroundCell *cell = itemBlock(nil, HLiveBackgroundCell.class, nil, YES);
            [cell setSignalBlock:nil];
        }
            break;
        case 1: {
            HTupleLiveCell*cell = itemBlock(nil, HTupleLiveCell.class, nil, YES);
            [cell setSignalBlock:^(HTupleLiveCell *cell, HTupleSignal *signal) {
                //NSInteger index = [signal.signal integerValue];
                
                // 开始旋转
                [cell.activityIndicator startAnimating];
                // 解除禁止滚动
                self.tupleView.scrollEnabled = YES;
            }];
        }
            break;

        default:
            break;
    }

}

//向上滚动
- (void)tupleScrollViewDidScrollToTop:(UIScrollView *)scrollView {
    self.tupleView.scrollEnabled = NO;
    HTupleLiveCell *cell = self.tupleView.cell(1, 0);
    HTupleSignal *signal = HTupleSignal.new;
    signal.signal = @(1);
    cell.signalBlock(cell, signal);
}
//向下滚动
- (void)tupleScrollViewDidScrollToBottom:(UIScrollView *)scrollView {
    self.tupleView.scrollEnabled = NO;
    HTupleLiveCell *cell = self.tupleView.cell(1, 0);
    HTupleSignal *signal = HTupleSignal.new;
    signal.signal = @(1);
    cell.signalBlock(cell, signal);
}

@end
