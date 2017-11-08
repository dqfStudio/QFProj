//
//  MGUIToolKits.h
//  MGMobileMusic
//
//  Created by MikeWang on 16/9/19.
//  Copyright © 2016年 migu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGWaitingView.h"
//#import "MGCommonNoDataView.h"
#import "MGRequestResultView.h"
#import "MGRefreshHeader.h"
#import "MGRefreshFooter.h"
#import <MJRefresh.h>

#define KDefaultPageSize 20
#define KMaxPageSize 100

@interface MGUIToolKits : NSObject

//+(void)showRoundCornerMessageOnTopView:(NSString*)content withDelay:(CGFloat)delay;
//
//+ (void)showWaitingHUDInView:(UIView *)view;
//
//+(void)hideWaitingHUDInView:(UIView*)view;
//
////展示消失消息
//+ (void)showMessageInView:(UIView *)view WithString:(NSString *)content;
//
//// 可以更改显示时长
//+ (void)showMessageInView:(UIView *)view WithString:(NSString *)content withDelay:(CGFloat)delay;
//
//
//+ (void)showMessageInView:(UIView *)view WithTitle:(NSString*)title WithString:(NSString *)content withDelay:(CGFloat)delay;
//
//+ (UIImage*) imageWithColor:(UIColor*)color andHeight:(CGFloat)height;
//
//+ (void)showAppLaunchImage;



@end

@interface UIScrollView (MGRefreshView)

- (void)addRefreshHeaderWithBlock:(void (^)(void))block;
- (void)addRefreshHeaderWithTarget:(id)target action:(SEL)action;

- (void)addRefreshFooterWithBlock:(void (^)(void))block;
- (void)addRefreshFooterWithTarget:(id)target action:(SEL)action;

@end

@interface UIView (MGToast)

// 在最上层的UIWindow上显示一个简短的提示，不会被键盘遮挡
+ (void)showToast:(NSString *)text;
+ (void)showToast:(NSString *)text
   hideAfterDelay:(NSTimeInterval)delay;

// 在最底层UIWindow上显示一个简短的提示，有键盘存在时，可能会被遮挡
+ (void)showToastInAppWindow:(NSString *)text;

+ (void)showToast:(NSString *)text
           inView:(UIView *)view
   hideAfterDelay:(NSTimeInterval)delay;

@end

@interface UIView (MGWaitingAndResultView)


@property (nonatomic, strong) MGWaitingView *watingView;
@property (nonatomic, strong) MGRequestResultView *requestResultView;

/**
 * 等待框和错误提示与父View顶部的距离
 */
@property (nonatomic, assign) CGFloat waitingAndResultViewMarginTop;

/** 默认内容居中，这个值是位于中的偏移。 */
@property (nonatomic, assign) CGFloat contentCenterYOffset;

// 等待框，MGWaitingViewStyleWhite
- (void)showWhiteWaitingView;
- (void)showWhiteWaitingViewNaviBarMarginTop;
- (void)showWhiteWaitingViewMarginTop:(NSInteger)marginTop;
- (void)showWhiteWaitingViewContentYOffset:(CGFloat)yOffset;
- (void)showWhiteWaitingViewMarginTop:(CGFloat)marginTop contentYOffset:(CGFloat)yOffset;

// 等待框，MGWaitingViewStyleGray
- (void)showGrayWatingViewWithText:(NSString *)text;

- (void)showWaitingViewWithText:(NSString *)text
                          style:(MGWaitingViewStyle)style
                      marginTop:(CGFloat)marginTop;

- (void)showWaitingViewWithText:(NSString *)text
                          style:(MGWaitingViewStyle)style
                      marginTop:(CGFloat)marginTop
           contentCenterYOffset:(CGFloat)yOffset;

- (void)showRequestResultViewWithType:(MGRequestResultViewType)type
                                 desc:(NSString *)desc
                           reloadText:(NSString *)reloadText
                            marginTop:(CGFloat)marginTop
                         clickedBlock:(void (^)(void))clickedBlock;

- (void)showRequestResultViewWithType:(MGRequestResultViewType)type
                                 desc:(NSString *)desc
                           reloadText:(NSString *)reloadText
                            marginTop:(CGFloat)marginTop
                       contentYOffset:(CGFloat)yOffset
                         clickedBlock:(void (^)(void))clickedBlock;
/**
 *  @param text     文字，此字段为预留字段，默认传nil
 *  @param style    样式，默认为MGWaitingViewStyleWhite
 */
- (void)showWaitingViewWithText:(NSString *)text
                          style:(MGWaitingViewStyle)style  __deprecated;

// 移除等待框
- (void)removeWaitingView;


// 结果适配
/** 请求成功，返回数据为0时，调用此方法
 *  @param desc     文字，此字段为预留字段，默认传nil
 */
- (void)showRequestResultNoDataViewWithDesc:(NSString *)desc;



// 请求失败时调用此方法
- (void)showRequestResultErrorViewWithClickedBlock:(void (^)(void))clickedBlock;

- (void)showRequestResultErrorViewContentYOffset:(CGFloat)yOffset
                                withClickedBlock:(void (^)(void))clickedBlock;

- (void)showRequestResultErrorViewContentMarginTop:(CGFloat)marginTop
                                  withClickedBlock:(void (^)(void))clickedBlock;
/**
 *  显示请求无数据、请求失败、重新请求3种情况
 *
 *  @param type             类型
 *  @param marginTop        与superview顶部的距离
 *  @param clickedBlock     点击回调
 */
- (void)showRequestResultViewWithType:(MGRequestResultViewType)type
                            marginTop:(CGFloat)marginTop
                         clickedBlock:(void (^)(void))clickedBlock;

- (void)showRequestResultViewWithType:(MGRequestResultViewType)type
                            marginTop:(CGFloat)marginTop
                       contentYOffset:(CGFloat)yOffset
                         clickedBlock:(void (^)(void))clickedBlock;

//- (void)showRequestResultViewWithType:(MGRequestResultViewType)type
//                                desc:(NSString *)desc
//                            marginTop:(CGFloat)marginTop
//                         clickedBlock:(void (^)(void))clickedBlock;

// 移除结果展示View
- (void)removeRequestResultView;


@property (nonatomic, assign) NSUInteger pageNo;
@property (nonatomic, assign) NSUInteger pageSize;

#pragma mark - 网络请求成功时，根据请求返回的结果来更新界面展示
/**
 * 无分页
 */
- (void)dealSuccessWithDataSourceCount:(NSInteger)dataSourceCount;

/**
 * 有分页且无下拉刷新
 * @param dataSourceCount       tableViewDataSource的的数量
 * @param hasMoreData           是否还有数据
 * @param refreshFooterBlock    上拉刷新触发的block
 */
- (void)dealSuccessWithDataSourceCount:(NSInteger)dataSourceCount
                           hasMoreData:(BOOL)hasMoreData
                    refreshFooterBlock:(void (^)(void))refreshFooterBlock;

/**
 * 有分页且有下拉刷新
 * @param dataSourceCount       tableViewDataSource的的数量
 * @param hasMoreData           是否还有数据
 * @param refreshHeaderBlock    下拉刷新触发的block
 * @param refreshFooterBlock    上拉刷新触发的block
 */
- (void)dealSuccessWithDataSourceCount:(NSInteger)dataSourceCount
                           hasMoreData:(BOOL)hasMoreData
                    refreshHeaderBlock:(void (^)(void))refreshHeaderBlock
                    refreshFooterBlock:(void (^)(void))refreshFooterBlock;

#pragma mark - 网络请求失败时，根据请求返回的结果来更新界面展示

/**
 * 无分页失败时
 */
- (void)dealFailureWithReloadBlock:(void (^)(void))reloadBlock;

/**
 * 有分页失败时
 * @param error                 网络请求传回的error对象
 * @param dataSourceCount       tableViewDataSource的的数量
 * @param reloadBlock           点击重新加载触发的block
 */
- (void)dealFailureWithError:(NSError *)error
             dataSourceCount:(NSInteger)dataSourceCount
                 reloadBlock:(void (^)(void))reloadBlock;



// 以下方法废弃

//- (void)showWaitingView;
//- (void)showWaitingViewWithMarginTop:(NSInteger)marginTop;

//- (void)showGrayWatingViewWithText:(NSString *)text
//                          style:(MGWaitingViewStyle)style
//                      marginTop:(CGFloat)marginTop;
//
//
//- (void)showRequestResultViewWhenNoData:(NSString *)title
//                              marginTop:(CGFloat)marginTop;
//- (void)showRequestResultViewWhenError:(CGFloat)marginTop
//                          clickedBlock:(void (^)(void))clickedBlock;


//- (void)showRequestResultViewWithType:(MGRequestResultViewType)type
//                            marginTop:(CGFloat)marginTop
//                         clickedBlock:(void (^)(void))clickedBlock;


@end

@interface UITableView (MGPage)




//@property (nonatomic, assign) CGFloat requestReslutViewMarginTop;
//@property (nonatomic, copy) void (^errorReloadBlock)();

//// 这三个方法将废弃
//- (void)updateViewWithNumberOfRows:(NSInteger)numberOfRows;
//- (void)updateViewWithNumberOfRows:(NSInteger)numberOfRows noDataViewTitle:(NSString *)noDataViewTitle;
//- (void)showErrorViewWithText:(NSString *)text;

@end

@interface UIView (MGHeaderImage)

- (void)setHeaderImageUrlString:(NSString *)headerUrlString;
- (void)setSelfHeaderImageUrlString:(NSString *)headerUrlString;

@end


