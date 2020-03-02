//
//  HMarquee.m
//  Wonderful
//

#import "HMarquee.h"

typedef void(^HWonderfulAction)(void);

typedef NS_ENUM(NSInteger, HMarqueeTapMode) {
    HMarqueeTapForMove   = 1,
    HMarqueeTapForAction = 2
};

@interface HMarquee ()

@property(nonatomic, strong) UIButton *bgBtn;
@property(nonatomic, strong) UILabel *marqueeLbl;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, copy  ) HWonderfulAction     tapAction;
@property(nonatomic, assign) HMarqueeTapMode      tapMode;
@property(nonatomic, assign) HMarqueeSpeedLevel   speedLevel;
@property(nonatomic, strong) UIView *middleView;
@property(nonatomic, strong) UIFont *marqueeLabelFont;

@end

@implementation HMarquee

- (instancetype)initWithFrame:(CGRect)frame speed:(HMarqueeSpeedLevel)speed Msg:(NSString *)msg bgColor:(UIColor *)bgColor txtColor:(UIColor *)txtColor {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 2;
        self.msg = msg;
        if (bgColor) {
            self.bgColor = bgColor;
        }else {
            self.bgColor = [UIColor whiteColor];
        }
        
        if (txtColor) {
            self.txtColor = txtColor;
        }else {
            self.txtColor = [UIColor darkGrayColor];
        }
        
        if (speed) {
            self.speedLevel = speed;
        }else {
            self.speedLevel = 3;
        }
    }
    return self;
}

//修改源码，这里修改为可以后置文字
- (void)setMsg:(NSString *)msg {
    _msg = msg;
    self.marqueeLbl.text = msg;
    [self doSometingBeginning];
}

// 背景颜色
- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    self.backgroundColor = _bgColor;
}

// 字体颜色
- (void)setTxtColor:(UIColor *)txtColor {
    _txtColor = txtColor;
    _marqueeLbl.textColor = _txtColor;
}

- (instancetype)initWithFrame:(CGRect)frame speed:(HMarqueeSpeedLevel)speed Msg:(NSString *)msg {
    if (self = [super initWithFrame:frame]) {
        self.msg = msg;
        if (speed) {
            self.speedLevel = speed;
        }else {
            self.speedLevel = 3;
        }
        self.bgColor = [UIColor whiteColor];
        self.txtColor = [UIColor darkGrayColor];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setFrame:(CGRect)frame {
    if (!CGRectEqualToRect(self.frame, frame)) {
        [super setFrame:frame];
        
        _middleView.frame = self.bounds;
        
        self.bgBtn.frame = self.bounds;
        
        CGRect tmpFrame = _marqueeLbl.frame;
        tmpFrame.size.height = self.frame.size.height;
        _marqueeLbl.frame = tmpFrame;
    }
}

- (void)doSometingBeginning {
    self.layer.masksToBounds = YES;
    self.backgroundColor = self.bgColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backAndRestart) name:UIApplicationDidBecomeActiveNotification object:nil];
    self.middleView = nil;
    _middleView = [[UIView alloc] initWithFrame:self.bounds];
    [_middleView addSubview:self.marqueeLbl];
    [self addSubview:_middleView];
    [self addLeftAndRightGradient];
    
    self.bgBtn.frame = self.bounds;
    [self bringSubviewToFront:self.bgBtn];
}

- (void)changeTapMarqueeAction:(void(^)(void))action {
    [self addSubview:self.bgBtn];
    self.tapAction = action;
    self.tapMode = HMarqueeTapForAction;
    [self bringSubviewToFront:self.bgBtn];
}

- (void)changeMarqueeLabelFont:(UIFont *)font {
    self.marqueeLbl.font = font;
    self.marqueeLabelFont = font;
    CGSize msgSize = [_marqueeLbl.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    CGRect fr = self.marqueeLbl.frame;
    fr.size.width = msgSize.width;
    self.marqueeLbl.frame = fr;
}

- (UIButton *)bgBtn {
    if (!_bgBtn) {
        _bgBtn = [[UIButton alloc] initWithFrame:self.bounds];
        [_bgBtn addTarget:self action:@selector(bgButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgBtn;
}

- (UILabel *)marqueeLbl {
    if (!_marqueeLbl) {
        self.tapMode = HMarqueeTapForMove;
        CGFloat h = self.frame.size.height;
        _marqueeLbl = [[UILabel alloc] init];
        _marqueeLbl.text = self.msg;
        UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
        _marqueeLbl.font = fnt;
        CGSize msgSize = [_marqueeLbl.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil]];
        _marqueeLbl.frame = CGRectMake(0, 0, msgSize.width, h);
        if (self.marqueeLabelFont != nil) {
            _marqueeLbl.font = self.marqueeLabelFont;
        }
        _marqueeLbl.textColor = self.txtColor;
    }
    return _marqueeLbl;
}

- (void)addLeftAndRightGradient {
//    CGFloat w = self.frame.size.width;
//    CGFloat h = self.frame.size.height;
//    HColorGradientView *leftFade = [HColorGradientView createWithColor:self.bgColor frame:CGRectMake(0, 0, h, h) direction:HGradientToRight];
//    self.leftFade = leftFade;
//
//    HColorGradientView *rightFade = [HColorGradientView createWithColor:self.bgColor frame:CGRectMake(w - h, 0, h, h) direction:HGradientToLeft];
//    self.rightFade = rightFade;
//
//    [self addSubview:leftFade];
//    [self addSubview:rightFade];
}

- (void)bgButtonClick {
    if (self.tapAction) {
        self.tapAction();
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.tapMode == HMarqueeTapForMove) {
        [self stop];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.tapMode == HMarqueeTapForMove) {
        [self restart];
    }
}

#pragma mark - 操作
- (void)start {
    [self moveAction];
}

- (void)backAndRestart {
    [self.marqueeLbl.layer removeAllAnimations];
    [self.marqueeLbl removeFromSuperview];
    self.marqueeLbl = nil;
    [self.middleView addSubview:self.marqueeLbl];
    [self moveAction];
}

- (void)stop {
    [self pauseLayer:self.marqueeLbl.layer];
}

- (void)restart {
    [self resumeLayer:self.marqueeLbl.layer];
}

- (void)moveAction {
    CGRect fr = self.marqueeLbl.frame;
    fr.origin.x = self.frame.size.width;
    self.marqueeLbl.frame = fr;
    
    CGPoint fromPoint = CGPointMake(self.frame.size.width + self.marqueeLbl.frame.size.width/2, self.frame.size.height/2);
    
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:fromPoint];
    [movePath addLineToPoint:CGPointMake(-self.marqueeLbl.frame.size.width/2, self.frame.size.height/2)];

    CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnim.path = movePath.CGPath;
    moveAnim.removedOnCompletion = YES;
    
    moveAnim.duration = self.marqueeLbl.frame.size.width *self.speedLevel *0.01;
    [moveAnim setDelegate:(id <CAAnimationDelegate>)self];
    
    [self.marqueeLbl.layer addAnimation:moveAnim forKey:nil];
}

- (void)pauseLayer:(CALayer *)layer {
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

- (void)resumeLayer:(CALayer *)layer {
    CFTimeInterval pausedTime = layer.timeOffset;
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self moveAction];
    }
}
@end
