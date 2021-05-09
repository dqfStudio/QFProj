//
//  HAppLanguage.m
//  HProj
//
//  Created by dqf on 2018/6/5.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HAppLanguage.h"
#import <objc/runtime.h>

#define KHSuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define KHLocalizedString(key) \
[[HAppLanguage userDefaults].currentBundle localizedStringForKey:(key)value:@"" table:nil]
#define KHLocalizedStringFromTable(key, tbl) \
[[HAppLanguage userDefaults].currentBundle localizedStringForKey:(key)value:@"" table:(tbl)]

@interface UIView (HLanguage)
@property (nonatomic) NSString *languageKey;
@end

@implementation UIView (HLanguage)
- (NSString *)languageKey {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setLanguageKey:(NSString *)languageKey {
    objc_setAssociatedObject(self, @selector(languageKey), languageKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

@interface HAppLanguage () {
    NSBundle *_currentBundle;
    NSHashTable *_hashTable;
}
@property (nonatomic, readonly) NSBundle *currentBundle;//当前语言资源文件
@end

@implementation HAppLanguage
+ (HAppLanguage *)userDefaults {
    static HAppLanguage *shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _hashTable = [NSHashTable weakObjectsHashTable];
    }
    return self;
}
//当前语言资源文件
- (NSBundle *)currentBundle {
    if (!_currentBundle) {
        NSString *aKey = NSStringFromClass(self.class);
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *userLanguage = [userDefaults valueForKey:aKey];
        if (!userLanguage || userLanguage.length == 0) {
            userLanguage = KDefaultLanguage;
            [userDefaults setValue:userLanguage forKey:aKey];
            [userDefaults synchronize];
        }
        //获取文件路径
        NSString *path = [[NSBundle mainBundle] pathForResource:userLanguage ofType:@"lproj"];
        _currentBundle = [NSBundle bundleWithPath:path];
    }
    return _currentBundle;
}
//获取当前语言
- (NSString *)userLanguage {
    NSString *aKey = NSStringFromClass(self.class);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userLanguage = [userDefaults valueForKey:aKey];
    if (!userLanguage || userLanguage.length == 0) {
        userLanguage = KDefaultLanguage;
        [userDefaults setValue:userLanguage forKey:aKey];
        [userDefaults synchronize];
    }
    return userLanguage;
}
//设置语言
- (void)setUserlanguage:(NSString *)language completion:(void (^)(void))completion {
    NSString *aKey = NSStringFromClass(self.class);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userLanguage = [userDefaults valueForKey:aKey];
    if (![userLanguage isEqualToString:language]) {

        [userDefaults setValue:language forKey:aKey];
        [userDefaults synchronize];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
        _currentBundle = [NSBundle bundleWithPath:path];
        [[HAppLanguage userDefaults] enumerateOperation:completion];
    }
}
- (void)addObject:(id)anObject {
    [_hashTable addObject:anObject];
}
- (void)enumerateOperation:(void (^)(void))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *allObjects = [[self->_hashTable objectEnumerator] allObjects];
        //倒序执行
        for (NSUInteger i=allObjects.count-1; i>=0; i--) {
            id anObject = allObjects[i];
            if ([anObject isKindOfClass:UILabel.class] || [anObject isKindOfClass:HLabel.class] || [anObject isKindOfClass:UITextView.class] || [anObject isKindOfClass:HTextView.class]) {
                UIView *view = anObject;
                SEL selector = NSSelectorFromString(@"skin_setText:");
                if ([view respondsToSelector:selector]) {
                    NSString *aKey = view.languageKey;
                    NSString *tbl = KSKinTable;
                    NSString *content = KHLocalizedStringFromTable(aKey, tbl);
                    KHSuppressPerformSelectorLeakWarning([view performSelector:selector withObject:content];);
                }
            }
        }
        if (completion) {
            completion();
        }
    });
}
@end

@implementation HLabel (HLanguage)
+ (void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self methodSwizzleWithOrigSEL:@selector(setText:) overrideSEL:@selector(skin_setText:)];
    });
}
- (void)skin_setText:(NSString *)text {
    if ([text isKindOfClass:NSString.class] || [text isKindOfClass:NSNumber.class]) {
        NSString *aKey = text;
        if ([text isKindOfClass:NSNumber.class]) {
            //aKey = [NSString stringWithFormat:@"%@", text];
            aKey = text.stringValue;
        }
        if (aKey.length > 0) {
            NSString *table = KSKinTable;
            NSString *content = KHLocalizedStringFromTable(aKey, table);
            if (content.length > 0) {
                //保存文字颜色
                UIColor *color = self.textColor;
                [self setLanguageKey:aKey];
                //此处文字颜色会被更改掉
                [self skin_setText:content];
                //重新设置保存的文字颜色
                [self setTextColor:color];
                
                [[HAppLanguage userDefaults] addObject:self];
            }else {
                [self skin_setText:aKey];
            }
        }else {
            [self skin_setText:aKey];
        }
    }else {
        [self skin_setText:nil];
    }
}
@end

@implementation UILabel (HLanguage)
+ (void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self methodSwizzleWithOrigSEL:@selector(setText:) overrideSEL:@selector(skin_setText:)];
    });
}
- (void)skin_setText:(NSString *)text {
    if ([text isKindOfClass:NSString.class] || [text isKindOfClass:NSNumber.class]) {
        NSString *aKey = text;
        if ([text isKindOfClass:NSNumber.class]) {
            //aKey = [NSString stringWithFormat:@"%@", text];
            aKey = text.stringValue;
        }
        if (aKey.length > 0) {
            NSString *table = KSKinTable;
            NSString *content = KHLocalizedStringFromTable(aKey, table);
            if (content.length > 0) {
                //保存文字颜色
                UIColor *color = self.textColor;
                [self setLanguageKey:aKey];
                //此处文字颜色会被更改掉
                [self skin_setText:content];
                //重新设置保存的文字颜色
                [self setTextColor:color];
                
                [[HAppLanguage userDefaults] addObject:self];
            }else {
                [self skin_setText:aKey];
            }
        }else {
            [self skin_setText:aKey];
        }
    }else {
        [self skin_setText:nil];
    }
}
@end

@implementation UITextView (HLanguage)
+ (void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self methodSwizzleWithOrigSEL:@selector(setText:) overrideSEL:@selector(skin_setText:)];
    });
}
- (void)skin_setText:(NSString *)text {
    if ([text isKindOfClass:NSString.class] || [text isKindOfClass:NSNumber.class]) {
        NSString *aKey = text;
        if ([text isKindOfClass:NSNumber.class]) {
            //aKey = [NSString stringWithFormat:@"%@", text];
            aKey = text.stringValue;
        }
        if (aKey.length > 0) {
            NSString *table = KSKinTable;
            NSString *content = KHLocalizedStringFromTable(aKey, table);
            if (content.length > 0) {
                //保存文字颜色
                UIColor *color = self.textColor;
                [self setLanguageKey:aKey];
                //此处文字颜色会被更改掉
                [self skin_setText:content];
                //重新设置保存的文字颜色
                [self setTextColor:color];
                
                [[HAppLanguage userDefaults] addObject:self];
            }else {
                [self skin_setText:aKey];
            }
        }else {
            [self skin_setText:aKey];
        }
    }else {
        [self skin_setText:nil];
    }
}
@end

@implementation HTextView (HLanguage)
+ (void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self methodSwizzleWithOrigSEL:@selector(setText:) overrideSEL:@selector(skin_setText:)];
    });
}
- (void)skin_setText:(NSString *)text {
    if ([text isKindOfClass:NSString.class] || [text isKindOfClass:NSNumber.class]) {
        NSString *aKey = text;
        if ([text isKindOfClass:NSNumber.class]) {
            //aKey = [NSString stringWithFormat:@"%@", text];
            aKey = text.stringValue;
        }
        if (aKey.length > 0) {
            NSString *table = KSKinTable;
            NSString *content = KHLocalizedStringFromTable(aKey, table);
            if (content.length > 0) {
                //保存文字颜色
                UIColor *color = self.textColor;
                [self setLanguageKey:aKey];
                //此处文字颜色会被更改掉
                [self skin_setText:content];
                //重新设置保存的文字颜色
                [self setTextColor:color];
                
                [[HAppLanguage userDefaults] addObject:self];
            }else {
                [self skin_setText:aKey];
            }
        }else {
            [self skin_setText:aKey];
        }
    }else {
        [self skin_setText:nil];
    }
}
@end
