//
//  HWebButtonView.m
//  PCommunityKitDemo
//
//  Created by zhangchutian on 15/8/6.
//  Copyright (c) 2015年 vstudio. All rights reserved.
//

#import "HWebButtonView.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIView+WebCache.h>

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
    [self initialize];
}
- (void)initialize {
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.layer.masksToBounds = YES;
    [self addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
}
- (UIImageView *)_imageView {
    if (!__imageView) {
        __imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        __imageView.contentMode = UIViewContentModeScaleAspectFill;
        __imageView.layer.masksToBounds = YES;
        __imageView.userInteractionEnabled = NO;
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
    }else {
        self._imageView.image = nil;
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
- (void)setImage:(UIImage *)image {
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
        [__imageView sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
        [self setImage:image];
    }else {
        [self _setImage:nil];
        self.lastURL = nil;
        if (self.didGetError) self.didGetError(self, herr(kDataFormatErrorCode, ([NSString stringWithFormat:@"url = %@", fileName])));
    }
}
- (void)setImageWithName:(NSString *)fileName {
    if (fileName.length > 0) {
        [self setImage:[UIImage imageNamed:fileName]];
    }
}
- (void)buttonPressed {
    if (_pressed) _pressed(self, nil);
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
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self._imageView.backgroundColor = backgroundColor;
}
- (UIColor *)backgroundColor {
    return self._imageView.backgroundColor;
}
@end
