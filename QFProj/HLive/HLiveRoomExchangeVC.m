//
//  HLiveRoomExchangeVC.m
//  QFProj
//
//  Created by dqf on 2021/8/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HLiveRoomExchangeVC.h"
#import "HLiveBackgroundCell.h"

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
//    if (self.videosList.count <= 1) {
//        return;
//    }
//    [[LiveGiftTableView shareInstance].dataArr removeAllObjects];
//    [[LiveGiftTableView shareInstance].tableView reloadData];

    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= 2*self.view.viewHeight) {//向上滚动
        
        [scrollView setContentOffset:CGPointMake(0, self.view.viewHeight) animated:NO];
        [self tupleScrollViewDidScrollToTop:scrollView];
        
//        [self.tupleView scrollRectToVisible:CGRectMake(0, self.view.viewHeight, self.view.viewWidth, self.view.viewHeight) animated:NO];
//        [self.tupleView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
//        [self.tupleView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:0]]];
        NSLog(@"index----->:下一个");
//        if (self.currentIndex >= self.videosList.count - 1) {
//            self.currentIndex = 0;
//        } else {
//            self.currentIndex++;
//        }
//        self.preImgView.image = self.middleImgView.image;
//        self.middleImgView.image = self.nextImgView.image;
//        VideoItemModel *model = self.videosList[self.currentIndex];
//        [self updateImageView:self.nextImgView forModel:model];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(liveRoomExchangeView:selectIndex:)]) {
//            [self.delegate liveRoomExchangeView:self selectIndex:self.currentIndex];
//        }
    }else if (offsetY <= 0) {//向下滚动
        
        [scrollView setContentOffset:CGPointMake(0, self.view.viewHeight) animated:NO];
        [self tupleScrollViewDidScrollToBottom:scrollView];
        
//        [self.tupleView scrollRectToVisible:CGRectMake(0, self.view.viewHeight, self.view.viewWidth, self.view.viewHeight) animated:NO];
//        [self.tupleView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
//        [self.tupleView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:0]]];
        
        NSLog(@"index----->:上一个");
//        if (self.currentIndex <= 0) {
//            self.currentIndex = self.videosList.count - 1;
//        } else {
//            self.currentIndex--;
//        }
//        self.nextImgView.image = self.middleImgView.image;
//        self.middleImgView.image = self.preImgView.image;
//        VideoItemModel *model = self.videosList[self.currentIndex];
//        [self updateImageView:self.preImgView forModel:model];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(liveRoomExchangeView:selectIndex:)]) {
//            [self.delegate liveRoomExchangeView:self selectIndex:self.currentIndex];
//        }
    }
}

//- (void)updateForItemsList:(NSArray <VideoItemModel *> *)videosList withSelectIndex:(NSInteger)selectIndex {
//    self.videosList = [NSArray arrayWithArray:videosList];
//    if (videosList.count <= 1) {
//        self.scrollView.scrollEnabled = NO;
//    } else {
//        self.scrollView.scrollEnabled = YES;
//    }
//    if (videosList.count <= 1) {
//        return;
//    }
//    //三个model赋值
//    self.currentIndex = selectIndex;
//    self.middleModel = videosList[selectIndex];
//    if (self.currentIndex == 0) {
//        self.preModel = [videosList lastObject];
//    } else {
//        self.preModel = videosList[selectIndex - 1];
//    }
//    if (self.currentIndex == videosList.count - 1) {
//        self.nextModel = [videosList firstObject];
//    } else {
//        self.nextModel = videosList[selectIndex + 1];
//    }
//    [self updateImageView:self.middleImgView forModel:self.middleModel];
//    [self updateImageView:self.preImgView forModel:self.preModel];
//    [self updateImageView:self.nextImgView forModel:self.nextModel];
//}
//- (void)setCoverUrl:(NSString *)coverUrl {
//    _coverUrl = coverUrl;
//    [self.middleImgView cacheImageForUrlString:coverUrl placeholderImage:nil completed:nil];
//}
//- (void)updateImageView:(UIImageView *)imageView forModel:(VideoItemModel *)model {
//    imageView.image = [UIImage imageNamed:@"liveplcehold"];
//}



- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return 3;
}
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.tupleView.size;
}
- (void)tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    HLiveBackgroundCell *cell = itemBlock(nil, HLiveBackgroundCell.class, nil, YES);
    NSLog(@"index----->:%ld",indexPath.row);
    switch (indexPath.row) {
        case 0: {
            cell.backgroundColor = UIColor.yellowColor;
            [cell setSignalBlock:nil];
        }
            break;
        case 1: {
            cell.backgroundColor = UIColor.redColor;
            [cell setSignalBlock:^(HLiveBackgroundCell *cell, HTupleSignal *signal) {
                NSInteger index = [signal.signal integerValue];
                
                self.tupleView.scrollEnabled = YES;
            }];
        }
            break;
        case 2: {
            cell.backgroundColor = UIColor.blueColor;
            [cell setSignalBlock:nil];
        }
            break;

        default:
            break;
    }

}

//向上滚动
- (void)tupleScrollViewDidScrollToTop:(UIScrollView *)scrollView {
    self.tupleView.scrollEnabled = NO;
    HLiveBackgroundCell *cell = self.tupleView.cell(1, 0);
    HTupleSignal *signal = HTupleSignal.new;
    signal.signal = @(1);
    cell.signalBlock(cell, signal);
}
//向下滚动
- (void)tupleScrollViewDidScrollToBottom:(UIScrollView *)scrollView {
    self.tupleView.scrollEnabled = NO;
    HLiveBackgroundCell *cell = self.tupleView.cell(1, 0);
    HTupleSignal *signal = HTupleSignal.new;
    signal.signal = @(1);
    cell.signalBlock(cell, signal);
}

@end
