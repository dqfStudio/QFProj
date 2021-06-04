////
////  LiveRoomExchangeView.m
////  UserClient
////
////  Created by wzz on 2019/1/4.
////  Copyright © 2019 wzz. All rights reserved.
////
//
//#import "LiveRoomExchangeView.h"
//#import "LiveGiftTableView.h"
//@interface LiveRoomExchangeView ()<UIScrollViewDelegate>
//
////切换的三个图片视图
//@property (nonatomic, strong) UIImageView *preImgView, *middleImgView, *nextImgView;
////切换的三个model
//@property (nonatomic, strong) VideoItemModel *preModel, *middleModel, *nextModel;
////切换滚动的offset
//@property (nonatomic, assign) CGFloat offsetY;
////当前播放的
//@property (nonatomic, assign) NSInteger currentIndex;
////视频数组
//@property (nonatomic, strong) NSArray<VideoItemModel *> *videosList;
//
//@end
//
//@implementation LiveRoomExchangeView
//
//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        [self setupUI];
//    }
//    return self;
//}
//
//- (void)setupUI {
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
//    self.scrollView = scrollView;
//    scrollView.contentSize = CGSizeMake(0, self.viewHeight * 3);
//    scrollView.contentOffset = CGPointMake(0, self.viewHeight);
//    scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
//    scrollView.pagingEnabled = YES;
//    scrollView.showsVerticalScrollIndicator = NO;
//    scrollView.showsHorizontalScrollIndicator = NO;
//    scrollView.delegate = self;
//    [self addSubview:scrollView];
//
//    for (int i = 0; i < 3; i++) {
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.viewHeight * i, self.viewWidth, self.viewHeight)];
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
//
//        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
//        effectView.alpha = 0.9;
//        effectView.frame = imageView.bounds;
//        [imageView addSubview:effectView];
//
//        [self.scrollView addSubview:imageView];
//        if (i == 0) {
//            self.preImgView = imageView;
//        } else if (i == 1) {
//            self.middleImgView = imageView;
//            imageView.image = [UIImage imageNamed:@"liveplcehold"];
//        } else {
//            self.nextImgView = imageView;
//        }
//    }
//}
////- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
////
////
////    [UIView animateWithDuration:1 animations:^{
//////        if (scrollView.contentOffset.y > (SCREEN_HEIGHT + SCREEN_HEIGHT/3)) {
//////            targetContentOffset->y = SCREEN_HEIGHT*2;
//////        } else if (scrollView.contentOffset.y < (SCREEN_HEIGHT - SCREEN_HEIGHT/3)){
//////            targetContentOffset->y = 0;
//////        }
////        targetContentOffset->x = (targetContentOffset->x - scrollView.contentOffset.x) / 5 + scrollView.contentOffset.x;
////        targetContentOffset->y = (targetContentOffset->y - scrollView.contentOffset.y) / 5 + scrollView.contentOffset.y;
////    }];
////}
//
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (self.videosList.count <= 1) {
//        return;
//    }
//    [[LiveGiftTableView shareInstance].dataArr removeAllObjects];
//    [[LiveGiftTableView shareInstance].tableView reloadData];
//
//    CGFloat offsetY = scrollView.contentOffset.y;
//    if (offsetY >= 2 * self.viewHeight) {
//        [scrollView setContentOffset:CGPointMake(0, self.viewHeight) animated:NO];
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
//    } else if (offsetY <= 0) {
//        [scrollView setContentOffset:CGPointMake(0, self.viewHeight) animated:NO];
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
//    }
//}
//
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
//
//@end
