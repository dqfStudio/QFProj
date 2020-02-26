//
//  HSwitchLanguage.m
//  TestProject
//
//  Created by dqf on 2018/6/5.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HSwitchLanguage.h"
#import <objc/runtime.h>

#define KHSuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define KHLocalizedString(key) \
[[HSwitchLanguage share].currentBundle localizedStringForKey:(key) value:@"" table:nil]
#define KHLocalizedStringFromTable(key, tbl) \
[[HSwitchLanguage share].currentBundle localizedStringForKey:(key) value:@"" table:(tbl)]

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

@interface HSwitchLanguage () {
    NSBundle *_currentBundle;
    NSHashTable *_hashTable;
}
@end

@implementation HSwitchLanguage
+ (HSwitchLanguage *)share {
    static HSwitchLanguage *shareInstance = nil;
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
        NSString *currentLanguage = [userDefaults valueForKey:aKey];
        /*
        if (!currentLanguage) {
            currentLanguage = KLanguageBase;
            [userDefaults setValue:currentLanguage forKey:aKey];
            [userDefaults synchronize];
        }
        //获取文件路径
        NSString *path = [[NSBundle mainBundle] pathForResource:currentLanguage ofType:@"lproj"];
        _currentBundle = [NSBundle bundleWithPath:path];
        */
        if (currentLanguage) {
            //获取文件路径
            NSString *path = [[NSBundle mainBundle] pathForResource:currentLanguage ofType:@"lproj"];
            _currentBundle = [NSBundle bundleWithPath:path];
        }
    }
    return _currentBundle;
}
//获取当前语言
- (NSString *)userLanguage {
    NSString *aKey = NSStringFromClass(self.class);
    return [[NSUserDefaults standardUserDefaults] valueForKey:aKey];
}
//设置默认语言
- (void)setDefaultLanguage:(NSString *)language {
    NSString *aKey = NSStringFromClass(self.class);
    [[NSUserDefaults standardUserDefaults] setValue:language forKey:aKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//设置语言
- (void)setUserlanguage:(NSString *)language completion:(void (^)(void))completion {
    NSString *aKey = NSStringFromClass(self.class);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *currentLanguage = [userDefaults valueForKey:aKey];
    if (![currentLanguage isEqualToString:language]) {
        
        [userDefaults setValue:language forKey:aKey];
        [userDefaults synchronize];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
        _currentBundle = [NSBundle bundleWithPath:path];
        [[HSwitchLanguage share] enumerateOperation:completion];
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
            if ([anObject isKindOfClass:UILabel.class] || [anObject isKindOfClass:UITextView.class]) {
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

@implementation UILabel (HLanguage)
+ (void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self methodSwizzleWithOrigSEL:@selector(setText:) overrideSEL:@selector(skin_setText:)];
    });
}
- (void)skin_setText:(NSString *)text {
    NSString *aKey = nil;
    if ([text isKindOfClass:NSString.class]) {
        aKey = text;
    }else if ([text isKindOfClass:NSNumber.class]) {
        aKey = [NSString stringWithFormat:@"%@", text];
    }
    if (aKey) {
        NSString *table = KSKinTable;
        NSString *content = KHLocalizedStringFromTable(aKey, table);
        if (content) {
            //保存文字颜色
            UIColor *color = self.textColor;
            [self setLanguageKey:aKey];
            //此处文字颜色会被更改掉
            [self skin_setText:content];
            //重新设置保存的文字颜色
            [self setTextColor:color];
            
            [[HSwitchLanguage share] addObject:self];
        }else {
            [self skin_setText:aKey];
        }
    }else {
        [self skin_setText:aKey];
    }
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
    NSString *aKey = nil;
    if ([text isKindOfClass:NSString.class]) {
        aKey = text;
    }else if ([text isKindOfClass:NSNumber.class]) {
        aKey = [NSString stringWithFormat:@"%@", text];
    }
    if (aKey) {
        NSString *table = KSKinTable;
        NSString *content = KHLocalizedStringFromTable(aKey, table);
        if (content) {
            //保存文字颜色
            UIColor *color = self.textColor;
            [self setLanguageKey:aKey];
            //此处文字颜色会被更改掉
            [self skin_setText:content];
            //重新设置保存的文字颜色
            [self setTextColor:color];
            
            [[HSwitchLanguage share] addObject:self];
        }else {
            [self skin_setText:aKey];
        }
    }else {
        [self skin_setText:aKey];
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
    NSString *aKey = text;
    if (aKey) {
        NSString *table = KSKinTable;
        NSString *content = KHLocalizedStringFromTable(aKey, table);
        if (content) {
            //保存文字颜色
            UIColor *color = self.textColor;
            [self setLanguageKey:aKey];
            //此处文字颜色会被更改掉
            [self skin_setText:content];
            //重新设置保存的文字颜色
            [self setTextColor:color];
            
            [[HSwitchLanguage share] addObject:self];
        }else {
            [self skin_setText:aKey];
        }
    }else {
        [self skin_setText:aKey];
    }
}
@end

