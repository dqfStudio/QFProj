//
//  HWebImageView.m
//  PCommunityKitDemo
//
//  Created by zhangchutian on 15/8/5.
//  Copyright (c) 2015年 vstudio. All rights reserved.
//

#import "HWebImageView.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIView+WebCache.h>

@interface HWebImageView ()
@property (nonatomic) NSString *lastURL;
@property (nonatomic) UITapGestureRecognizer *tapGesture;
@end

@implementation HWebImageView

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
    //self.backgroundColor = [UIColor colorWithHex:0xe8e8e8];
    self.backgroundColor = [UIColor clearColor];
    [self initialize];
}
- (void)initialize {
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.layer.masksToBounds = YES;
}
- (void)_setImage:(UIImage *)image {
    [self sd_cancelCurrentImageLoad];
    if (image != nil) {
        if (self.renderColor) {
            self.tintColor = self.renderColor;
            super.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }else {
            super.image = image;
        }
    }else {
        super.image = nil;
    }
}
- (void)setRenderColor:(UIColor *)renderColor {
    _renderColor = renderColor;
    if (self.renderColor) {
        self.tintColor = self.renderColor;
        super.image = [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }else {
        super.image = [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
}
- (void)setImage:(UIImage *)image {
    [self _setImage:image];
    self.lastURL = nil;
    self.placeHoderImage = nil;
    self.alpha = 1;
    if (self.didGetImage) self.didGetImage(self, image);
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
        [self _setImage:[UIImage imageNamed:urlString]];
        self.alpha = 1;
        if (self.didGetImage) self.didGetImage(self, self.image);
        return;
    }
    if (self.image && [_lastURL isEqual:urlString]) {
        self.alpha = 1;
        if (self.didGetImage) self.didGetImage(self, self.image);
        return;
    }
    if(!self.placeHoderImage && !self.image) self.alpha = 0;
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
            self.alpha = 1;
            self.lastURL = url.absoluteString;
            if (self.didGetImage) self.didGetImage(self, image);
        }
    }
    if (!self.image) {
        [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            @strongify(self);
            if (error) {
                if (self.didGetError) self.didGetError(self, error);
            }else if (image) {
                [self _setImage:image];
                self.lastURL = url.absoluteString;
                if (SDImageCacheTypeNone == cacheType) {
                    [UIView animateWithDuration:0.5 animations:^{
                        self.alpha = 1;
                    }];
                }else {
                    self.alpha = 1;
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
- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] init];
        _tapGesture.numberOfTapsRequired = 1;
        _tapGesture.numberOfTouchesRequired = 1;
        [_tapGesture addTarget:self action:@selector(tapGestureAction)];
    }
    return _tapGesture;
}
- (void)tapGestureAction {
    if (_pressed) _pressed(self, nil);
}
- (void)setPressed:(callback)pressed {
    if (_pressed != pressed) {
        _pressed = nil;
        _pressed = pressed;
        if (pressed) {
            [self setUserInteractionEnabled:YES];
            if (!self.tapGesture.view) {
                [self addGestureRecognizer:self.tapGesture];
            }
        }else {
            [self setUserInteractionEnabled:NO];
        }
    }
}
@end

