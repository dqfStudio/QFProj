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

@implementation UIView (HUserInterfaceStyle)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] methodSwizzleWithOrigSEL:@selector(willMoveToSuperview:) overrideSEL:@selector(pvc_willMoveToSuperview:)];
    });
}
- (void)pvc_willMoveToSuperview:(nullable UIView *)newSuperview {
    //关闭暗黑模式
#ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
#endif
    [self pvc_willMoveToSuperview:newSuperview];
}
@end

@interface HViewController ()

@property (nonatomic) NSMutableArray *controllableRequests;

//topBar的顶部内边距,如果有statusBar没有系统导航栏的情况下为statusbar的高度(20)
@property (nonatomic) CGFloat statusBarPadding;
//记录屏幕方向
@property (nonatomic) UIDeviceOrientation orientation;

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
    //modalPresentationStyle 设置默认样式为 UIModalPresentationFullScreen
    self.modalPresentationStyle = UIModalPresentationFullScreen;
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
    [self setLeftNaviImage:[UIImage imageNamed:@"hvc_back_icon"]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_controllableRequests) {
        [_controllableRequests enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            //[(HNetworkDAO *)obj cancel];
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
    //记录屏幕方向
    self.orientation = [UIDevice currentDevice].orientation;
    //关闭暗黑模式
#ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self becomeFirstResponder];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.view bringSubviewToFront:self.topBar];
    //要更新statusbar状态的需要调用下这个方法,最好与viewWillDisappear对应
    [self setNeedsStatusBarAppearanceUpdate];
    //根据导航栏的颜色动态设置状态栏样式
    if (self.preferredStatusBarColor) {
        [UIApplication setStatusBarStyleWithColor:self.preferredStatusBarColor];
    }else if (self.autoAdjustStatusBarStyle && !self.topBar.hidden) {
        [UIApplication setStatusBarStyleWithColor:self.topBar.backgroundColor];
    }
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
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    //重新设置topbar的frame
    if (self.orientation != [UIDevice currentDevice].orientation) {
        self.orientation = [UIDevice currentDevice].orientation;
        [self resetTopbarFrame];
    }
}

- (void)vcWillDisappear:(HVCDisappearType)type {
    if (type == HVCDisappearTypePop || type == HVCDisappearTypeDismiss) {
        //tupleView default tag 1213141516171819
        UIView *tupleView = [self.view viewWithTag:1213141516171819];
        if ([tupleView isKindOfClass:NSClassFromString(@"HTupleView")]) {
            SEL selector = NSSelectorFromString(@"releaseTupleBlock");
            if ([tupleView respondsToSelector:selector]) {
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [tupleView performSelector:selector];
                #pragma clang diagnostic pop
            }
        }
        //tableView default tag 1918171615141312
        UIView *tableView = [self.view viewWithTag:1918171615141312];
        if ([tableView isKindOfClass:NSClassFromString(@"HTableView")]) {
            SEL selector = NSSelectorFromString(@"releaseTableBlock");
            if ([tableView respondsToSelector:selector]) {
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [tableView performSelector:selector];
                #pragma clang diagnostic pop
            }
        }
    }
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

#pragma mark - 各个视图
- (UIView *)topBar {
    if (!_topBar) {
        _topBar = [[UIView alloc] init];
        //_topBar = [[UIButton alloc] init];
        //[_topBar setAdjustsImageWhenHighlighted:NO];
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
        _topBarLine.hidden = [self prefersTopBarLineHidden];
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
        _leftNaviButton.frame = CGRectMake(10, 0, UIDevice.naviBarHeight, UIDevice.naviBarHeight);
        [_leftNaviButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        _leftNaviButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        @weakify(self)
        [_leftNaviButton setPressed:^(id sender, id data) {
            @strongify(self)
            [self leftNaviButtonPressed];
        }];
        _leftNaviButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.topBar addSubview:_leftNaviButton];
    }
    return _leftNaviButton;
}

- (HWebButtonView *)rightNaviButton {
    if (!_rightNaviButton) {
        _rightNaviButton = [[HWebButtonView alloc] init];
        _rightNaviButton.backgroundColor = nil;
        [_rightNaviButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        _rightNaviButton.frame = CGRectMake(self.topBar.h_width - UIDevice.naviBarHeight - 10, 0, UIDevice.naviBarHeight, UIDevice.naviBarHeight);
        _rightNaviButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        _rightNaviButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        @weakify(self)
        [_rightNaviButton setPressed:^(id sender, id data) {
            @strongify(self)
            [self rightNaviButtonPressed];
        }];
        [self.topBar addSubview:_rightNaviButton];
    }
    return _rightNaviButton;
}

//重新设置topbar的frame
- (void)resetTopbarFrame {
    _statusBarPadding = 0.f;
    if (![self prefersStatusBarHidden] && ![self prefersNavigationBarHidden]) {
        _statusBarPadding = UIDevice.statusBarHeight;
    }
    //reset topBar
    if([self prefersNavigationBarHidden]) {
        _topBar.frame = CGRectMake(0, _statusBarPadding, self.view.h_width, UIDevice.naviBarHeight);
    }else {
        _topBar.frame = CGRectMake(0, 0, self.view.h_width, UIDevice.naviBarHeight + _statusBarPadding);
        _topBar.bounds = CGRectMake(0, -_statusBarPadding, self.view.h_width, UIDevice.naviBarHeight + _statusBarPadding);
    }
    //reset topBar line
    _topBarLine.frame = CGRectMake(0, UIDevice.naviBarHeight - 1, _topBar.h_width, 1);
    //reset right button
    _rightNaviButton.frame = CGRectMake(_topBar.h_width - _rightNaviButton.h_width - 10, _rightNaviButton.h_y, _rightNaviButton.h_width, _rightNaviButton.h_height);
    //reset title label
    if (_rightNaviButton) {
        _titleLabel.frame = CGRectMake(_leftNaviButton.h_maxX, 0, _rightNaviButton.h_minX - _leftNaviButton.h_maxX, UIDevice.naviBarHeight);
    }else {
        _titleLabel.frame = CGRectMake(_leftNaviButton.h_maxX, 0, self.view.h_width - _leftNaviButton.h_maxX - 10, UIDevice.naviBarHeight);
    }
}

#pragma mark - 设置视图

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    if (self.viewLoaded) {
        self.titleLabel.text = title;
    }
}


- (void)setLeftNaviImage:(UIImage *)image {
    [self.leftNaviButton setTitle:@"" forState:UIControlStateNormal];
    [self.leftNaviButton setTitle:@"" forState:UIControlStateHighlighted];
    [self.leftNaviButton setImage:image forState:UIControlStateNormal];
    [self.leftNaviButton setImage:image forState:UIControlStateHighlighted];
}
- (void)setLeftNaviImageURL:(NSString *)imageURL {
    [self.leftNaviButton setTitle:@"" forState:UIControlStateNormal];
    [self.leftNaviButton setTitle:@"" forState:UIControlStateHighlighted];
    [self.leftNaviButton setImage:nil forState:UIControlStateNormal];
    [self.leftNaviButton setImage:nil forState:UIControlStateHighlighted];
    [self.leftNaviButton setImageUrlString:imageURL];
}
- (void)setNaviLeftImage:(UIImage *)normal highlight:(UIImage *)highlight {
    [self.leftNaviButton setTitle:@"" forState:UIControlStateNormal];
    [self.leftNaviButton setTitle:@"" forState:UIControlStateHighlighted];
    [self.leftNaviButton setImage:normal forState:UIControlStateNormal];
    [self.leftNaviButton setImage:highlight forState:UIControlStateHighlighted];
}

- (void)setRightNaviImage:(UIImage *)image {
    [self.rightNaviButton setTitle:@"" forState:UIControlStateNormal];
    [self.rightNaviButton setTitle:@"" forState:UIControlStateHighlighted];
    [self.rightNaviButton setImage:image forState:UIControlStateNormal];
    [self.rightNaviButton setImage:image forState:UIControlStateHighlighted];
}
- (void)setRightNaviImageURL:(NSString *)imageURL {
    [self.rightNaviButton setTitle:@"" forState:UIControlStateNormal];
    [self.rightNaviButton setTitle:@"" forState:UIControlStateHighlighted];
    [self.rightNaviButton setImage:nil forState:UIControlStateNormal];
    [self.rightNaviButton setImage:nil forState:UIControlStateHighlighted];
    [self.rightNaviButton setImageUrlString:imageURL];
}
- (void)setNaviRightImage:(UIImage *)normal highlight:(UIImage *)highlight {
    [self.rightNaviButton setTitle:@"" forState:UIControlStateNormal];
    [self.rightNaviButton setTitle:@"" forState:UIControlStateHighlighted];
    [self.rightNaviButton setImage:normal forState:UIControlStateNormal];
    [self.rightNaviButton setImage:highlight forState:UIControlStateHighlighted];
}
- (void)setLeftNaviTitle:(NSString *)title {
    [self.leftNaviButton setImage:nil forState:UIControlStateNormal];
    [self.leftNaviButton setImage:nil forState:UIControlStateHighlighted];
    [self.leftNaviButton setTitle:title forState:UIControlStateNormal];
    [self.leftNaviButton setTitle:title forState:UIControlStateHighlighted];
}
- (void)setLeftNaviTitle:(NSString *)title titleColor:(UIColor *)color highlightColor:(UIColor *)highlightcolor {
    [self.leftNaviButton setImage:nil forState:UIControlStateNormal];
    [self.leftNaviButton setImage:nil forState:UIControlStateHighlighted];
    [self.leftNaviButton setTitle:title forState:UIControlStateNormal];
    [self.leftNaviButton setTitle:title forState:UIControlStateHighlighted];
    [self.leftNaviButton setTitleColor:color forState:UIControlStateNormal];
    [self.leftNaviButton setTitleColor:highlightcolor forState:UIControlStateHighlighted];
    self.leftNaviButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.leftNaviButton.frame = CGRectMake(HNavTitleButtonMargin, self.rightNaviButton.h_y, HNavTitleButtonWidth, self.rightNaviButton.h_height);
}
- (void)setRightNaviTitle:(NSString *)title {
    [self.rightNaviButton setImage:nil forState:UIControlStateNormal];
    [self.rightNaviButton setImage:nil forState:UIControlStateHighlighted];
    [self.rightNaviButton setTitle:title forState:UIControlStateNormal];
    [self.rightNaviButton setTitle:title forState:UIControlStateHighlighted];
}
- (void)setRightNaviTitle:(NSString *)title titleColor:(UIColor *)color highlightColor:(UIColor *)highlightcolor {
    [self.rightNaviButton setImage:nil forState:UIControlStateNormal];
    [self.rightNaviButton setImage:nil forState:UIControlStateHighlighted];
    [self.rightNaviButton setTitle:title forState:UIControlStateNormal];
    [self.rightNaviButton setTitle:title forState:UIControlStateHighlighted];
    [self.rightNaviButton setTitleColor:color forState:UIControlStateNormal];
    [self.rightNaviButton setTitleColor:highlightcolor forState:UIControlStateHighlighted];
    self.rightNaviButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.rightNaviButton.frame = CGRectMake(self.topBar.h_width - HNavTitleButtonWidth - HNavTitleButtonMargin, self.rightNaviButton.h_y, HNavTitleButtonWidth, self.rightNaviButton.h_height);
}

#pragma mark - 状态栏的隐藏控制
//iOS7必须覆盖该方法并返回YES才能控制状态栏隐藏
- (BOOL)prefersStatusBarHidden {
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return YES;
    }
    return NO;
}

- (BOOL)autoAdjustStatusBarStyle {
    if (self.prefersStatusBarHidden) {
        return NO;
    }
    return YES;
}

- (UIColor *)preferredStatusBarColor {
    return nil;
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

- (BOOL)prefersTopBarLineHidden {
    return NO;
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
- (NSMutableArray *)sourceArr {
    NSMutableArray *array = objc_getAssociatedObject(self, _cmd);
    if (!array) {
        array = NSMutableArray.array;
        self.sourceArr = array;
    }
    return array;
}
- (void)setSourceArr:(NSMutableArray *)sourceArr {
    objc_setAssociatedObject(self, @selector(sourceArr), sourceArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableDictionary *)sourceDict {
    NSMutableDictionary *dictionary = objc_getAssociatedObject(self, _cmd);
    if (!dictionary) {
        dictionary= NSMutableDictionary.dictionary;
        self.sourceDict = dictionary;
    }
    return dictionary;
}
- (void)setSourceDict:(NSMutableDictionary *)sourceDict {
    objc_setAssociatedObject(self, @selector(sourceDict), sourceDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
