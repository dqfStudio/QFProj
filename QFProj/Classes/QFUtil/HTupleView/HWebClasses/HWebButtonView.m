//
//  HWebButtonView.m
//  QFProj
//
//  Created by dqf on 15/8/6.
//  Copyright (c) 2015年 dqfStudio. All rights reserved.
//

#import "HWebButtonView.h"
#import <objc/runtime.h>
#import <UIView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface HWebButtonAppearance ()
@property (nonatomic) NSHashTable *hashButtons;
@end

@implementation HWebButtonAppearance
+ (instancetype)appearance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (void)addButton:(id)anButton {
    if (!self.hashButtons) {
        self.hashButtons = [NSHashTable weakObjectsHashTable];
    }
    [self.hashButtons addObject:anButton];
}
- (void)enumerateButtons:(void (^)(void))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *allObjects = [[self.hashButtons objectEnumerator] allObjects];
        //倒序执行
        for (NSUInteger i=allObjects.count-1; i>=0; i--) {
            HWebButtonView *buttonView = allObjects[i];
            if (buttonView.themeSkin) {
                buttonView.themeSkin(buttonView, nil);
            }
        }
        if (completion) {
            completion();
        }
    });
}
@end

@interface HWebButtonView()
@property (nonatomic) UIImageView *_imageView;
@property (nonatomic) NSString *lastURL;
@end

@implementation HWebButtonView
- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, 200, 200)];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup {
    [self addSubview:self._imageView];
    //self.backgroundColor = [UIColor colorWithHex:0xe8e8e8];
    self.backgroundColor = [UIColor clearColor];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self initialize];
}
- (void)initialize {
    [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.layer.masksToBounds = YES;
    self.imageOptions = SDWebImageRetryFailed;
    [self addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
}
- (UIImageView *)_imageView {
    if (!__imageView) {
        __imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        __imageView.contentMode = UIViewContentModeScaleAspectFill;
        __imageView.layer.masksToBounds = YES;
        __imageView.userInteractionEnabled = NO;
        __imageView.hidden = YES;
        __imageView.autoresizingMask = (UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth);
    }
    return __imageView;
}
- (void)_setImage:(UIImage *)image {
    [self._imageView sd_cancelCurrentImageLoad];
    if (image != nil) {
        if (self.renderColor) {
            self._imageView.tintColor = self.renderColor;
            self._imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }else {
            self._imageView.image = image;
        }
        self._imageView.hidden = NO;
    }else {
        self._imageView.image = nil;
        self._imageView.hidden = YES;
    }
}
- (void)setRenderColor:(UIColor *)renderColor {
    _renderColor = renderColor;
    if (_renderColor) {
        self._imageView.tintColor = _renderColor;
        self._imageView.image = [self._imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        self.tintColor = _renderColor;
        [self setImage:[[self imageForState:UIControlStateNormal] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }else {
        self._imageView.image = [self._imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [self setImage:[[self imageForState:UIControlStateNormal] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
}
- (void)setWithImage:(UIImage *)image {
    [self _setImage:image];
    self.lastURL = nil;
    self.placeHoderImage = nil;
    self.imageView.alpha = 1;
    if (self.didGetImage) {
        self.didGetImage(self, image);
    }
}
- (void)setImageUrl:(NSURL *)url {
    [self setImageUrl:url syncLoadCache:NO];
}
- (void)setImageUrl:(NSURL *)url syncLoadCache:(BOOL)syncLoadCache {
    [self setImageUrlString:url.absoluteString syncLoadCache:syncLoadCache];
}
- (void)setImageUrlString:(NSString *)urlString {
    [self setImageUrlString:urlString syncLoadCache:NO];
}
- (void)setImageUrlString:(NSString *)urlString syncLoadCache:(BOOL)syncLoadCache {
    if (urlString.length == 0) {
        [self _setImage:nil];
        self.lastURL = nil;
        if (self.didGetError) self.didGetError(self, herr(kDataFormatErrorCode, ([NSString stringWithFormat:@"url = %@", urlString])));
        return;
    }

    if (![urlString hasPrefix:@"http"]) {
        UIImage *image = [UIImage imageNamed:urlString];
        [self _setImage:image];
        self._imageView.alpha = 1;
        if (self.didGetImage) self.didGetImage(self, self._imageView.image);
        return;
    }
    if (self._imageView.image && [_lastURL isEqual:urlString]) {
        self._imageView.alpha = 1;
        if (self.didGetImage) self.didGetImage(self, self._imageView.image);
        return;
    }
    
    if(!self.placeHoderImage && !self._imageView.image) self._imageView.alpha = 0;
    
    __block UIImage *placeholder = self.placeHoderImage;
    
    @weakify(self);
    
    [self _setImage:nil];
    self.lastURL = nil;
    NSURL *url = [NSURL URLWithString:urlString];
    
    if (syncLoadCache) {
        NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
        UIImage *image = [[SDWebImageManager sharedManager].imageCache imageFromCacheForKey:key];
        if (image) {
            [self _setImage:image];
            self._imageView.alpha = 1;
            self.lastURL = url.absoluteString;
            if (self.didGetImage) self.didGetImage(self, image);
        }
    }
    if (!self._imageView.image) {
        [__imageView sd_setImageWithURL:url placeholderImage:placeholder options:self.imageOptions completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            @strongify(self);
            if (error) {
                if (self.didGetError) self.didGetError(self, error);
            }else if (image) {
                [self _setImage:image];
                self.lastURL = url.absoluteString;
                if (SDImageCacheTypeNone == cacheType) {
                    [UIView animateWithDuration:0.5 animations:^{
                        self._imageView.alpha = 1;
                    }];
                }else {
                    self._imageView.alpha = 1;
                }
                if (self.didGetImage) self.didGetImage(self, image);
            }
        }];
    }
}
- (void)setImageWithFile:(NSString *)fileName {
    if (fileName.length > 0) {
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        NSString *filePath = [resourcePath stringByAppendingPathComponent:fileName];
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        [self setWithImage:image];
    }else {
        [self _setImage:nil];
        self.lastURL = nil;
        if (self.didGetError) self.didGetError(self, herr(kDataFormatErrorCode, ([NSString stringWithFormat:@"url = %@", fileName])));
    }
}
- (void)setImageWithName:(NSString *)fileName {
    if (fileName.length > 0) {
        [self setWithImage:[UIImage imageNamed:fileName]];
    }
}
- (void)buttonPressed {
    if (_pressed) _pressed(self, nil);
}
- (void)setThemeSkin:(callback)themeSkin {
    if (_themeSkin != themeSkin) {
        _themeSkin = nil;
        _themeSkin = themeSkin;
        if (themeSkin) {
            //保存button用于全局刷新
            [[HWebButtonAppearance appearance] addButton:self];
        }
    }
}
@end


@implementation HWebButtonView (HFilletLayer)
- (BOOL)fillet {
    return self._imageView.fillet;
}
- (void)setFillet:(BOOL)fillet {
    self._imageView.fillet = fillet;
}
- (UIImageViewFilletStyle)filletStyle {
    return self._imageView.filletStyle;
}
- (void)setFilletStyle:(UIImageViewFilletStyle)filletStyle {
    self._imageView.filletStyle = filletStyle;
}
@end


@implementation UIButton (HUtil)

- (void)setTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setTitleColor:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateNormal];
}
- (void)setTitleColorHex:(NSString *)color {
    [self setTitleColor:[UIColor colorWithString:color] forState:UIControlStateNormal];
}

- (void)setFont:(UIFont *)font {
    [self.titleLabel setFont:font];
}
- (void)setSysFont:(CGFloat)font {
    [self.titleLabel setFont:[UIFont systemFontOfSize:font]];
}
- (void)setBoldSysFont:(CGFloat)font {
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:font]];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [self.titleLabel setTextAlignment:textAlignment];
}
- (void)setImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateNormal];
}
- (void)setBackgroundImage:(UIImage *)image {
    [self setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)setBackgroundImageWithName:(NSString *)fileName {
    [self setBackgroundImage:[UIImage imageNamed:fileName] forState:UIControlStateNormal];
}

- (void)setBackgroundColorHex:(NSString *)color {
    [self setBackgroundColor:[UIColor colorWithString:color]];
}

- (void)addTarget:(id)target action:(SEL)action {
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)addTarget:(id)target actionBlock:(void(^)(id button))action {
    SEL selector = [self selectorBlock:^(id weakSelf, id arg) {
         if (action) action(self);
    }];
    [self addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}

//图左文字右
- (void)imageAndTextWithSpacing:(CGFloat)spacing {
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
}

//图右文字左
- (void)textAndImageWithSpacing:(CGFloat)spacing {
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.frame.size.width, 0, self.imageView.frame.size.width-spacing)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width-spacing, 0, -self.titleLabel.bounds.size.width)];
}

//图上文字下
- (void)imageUpAndTextDownWithSpacing:(CGFloat)spacing {
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.frame.size.width, -self.imageView.frame.size.height-spacing/2, 0);
    self.imageEdgeInsets = UIEdgeInsetsMake(-self.titleLabel.intrinsicContentSize.height-spacing/2, 0, 0, -self.titleLabel.intrinsicContentSize.width);
}

@end
