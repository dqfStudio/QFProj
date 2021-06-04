////
////  LoadingLiveView.m
////  UserClient
////
////  Created by wzz on 2019/1/14.
////  Copyright © 2019 wzz. All rights reserved.
////
//
//#import "LoadingLiveView.h"
//
//@interface LoadingLiveView()
//
//@property (nonatomic, strong) UIImageView *loadingImgView;
//
//@end
//
//@implementation LoadingLiveView
//
//- (void)dealloc {
//    NSLog(@"...dealloc...%@", NSStringFromClass(self.class));
//}
//
//+ (void)showLoadingInteractionInSuperView:(UIView *)superView text:(NSString *)text {
//    if ([superView viewWithTag:30000]) {
//        return;
//    }
//    
//    LoadingLiveView *loadingView = [[LoadingLiveView alloc] initWithFrame:CGRectMake(0, 0, 96, 90)];
//    loadingView.tag = 30000;
//    [superView addSubview:loadingView];
//    loadingView.center = superView.center;
//
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 96, 90)];
//    loadingView.loadingImgView = imageView;
//    imageView.image = [UIImage imageNamed:@"liveLoadingCircle"];
//    [loadingView addSubview:imageView];
//
//    UILabel *tipLabel = [UILabel labelFrame:CGRectZero text:text bgColor:nil textColor:CFHexColor(@"#FFCC00") font:CFFont(14)];
//    [loadingView addSubview:tipLabel];
//    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(loadingView);
//        make.top.equalTo(imageView.mas_bottom).offset(24);
//    }];
//
//    //动画
//    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    basicAnimation.toValue = @(M_PI*2);
//    basicAnimation.duration = 3.0;
//    basicAnimation.repeatCount = INFINITY;
//    basicAnimation.removedOnCompletion = NO;
//    [imageView.layer addAnimation:basicAnimation forKey:@"rotationAnimation"];
//}
//
//+ (void)showLoadingInSuperView:(UIView *)superView {
//    LoadingLiveView *loadingView = [[LoadingLiveView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    loadingView.backgroundColor = CFHexColorAlpha(@"#000000", 0.74);
//    loadingView.tag = 30000;
//    if (superView) {
//        [superView addSubview:loadingView];
//    }else {
//        [APPDELEGATE.window addSubview:loadingView];
//    }
//
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((loadingView.viewWidth-96)/2, (loadingView.viewHeight-90)/2-45, 96, 90)];
//    loadingView.loadingImgView = imageView;
//    imageView.image = [UIImage imageNamed:@"liveLoadingCircle"];
//    [loadingView addSubview:imageView];
//
//    UILabel *tipLabel = [UILabel labelFrame:CGRectZero text:Local_String(@"common.loading") bgColor:nil textColor:CFHexColor(@"#FFCC00") font:CFFont(14)];
//    [loadingView addSubview:tipLabel];
//    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(loadingView);
//        make.top.equalTo(imageView.mas_bottom).offset(24);
//    }];
//
//    //动画
//    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    basicAnimation.toValue = @(M_PI*2);
//    basicAnimation.duration = 3.0;
//    basicAnimation.repeatCount = INFINITY;
//    basicAnimation.removedOnCompletion = NO;
//    [imageView.layer addAnimation:basicAnimation forKey:@"rotationAnimation"];
//}
//
//+ (void)hideLoadingViewInSuperView:(UIView *)superView {
//    UIView *selfView = nil;
//    if (superView) {
//        selfView = [superView viewWithTag:30000];
//    } else {
//        selfView = [APPDELEGATE.window viewWithTag:30000];
//    }
//    if (!selfView) {
//        return;
//    }
//    if (selfView && [selfView isKindOfClass:[LoadingLiveView class]]) {
//        selfView.alpha = 1;
//        [UIView animateWithDuration:0.25 animations:^{
//            selfView.alpha = 0.1;
//        } completion:^(BOOL finished) {
//            [selfView removeFromSuperview];
//            [((LoadingLiveView*)selfView).loadingImgView.layer removeAllAnimations];
//        }];
//    }
//}
//
////影响不影响弹框下面的页面交互
//+ (void)showLoadingInteractionInSuperView:(UIView *)superView canTouch:(BOOL)canTouch{
//
//    LoadingLiveView *loadingView = [superView viewWithTag:30000];
//    if (loadingView) {
//        return;
//    }
//    loadingView = [[LoadingLiveView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    loadingView.backgroundColor = [UIColor clearColor];//CFHexColorAlpha(@"#000000", 0.74);
//    loadingView.tag = 30000;
//    loadingView.userInteractionEnabled = !canTouch;
//    [superView addSubview:loadingView];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((loadingView.viewWidth-96)/2, (loadingView.viewHeight-90)/2-45, 96, 90)];
//    loadingView.loadingImgView = imageView;
//    imageView.image = [UIImage imageNamed:@"liveLoadingCircle"];
//    [loadingView addSubview:imageView];
//
////    UILabel *tipLabel = [UILabel labelFrame:CGRectZero text:Local_String(@"loading") bgColor:nil textColor:CFHexColor(@"#FFCC00") font:CFFont(14)];
////    [loadingView addSubview:tipLabel];
////    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.centerX.equalTo(loadingView);
////        make.top.equalTo(imageView.mas_bottom).offset(24);
////    }];
//    //动画
//    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    basicAnimation.toValue = @(M_PI*2);
//    basicAnimation.duration = 3.0;
//    basicAnimation.repeatCount = INFINITY;
//    basicAnimation.removedOnCompletion = NO;
//    [imageView.layer addAnimation:basicAnimation forKey:@"rotationAnimation"];
//}
//
//@end
