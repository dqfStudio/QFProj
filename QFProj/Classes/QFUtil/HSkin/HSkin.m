//
//  HSkin.m
//  TestProject
//
//  Created by dqf on 2018/6/9.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HSkin.h"
#import <objc/runtime.h>

#define HLocalizedString(key) \
[[HSkin share].currentBundle localizedStringForKey:(key) value:@"" table:nil]
#define HLocalizedStringFromTable(key, tbl) \
[[HSkin share].currentBundle localizedStringForKey:(key) value:@"" table:(tbl)]

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@interface HSkin ()
@property (nonatomic) NSBundle *currentBundle;
+ (HSkin *)share;
@end

@interface _HSkinUtil : NSObject
@property (nonatomic) NSHashTable *hashTable;
+ (_HSkinUtil *)share;
- (void)addObject:(id)anObject operation:(SEL)selector;
- (void)enumerateOperation;
@end

@interface UIView (UISkinKeys)
@property (nonatomic) NSString *skinKey;
@property (nonatomic) NSString *skinSelector;
@end

@implementation UIView (UISkinKeys)
- (NSString *)skinKey {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setSkinKey:(NSString *)skinKey {
    objc_setAssociatedObject(self, @selector(skinKey), skinKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)skinSelector {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setSkinSelector:(NSString *)skinSelector {
    objc_setAssociatedObject(self, @selector(skinSelector), skinSelector, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
            [v setSkinSelector:NSStringFromSelector(selector)];
            [self.hashTable addObject:v];
        }
    }
}
- (void)enumerateOperation {
    @synchronized(self) {
        NSArray *allObjects = [[self.hashTable objectEnumerator] allObjects];
        //倒序执行
        for (NSUInteger i=allObjects.count; i>0; i--) {
            id anObject = allObjects[i-1];
            if ([anObject isKindOfClass:UILabel.class] || [anObject isKindOfClass:UITextView.class]) {
                UIView *v = anObject;
                if (v.skinSelector) {
                    SEL selector = NSSelectorFromString(v.skinSelector);
                    if ([v respondsToSelector:selector]) {
                        NSString *key = v.skinKey;
                        NSString *tbl = KSKinTbl;
                        NSString *content = HLocalizedStringFromTable(key, tbl);
                        SuppressPerformSelectorLeakWarning([v performSelector:selector withObject:content];);
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
    NSString *tbl = KSKinTbl;
    NSString *content = HLocalizedStringFromTable(key, tbl);
    UIColor *tmpColor = [UIColor colorWithString:content];
    [self setSkinKey:key];
    [self setBackgroundColor:tmpColor];
    [[_HSkinUtil share] addObject:self operation:@selector(setBackgroundColor:)];
}
@end

@implementation UILabel (UISkin)
- (void)skin_setFont:(NSString *)font {
    NSString *key = [font mutableCopy];
    NSString *tbl = KSKinTbl;
    NSString *content = HLocalizedStringFromTable(key, tbl);
    UIFont *tmpFont = [UIFont systemFontOfSize:[content floatValue]];
    [self setSkinKey:key];
    [self setFont:tmpFont];
    [[_HSkinUtil share] addObject:self operation:@selector(setFont:)];
}
- (void)skin_setTextColor:(NSString *)color {
    NSString *key = [color mutableCopy];
    NSString *tbl = KSKinTbl;
    NSString *content = HLocalizedStringFromTable(key, tbl);
    UIColor *tmpColor = [UIColor colorWithString:content];
    [self setSkinKey:key];
    [self setTextColor:tmpColor];
    [[_HSkinUtil share] addObject:self operation:@selector(setTextColor:)];
}
@end

@implementation UIButton (UISkin)
- (void)skin_setFont:(NSString *)font {
    NSString *key = [font mutableCopy];
    NSString *tbl = KSKinTbl;
    NSString *content = HLocalizedStringFromTable(key, tbl);
    UIFont *tmpFont = [UIFont systemFontOfSize:[content floatValue]];
    [self setSkinKey:key];
    [self.titleLabel setFont:tmpFont];
    [[_HSkinUtil share] addObject:self operation:@selector(setFont:)];
}
- (void)skin_setTextColor:(NSString *)color {
    NSString *key = [color mutableCopy];
    NSString *tbl = KSKinTbl;
    NSString *content = HLocalizedStringFromTable(key, tbl);
    UIColor *tmpColor = [UIColor colorWithString:content];
    [self setSkinKey:key];
    [self setTitleColor:tmpColor forState:UIControlStateNormal];
    [[_HSkinUtil share] addObject:self operation:@selector(setTextColor:)];
}
- (void)skin_setImage:(NSString *)image {
    NSString *key = [image mutableCopy];
    NSString *tbl = KSKinTbl;
    NSString *content = HLocalizedStringFromTable(key, tbl);
    UIImage *tmpImage = [UIImage imageNamed:content];
    [self setSkinKey:key];
    [self setImage:tmpImage forState:UIControlStateNormal];
    [[_HSkinUtil share] addObject:self operation:@selector(setImage:)];
}
@end

@implementation UITextView (UISkin)
- (void)skin_setFont:(NSString *)font {
    NSString *key = [font mutableCopy];
    NSString *tbl = KSKinTbl;
    NSString *content = HLocalizedStringFromTable(key, tbl);
    UIFont *tmpFont = [UIFont systemFontOfSize:[content floatValue]];
    [self setSkinKey:key];
    [self setFont:tmpFont];
    [[_HSkinUtil share] addObject:self operation:@selector(setFont:)];
}
- (void)skin_setTextColor:(NSString *)color {
    NSString *key = [color mutableCopy];
    NSString *tbl = KSKinTbl;
    NSString *content = HLocalizedStringFromTable(key, tbl);
    UIColor *tmpColor = [UIColor colorWithString:content];
    [self setSkinKey:key];
    [self setTextColor:tmpColor];
    [[_HSkinUtil share] addObject:self operation:@selector(setTextColor:)];
}
@end

@implementation UIImageView (UISkin)
- (void)skin_setImage:(NSString *)image {
    NSString *key = [image mutableCopy];
    NSString *tbl = KSKinTbl;
    NSString *content = HLocalizedStringFromTable(key, tbl);
    UIImage *tmpImage = [UIImage imageNamed:content];
    [self setSkinKey:key];
    [self setImage:tmpImage];
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
        NSString *currLanguage = [userDefaults valueForKey:key];
        if(!currLanguage){
            [userDefaults setValue:KLanguageBase forKey:key];
            [userDefaults synchronize];
        }
        //获取文件路径
        NSString *path = [[NSBundle mainBundle] pathForResource:currLanguage ofType:@"lproj"];
        self.currentBundle = [NSBundle bundleWithPath:path];
    }
    return self;
}
//获取当前语言
+ (NSString *)userLanguage {
    NSString *key = NSStringFromClass(self.class);
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}
//设置语言
+ (void)setUserlanguage:(NSString *)language {
    @synchronized(self) {
        NSString *key = NSStringFromClass(self.class);
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *currLanguage = [userDefaults valueForKey:key];
        if (![currLanguage isEqualToString:language]) {
            
            [userDefaults setValue:language forKey:key];
            [userDefaults synchronize];
            
            NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
            [HSkin share].currentBundle = [NSBundle bundleWithPath:path];
        }
        [[_HSkinUtil share] enumerateOperation];
    }
}
@end

