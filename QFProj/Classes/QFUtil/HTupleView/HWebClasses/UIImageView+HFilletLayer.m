//
//  UIImageView+HFilletLayer.m
//  QFProj
//
//  Created by wind on 2019/9/5.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "UIImageView+HFilletLayer.h"

@implementation UIImageView (HFilletLayer)
- (BOOL)fillet {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setFillet:(BOOL)fillet {
    objc_setAssociatedObject(self, @selector(fillet), @(fillet), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (fillet) {
        [self addFilletLayer];
    }
}
- (UIImageViewFilletStyle)filletStyle {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (void)setFilletStyle:(UIImageViewFilletStyle)filletStyle {
    if (self.filletStyle != filletStyle) {
        if (self.fillet && self.image) {
            [self addFilletLayer];
        }
    }
    objc_setAssociatedObject(self, @selector(filletStyle), @(filletStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] methodSwizzleWithOrigSEL:@selector(setImage:) overrideSEL:@selector(pvc_setImage:)];
        [[self class] methodSwizzleWithOrigSEL:@selector(setFrame:) overrideSEL:@selector(pvc_setFrame:)];
    });
}
- (void)pvc_setImage:(UIImage *)image {
    [self pvc_setImage:image];
    if (self.fillet && image) {
        [self addFilletLayer];
    }
}
- (void)pvc_setFrame:(CGRect)frame {
    if (!CGRectEqualToRect(self.frame, frame)) {
        [self pvc_setFrame:frame];
        if (self.fillet && self.image) {
            [self addFilletLayer];
        }
    }
}
- (void)addFilletLayer {
    if (self.image) {
        CGFloat width = CGRectGetWidth(self.frame);
        CGFloat height = CGRectGetHeight(self.frame);
        
        if (width == height) {
            self.layer.cornerRadius = width/2;
            self.layer.masksToBounds = YES;
        }else {
            CGFloat value = width;
            if (height < width) value = height;
            
            CGFloat originX = width/2-value/2;
            CGFloat originY = height/2-value/2;
            if (originX > 0) {
                
                switch (self.filletStyle) {
                    case UIImageViewFilletCenter:
                        self.layer.frame = CGRectMake(width/2-value/2, height/2-value/2, value, value);
                        break;
                    case UIImageViewFilletLeftOrTop:
                        self.layer.frame = CGRectMake(0, height/2-value/2, value, value);
                        break;
                    case UIImageViewFilletRightOrBottom:
                        self.layer.frame = CGRectMake(width-value, height/2-value/2, value, value);
                        break;
                        
                    default:
                        break;
                }
                
            }else if (originY > 0) {
                
                switch (self.filletStyle) {
                    case UIImageViewFilletCenter:
                        self.layer.frame = CGRectMake(width/2-value/2, height/2-value/2, value, value);
                        break;
                    case UIImageViewFilletLeftOrTop:
                        self.layer.frame = CGRectMake(width/2-value/2, 0, value, value);
                        break;
                    case UIImageViewFilletRightOrBottom:
                        self.layer.frame = CGRectMake(width/2-value/2, height-value, value, value);
                        break;
                        
                    default:
                        break;
                }
            }
            self.layer.cornerRadius = value/2;
            self.layer.masksToBounds = YES;
        }
    }
}
@end
