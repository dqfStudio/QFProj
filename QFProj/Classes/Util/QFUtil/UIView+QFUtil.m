//
//  UIView+QFUtil.m
//  MeTa
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 hisun. All rights reserved.
//

#import "UIView+QFUtil.h"

#define TIPS_IMAGE_VIEW_TAG 10000
#define TIPS_LABEL_TAG 10001

static const void *userInfoAddress = &userInfoAddress;

@implementation UIView (QFUtil)

#pragma mark - Init

+ (instancetype)viewWithNibName:(NSString *)name {
    return [[[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil] firstObject];
}

+ (instancetype)viewFromNib {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

#pragma mark - Frame

- (CGFloat)x_yy {
    return self.frame.origin.x;
}
- (void)setX_yy:(CGFloat)x_yy {
    CGRect frame = self.frame;
    frame.origin.x = x_yy;
    self.frame = frame;
}

- (CGFloat)y_yy {
    return self.frame.origin.y;
}
- (void)setY_yy:(CGFloat)y_yy {
    CGRect frame = self.frame;
    frame.origin.y = y_yy;
    self.frame = frame;
}

- (CGFloat)width_yy {
    return self.frame.size.width;
}
- (void)setWidth_yy:(CGFloat)width_yy {
    CGRect frame = self.frame;
    frame.size.width = width_yy;
    self.frame = frame;
}

- (CGFloat)height_yy {
    return self.frame.size.height;
}
- (void)setHeight_yy:(CGFloat)height_yy {
    CGRect frame = self.frame;
    frame.size.height = height_yy;
    self.frame = frame;
}






- (CGPoint)origin_yy {
    return self.frame.origin;
}
- (void)setOrigin_yy:(CGPoint)origin_yy {
    CGRect frame = self.frame;
    frame.origin = origin_yy;
    self.frame = frame;
}

- (CGSize)size_yy {
    return self.frame.size;
}
- (void)setSize_yy:(CGSize)size_yy {
    CGRect frame = self.frame;
    frame.size = size_yy;
    self.frame = frame;
}

- (CGFloat)centerX_yy {
    return self.center.x;
}
- (void)setCenterX_yy:(CGFloat)centerX_yy {
    self.center = CGPointMake(centerX_yy, self.center.y);
}

- (CGFloat)centerY_yy {
    return self.center.y;
}
- (void)setCenterY_yy:(CGFloat)centerY_yy {
    self.center = CGPointMake(self.center.x, centerY_yy);
}

- (CGFloat)minX_yy {
    return CGRectGetMinX(self.frame);
}
- (CGFloat)minY_yy {
    return CGRectGetMinY(self.frame);
}

- (CGFloat)midX_yy {
    return CGRectGetMidX(self.frame);
}
- (CGFloat)midY_yy {
    return CGRectGetMidY(self.frame);
}

- (CGFloat)maxX_yy {
    return CGRectGetMaxX(self.frame);
}
- (CGFloat)maxY_yy {
    return CGRectGetMaxY(self.frame);
}

- (void)fillWidth {
    [self setWidth_yy:CGRectGetWidth([UIScreen mainScreen].bounds)];
}

- (void)fillHeight {
    [self setHeight_yy:CGRectGetHeight([UIScreen mainScreen].bounds)];
}




- (void)horizontalCenterWithWidth:(CGFloat)width {
    self.x_yy = ceilf((width - self.width_yy) / 2);
}

- (void)verticalCenterWithHeight:(CGFloat)height {
    self.y_yy = ceilf((height - self.height_yy) / 2);
}

- (void)verticalCenterInSuperView {
    [self verticalCenterWithHeight:self.superview.height_yy];
}

- (void)horizontalCenterInSuperView {
    [self horizontalCenterWithWidth:self.superview.width_yy];
}

#pragma mark - Tap Gesture

- (UITapGestureRecognizer *)addSingleTapGestureWithBlock:(void (^)(UITapGestureRecognizer *))block {
    return [self addTapGestureWithNumberOfTapsRequired:1 block:block];
}

- (UITapGestureRecognizer *)addDoubleTapGestureWithBlock:(void (^)(UITapGestureRecognizer *))block {
    return [self addTapGestureWithNumberOfTapsRequired:2 block:block];
}

- (UITapGestureRecognizer *)addTapGestureWithNumberOfTapsRequired:(NSUInteger)numberOfTapsRequired
                                                            block:(void (^)(UITapGestureRecognizer *))block {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithActionBlock:block];
    recognizer.numberOfTapsRequired = numberOfTapsRequired;
    [self addGestureRecognizer:recognizer];
    return recognizer;
}

- (UITapGestureRecognizer *)setSingleTapGestureWithBlock:(void (^)(UITapGestureRecognizer *))block {
    [self.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITapGestureRecognizer class]]) {
            [self removeGestureRecognizer:obj];
        }
    }];
    return [self addTapGestureWithNumberOfTapsRequired:1 block:block];
}

- (UITapGestureRecognizer *)setSingleTapGestureTarget:(id)target action:(SEL)action {
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

#pragma mark - Top and bottom line

- (CALayer *)topLineLayer {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTopLineLayer:(CALayer *)topLineLayer {
    objc_setAssociatedObject(self, @selector(topLineLayer), topLineLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CALayer *)bottomLineLayer {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBottomLineLayer:(CALayer *)bottomLineLayer {
    objc_setAssociatedObject(self, @selector(bottomLineLayer), bottomLineLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CALayer *)addSubLayerWithFrame:(CGRect)frame color:(UIColor *)color {
    CALayer *layer = [CALayer layer];
    layer.frame = frame;
    layer.backgroundColor = color.CGColor;
    [self.layer addSublayer:layer];
    return layer;
}

- (void)setTopFillLineWithColor:(UIColor *)color {
    [self setTopLineWithColor:color paddingLeft:0 paddingRight:0];
}

- (void)setTopLineWithColor:(UIColor *)color paddingLeft:(CGFloat)paddingLeft paddingRight:(CGFloat)paddingRight {
    CGRect frame = CGRectMake(paddingLeft,
                              0,
                              [UIScreen mainScreen].bounds.size.width - paddingLeft-paddingRight,
                              ONE_PIXEL);
    if (!self.topLineLayer) {
        self.topLineLayer = [self addSubLayerWithFrame:frame color:color];
    }else {
        self.topLineLayer.frame = frame;
        self.topLineLayer.backgroundColor = color.CGColor;
    }
}

- (void)setBottomFillLineWithColor:(UIColor *)color {
    [self setBottomLineWithColor:color paddingLeft:0 paddingRight:0];
}

- (void)setBottomLineWithColor:(UIColor *)color paddingLeft:(CGFloat)paddingLeft paddingRight:(CGFloat)paddingRight {
    CGRect frame = CGRectMake(paddingLeft,
                              self.height_yy - ONE_PIXEL,
                              [UIScreen mainScreen].bounds.size.width - paddingLeft- paddingRight,
                              ONE_PIXEL);
    if (!self.bottomLineLayer) {
        self.bottomLineLayer = [self addSubLayerWithFrame:frame color:color];
    }else {
        self.bottomLineLayer.frame = frame;
        self.bottomLineLayer.backgroundColor = color.CGColor;
    }
    
}

- (void)setTopAndBottomLineWithColor:(UIColor *)color {
    [self setTopFillLineWithColor:color];
    [self setBottomFillLineWithColor:color];
}

- (UIView *)setTopLineViewWithColor:(UIColor *)color paddingLeft:(CGFloat)left paddingRight:(CGFloat)right {
    __weak UIView *weakSelf = self;
    return [self addSubviewWithColor:color constraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(left));
        make.right.equalTo(@(right));
        make.height.equalTo(@(ONE_PIXEL));
        make.top.equalTo(weakSelf);
    }];
}

- (UIView *)setBottomLineViewWithColor:(UIColor *)color paddingLeft:(CGFloat)left paddingRight:(CGFloat)right {
    __weak UIView *weakSelf = self;
    return [self addSubviewWithColor:color constraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(left));
        make.right.equalTo(@(right));
        make.height.equalTo(@(ONE_PIXEL));
        make.bottom.equalTo(weakSelf);
    }];
}

- (UIView *)addSubviewWithColor:(UIColor *)color
                    constraints:(void(^)(MASConstraintMaker *make))block  {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = color;
    [self addSubview:line];
    [line mas_makeConstraints:block];
    return line;
}



#pragma mark - other

- (id)userInfo {
    return objc_getAssociatedObject(self, userInfoAddress);
}

- (void)setUserInfo:(id)userInfo {
    objc_setAssociatedObject(self, userInfoAddress, userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)setBoarderWith:(CGFloat)width color:(UIColor *)color {
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setTipsViewWithImageName:(NSString *)imageName
                            text:(NSString *)text
                       textColor:(UIColor *)textColor {
    UIImageView *imageView = [self viewWithTag:TIPS_IMAGE_VIEW_TAG];
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    }
    imageView.center = CGPointMake(self.width_yy / 2, self.height_yy / 2 - 40);
    imageView.contentMode = UIViewContentModeCenter;
    imageView.tag = TIPS_IMAGE_VIEW_TAG;
    [self addSubview:imageView];
    
    UILabel *label = [self viewWithTag:TIPS_LABEL_TAG];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.maxY_yy + 10, [UIScreen mainScreen].bounds.size.width, 20)];
    }
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = textColor;
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.tag = TIPS_LABEL_TAG;
    [self addSubview:label];
}

- (void)removeTipsView {
    [[self viewWithTag:TIPS_IMAGE_VIEW_TAG] removeFromSuperview];
    [[self viewWithTag:TIPS_LABEL_TAG] removeFromSuperview];
}





//设置视图上边角幅度
- (void)setCornerRadiiOnTop:(CGFloat)radii {
    [self setGivenCorner:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:radii];
}
//设置视图下边角幅度
- (void)setCornerRadiiOnBottom:(CGFloat)radii {
    [self setGivenCorner:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:radii];
}
//设置指定角的角幅度
- (void)setGivenCorner:(UIRectCorner)corners cornerRadii:(CGFloat)radii {
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
- (void)setAllCornerRadii:(CGFloat)radii {
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
