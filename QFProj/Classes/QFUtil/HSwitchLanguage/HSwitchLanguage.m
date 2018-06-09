//
//  HSwitchLanguage.m
//  TestProject
//
//  Created by 邓清峰 on 2018/6/5.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HSwitchLanguage.h"
#import <objc/runtime.h>

#define HLocalizedString(key) \
[[HSwitchLanguage share].currentBundle localizedStringForKey:(key) value:@"" table:nil]
#define HLocalizedStringFromTable(key, tbl) \
[[HSwitchLanguage share].currentBundle localizedStringForKey:(key) value:@"" table:(tbl)]

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@interface HSwitchLanguage ()
@property (nonatomic) NSBundle *currentBundle;
+ (HSwitchLanguage *)share;
@end

@interface _HSkinUtil : NSObject
@property (nonatomic) NSHashTable *hashTable;
+ (_HSkinUtil *)share;
- (void)addObject:(id)anObject operation:(SEL)selector;
- (void)enumerateOperation;
@end

@interface UIView (UISkin)
@property (nonatomic) NSString *textKey;
@property (nonatomic) NSString *textSelector;
@end

@implementation UIView (UISkin)
- (NSString *)textKey {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setTextKey:(NSString *)textKey {
    objc_setAssociatedObject(self, @selector(textKey), textKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)textSelector {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setTextSelector:(NSString *)textSelector {
    objc_setAssociatedObject(self, @selector(textSelector), textSelector, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
            [v setTextSelector:NSStringFromSelector(selector)];
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
                if (v.textSelector) {
                    SEL selector = NSSelectorFromString(v.textSelector);
                    if ([v respondsToSelector:selector]) {
                        NSString *key = v.textKey;
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

@interface NSObject (UISkin)

@end

@implementation NSObject (UISkin)
+ (void)methodSwizzleWithOrigSEL:(SEL)origSEL overrideSEL:(SEL)overrideSEL {
    Method origMethod = class_getInstanceMethod([self class], origSEL);
    Method overrideMethod= class_getInstanceMethod([self class], overrideSEL);
    if(class_addMethod([self class], origSEL,
                       method_getImplementation(overrideMethod),
                       method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod([self class],overrideSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }else {
        method_exchangeImplementations(origMethod,overrideMethod);
    }
}
@end

@interface UILabel (UISkin)

@end

@implementation UILabel (UISkin)
+ (void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self methodSwizzleWithOrigSEL:@selector(setText:) overrideSEL:@selector(skin_setText:)];
    });
}
- (void)skin_setText:(NSString *)text {
    @synchronized(self) {
        NSString *key = [text mutableCopy];
        NSString *tbl = KSKinTbl;
        NSString *content = HLocalizedStringFromTable(key, tbl);
        [self setTextKey:key];
        [self skin_setText:content];
        [[_HSkinUtil share] addObject:self operation:@selector(skin_setText:)];
    }
}
@end

@interface UITextView (UISkin)

@end

@implementation UITextView (UISkin)
+ (void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self methodSwizzleWithOrigSEL:@selector(setText:) overrideSEL:@selector(skin_setText:)];
    });
}
- (void)skin_setText:(NSString *)text {
    @synchronized(self) {
        NSString *key = [text mutableCopy];
        NSString *tbl = KSKinTbl;
        NSString *content = HLocalizedStringFromTable(key, tbl);
        [self setTextKey:key];
        [self skin_setText:content];
        [[_HSkinUtil share] addObject:self operation:@selector(skin_setText:)];
    }
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
            [HSwitchLanguage share].currentBundle = [NSBundle bundleWithPath:path];
        }
        [[_HSkinUtil share] enumerateOperation];
    }
}
@end
