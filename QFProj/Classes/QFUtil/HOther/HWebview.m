//
//  HWebview.m
//  QFProj
//
//  Created by dqf on 2019/7/21.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HWebview.h"

@interface HWebview ()
@property (nonatomic) CGRect oldFrame;
@property (nonatomic) UIProgressView *progress;
@end

@implementation HWebview
- (WKWebViewJavascriptBridge *)bridge {
    if (!_bridge) {
        _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self];
    }
    return _bridge;
}
- (UIProgressView *)progress {
    if (!_progress) {
        CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 2);
        _progress = [[UIProgressView alloc] initWithFrame:frame];
        _progress.backgroundColor = [UIColor whiteColor];
        _progress.progressTintColor = [UIColor blueColor];
        _progress.trackTintColor = [UIColor whiteColor];
    }
    return _progress;
}
- (void)setAutorotate:(BOOL)autorotate {
    if (_autorotate != autorotate) {
        _autorotate = autorotate;
        if (_autorotate) {
            if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
                [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
            }
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(NSDeviceOrientationChangedEvent:)
                                                         name:UIDeviceOrientationDidChangeNotification
                                                       object:nil];
        }else {
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:UIDeviceOrientationDidChangeNotification
                                                          object:nil];
        }
    }
}
- (void)setDisplayProgress:(BOOL)displayProgress {
    if (_displayProgress != displayProgress) {
        _displayProgress = displayProgress;
        if (_displayProgress) {
            [self addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
            if (![self.subviews containsObject:self.progress]) {
                [self addSubview:self.progress];
            }
        }else {
            [self removeObserver:self forKeyPath:@"estimatedProgress"];
            if ([self.subviews containsObject:self.progress]) {
                [self.progress removeFromSuperview];
            }
        }
    }
}
- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
    self = [super initWithFrame:frame configuration:configuration];
    if (self) {
        _oldFrame = frame;
    }
    return self;
}
- (nullable WKNavigation *)loadURL:(NSURL *)url {
    return [self loadRequest:[NSMutableURLRequest requestWithURL:url]];
}
- (nullable WKNavigation *)loadURLString:(NSString *)urlString {
    return [self loadRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}
- (nullable WKNavigation *)loadHTMLFile:(NSString *)fileName {
    NSString *basePath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseUrl = [NSURL fileURLWithPath:basePath isDirectory:YES];
    NSString *indexPath = [NSString stringWithFormat:@"%@/%@", basePath, fileName];
    NSString *indexContent = [NSString stringWithContentsOfFile:indexPath encoding:NSUTF8StringEncoding error:nil];
    return [self loadHTMLString:indexContent baseURL:baseUrl];
}
#pragma mark - notification method
- (void)NSDeviceOrientationChangedEvent:(NSNotification *)notification {
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    switch (deviceOrientation) {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight: {
            [UIApplication sharedApplication].statusBarHidden = YES;
            [UIView animateWithDuration:0.25 animations:^{
                [self setFrame:self->_oldFrame];
            }];
        }
            break;
        case UIDeviceOrientationPortrait: {
            [UIApplication sharedApplication].statusBarHidden = NO;
            [UIView animateWithDuration:0.25 animations:^{
                CGRect frame = [UIScreen mainScreen].bounds;
                frame.origin.y += self->_rotateEdgeInsets.top;
                frame.origin.x += self->_rotateEdgeInsets.left;
                frame.size.height -= self->_rotateEdgeInsets.top+self->_rotateEdgeInsets.bottom;
                frame.size.width -= self->_rotateEdgeInsets.left+self->_rotateEdgeInsets.right;
                [self setFrame:frame];
            }];
        }
            break;
        default:
            break;
    }
}
#pragma mark - KVO的监听代理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //加载进度值
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == self) {
            [self.progress setAlpha:1.0f];
            [self.progress setProgress:self.estimatedProgress animated:YES];
            if (self.estimatedProgress >= 1.0f) {
                [UIView animateWithDuration:0.5f
                                      delay:0.3f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     [self.progress setAlpha:0.0f];
                                 }
                                 completion:^(BOOL finished) {
                                     [self.progress setProgress:0.0f animated:NO];
                                 }];
            }
        }else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
@end
