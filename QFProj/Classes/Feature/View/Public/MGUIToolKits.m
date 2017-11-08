//
//  MGUIToolKits.m
//  MGMobileMusic
//
//  Created by MikeWang on 16/9/19.
//  Copyright © 2016年 migu. All rights reserved.
//

#import "MGUIToolKits.h"
#import "MGMBProgressHUD.h"
//#import "CoordinatingController.h"
#import <objc/runtime.h>
#import "QFKit.h"
//#import <AFNetworking/AFNetworking.h>
#import "MGRequestManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
//#import "MGWindmillRefreshHeader.h"
#import "MJRefresh.h"

#define WAITING_VIEW_TAG 10000
#define NO_DATA_VIEW_TAG 10001

@implementation MGUIToolKits
//+(void)showRoundCornerMessageOnTopView:(NSString*)content withDelay:(CGFloat)delay
//{
//    UIViewController *topVc = [[[CoordinatingController sharedInstance].rootNavController viewControllers] lastObject];
////    [MGMBProgressHUD hideHUDForView:topVc.view animated:NO];
////    NSDictionary *attributes =  @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:16]};
////    CGSize contentSize = [content :];
//    MGMBProgressHUD *mbProgressHUD = [MGMBProgressHUD showHUDAddedTo:topVc.view animated:YES];
//    [mbProgressHUD setMode:MGMBProgressHUDModeCustomView];
//    [mbProgressHUD setColor:UIColorFromRGBA(0x0000007f)];
//    [mbProgressHUD setMargin:10];
//    [mbProgressHUD setOpacity:0.3];
////    [mbProgressHUD setSquare:YES];
//    [mbProgressHUD setCornerRadius:18];
//    [mbProgressHUD setLabelText:content];
//    [mbProgressHUD hide:YES afterDelay:delay];
//    [mbProgressHUD setCenter:CGPointMake(topVc.view.center.x, topVc.view.center.y-120.)];
//}
//
//
//+ (void)showWaitingHUDInView:(UIView *)view
//{
//    [MGMBProgressHUD hideHUDForView:view animated:NO];
//    MGMBProgressHUD *mbProgressHUD = [MGMBProgressHUD showHUDAddedTo:view animated:YES];
//    [mbProgressHUD setMode:MGMBProgressHUDModeIndeterminate];
//    [mbProgressHUD setSquare:YES];
//    [mbProgressHUD setLabelText:@"请稍候..."];
//
//    [mbProgressHUD setCenter:CGPointMake(view.center.x, view.center.y-120.)];
//}
//
//+(void)hideWaitingHUDInView:(UIView*)view
//{
//    [MGMBProgressHUD hideAllHUDsForView:view animated:YES];
//}
//
////展示消失消息
//+ (void)showMessageInView:(UIView *)view WithString:(NSString *)content
//{
//    [self showMessageInView:view WithString:content withDelay:1.5];
//}
//
//// 可以更改显示时长
//+ (void)showMessageInView:(UIView *)view WithString:(NSString *)content withDelay:(CGFloat)delay
//{
//    MGMBProgressHUD *mbProgressHUD = [MGMBProgressHUD showHUDAddedTo:view animated:YES];
//    [mbProgressHUD setMode:MGMBProgressHUDModeText];
//    [mbProgressHUD setLabelText:content];
//    [mbProgressHUD hide:YES afterDelay:delay];
//}
//
//+ (void)showMessageInView:(UIView *)view WithTitle:(NSString*)title WithString:(NSString *)content withDelay:(CGFloat)delay
//{
//    MGMBProgressHUD *mbProgressHUD = [MGMBProgressHUD showHUDAddedTo:view animated:YES];
//    [mbProgressHUD setMode:MGMBProgressHUDModeText];
//    [mbProgressHUD setLabelText:title];
//    [mbProgressHUD setDetailsLabelText:content];
//    [mbProgressHUD hide:YES afterDelay:delay];
//}
//
//
//+ (UIImage*) imageWithColor:(UIColor*)color andHeight:(CGFloat)height
//{
//    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, height);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return image;
//}
//
//+ (void)showAppLaunchImage {
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIApplication appLaunchImage]];
//    imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    [[UIApplication mainWindow] addSubview:imageView];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [imageView removeFromSuperview];
//        });
//    });
//}



@end

@implementation UIView (MGToast)

+ (void)showToast:(NSString *)text {
    [UIView showToast:text hideAfterDelay:1.5f];
}

+ (void)showToastInAppWindow:(NSString *)text {
    [UIView showToast:text inView:[[UIApplication sharedApplication].windows firstObject] hideAfterDelay:1.5f];
}

+ (void)showToast:(NSString *)text hideAfterDelay:(NSTimeInterval)delay {
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [UIView showToast:text inView:window hideAfterDelay:delay];
}

+ (void)showToast:(NSString *)text
           inView:(UIView *)view
   hideAfterDelay:(NSTimeInterval)delay {
    [MGMBProgressHUD hideAllHUDsForView:view animated:NO];
    MGMBProgressHUD *hud = [MGMBProgressHUD showHUDAddedTo:view animated:YES];
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    
    // Configure for text only and offset down
    //hud.mode = MGMBProgressHUDModeText;
    //hud.labelText = text;
    //hud.labelFont = [UIFont systemFontOfSize:16];
    hud.mode = MGMBProgressHUDModeCustomView;
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:16];
    hud.color = [UIColor colorWithWhite:0 alpha:.5];
    
    hud.margin = 10.f;
    hud.center = window.center;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    [hud hide:YES afterDelay:delay];
}

@end

@implementation UIScrollView (MGRefreshView)

- (void)addRefreshHeaderWithBlock:(void (^)(void))block {
    MGRefreshHeader *header = [MGRefreshHeader headerWithRefreshingBlock:block];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.mj_header = header;
}

- (void)addRefreshHeaderWithTarget:(id)target action:(SEL)action {
    MGRefreshHeader *header = [MGRefreshHeader headerWithRefreshingTarget:target refreshingAction:action];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.mj_header = header;
}

//- (void)addWindmillRefreshHeaderWithBlock:(void (^)(void))block {
//    MGWindmillRefreshHeader *header = [MGWindmillRefreshHeader headerWithRefreshingBlock:block];
//    header.lastUpdatedTimeLabel.hidden = YES;
//    header.stateLabel.hidden = YES;
//    header.backgroundColor = [UIColor colorWithRed:215/255.0 green:57/255.0 blue:100/255.0 alpha:1.0];
//    self.mj_header = header;
//}
//
//- (void)addWindmillRefreshHeaderWithTarget:(id)target action:(SEL)action {
//    MGWindmillRefreshHeader *header = [MGWindmillRefreshHeader headerWithRefreshingTarget:target refreshingAction:action];
//    header.lastUpdatedTimeLabel.hidden = YES;
//    header.stateLabel.hidden = YES;
//    self.mj_header = header;
//}

- (void)addRefreshFooterWithBlock:(void (^)(void))block {
    MGRefreshFooter *footer = [MGRefreshFooter footerWithRefreshingBlock:block];
    footer.stateLabel.hidden = NO;
    self.mj_footer = footer;
}

- (void)addRefreshFooterWithTarget:(id)target action:(SEL)action {
    MGRefreshFooter *footer = [MGRefreshFooter footerWithRefreshingTarget:target refreshingAction:action];
    self.mj_footer = footer;
}

@end

@implementation UIView (MGWaitingAndResultView)

- (void)showWhiteWaitingView {
    [self showWhiteWaitingViewMarginTop:self.waitingAndResultViewMarginTop];
}

- (void)showWhiteWaitingViewNaviBarMarginTop {
    [self showWaitingViewWithText:nil style:MGWaitingViewStyleWhite marginTop:64];
}

- (void)showWhiteWaitingViewMarginTop:(NSInteger)marginTop {
    [self showWaitingViewWithText:nil style:MGWaitingViewStyleWhite marginTop:marginTop];
}

- (void)showWhiteWaitingViewContentYOffset:(CGFloat)yOffset {
    [self showWhiteWaitingViewMarginTop:self.waitingAndResultViewMarginTop contentYOffset:yOffset];
}

- (void)showWhiteWaitingViewMarginTop:(CGFloat)marginTop contentYOffset:(CGFloat)yOffset {
    [self showWaitingViewWithText:nil style:MGWaitingViewStyleWhite marginTop:marginTop contentCenterYOffset:yOffset];
}

- (void)showGrayWatingViewWithText:(NSString *)text {
    [self showWaitingViewWithText:text style:MGWaitingViewStyleGray marginTop:0];
}

- (void)showWaitingViewWithText:(NSString *)text
                          style:(MGWaitingViewStyle)style {
    [self showWaitingViewWithText:text style:style marginTop:self.waitingAndResultViewMarginTop];
}

- (void)showWaitingViewWithText:(NSString *)text
                          style:(MGWaitingViewStyle)style
                      marginTop:(CGFloat)marginTop {
    [self showWaitingViewWithText:text style:style marginTop:marginTop contentCenterYOffset:0];
}

- (void)showWaitingViewWithText:(NSString *)text
                          style:(MGWaitingViewStyle)style
                      marginTop:(CGFloat)marginTop
           contentCenterYOffset:(CGFloat)yOffset {
    if (!self.watingView) {
        self.watingView = [MGWaitingView viewFromNib];
        [self addSubview:self.watingView];
    }
    self.waitingAndResultViewMarginTop = marginTop;
    self.contentCenterYOffset = yOffset;
    self.watingView.frame = CGRectMake(0, marginTop, self.frame.size.width, self.frame.size.height - marginTop);
    self.watingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.watingView.style = style;
    self.watingView.text = text;
    self.watingView.yOffset = yOffset;
    [self bringSubviewToFront:self.watingView];
    //NSLog(@"show in--->%@ %@", [[self.viewController class] description], NSStringFromCGRect(self.watingView.frame));
    [self removeRequestResultView];
}



- (void)removeWaitingView {
    if (!self.watingView) {
        return;
    }
    //NSLog(@"hide in--->%@", [[self.viewController class] description]);
    [self.watingView removeFromSuperview];
    self.watingView = nil;
}

- (void)showRequestResultNoDataViewWithDesc:(NSString *)desc {
    [self showRequestResultViewWithType:MGRequestResultViewTypeNoData
                                   desc:desc
                              marginTop:self.waitingAndResultViewMarginTop
                           clickedBlock:nil];
}

- (void)showRequestResultErrorViewContentYOffset:(CGFloat)yOffset
                                withClickedBlock:(void (^)(void))clickedBlock {
    if ([AFNetworkReachabilityManager sharedManager].isReachable) {
        [self showRequestResultViewWithType:MGRequestResultViewTypeLoadError
                                  marginTop:self.waitingAndResultViewMarginTop
                             contentYOffset:yOffset
                               clickedBlock:clickedBlock];
    }else {
        [self showRequestResultViewWithType:MGRequestResultViewTypeNoNetwork
                                       desc:nil
                                 reloadText:nil
                                  marginTop:self.waitingAndResultViewMarginTop
                             contentYOffset:yOffset
                               clickedBlock:clickedBlock];
    }
}

- (void)showRequestResultErrorViewContentMarginTop:(CGFloat)marginTop withClickedBlock:(void (^)(void))clickedBlock {
    
    if ([AFNetworkReachabilityManager sharedManager].isReachable) {
        [self showRequestResultViewWithType:MGRequestResultViewTypeLoadError
                                  marginTop:marginTop
                             contentYOffset:0
                               clickedBlock:clickedBlock];
    } else {
        [self showRequestResultViewWithType:MGRequestResultViewTypeNoNetwork
                                       desc:nil
                                 reloadText:nil
                                  marginTop:marginTop
                             contentYOffset:0
                               clickedBlock:clickedBlock];
    }
    
}

- (void)showRequestResultErrorViewWithClickedBlock:(void (^)(void))clickedBlock {
    [self showRequestResultErrorViewContentYOffset:self.contentCenterYOffset withClickedBlock:clickedBlock];
}

- (void)showRequestResultViewWithType:(MGRequestResultViewType)type
                            marginTop:(CGFloat)marginTop
                       contentYOffset:(CGFloat)yOffset
                         clickedBlock:(void (^)(void))clickedBlock {
    
    [self showRequestResultViewWithType:type
                                   desc:nil
                             reloadText:nil
                              marginTop:marginTop
                         contentYOffset:yOffset
                           clickedBlock:clickedBlock];
}


- (void)showRequestResultViewWithType:(MGRequestResultViewType)type
                            marginTop:(CGFloat)marginTop
                         clickedBlock:(void (^)(void))clickedBlock {
    
    [self showRequestResultViewWithType:type desc:nil marginTop:marginTop clickedBlock:clickedBlock];
}

- (void)showRequestResultViewWithType:(MGRequestResultViewType)type
                                 desc:(NSString *)desc
                            marginTop:(CGFloat)marginTop
                         clickedBlock:(void (^)(void))clickedBlock {
    [self showRequestResultViewWithType:type desc:desc reloadText:nil marginTop:marginTop clickedBlock:clickedBlock];
}

- (void)showRequestResultViewWithType:(MGRequestResultViewType)type
                                 desc:(NSString *)desc
                           reloadText:(NSString *)reloadText
                            marginTop:(CGFloat)marginTop
                         clickedBlock:(void (^)(void))clickedBlock {
    [self showRequestResultViewWithType:type desc:desc reloadText:reloadText marginTop:marginTop contentYOffset:self.contentCenterYOffset clickedBlock:clickedBlock];
}

- (void)showRequestResultViewWithType:(MGRequestResultViewType)type
                                 desc:(NSString *)desc
                           reloadText:(NSString *)reloadText
                            marginTop:(CGFloat)marginTop
                       contentYOffset:(CGFloat)yOffset
                         clickedBlock:(void (^)(void))clickedBlock
{
    CGRect frame = CGRectMake(0, marginTop, self.frame.size.width, self.frame.size.height - marginTop);
    if (!self.requestResultView) {
        self.requestResultView = [MGRequestResultView viewFromNib];
        [self addSubview:self.requestResultView];
    }
    self.requestResultView.frame = frame;
    self.requestResultView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.requestResultView.type = type;
    self.requestResultView.yOffset = yOffset;
    if (desc) {
        self.requestResultView.title = desc;
    }
    if (clickedBlock) {
        self.requestResultView.reloadLabel.text = @"点击重试";
        if (reloadText) {
            self.requestResultView.reloadLabel.text = reloadText;
        }
        [self.requestResultView setSingleTapGestureWithBlock:^(UITapGestureRecognizer *recognizer) {
            clickedBlock();
        }];
    } else {
        self.requestResultView.reloadLabel.text = nil;
        [self.requestResultView setSingleTapGestureWithBlock:nil];
    }

    [self bringSubviewToFront:self.requestResultView];
    [self removeWaitingView];
}


- (void)removeRequestResultView {
    //NSLog(@"request--->%@", self.requestResultView);
    [self.requestResultView removeFromSuperview];
    self.requestResultView = nil;
}

- (void)dealSuccessWithDataSourceCount:(NSInteger)dataSourceCount {
    if ([self isKindOfClass:[UITableView class]]) {
        [(UITableView *)self reloadData];
    }
    if (dataSourceCount == 0) {
        [self showRequestResultNoDataViewWithDesc:nil];
    }
    [self removeWaitingView];
}

- (void)dealSuccessWithDataSourceCount:(NSInteger)dataSourceCount
                           hasMoreData:(BOOL)hasMoreData
                    refreshFooterBlock:(void (^)(void))refreshFooterBlock {
    [self dealSuccessWithDataSourceCount:dataSourceCount
                             hasMoreData:hasMoreData
                      refreshHeaderBlock:nil
                      refreshFooterBlock:refreshFooterBlock];
}

- (void)dealSuccessWithDataSourceCount:(NSInteger)dataSourceCount
                           hasMoreData:(BOOL)hasMoreData
                    refreshHeaderBlock:(void (^)(void))refreshHeaderBlock
                    refreshFooterBlock:(void (^)(void))refreshFooterBlock {
    if ([self isKindOfClass:[UITableView class]]) {
        [(UITableView *)self reloadData];
    }
    self.pageNo++;
    if (dataSourceCount == 0) {
        [self showRequestResultNoDataViewWithDesc:nil];
    } else {
        if ([self isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)self;
            if (refreshHeaderBlock && !tableView.mj_header) {
                [tableView addRefreshHeaderWithBlock:refreshHeaderBlock];
            }
            
            if (refreshFooterBlock && !tableView.mj_footer) {
                [tableView addRefreshFooterWithBlock:refreshFooterBlock];
            }
            if (tableView.mj_header) {
                [tableView.mj_header endRefreshing];
            }
            if (hasMoreData) {
                [tableView.mj_footer endRefreshing];
            } else {
                [tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
    }
    [self removeWaitingView];
}

- (void)dealFailureWithReloadBlock:(void (^)(void))reloadBlock {
    [self showRequestResultErrorViewWithClickedBlock:reloadBlock];
    [self removeWaitingView];
}

- (void)dealFailureWithError:(NSError *)error
             dataSourceCount:(NSInteger)dataSourceCount
                 reloadBlock:(void (^)(void))reloadBlock {
    if ([self isKindOfClass:[UITableView class]]) {
        [[(UITableView *)self mj_header] endRefreshing];
        [[(UITableView *)self mj_footer] endRefreshing];
    }
    if (dataSourceCount == 0) {
        [self showRequestResultErrorViewWithClickedBlock:reloadBlock];
    } else {
        [MGRequestManager dealError:error];
    }
    [self removeWaitingView];
}

- (void)setPageNo:(NSUInteger)pageNo {
    objc_setAssociatedObject(self, @selector(pageNo), @(pageNo), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)pageNo {
    NSNumber *page = objc_getAssociatedObject(self, _cmd);
    if (!page) [self setPageNo:1];
    return [objc_getAssociatedObject(self, _cmd) unsignedIntegerValue];
}

- (void)setPageSize:(NSUInteger)pageSize {
    objc_setAssociatedObject(self, @selector(pageSize), @(pageSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)pageSize {
    NSNumber *pageSize = objc_getAssociatedObject(self, _cmd);
    if (!pageSize) return KDefaultPageSize;
    return [pageSize unsignedIntegerValue];
}

- (void)setWatingView:(MGWaitingView *)watingView {
    [self setAssociateValue:watingView withKey:@selector(watingView)];
}

- (MGWaitingView *)watingView {
    return [self getAssociatedValueForKey:_cmd];
}

- (void)setRequestResultView:(MGRequestResultView *)requestResultView {
    [self setAssociateValue:requestResultView withKey:@selector(requestResultView)];
}

- (MGRequestResultView *)requestResultView {
    return [self getAssociatedValueForKey:_cmd];
}

- (void)setWaitingAndResultViewMarginTop:(CGFloat)waitingAndResultViewMarginTop {
    [self setAssociateValue:@(waitingAndResultViewMarginTop) withKey:@selector(waitingAndResultViewMarginTop)];
}

- (CGFloat)waitingAndResultViewMarginTop {
    return [[self getAssociatedValueForKey:_cmd] floatValue];
}

- (CGFloat)contentCenterYOffset {
    return [[self getAssociatedValueForKey:_cmd] floatValue];
}

- (void)setContentCenterYOffset:(CGFloat)contentCenterYOffset {
    [self setAssociateValue:@(contentCenterYOffset) withKey:@selector(contentCenterYOffset)];
}


#pragma mark - 待处理

//
//- (void)showRequestResultViewWhenNoData:(NSString *)title
//                              marginTop:(CGFloat)marginTop {
//    [self showRequestResultViewWithType:MGRequestResultViewTypeNoData
//                                  title:title
//                              marginTop:marginTop
//                           clickedBlock:nil];
//}
//
//- (void)showRequestResultViewWhenError:(CGFloat)marginTop
//                          clickedBlock:(void (^)(void))clickedBlock {
//    if ([AFNetworkReachabilityManager sharedManager].isReachable) {
//        [self showRequestResultViewWithType:MGRequestResultViewTypeLoadError
//                                  marginTop:marginTop
//                               clickedBlock:clickedBlock];
//    } else {
//        [self showRequestResultViewWithType:MGRequestResultViewTypeNoNetwork
//                                  marginTop:marginTop
//                               clickedBlock:clickedBlock];
//    }
//}
//





@end

@implementation UITableView (MGPage)

//- (void)showErrorViewWithText:(NSString *)text {
//    @www
//    [self showRequestResultViewWithType:MGRequestResultViewTypeLoadError
//                              marginTop:self.waitingAndResultViewMarginTop
//                           clickedBlock:^{
//                               @sss
//                               [self removeRequestResultView];
//                           }];
//}

//- (void)updateViewWithNumberOfRows:(NSInteger)numberOfRows {
//    [self updateViewWithNumberOfRows:numberOfRows noDataViewTitle:nil];
//}

//- (void)updateViewWithNumberOfRows:(NSInteger)numberOfRows noDataViewTitle:(NSString *)noDataViewTitle {
//    
//    if (numberOfRows == 0) {
//        self.mj_footer.hidden = YES;
//        [self showRequestResultViewWithType:MGRequestResultViewTypeNoData
//                                  marginTop:self.waitingAndResultViewMarginTop
//                               clickedBlock:nil];
//        [self showRequestResultNoDataViewWithDesc:noDataViewTitle];
//    } else {
//        if (self.mj_footer) {
//            self.mj_footer.hidden = NO;
//            //NSLog(@"number-->%ld  page size-->%lu", (long)numberOfRows, (unsigned long)self.pageSize);
//            if (numberOfRows % self.pageSize > 0) {
//                [self.mj_footer endRefreshingWithNoMoreData];
//            } else {
//                [self.mj_footer endRefreshing];
//            }
//        }
//    }
//}

@end

@implementation UIView (MGHeaderImage)

- (void)setHeaderImageUrlString:(NSString *)headerUrlString {
    if (headerUrlString.length > 0 && ![headerUrlString isEqualToString:@"http://tvax2.sinaimg.cn/default/images/default_avatar_male_180.gif"]) {
        if ([self isKindOfClass:[UIButton class]]) {
            @www
            [(UIButton *)self sd_setImageWithURL:[NSURL URLWithString:headerUrlString]
                                        forState:UIControlStateNormal
                                placeholderImage:[UIImage imageNamed:@"icon_user_red_116"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                    @sss
                                    if (cacheType == SDImageCacheTypeNone) {
                                        self.alpha = 0;
                                        [UIView animateWithDuration:0.2f animations:^{
                                            self.alpha = 1;
                                        }];
                                    }
                                }];
        } else if ([self isKindOfClass:[UIImageView class]]) {
            @www
            [(UIImageView *)self sd_setImageWithURL:[NSURL URLWithString:headerUrlString]
                                   placeholderImage:[UIImage imageNamed:@"icon_user_red_116"]
                                          completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                              @sss
                                              if (cacheType == SDImageCacheTypeNone) {
                                                  self.alpha = 0;
                                                  [UIView animateWithDuration:0.2f animations:^{
                                                      self.alpha = 1;
                                                  }];
                                              }
                                          }];
        }
        
    } else {
        if ([self isKindOfClass:[UIButton class]]) {
            [(UIButton *)self setImage:[UIImage imageNamed:@"icon_user_red_116"] forState:UIControlStateNormal];
        } else if ([self isKindOfClass:[UIImageView class]]) {
            [(UIImageView *)self setImage:[UIImage imageNamed:@"icon_user_red_116"]];
        }
    }
}

- (void)setSelfHeaderImageUrlString:(NSString *)headerUrlString {
    MGUserInfoItemModel *user = [MGAccountManager sharedInstance].loginUser;
    if (user.tmpHeaderImage) {
        if ([self isKindOfClass:[UIButton class]]) {
            [(UIButton *)self setImage:user.tmpHeaderImage forState:UIControlStateNormal];
        } else if ([self isKindOfClass:[UIImageView class]]) {
            [(UIImageView *)self setImage:user.tmpHeaderImage];
        }
    } else {
        [self setHeaderImageUrlString:user.smallIcon];
    }
}

@end
