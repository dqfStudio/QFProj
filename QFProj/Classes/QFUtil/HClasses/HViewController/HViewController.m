//
//  HViewController.m
//  TestProject
//
//  Created by dqf on 2018/4/27.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HViewController.h"

#define IS_KIPHONEX ([UIScreen mainScreen].bounds.size.width == 375.f && [UIScreen mainScreen].bounds.size.height == 812.f ? YES : NO)

@interface HViewControllerMgr : NSObject <UIGestureRecognizerDelegate>

@end

@implementation HViewControllerMgr :NSObject
+ (instancetype)shared {
    static dispatch_once_t pred;
    static HViewControllerMgr *o = nil;
    dispatch_once(&pred, ^{ o = [[self alloc] init]; });
    return o;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}
@end


#define HTopBarHeight 44.0f
#define HStatusBarHeight (IS_KIPHONEX?44.0:20.0f)
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
@property (nonatomic) CGFloat topBarTopPadding;

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
    if (self)
    {
        [self pvc_initialize];
    }
    return self;
}

- (void)pvc_initialize {
    _topBarTopPadding = 0;
    
    //只有statusBar没有系统导航栏的情况下,statusBar背景色是透明的需要自定义的导航栏多增加一点高度来伪造statusBar的背景
    if (![self prefersStatusBarHidden] && ![self prefersNavigationBarHidden]) {
        _topBarTopPadding = HStatusBarHeight;
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
    [self.leftNaviButton setImageUrlString:@"icon_back_co2"];
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
    self.navigationController.interactivePopGestureRecognizer.enabled = [self popGestureEnabled];
    self.navigationController.interactivePopGestureRecognizer.delegate = [HViewControllerMgr shared];
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

#pragma mark - 事件处理
- (void)back {
    if (self.presentedViewController || self.presentingViewController) {
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
        //没有系统导航栏的时候,status背景色是透明的,用自定义导航栏去伪造一个status背景区域
        if([self prefersNavigationBarHidden]) {
            _topBar.frame = CGRectMake(0, _topBarTopPadding, self.view.h_width, HTopBarHeight);
        }else {
            _topBar.frame = CGRectMake(0, 0, self.view.h_width, HTopBarHeight + _topBarTopPadding);
            _topBar.bounds = CGRectMake(0, -_topBarTopPadding, self.view.h_width, HTopBarHeight + _topBarTopPadding);
        }
        _topBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _topBarLine = [[UIView alloc] init];
        _topBarLine.frame = CGRectMake(0, HTopBarHeight - 1, _topBar.h_width, 1);
        [_topBar addSubview:_topBarLine];
        _topBarLine.hidden = YES;
    }
    return _topBar;
}
- (float)topBarHeight {
    return ([self prefersStatusBarHidden]?0:HStatusBarHeight) + ([self prefersNavigationBarHidden]?0:HTopBarHeight);
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(54, 0, self.view.h_width - 54 * 2, HTopBarHeight);
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
        _leftNaviButton.frame = CGRectMake(0, 0, HTopBarHeight, HTopBarHeight);
        [_leftNaviButton.button setFont:[UIFont systemFontOfSize:16]];
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
        [_rightNaviButton.button setFont:[UIFont systemFontOfSize:16]];
        _rightNaviButton.frame = CGRectMake(self.topBar.h_width - HTopBarHeight, 0, HTopBarHeight, HTopBarHeight);
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

#pragma mark - 旋转支持
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


//#pragma mark - gestureRecognizer delegate
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    [otherGestureRecognizer requireGestureRecognizerToFail:gestureRecognizer];
//    return NO;
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
    return NO;
}

@end
