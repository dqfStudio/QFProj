//
//  UIView+HUtil.m
//  MeTa
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 dqf. All rights reserved.
//

#import "UIView+HUtil.h"

#define TIPS_IMAGE_VIEW_TAG 10000
#define TIPS_LABEL_TAG 10001

static const void *userInfoAddress = &userInfoAddress;

static char const * const KTopLineViewKey = "KTopLineViewKey";
static char const * const KBottomLineView = "KBottomLineView";
static char const * const KLeftLineView   = "KLeftLineView";
static char const * const KRightLineView  = "KRightLineView";

#define KLineDefaultColor [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0]

@implementation UIView (HUtil)

#pragma mark - Init
#pragma mark -

+ (instancetype)viewWithNibName:(NSString *)name {
    return [[[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil] firstObject];
}

+ (instancetype)viewFromNib {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

#pragma mark - Frame
#pragma mark -

- (CGFloat)h_x {
    return self.frame.origin.x;
}
- (void)setH_x:(CGFloat)h_x {
    CGRect frame = self.frame;
    frame.origin.x = h_x;
    self.frame = frame;
}

- (CGFloat)h_y {
    return self.frame.origin.y;
}
- (void)setH_y:(CGFloat)h_y {
    CGRect frame = self.frame;
    frame.origin.y = h_y;
    self.frame = frame;
}

- (CGFloat)h_width {
    return self.frame.size.width;
}
- (void)setH_width:(CGFloat)h_width {
    CGRect frame = self.frame;
    frame.size.width = h_width;
    self.frame = frame;
}

- (CGFloat)h_height {
    return self.frame.size.height;
}
- (void)setH_height:(CGFloat)h_height {
    CGRect frame = self.frame;
    frame.size.height = h_height;
    self.frame = frame;
}



- (CGPoint)h_origin {
    return self.frame.origin;
}
- (void)setH_origin:(CGPoint)h_origin {
    CGRect frame = self.frame;
    frame.origin = h_origin;
    self.frame = frame;
}

- (CGSize)h_size {
    return self.frame.size;
}
- (void)setH_size:(CGSize)h_size {
    CGRect frame = self.frame;
    frame.size = h_size;
    self.frame = frame;
}

- (CGFloat)h_centerX {
    return self.center.x;
}
- (void)setH_centerX:(CGFloat)h_centerX {
    self.center = CGPointMake(h_centerX, self.center.y);
}

- (CGFloat)h_centerY {
    return self.center.y;
}
- (void)setH_centerY:(CGFloat)h_centerY {
    self.center = CGPointMake(self.center.x, h_centerY);
}

- (CGFloat)h_minX {
    return CGRectGetMinX(self.frame);
}
- (CGFloat)h_minY {
    return CGRectGetMinY(self.frame);
}

- (CGFloat)h_midX {
    return CGRectGetMidX(self.frame);
}
- (CGFloat)h_midY {
    return CGRectGetMidY(self.frame);
}

- (CGFloat)h_maxX {
    return CGRectGetMaxX(self.frame);
}
- (CGFloat)h_maxY {
    return CGRectGetMaxY(self.frame);
}

#pragma mark - 上下左右边角
#pragma mark -

//设置圆角
- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}
- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}

//设置边框宽度和颜色
- (void)setBoarderWith:(CGFloat)width color:(UIColor *)color {
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}

//设置视图上边角幅度
- (void)setTopCorner:(CGFloat)radii {
    [self setCorner:(UIRectCornerTopLeft|UIRectCornerTopRight) radii:radii];
}
//设置视图下边角幅度
- (void)setBottomCorner:(CGFloat)radii {
    [self setCorner:(UIRectCornerBottomLeft|UIRectCornerBottomRight) radii:radii];
}
//设置指定角的角幅度
- (void)setCorner:(UIRectCorner)corners radii:(CGFloat)radii {
    UIBezierPath *maskPath = nil;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:corners
                                           cornerRadii:CGSizeMake(radii, radii)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
//设置视图所有角幅度
- (void)setAllCorner:(CGFloat)radii {
    UIBezierPath *maskPath = nil;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                          cornerRadius:radii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
//去掉视图所有角幅度
- (void)setNoneCorner {
    self.layer.mask = nil;
}

#pragma mark - 上下左右边线
#pragma mark -

- (UIView *)topLine {
    UIView *lineView = objc_getAssociatedObject(self, KTopLineViewKey);
    if (!lineView) {
        lineView = UIView.new;
        lineView.backgroundColor = KLineDefaultColor;
        lineView.frame = CGRectMake(0, 0, self.bounds.size.width, 1);
        lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        objc_setAssociatedObject(self, KTopLineViewKey, lineView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return lineView;
}

- (UIView *)bottomLine {
    UIView *lineView = objc_getAssociatedObject(self, KBottomLineView);
    if (!lineView) {
        lineView = UIView.new;
        lineView.backgroundColor = KLineDefaultColor;
        lineView.frame = CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width, 1);
        lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        objc_setAssociatedObject(self, KBottomLineView, lineView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return lineView;
}



- (UIView *)leftLine {
    UIView *lineView = objc_getAssociatedObject(self, KLeftLineView);
    if (!lineView) {
        lineView = UIView.new;
        lineView.backgroundColor = KLineDefaultColor;
        lineView.frame = CGRectMake(0, 0, 1, self.bounds.size.height);
        lineView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        objc_setAssociatedObject(self, KLeftLineView, lineView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return lineView;
}

- (UIView *)rightLine {
    UIView *lineView = objc_getAssociatedObject(self, KRightLineView);
    if (!lineView) {
        lineView = UIView.new;
        lineView.backgroundColor = KLineDefaultColor;
        lineView.frame = CGRectMake(self.bounds.size.width-1, 0, 1, self.bounds.size.height);
        lineView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        objc_setAssociatedObject(self, KRightLineView, lineView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return lineView;
}



- (void)addTopLineWithSize:(CGFloat)size color:(UIColor *)color paddingLeft:(CGFloat)left paddingRight:(CGFloat)right {
    if (size <= 0) size = 1;
    if (color) self.topLine.backgroundColor = color;
    self.topLine.frame = CGRectMake(left, 0, self.bounds.size.width-left-right, size);
    [self addSubview:self.topLine];
}
- (void)addBottomLineWithSize:(CGFloat)size color:(UIColor *)color paddingLeft:(CGFloat)left paddingRight:(CGFloat)right {
    if (size <= 0) size = 1;
    if (color) self.bottomLine.backgroundColor = color;
    self.bottomLine.frame = CGRectMake(left, self.bounds.size.height-size, self.bounds.size.width-left-right, size);
    [self addSubview:self.bottomLine];
}



- (void)addLeftLineWithSize:(CGFloat)size color:(UIColor *)color paddingTop:(CGFloat)top paddingBottom:(CGFloat)bottom {
    if (size <= 0) size = 1;
    if (color) self.leftLine.backgroundColor = color;
    self.leftLine.frame = CGRectMake(0, top, size, self.bounds.size.height-top-bottom);
    [self addSubview:self.leftLine];
}
- (void)addRightLineWithSize:(CGFloat)size color:(UIColor *)color paddingTop:(CGFloat)top paddingBottom:(CGFloat)bottom {
    if (size <= 0) size = 1;
    if (color) self.rightLine.backgroundColor = color;
    self.rightLine.frame = CGRectMake(self.bounds.size.width-size, top, size, self.bounds.size.height-top-bottom);
    [self addSubview:self.rightLine];
}


#pragma mark - Tap Gesture
#pragma mark -

- (UITapGestureRecognizer *)addSingleTapGestureWithBlock:(void (^)(UITapGestureRecognizer *))block {
    return [self addTapGestureWithNumberOfTapsRequired:1 block:block];
}

- (UITapGestureRecognizer *)addDoubleTapGestureWithBlock:(void (^)(UITapGestureRecognizer *))block {
    return [self addTapGestureWithNumberOfTapsRequired:2 block:block];
}

- (UITapGestureRecognizer *)addTapGestureWithNumberOfTapsRequired:(NSUInteger)numberOfTapsRequired
                                                            block:(void (^)(UITapGestureRecognizer *))block {
    self.userInteractionEnabled = YES;
    [self.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITapGestureRecognizer class]]) {
            [self removeGestureRecognizer:obj];
        }
    }];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithActionBlock:block];
    recognizer.numberOfTapsRequired = numberOfTapsRequired;
    [self addGestureRecognizer:recognizer];
    return recognizer;
}

- (UITapGestureRecognizer *)addSingleTapGestureTarget:(id)target action:(SEL)action {
    self.userInteractionEnabled = YES;
    [self.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITapGestureRecognizer class]]) {
            [self removeGestureRecognizer:obj];
        }
    }];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:recognizer];
    return recognizer;
}

#pragma mark - adapt screen
#pragma mark -

- (void)adaptScreenWidthWithType:(HAdaptScreenWidthType)type {

    // 是否要对约束进行等比例
    BOOL adaptConstraint = ((type & HAdaptScreenWidthTypeConstraint) || type == HAdaptScreenWidthTypeAll);
    
    // 是否要对frameHeight等比例
    BOOL adaptFrameHeight = ((type & HAdaptScreenWidthTypeFrameHeight) || type == HAdaptScreenWidthTypeAll);
    
    // 是否要对frameSize等比例
    BOOL adaptFrameSize = ((type & HAdaptScreenWidthTypeFrameSize) || type == HAdaptScreenWidthTypeAll);
    
    // 是否对字体大小进行等比例
    BOOL adaptFontSize = ((type & HAdaptScreenWidthTypeFontSize) || type == HAdaptScreenWidthTypeAll);
    
    // 是否对圆角大小进行等比例
    BOOL adaptCornerRadius = ((type & HAdaptScreenWidthTypeCornerRadius) || type == HAdaptScreenWidthTypeAll);
    
    // 约束
    if (adaptConstraint) {
        [self.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull subConstraint, NSUInteger idx, BOOL * _Nonnull stop) {
            subConstraint.constant = HAdaptWidth(subConstraint.constant);
        }];
    }
    
    // frameHeight
    if (adaptFrameHeight) {
        CGRect frame = self.frame;
        frame.size.height = HAdaptWidth(frame.size.width);
        self.frame = frame;
    }
    
    // frameSize
    if (adaptFrameSize) {
        CGRect frame = self.frame;
        frame.size.width = HAdaptWidth(frame.size.width);
        frame.size.height = HAdaptWidth(frame.size.width);
        self.frame = frame;
    }
    
    // 字体大小
    if (adaptFontSize) {
        
        if ([self isKindOfClass:[UILabel class]] && ![self isKindOfClass:NSClassFromString(@"UIButtonLabel")]) {
            UILabel *label = (UILabel *)self;
            label.font = [UIFont systemFontOfSize:HAdaptWidth(label.font.pointSize)];
        }
        else if ([self isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)self;
            textField.font = [UIFont systemFontOfSize:HAdaptWidth(textField.font.pointSize)];
        }
        else  if ([self isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)self;
            button.titleLabel.font = [UIFont systemFontOfSize:HAdaptWidth(button.titleLabel.font.pointSize)];
        }
        else  if ([self isKindOfClass:[UITextView class]]) {
            UITextView *textView = (UITextView *)self;
            textView.font = [UIFont systemFontOfSize:HAdaptWidth(textView.font.pointSize)];
        }
    }
    
    // 圆角
    if (adaptCornerRadius) {
        if (self.layer.cornerRadius) {
            self.layer.cornerRadius = HAdaptWidth(self.layer.cornerRadius);
        }
    }
}

- (void)adaptScreenWidthWithType:(HAdaptScreenWidthType)type exceptViews:(NSArray<Class> *)exceptViews {

    if (![self isExceptViewClassWithClassArray:exceptViews]) {
     
        // 是否要对约束进行等比例
        BOOL adaptConstraint = ((type & HAdaptScreenWidthTypeConstraint) || type == HAdaptScreenWidthTypeAll);
        
        // 是否要对frameHeight等比例
        BOOL adaptFrameHeight = ((type & HAdaptScreenWidthTypeFrameHeight) || type == HAdaptScreenWidthTypeAll);
        
        // 是否要对frameSize等比例
        BOOL adaptFrameSize = ((type & HAdaptScreenWidthTypeFrameSize) || type == HAdaptScreenWidthTypeAll);
        
        // 是否对字体大小进行等比例
        BOOL adaptFontSize = ((type & HAdaptScreenWidthTypeFontSize) || type == HAdaptScreenWidthTypeAll);
        
        // 是否对圆角大小进行等比例
        BOOL adaptCornerRadius = ((type & HAdaptScreenWidthTypeCornerRadius) || type == HAdaptScreenWidthTypeAll);
        
        // 约束
        if (adaptConstraint) {
            [self.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull subConstraint, NSUInteger idx, BOOL * _Nonnull stop) {
                subConstraint.constant = HAdaptWidth(subConstraint.constant);
            }];
        }
        
        // frameHeight
        if (adaptFrameHeight) {
            CGRect frame = self.frame;
            frame.size.height = HAdaptWidth(frame.size.width);
            self.frame = frame;
        }
        
        // frameSize
        if (adaptFrameSize) {
            CGRect frame = self.frame;
            frame.size.width = HAdaptWidth(frame.size.width);
            frame.size.height = HAdaptWidth(frame.size.width);
            self.frame = frame;
        }
        
        // 字体大小
        if (adaptFontSize) {
            
            if ([self isKindOfClass:[UILabel class]] && ![self isKindOfClass:NSClassFromString(@"UIButtonLabel")]) {
                UILabel *label = (UILabel *)self;
                label.font = [UIFont systemFontOfSize:HAdaptWidth(label.font.pointSize)];
            }
            else if ([self isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)self;
                textField.font = [UIFont systemFontOfSize:HAdaptWidth(textField.font.pointSize)];
            }
            else  if ([self isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)self;
                button.titleLabel.font = [UIFont systemFontOfSize:HAdaptWidth(button.titleLabel.font.pointSize)];
            }
            else  if ([self isKindOfClass:[UITextView class]]) {
                UITextView *textView = (UITextView *)self;
                textView.font = [UIFont systemFontOfSize:HAdaptWidth(textView.font.pointSize)];
            }
        }
        
        // 圆角
        if (adaptCornerRadius) {
            if (self.layer.cornerRadius) {
                self.layer.cornerRadius = HAdaptWidth(self.layer.cornerRadius);
            }
        }
        
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subView, NSUInteger idx, BOOL * _Nonnull stop) {
            // 继续对子view操作
            [subView adaptScreenWidthWithType:type exceptViews:exceptViews];
        }];
    }
}

// 当前view对象是否是例外的视图
- (BOOL)isExceptViewClassWithClassArray:(NSArray<Class> *)classArray {
    __block BOOL isExcept = NO;
    [classArray enumerateObjectsUsingBlock:^(Class  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self isKindOfClass:obj]) {
            isExcept = YES;
            *stop = YES;
        }
    }];
    return isExcept;
}

#pragma mark - other
#pragma mark -

- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

//根据视图生成图片
- (UIImage *)snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (UIImage *)snapshotImageWithFrame:(CGRect)frame {
    UIGraphicsBeginImageContextWithOptions(frame.size, self.opaque, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -frame.origin.x, -frame.origin.y);
    [self.layer renderInContext: context];
    CGContextTranslateCTM(context, frame.origin.x, frame.origin.y);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (NSData *)snapshotPDF {
    CGRect bounds = self.bounds;
    NSMutableData *data = [NSMutableData data];
    CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)data);
    CGContextRef context = CGPDFContextCreate(consumer, &bounds, NULL);
    CGDataConsumerRelease(consumer);
    if (!context) return nil;
    CGPDFContextBeginPage(context, NULL);
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    [self.layer renderInContext:context];
    CGPDFContextEndPage(context);
    CGPDFContextClose(context);
    CGContextRelease(context);
    return data;
}

@end
