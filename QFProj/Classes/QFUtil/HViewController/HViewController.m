//
//  HViewController.m
//  TestProject
//
//  Created by dqf on 2018/4/27.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HViewController.h"

#define HNavTitleButtonWidth 70.0f
#define HNavTitleButtonMargin 10.0f

@implementation HVCAppearance

- (instancetype)init {
    self = [super init];
    if (self) {
        _barColor = [UIColor whiteColor];
        _bgColor = [UIColor whiteColor];
        _textColor = [UIColor blackColor];
        _lightTextColor = [UIColor lightGrayColor];
    }
    return self;
}
+ (instancetype)shared {
    static dispatch_once_t pred;
    static HVCAppearance *o = nil;
    dispatch_once(&pred, ^{
        o = [[self alloc] init];
    });
    return o;
}

@end


@interface HViewController ()

@property (nonatomic) NSMutableArray *controllableRequests;

//topBar的顶部内边距,如果有statusBar没有系统导航栏的情况下为statusbar的高度(20)
@property (nonatomic) CGFloat statusBarPadding;

@end

@implementation HViewController

//一般情况下调用 init 方法或者调用 initWithNibName 方法实例化 UIViewController, 不管调用哪个方法都为调用 initWithNibName
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self pvc_initialize];
    }
    return self;
}

//使用storeBoard初始化的
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self pvc_initialize];
    }
    return self;
}

- (void)pvc_initialize {
    _statusBarPadding = 0;
    
    //只有statusBar没有系统导航栏的情况下,statusBar背景色是透明的需要自定义的导航栏多增加一点高度来伪造statusBar的背景
    if (![self prefersStatusBarHidden] && ![self prefersNavigationBarHidden]) {
        _statusBarPadding = UIDevice.statusBarHeight;
    }
}
+ (HVCAppearance *)appearance {
    return [HVCAppearance shared];
}
//loadView 从nib载入视图 ，通常这一步不需要去干涉。除非你没有使用xib文件创建视图,即用代码创建的UI
- (void)loadView {
    [super loadView];
    [self pvc_initView];
}

- (void)pvc_initView {
    [self setNeedsNavigationBarAppearanceUpdate];
    [self.leftNaviButton setImageUrlString:@"hvc_back_icon"];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_controllableRequests) {
        [_controllableRequests enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            //[(HNetworkDAO*)obj cancel];
        }];
    }
    _controllableRequests = nil;
#if DEBUG
//    NSString *message = [NSStringFromClass(self.class) stringByAppendingString:@"--释放内存"];
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了"
//                                                           style:UIAlertActionStyleCancel
//                                                         handler:^(UIAlertAction * _Nonnull action) {}];
//    [alertController addAction:cancelAction];
//    UIViewController *rootController = [UIApplication sharedApplication].delegate.window.rootViewController;
//    [rootController presentViewController:alertController animated:YES completion:nil];
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.title.length > 0) {
        self.titleLabel.text = self.title;
    }
    self.view.backgroundColor = [HViewController appearance].bgColor;
    [self.view addSubview:self.topBar];
    self.view.exclusiveTouch = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self becomeFirstResponder];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.view bringSubviewToFront:self.topBar];
    //要更新statusbar状态的需要调用下这个方法,最好与viewWillDisappear对应
    [self setNeedsStatusBarAppearanceUpdate];
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        if ([self.view isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView *)self.view setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
        for (UIView *view in self.view.subviews) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                [(UIScrollView *)view setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
            }
        }
    }else{
        SuppressWdeprecatedDeclarationsWarning(
            self.automaticallyAdjustsScrollViewInsets = NO;
        );
    }
#else
    self.automaticallyAdjustsScrollViewInsets = NO;
#endif
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    [self disappearTypeJudge];
}

- (void)disappearTypeJudge {
    NSArray *viewControllers = self.navigationController.viewControllers;
    NSUInteger disappearType = -1;
    if (!viewControllers || (viewControllers.count == 1 && viewControllers.lastObject == self)) {
        // View is disappearing because it will dismissed
        disappearType = HVCDisappearTypeDismiss;
    }else if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        // View is disappearing because a new view controller was pushed onto the stack
        disappearType = HVCDisappearTypePush;
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        // View is disappearing because it was popped from the stack
        disappearType = HVCDisappearTypePop;
    }
    if (disappearType != -1) {
        [self vcWillDisappear:disappearType];
        if (disappearType == HVCDisappearTypePop || disappearType == HVCDisappearTypeDismiss) {
            [self willDealloc];
        }
    }
}

//即将调用dealloc
- (void)willDealloc {
#if DEBUG
    __weak typeof(self) weakSelf = self;
    //延时3s，留足释放内存时间
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(self) strongSelf = weakSelf;
        //这个的原理就是通过给nil发送方法，如何不为空就执行，为nil不执行
        [strongSelf isNotDealloc];
    });
#endif
}

//打印没有释放的vc
- (void)isNotDealloc {
    NSLog(@"🍎🍎🍎🍎🍎🍎🍎%@ is not dealloc🍎🍎🍎🍎🍎🍎🍎", NSStringFromClass([self class]));
}

#pragma mark - 事件处理
- (void)back {
//    if (self.presentedViewController || self.presentingViewController) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    if (self.navigationController.topViewController != self) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)leftNaviButtonPressed {
    [self back];
}

- (void)rightNaviButtonPressed {
    
}

- (void)vcWillDisappear:(HVCDisappearType)type {
    
}

#pragma mark - 各个视图
- (UIView *)topBar {
    if (!_topBar) {
        _topBar = [[UIView alloc] init];
        //没有系统导航栏的时候,status背景色是透明的,用自定义导航栏去伪造一个status背景区域
        if([self prefersNavigationBarHidden]) {
            _topBar.frame = CGRectMake(0, _statusBarPadding, self.view.h_width, UIDevice.naviBarHeight);
        }else {
            _topBar.frame = CGRectMake(0, 0, self.view.h_width, UIDevice.naviBarHeight + _statusBarPadding);
            _topBar.bounds = CGRectMake(0, -_statusBarPadding, self.view.h_width, UIDevice.naviBarHeight + _statusBarPadding);
        }
        _topBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _topBarLine = [[UIView alloc] init];
        _topBarLine.frame = CGRectMake(0, UIDevice.naviBarHeight - 1, _topBar.h_width, 1);
        [_topBar addSubview:_topBarLine];
        _topBarLine.hidden = YES;
    }
    return _topBar;
}
- (CGFloat)topBarHeight {
    return ([self prefersStatusBarHidden]?0:UIDevice.statusBarHeight) + ([self prefersNavigationBarHidden]?0:UIDevice.naviBarHeight);
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(54, 0, self.view.h_width - 54 * 2, UIDevice.naviBarHeight);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        [self.topBar addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (HWebButtonView *)leftNaviButton {
    if (!_leftNaviButton) {
        _leftNaviButton = [[HWebButtonView alloc] init];
        _leftNaviButton.backgroundColor = nil;
        _leftNaviButton.frame = CGRectMake(0, 0, UIDevice.naviBarHeight, UIDevice.naviBarHeight);
        [_leftNaviButton.button.titleLabel setFont:[UIFont systemFontOfSize:16]];
        _leftNaviButton.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        @weakify(self)
        [_leftNaviButton setPressed:^(id sender, id data) {
            @strongify(self)
            [self leftNaviButtonPressed];
        }];
        _leftNaviButton.imageView.contentMode = UIViewContentModeCenter;
        [self.topBar addSubview:_leftNaviButton];
    }
    return _leftNaviButton;
}

- (HWebButtonView *)rightNaviButton {
    if (!_rightNaviButton) {
        _rightNaviButton = [[HWebButtonView alloc] init];
        _rightNaviButton.backgroundColor = nil;
        [_rightNaviButton.button.titleLabel setFont:[UIFont systemFontOfSize:16]];
        _rightNaviButton.frame = CGRectMake(self.topBar.h_width - UIDevice.naviBarHeight, 0, UIDevice.naviBarHeight, UIDevice.naviBarHeight);
        _rightNaviButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        _rightNaviButton.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        @weakify(self)
        [_rightNaviButton setPressed:^(id sender, id data) {
            @strongify(self)
            [self rightNaviButtonPressed];
        }];
        [self.topBar addSubview:_rightNaviButton];
    }
    return _rightNaviButton;
}

#pragma mark - 设置视图

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    if (self.viewLoaded) {
        self.titleLabel.text = title;
    }
}


- (void)setLeftNaviImage:(UIImage *)image {
    [self.leftNaviButton.button setTitle:@"" forState:UIControlStateNormal];
    [self.leftNaviButton.button setTitle:@"" forState:UIControlStateHighlighted];
    [self.leftNaviButton.button setImage:image forState:UIControlStateNormal];
    [self.leftNaviButton.button setImage:image forState:UIControlStateHighlighted];
}
- (void)setLeftNaviImageURL:(NSString *)imageURL {
    [self.leftNaviButton.button setTitle:@"" forState:UIControlStateNormal];
    [self.leftNaviButton.button setTitle:@"" forState:UIControlStateHighlighted];
    [self.leftNaviButton.button setImage:nil forState:UIControlStateNormal];
    [self.leftNaviButton.button setImage:nil forState:UIControlStateHighlighted];
    [self.leftNaviButton setImageUrlString:imageURL];
}
- (void)setNaviLeftImage:(UIImage *)normal highlight:(UIImage *)highlight {
    [self.leftNaviButton.button setTitle:@"" forState:UIControlStateNormal];
    [self.leftNaviButton.button setTitle:@"" forState:UIControlStateHighlighted];
    [self.leftNaviButton.button setImage:normal forState:UIControlStateNormal];
    [self.leftNaviButton.button setImage:highlight forState:UIControlStateHighlighted];
}

- (void)setRightNaviImage:(UIImage *)image {
    [self.rightNaviButton.button setTitle:@"" forState:UIControlStateNormal];
    [self.rightNaviButton.button setTitle:@"" forState:UIControlStateHighlighted];
    [self.rightNaviButton.button setImage:image forState:UIControlStateNormal];
    [self.rightNaviButton.button setImage:image forState:UIControlStateHighlighted];
}
- (void)setRightNaviImageURL:(NSString *)imageURL {
    [self.rightNaviButton.button setTitle:@"" forState:UIControlStateNormal];
    [self.rightNaviButton.button setTitle:@"" forState:UIControlStateHighlighted];
    [self.rightNaviButton.button setImage:nil forState:UIControlStateNormal];
    [self.rightNaviButton.button setImage:nil forState:UIControlStateHighlighted];
    [self.rightNaviButton setImageUrlString:imageURL];
}
- (void)setNaviRightImage:(UIImage *)normal highlight:(UIImage *)highlight {
    [self.rightNaviButton.button setTitle:@"" forState:UIControlStateNormal];
    [self.rightNaviButton.button setTitle:@"" forState:UIControlStateHighlighted];
    [self.rightNaviButton.button setImage:normal forState:UIControlStateNormal];
    [self.rightNaviButton.button setImage:highlight forState:UIControlStateHighlighted];
}
- (void)setLeftNaviTitle:(NSString *)title {
    [self.leftNaviButton.button setImage:nil forState:UIControlStateNormal];
    [self.leftNaviButton.button setImage:nil forState:UIControlStateHighlighted];
    [self.leftNaviButton.button setTitle:title forState:UIControlStateNormal];
    [self.leftNaviButton.button setTitle:title forState:UIControlStateHighlighted];
}
- (void)setLeftNaviTitle:(NSString *)title titleColor:(UIColor *)color highlightColor:(UIColor *)highlightcolor {
    [self.leftNaviButton.button setImage:nil forState:UIControlStateNormal];
    [self.leftNaviButton.button setImage:nil forState:UIControlStateHighlighted];
    [self.leftNaviButton.button setTitle:title forState:UIControlStateNormal];
    [self.leftNaviButton.button setTitle:title forState:UIControlStateHighlighted];
    [self.leftNaviButton.button setTitleColor:color forState:UIControlStateNormal];
    [self.leftNaviButton.button setTitleColor:highlightcolor forState:UIControlStateHighlighted];
    self.leftNaviButton.button.titleLabel.font = [UIFont systemFontOfSize:15];
    self.leftNaviButton.frame = CGRectMake(HNavTitleButtonMargin, self.rightNaviButton.h_y, HNavTitleButtonWidth, self.rightNaviButton.h_height);
}
- (void)setRightNaviTitle:(NSString *)title {
    [self.rightNaviButton.button setImage:nil forState:UIControlStateNormal];
    [self.rightNaviButton.button setImage:nil forState:UIControlStateHighlighted];
    [self.rightNaviButton.button setTitle:title forState:UIControlStateNormal];
    [self.rightNaviButton.button setTitle:title forState:UIControlStateHighlighted];
}
- (void)setRightNaviTitle:(NSString *)title titleColor:(UIColor *)color highlightColor:(UIColor *)highlightcolor {
    [self.rightNaviButton.button setImage:nil forState:UIControlStateNormal];
    [self.rightNaviButton.button setImage:nil forState:UIControlStateHighlighted];
    [self.rightNaviButton.button setTitle:title forState:UIControlStateNormal];
    [self.rightNaviButton.button setTitle:title forState:UIControlStateHighlighted];
    [self.rightNaviButton.button setTitleColor:color forState:UIControlStateNormal];
    [self.rightNaviButton.button setTitleColor:highlightcolor forState:UIControlStateHighlighted];
    self.rightNaviButton.button.titleLabel.font = [UIFont systemFontOfSize:15];
    self.rightNaviButton.frame = CGRectMake(self.topBar.h_width - HNavTitleButtonWidth - HNavTitleButtonMargin, self.rightNaviButton.h_y, HNavTitleButtonWidth, self.rightNaviButton.h_height);
}

#pragma mark - 状态栏的隐藏控制
//iOS7必须覆盖该方法并返回YES才能控制状态栏隐藏
- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


#pragma mark - 导航栏状态控制

- (void)setNeedsNavigationBarAppearanceUpdate {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.topBar.hidden = [self prefersNavigationBarHidden];
    self.topBar.backgroundColor = [self preferredNaviBarColor];
    self.topBarLine.backgroundColor = [self preferredNaviShadowColor];
}

- (BOOL)prefersNavigationBarHidden {
    return NO;
}

- (UIColor *)preferredNaviBarColor {
    return [HViewController appearance].barColor;
}

- (UIColor *)preferredNaviShadowColor {
    return [UIColor colorWithHex:0xe5e5e5];;
}

#pragma mark - home indicator
- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

#pragma mark - 旋转支持
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
    //return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    if (UIDeviceOrientationIsLandscape(UIDevice.currentDevice.orientation)) {
//        switch (UIDevice.currentDevice.orientation) {
//            case UIDeviceOrientationLandscapeLeft:return UIInterfaceOrientationLandscapeLeft;
//            case UIDeviceOrientationLandscapeRight: return UIInterfaceOrientationLandscapeRight;
//            default:return UIInterfaceOrientationLandscapeRight;
//        }
//    }
//    return UIInterfaceOrientationLandscapeRight;
//}

#pragma mark - 请求控制
- (NSMutableArray *)controllableRequests {
    if (!_controllableRequests) {
        _controllableRequests = [NSMutableArray new];
    }
    return _controllableRequests;
}
//- (void)controlRequest:(HNetworkDAO *)request {
//    if ([request isKindOfClass:[HNetworkDAO class]]) {
//        [self.controllableRequests addObject:request];
//    }
//}

- (void)refresh {
    
}
//需要释放内存
- (void)needReleaseMemory {
    
}
- (BOOL)popGestureEnabled {
    return YES;
}

@end

@implementation UIViewController (HChildControllerNavigation)
- (void)transitionChildViewControllerWithIndex:(NSUInteger)index {
    NSUInteger count = self.childViewControllers.count;
    if (index >= 0 && index < count) {
        for (int i=0; i<count; i++) {
            UIViewController *vc = self.childViewControllers[i];
            if (vc.view.superview && index != i) {
                [vc.view removeFromSuperview];
            }
        }
        UIViewController *vc = self.childViewControllers[index];
        if (!vc.view.superview) {
            [self.view addSubview:vc.view];
        }
    }
}
- (void)pushChildViewController:(UIViewController *)viewController {
    if (self.childViewControllers.count == 0) {
        [self.view addSubview:viewController.view];
        [self addChildViewController:viewController];
    }else if (self.childViewControllers.count >= 1) {
        UIViewController *vc = [self.childViewControllers lastObject];
        [self addChildViewController:viewController];
        [self transitionFromViewController:vc toViewController:viewController duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:nil];
    }
}
- (void)popChildViewController {
    if (self.childViewControllers.count == 1) {
        UIViewController *vc = [self.childViewControllers lastObject];
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }else if (self.childViewControllers.count >= 2) {
        UIViewController *vc1 = [self.childViewControllers objectAtIndex:self.childViewControllers.count -1];
        UIViewController *vc2 = [self.childViewControllers objectAtIndex:self.childViewControllers.count -2];
        [self transitionFromViewController:vc1 toViewController:vc2 duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
            if (finished) {
                [vc1.view removeFromSuperview];
                [vc1 removeFromParentViewController];
            }
        }];
    }
}
@end

@implementation HViewController (HMessy)
- (UIWindow *)window {
    return UIApplication.sharedApplication.delegate.window;
}
- (UIScreen *)screen {
    return UIScreen.mainScreen;
}
- (CGFloat)width {
    return CGRectGetWidth(self.view.frame);
}
- (CGFloat)height {
    return CGRectGetHeight(self.view.frame);
}
- (CGSize)size {
    return self.view.frame.size;
}
- (CGRect)frame {
    return self.view.frame;
}
- (CGRect)bounds {
    return self.view.bounds;
}
- (NSMutableArray *)sourceArr {
    NSMutableArray *array = objc_getAssociatedObject(self, _cmd);
    if (!array) {
        self.sourceArr = NSMutableArray.array;
    }
    return array;
}
- (void)setSourceArr:(NSMutableArray *)sourceArr {
    objc_setAssociatedObject(self, @selector(sourceArr), sourceArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableDictionary *)sourceDict {
    NSMutableDictionary *dictionary = objc_getAssociatedObject(self, _cmd);
    if (!dictionary) {
        self.sourceDict = NSMutableDictionary.dictionary;
    }
    return dictionary;
}
- (void)setSourceDict:(NSMutableDictionary *)sourceDict {
    objc_setAssociatedObject(self, @selector(sourceDict), sourceDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
