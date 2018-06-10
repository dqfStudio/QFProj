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

@interface HSkin ()
@property (nonatomic) NSString *currentSubject;
@property (nonatomic) NSBundle *currentBundle;
@property (nonatomic) NSDictionary *currentFontDict;
@property (nonatomic) NSDictionary *currentColorDict;
+ (HSkin *)share;
- (UIFont *)fontWithKey:(NSString *)aKey;
- (UIColor *)colorWithKey:(NSString *)aKey;
- (UIImage *)imageWithKey:(NSString *)aKey ofType:(nullable NSString *)ext;
@end

@interface _HSkinUtil : NSObject
@property (nonatomic) NSHashTable *hashTable;
+ (_HSkinUtil *)share;
- (void)addObject:(id)anObject operation:(SEL)selector;
- (void)enumerateOperation;
@end

@interface UIView (UISkinKeys)
@property (nonatomic) NSString *fontKey;
@property (nonatomic) NSString *fontSelector;

@property (nonatomic) NSString *textColorKey;
@property (nonatomic) NSString *textColorSelector;

@property (nonatomic) NSString *selectedTextColorKey;
@property (nonatomic) NSString *selectedTextColorSelector;

@property (nonatomic) NSString *backgroundColorKey;
@property (nonatomic) NSString *backgroundColorSelector;

@property (nonatomic) NSString *imageKey;
@property (nonatomic) NSString *imageSelector;

@property (nonatomic) NSString *seletedImageKey;
@property (nonatomic) NSString *selectedImageSelector;
@end

@implementation UIView (UISkinKeys)
- (NSString *)fontKey {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setFontKey:(NSString *)fontKey {
    objc_setAssociatedObject(self, @selector(fontKey), fontKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)fontSelector {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setFontSelector:(NSString *)fontSelector {
    objc_setAssociatedObject(self, @selector(fontSelector), fontSelector, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSString *)textColorKey {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setTextColorKey:(NSString *)textColorKey {
    objc_setAssociatedObject(self, @selector(textColorKey), textColorKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)textColorSelector {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setTextColorSelector:(NSString *)textColorSelector {
    objc_setAssociatedObject(self, @selector(textColorSelector), textColorSelector, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSString *)selectedTextColorKey {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setSelectedTextColorKey:(NSString *)selectedTextColorKey {
    objc_setAssociatedObject(self, @selector(selectedTextColorKey), selectedTextColorKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)selectedTextColorSelector {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setSelectedTextColorSelector:(NSString *)selectedTextColorSelector {
    objc_setAssociatedObject(self, @selector(selectedTextColorSelector), selectedTextColorSelector, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSString *)backgroundColorKey {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setBackgroundColorKey:(NSString *)backgroundColorKey {
    objc_setAssociatedObject(self, @selector(backgroundColorKey), backgroundColorKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)backgroundColorSelector {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setBackgroundColorSelector:(NSString *)backgroundColorSelector {
    objc_setAssociatedObject(self, @selector(backgroundColorSelector), backgroundColorSelector, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSString *)imageKey {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setImageKey:(NSString *)imageKey {
    objc_setAssociatedObject(self, @selector(imageKey), imageKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)imageSelector {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setImageSelector:(NSString *)imageSelector {
    objc_setAssociatedObject(self, @selector(imageSelector), imageSelector, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSString *)seletedImageKey {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setSeletedImageKey:(NSString *)seletedImageKey {
    objc_setAssociatedObject(self, @selector(seletedImageKey), seletedImageKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)selectedImageSelector {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setSelectedImageSelector:(NSString *)selectedImageSelector {
    objc_setAssociatedObject(self, @selector(selectedImageSelector), selectedImageSelector, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
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
- (void)addObject:(id)anObject operation:(SEL)selector {
    @synchronized(self) {
        if ([anObject isKindOfClass:UIView.class]) {
            UIView *v = anObject;
            NSString *seltor = NSStringFromSelector(selector);
            if ([seltor isEqualToString:NSStringFromSelector(@selector(setBackgroundColor:))]) {
                [v setBackgroundColorSelector:seltor];
            }
        }
        if ([anObject isKindOfClass:UILabel.class]) {
            UILabel *label = anObject;
            NSString *seltor = NSStringFromSelector(selector);
            if ([seltor isEqualToString:NSStringFromSelector(@selector(setFont:))]) {
                [label setFontSelector:seltor];
            }else if ([seltor isEqualToString:NSStringFromSelector(@selector(setTextColor:))]) {
                [label setTextColorSelector:seltor];
            }
            [self.hashTable addObject:label];
        }else if ([anObject isKindOfClass:UITextView.class]) {
            UITextView *textView = anObject;
            NSString *seltor = NSStringFromSelector(selector);
            if ([seltor isEqualToString:NSStringFromSelector(@selector(setFont:))]) {
                [textView setFontSelector:seltor];
            }else if ([seltor isEqualToString:NSStringFromSelector(@selector(setTextColor:))]) {
                [textView setTextColorSelector:seltor];
            }
            [self.hashTable addObject:textView];
        }else if ([anObject isKindOfClass:UIButton.class]) {
            UIButton *button = anObject;
            NSString *seltor = NSStringFromSelector(selector);
            if ([seltor isEqualToString:NSStringFromSelector(@selector(setFont:))]) {
                [button setFontSelector:seltor];
            }else if ([seltor isEqualToString:NSStringFromSelector(@selector(setTextColor:))]) {
                [button setTextColorSelector:seltor];
            }else if ([seltor isEqualToString:NSStringFromSelector(@selector(setImageSelector:))]) {
                [button setImageSelector:seltor];
            }
            [self.hashTable addObject:button];
        }else if ([anObject isKindOfClass:UIImageView.class]) {
            UIImageView *imageView = anObject;
            NSString *seltor = NSStringFromSelector(selector);
            if ([seltor isEqualToString:NSStringFromSelector(@selector(setImageSelector:))]) {
                [imageView setImageSelector:seltor];
            }
            [self.hashTable addObject:imageView];
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
                        UIFont *content = [[HSkin share] fontWithKey:key];
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
                        UIFont *content = [[HSkin share] fontWithKey:key];
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
                        UIFont *content = [[HSkin share] fontWithKey:key];
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
    [self setBackgroundColor:[[HSkin share] colorWithKey:key]];
    [[_HSkinUtil share] addObject:self operation:@selector(setBackgroundColor:)];
}
@end

@implementation UILabel (UISkin)
- (void)skin_setFont:(NSString *)font {
    NSString *key = [font mutableCopy];
    [self setFontKey:key];
    [self setFont:[[HSkin share] fontWithKey:key]];
    [[_HSkinUtil share] addObject:self operation:@selector(setFont:)];
}
- (void)skin_setTextColor:(NSString *)color {
    NSString *key = [color mutableCopy];
    [self setTextColorKey:key];
    [self setTextColor:[[HSkin share] colorWithKey:key]];
    [[_HSkinUtil share] addObject:self operation:@selector(setTextColor:)];
}
@end

@implementation UIButton (UISkin)
- (void)skin_setFont:(NSString *)font {
    NSString *key = [font mutableCopy];
    [self setFontKey:key];
    [self.titleLabel setFont:[[HSkin share] fontWithKey:key]];
    [[_HSkinUtil share] addObject:self operation:@selector(setFont:)];
}
- (void)skin_setNormalTextColor:(NSString *)color {
    NSString *key = [color mutableCopy];
    [self setTextColorKey:key];
    [self setTitleColor:[[HSkin share] colorWithKey:key] forState:UIControlStateNormal];
    [[_HSkinUtil share] addObject:self operation:@selector(setTitleColor:forState:)];
}
- (void)skin_setSelectedTextColor:(NSString *)color {
    NSString *key = [color mutableCopy];
    [self setSelectedTextColorSelector:key];
    [self setTitleColor:[[HSkin share] colorWithKey:key] forState:UIControlStateSelected];
    [[_HSkinUtil share] addObject:self operation:@selector(setTitleColor:forState:)];
}
- (void)skin_setNormalImage:(NSString *)image {
    NSString *key = [image mutableCopy];
    [self setImageKey:key];
    [self setImage:[[HSkin share] imageWithKey:key ofType:nil] forState:UIControlStateNormal];
    [[_HSkinUtil share] addObject:self operation:@selector(setImage:forState:)];
}
- (void)skin_setSelectedImage:(NSString *)image {
    NSString *key = [image mutableCopy];
    [self setSeletedImageKey:key];
    [self setImage:[[HSkin share] imageWithKey:key ofType:nil] forState:UIControlStateSelected];
    [[_HSkinUtil share] addObject:self operation:@selector(setImage:forState:)];
}
@end

@implementation UITextView (UISkin)
- (void)skin_setFont:(NSString *)font {
    NSString *key = [font mutableCopy];
    [self setFontKey:key];
    [self setFont:[[HSkin share] fontWithKey:key]];
    [[_HSkinUtil share] addObject:self operation:@selector(setFont:)];
}
- (void)skin_setTextColor:(NSString *)color {
    NSString *key = [color mutableCopy];
    [self setTextColorKey:key];
    [self setTextColor:[[HSkin share] colorWithKey:key]];
    [[_HSkinUtil share] addObject:self operation:@selector(setTextColor:)];
}
@end

@implementation UIImageView (UISkin)
- (void)skin_setImage:(NSString *)image {
    NSString *key = [image mutableCopy];
    [self setImageKey:key];
    [self setImage:[[HSkin share] imageWithKey:key ofType:nil]];
    [[_HSkinUtil share] addObject:self operation:@selector(setImage:)];
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

- (UIFont *)fontWithKey:(NSString *)aKey {
    if (!aKey) {
        NSString *value = self.currentFontDict[aKey];
        return [UIFont systemFontOfSize:value.integerValue];
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

