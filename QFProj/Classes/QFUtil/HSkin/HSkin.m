//
//  HSkin.m
//  TestProject
//
//  Created by dqf on 2018/6/9.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HSkin.h"
#import <objc/runtime.h>

#define HCurrentBundlePath [[NSBundle mainBundle] pathForResource:[HSkin share].currentSubject ofType:@"bundle"]

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define H_SkinProperty(p, setP) \
- (NSString *)p {\
return objc_getAssociatedObject(self, _cmd);\
}\
- (void)setP:(NSString *)p {\
    objc_setAssociatedObject(self, @selector(p), p, OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}

@interface HSkin ()
@property (nonatomic) NSString *currentSubject;
@property (nonatomic) NSBundle *currentBundle;
@property (nonatomic) NSDictionary *currentFontDict;
@property (nonatomic) NSDictionary *currentColorDict;
+ (HSkin *)share;
- (UIFont *)fontWithKey:(NSString *)aKey type:(NSNumber *)type;
- (UIColor *)colorWithKey:(NSString *)aKey;
- (UIImage *)imageWithKey:(NSString *)aKey ofType:(nullable NSString *)ext;
@end

@interface _HSkinUtil : NSObject
@property (nonatomic) NSHashTable *hashTable;
+ (_HSkinUtil *)share;
- (void)addObject:(id)anObject;
- (void)enumerateOperation;
@end

@interface UIView (UISkinKeys)
@property (nonatomic) NSString  *fontKey;
@property (nonatomic) NSNumber  *fontType;
@property (nonatomic) NSString  *fontSelector;

@property (nonatomic) NSString  *textColorKey;
@property (nonatomic) NSString  *textColorSelector;

@property (nonatomic) NSString  *selectedTextColorKey;
@property (nonatomic) NSString  *selectedTextColorSelector;

@property (nonatomic) NSString  *backgroundColorKey;
@property (nonatomic) NSString  *backgroundColorSelector;

@property (nonatomic) NSString  *imageKey;
@property (nonatomic) NSString  *imageSelector;

@property (nonatomic) NSString  *seletedImageKey;
@property (nonatomic) NSString  *selectedImageSelector;
@end

@implementation UIView (UISkinKeys)

H_SkinProperty(fontKey, setFontKey)
H_SkinProperty(fontType, setFontType)
H_SkinProperty(fontSelector, setFontSelector)

H_SkinProperty(textColorKey, setTextColorKey)
H_SkinProperty(textColorSelector, setTextColorSelector)

H_SkinProperty(selectedTextColorKey, setSelectedTextColorKey)
H_SkinProperty(selectedTextColorSelector, setSelectedTextColorSelector)

H_SkinProperty(backgroundColorKey, setBackgroundColorKey)
H_SkinProperty(backgroundColorSelector, setBackgroundColorSelector)

H_SkinProperty(imageKey, setImageKey)
H_SkinProperty(imageSelector, setImageSelector)

H_SkinProperty(seletedImageKey, setSeletedImageKey)
H_SkinProperty(selectedImageSelector, setSelectedImageSelector)

@end

@implementation _HSkinUtil
- (NSHashTable *)hashTable {
    if (!_hashTable) {
        _hashTable = [NSHashTable weakObjectsHashTable];
    }
    return _hashTable;
}
+ (_HSkinUtil *)share {
    static _HSkinUtil *shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}
- (void)addObject:(id)anObject {
    @synchronized(self) {
        if ([anObject isKindOfClass:UIView.class]) {
            [self.hashTable addObject:anObject];
        }
    }
}
- (void)enumerateOperation {
    @synchronized(self) {
        NSArray *allObjects = [[self.hashTable objectEnumerator] allObjects];
        //倒序执行
        for (NSUInteger i=allObjects.count; i>0; i--) {
            id anObject = allObjects[i-1];
            if ([anObject isKindOfClass:UIView.class]) {
                UIView *v = anObject;
                if (v.backgroundColorSelector) {
                    SEL selector = NSSelectorFromString(v.backgroundColorSelector);
                    if ([v respondsToSelector:selector]) {
                        NSString *key = v.fontKey;
                        UIColor *content = [[HSkin share] colorWithKey:key];
                        SuppressPerformSelectorLeakWarning([v performSelector:selector withObject:content];);
                    }
                }
            }
            if ([anObject isKindOfClass:UILabel.class]) {
                UILabel *label = anObject;
                if (label.fontSelector) {
                    SEL selector = NSSelectorFromString(label.fontSelector);
                    if ([label respondsToSelector:selector]) {
                        NSString *key = label.fontKey;
                        UIFont *content = [[HSkin share] fontWithKey:key type:label.fontType];
                        SuppressPerformSelectorLeakWarning([label performSelector:selector withObject:content];);
                    }
                }else if (label.textColorSelector) {
                    SEL selector = NSSelectorFromString(label.textColorSelector);
                    if ([label respondsToSelector:selector]) {
                        NSString *key = label.textColorKey;
                        UIColor *content = [[HSkin share] colorWithKey:key];
                        SuppressPerformSelectorLeakWarning([label performSelector:selector withObject:content];);
                    }
                }
            }else if ([anObject isKindOfClass:UITextView.class]) {
                UITextView *textView = anObject;
                if (textView.fontSelector) {
                    SEL selector = NSSelectorFromString(textView.fontSelector);
                    if ([textView respondsToSelector:selector]) {
                        NSString *key = textView.fontKey;
                        UIFont *content = [[HSkin share] fontWithKey:key type:textView.fontType];
                        SuppressPerformSelectorLeakWarning([textView performSelector:selector withObject:content];);
                    }
                }else if (textView.textColorSelector) {
                    SEL selector = NSSelectorFromString(textView.textColorSelector);
                    if ([textView respondsToSelector:selector]) {
                        NSString *key = textView.textColorKey;
                        UIColor *content = [[HSkin share] colorWithKey:key];
                        SuppressPerformSelectorLeakWarning([textView performSelector:selector withObject:content];);
                    }
                }
            }else if ([anObject isKindOfClass:UIButton.class]) {
                UIButton *button = anObject;
                if (button.fontSelector) {
                    SEL selector = NSSelectorFromString(button.fontSelector);
                    if ([button respondsToSelector:selector]) {
                        NSString *key = button.fontKey;
                        UIFont *content = [[HSkin share] fontWithKey:key type:button.fontType];
                        SuppressPerformSelectorLeakWarning([button performSelector:selector withObject:content];);
                    }
                }else if (button.textColorSelector) {
                    SEL selector = NSSelectorFromString(button.textColorSelector);
                    if ([button respondsToSelector:selector]) {
                        NSString *key = button.textColorKey;
                        UIColor *content = [[HSkin share] colorWithKey:key];
                        NSUInteger state = UIControlStateNormal;
                        
                        SEL selector = @selector(setTitleColor:forState:);
                        NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
                        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                        [invocation setTarget:self];
                        [invocation setSelector:selector];
                        
                        [invocation setArgument:&content atIndex:2];
                        [invocation setArgument:&state atIndex:3];
                        [invocation invoke];
                    }
                }else if (button.selectedTextColorSelector) {
                    SEL selector = NSSelectorFromString(button.selectedTextColorSelector);
                    if ([button respondsToSelector:selector]) {
                        NSString *key = button.selectedTextColorKey;
                        UIColor *content = [[HSkin share] colorWithKey:key];
                        NSUInteger state = UIControlStateSelected;
                        
                        SEL selector = @selector(setTitleColor:forState:);
                        NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
                        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                        [invocation setTarget:self];
                        [invocation setSelector:selector];
                        
                        [invocation setArgument:&content atIndex:2];
                        [invocation setArgument:&state atIndex:3];
                        [invocation invoke];
                    }
                }else if (button.imageSelector) {
                    SEL selector = NSSelectorFromString(button.imageSelector);
                    if ([button respondsToSelector:selector]) {
                        NSString *key = button.imageKey;
                        UIImage *content = [[HSkin share] imageWithKey:key ofType:nil];
                        NSUInteger state = UIControlStateNormal;
                        
                        SEL selector = @selector(setImage:forState:);
                        NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
                        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                        [invocation setTarget:self];
                        [invocation setSelector:selector];
                        
                        [invocation setArgument:&content atIndex:2];
                        [invocation setArgument:&state atIndex:3];
                        [invocation invoke];
                    }
                }else if (button.selectedImageSelector) {
                    SEL selector = NSSelectorFromString(button.selectedImageSelector);
                    if ([button respondsToSelector:selector]) {
                        NSString *key = button.seletedImageKey;
                        UIImage *content = [[HSkin share] imageWithKey:key ofType:nil];
                        NSUInteger state = UIControlStateSelected;
                        
                        SEL selector = @selector(setImage:forState:);
                        NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
                        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                        [invocation setTarget:self];
                        [invocation setSelector:selector];
                        
                        [invocation setArgument:&content atIndex:2];
                        [invocation setArgument:&state atIndex:3];
                        [invocation invoke];
                    }
                }
            }else if ([anObject isKindOfClass:UIImageView.class]) {
                UIImageView *imageView = anObject;
                if (imageView.imageSelector) {
                    SEL selector = NSSelectorFromString(imageView.imageSelector);
                    if ([imageView respondsToSelector:selector]) {
                        NSString *key = imageView.imageKey;
                        UIImage *content = [[HSkin share] imageWithKey:key ofType:nil];
                        SuppressPerformSelectorLeakWarning([imageView performSelector:selector withObject:content];);
                    }
                }
            }
        }
    }
}
@end

@implementation UIView (UISkin)
- (void)skin_setBackgroundColor:(NSString *)color {
    NSString *key = [color mutableCopy];
    [self setBackgroundColorKey:key];
    [self setBackgroundColorSelector:NSStringFromSelector(@selector(setBackgroundColor:))];
    [self setBackgroundColor:[[HSkin share] colorWithKey:key]];
    [[_HSkinUtil share] addObject:self];
}
@end

@implementation UILabel (UISkin)
- (void)skin_setFont:(NSString *)font {
    NSString *key = [font mutableCopy];
    [self setFontKey:key];
    [self setFontType:@(0)];
    [self setFontSelector:NSStringFromSelector(@selector(setFont:))];
    [self setFont:[[HSkin share] fontWithKey:key type:@(0)]];
    [[_HSkinUtil share] addObject:self];
}
- (void)skin_setBoldFont:(NSString *)font {
    NSString *key = [font mutableCopy];
    [self setFontKey:key];
    [self setFontType:@(1)];
    [self setFontSelector:NSStringFromSelector(@selector(setFont:))];
    [self setFont:[[HSkin share] fontWithKey:key type:@(1)]];
    [[_HSkinUtil share] addObject:self];
}
- (void)skin_setTextColor:(NSString *)color {
    NSString *key = [color mutableCopy];
    [self setTextColorKey:key];
    [self setTextColorSelector:NSStringFromSelector(@selector(setTextColor:))];
    [self setTextColor:[[HSkin share] colorWithKey:key]];
    [[_HSkinUtil share] addObject:self];
}
@end

@implementation UIButton (UISkin)
- (void)skin_setFont:(NSString *)font {
    NSString *key = [font mutableCopy];
    [self setFontKey:key];
    [self setFontType:@(0)];
    [self setFontSelector:NSStringFromSelector(@selector(setFont:))];
    [self.titleLabel setFont:[[HSkin share] fontWithKey:key type:@(0)]];
    [[_HSkinUtil share] addObject:self];
}
- (void)skin_setBoldFont:(NSString *)font {
    NSString *key = [font mutableCopy];
    [self setFontKey:key];
    [self setFontType:@(1)];
    [self setFontSelector:NSStringFromSelector(@selector(setFont:))];
    [self.titleLabel setFont:[[HSkin share] fontWithKey:key type:@(1)]];
    [[_HSkinUtil share] addObject:self];
}
- (void)skin_setNormalTextColor:(NSString *)color {
    NSString *key = [color mutableCopy];
    [self setTextColorKey:key];
    [self setTextColorSelector:NSStringFromSelector(@selector(setTitleColor:forState:))];
    [self setTitleColor:[[HSkin share] colorWithKey:key] forState:UIControlStateNormal];
    [[_HSkinUtil share] addObject:self];
}
- (void)skin_setSelectedTextColor:(NSString *)color {
    NSString *key = [color mutableCopy];
    [self setSelectedTextColorSelector:key];
    [self setSelectedTextColorSelector:NSStringFromSelector(@selector(setTitleColor:forState:))];
    [self setTitleColor:[[HSkin share] colorWithKey:key] forState:UIControlStateSelected];
    [[_HSkinUtil share] addObject:self];
}
- (void)skin_setNormalImage:(NSString *)image {
    NSString *key = [image mutableCopy];
    [self setImageKey:key];
    [self setImageSelector:NSStringFromSelector(@selector(setImage:forState:))];
    [self setImage:[[HSkin share] imageWithKey:key ofType:nil] forState:UIControlStateNormal];
    [[_HSkinUtil share] addObject:self];
}
- (void)skin_setSelectedImage:(NSString *)image {
    NSString *key = [image mutableCopy];
    [self setSeletedImageKey:key];
    [self setSelectedImageSelector:NSStringFromSelector(@selector(setImage:forState:))];
    [self setImage:[[HSkin share] imageWithKey:key ofType:nil] forState:UIControlStateSelected];
    [[_HSkinUtil share] addObject:self];
}
@end

@implementation UITextView (UISkin)
- (void)skin_setFont:(NSString *)font {
    NSString *key = [font mutableCopy];
    [self setFontKey:key];
    [self setFontType:@(0)];
    [self setFontSelector:NSStringFromSelector(@selector(setFont:))];
    [self setFont:[[HSkin share] fontWithKey:key type:@(0)]];
    [[_HSkinUtil share] addObject:self];
}
- (void)skin_setBoldFont:(NSString *)font {
    NSString *key = [font mutableCopy];
    [self setFontKey:key];
    [self setFontType:@(1)];
    [self setFontSelector:NSStringFromSelector(@selector(setFont:))];
    [self setFont:[[HSkin share] fontWithKey:key type:@(1)]];
    [[_HSkinUtil share] addObject:self];
}
- (void)skin_setTextColor:(NSString *)color {
    NSString *key = [color mutableCopy];
    [self setTextColorKey:key];
    [self setTextColorSelector:NSStringFromSelector(@selector(setTextColor:))];
    [self setTextColor:[[HSkin share] colorWithKey:key]];
    [[_HSkinUtil share] addObject:self];
}
@end

@implementation UIImageView (UISkin)
- (void)skin_setImage:(NSString *)image {
    NSString *key = [image mutableCopy];
    [self setImageKey:key];
    [self setImageSelector:NSStringFromSelector(@selector(setImage:))];
    [self setImage:[[HSkin share] imageWithKey:key ofType:nil]];
    [[_HSkinUtil share] addObject:self];
}
@end

@implementation HSkin
+ (HSkin *)share {
    static HSkin *shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}
- (id)init {
    self = [super init];
    if (self) {
        NSString *key = NSStringFromClass(self.class);
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *currSkin = [userDefaults valueForKey:key];
        if(!currSkin){
            [userDefaults setValue:KSkinBase forKey:key];
            [userDefaults synchronize];
        }
        //获取文件路径
        self.currentBundle = [NSBundle bundleWithPath:HCurrentBundlePath];
        
        NSString *colorPath = [self.currentBundle pathForResource:KSKinColor ofType:@"plist"];;
        NSString *fontPath  = [self.currentBundle pathForResource:KSKinFont ofType:@"plist"];
        
        self.currentColorDict = [NSDictionary dictionaryWithContentsOfFile:colorPath];
        self.currentFontDict = [NSDictionary dictionaryWithContentsOfFile:fontPath];
    }
    return self;
}

- (UIFont *)fontWithKey:(NSString *)aKey type:(NSNumber *)type {
    if (!aKey) {
        NSString *value = self.currentFontDict[aKey];
        if (type.intValue == 0) return [UIFont systemFontOfSize:value.integerValue];
        return [UIFont boldSystemFontOfSize:value.integerValue];
    }
    return nil;
}
- (UIColor *)colorWithKey:(NSString *)aKey {
    if (!aKey) {
        NSString *value = self.currentColorDict[aKey];;
        return [UIColor colorWithString:value];
    }
    return nil;
}
- (UIImage *)imageWithKey:(NSString *)aKey ofType:(nullable NSString *)ext {
    if (!aKey) {
        if (!ext) ext = @"png";
        NSString *imagePath = [self.currentBundle pathForResource:aKey ofType:ext inDirectory:KSKinImage];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        return image;
    }
    return nil;
}
//获取当前皮肤主题
+ (NSString *)userSubject {
    NSString *key = NSStringFromClass(self.class);
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}
//设置皮肤主题
+ (void)setUserSubject:(NSString *)suject {
    @synchronized(self) {
        NSString *key = NSStringFromClass(self.class);
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *currSuject = [userDefaults valueForKey:key];
        if (![currSuject isEqualToString:suject]) {
            
            [userDefaults setValue:suject forKey:key];
            [userDefaults synchronize];
            
            //获取文件路径
            [HSkin share].currentBundle = [NSBundle bundleWithPath:HCurrentBundlePath];
            
            NSString *colorPath = [[HSkin share].currentBundle pathForResource:KSKinColor ofType:@"plist"];;
            NSString *fontPath  = [[HSkin share].currentBundle pathForResource:KSKinFont ofType:@"plist"];
            
            [HSkin share].currentColorDict = [NSDictionary dictionaryWithContentsOfFile:colorPath];
            [HSkin share].currentFontDict = [NSDictionary dictionaryWithContentsOfFile:fontPath];
            
            [[_HSkinUtil share] enumerateOperation];
        }
    }
}
@end

