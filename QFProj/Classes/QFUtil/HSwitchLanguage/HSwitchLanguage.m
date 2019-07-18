//
//  HSwitchLanguage.m
//  TestProject
//
//  Created by wind on 2018/6/5.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HSwitchLanguage.h"
#import <objc/runtime.h>

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define HLocalizedString(key) \
[[HSwitchLanguage currentBundle] localizedStringForKey:(key) value:@"" table:nil]
#define HLocalizedStringFromTable(key, tbl) \
[[HSwitchLanguage currentBundle] localizedStringForKey:(key) value:@"" table:(tbl)]

@interface UIView (UISkin)
@property (nonatomic) NSString *textKey;
@end

@implementation UIView (UISkin)
- (NSString *)textKey {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setTextKey:(NSString *)textKey {
    objc_setAssociatedObject(self, @selector(textKey), textKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

@interface _HSkin : NSObject
@property (nonatomic) NSHashTable *hashTable;
+ (_HSkin *)share;
- (void)addObject:(id)anObject;
- (void)removeObject:(id)anObject;
- (void)enumerateOperation;
@end

@implementation _HSkin
- (NSHashTable *)hashTable {
    if (!_hashTable) {
        _hashTable = [NSHashTable weakObjectsHashTable];
    }
    return _hashTable;
}
+ (_HSkin *)share {
    static _HSkin *shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}
- (void)addObject:(id)anObject {
    if ([anObject isKindOfClass:UIView.class]) {
        [self.hashTable addObject:anObject];
    }
}
- (void)removeObject:(id)anObject {
    if ([self.hashTable containsObject:anObject]) {
        [self.hashTable removeObject:anObject];
    }
}
- (void)enumerateOperation {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSArray *allObjects = [[self.hashTable objectEnumerator] allObjects];
        //倒序执行
        for (NSUInteger i=allObjects.count-1; i>=0; i--) {
            id anObject = allObjects[i];
            if ([anObject isKindOfClass:UILabel.class] || [anObject isKindOfClass:UITextView.class]) {
                UIView *view = anObject;
                SEL selector = NSSelectorFromString(@"skin_setText:");
                if ([view respondsToSelector:selector]) {
                    NSString *key = view.textKey;
                    NSString *tbl = KSKinTable;
                    NSString *content = HLocalizedStringFromTable(key, tbl);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        SuppressPerformSelectorLeakWarning([view performSelector:selector withObject:content];);
                    });
                }
            }
        }
    });
}
@end

@implementation UILabel (HSkin)
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
        NSString *content = HLocalizedStringFromTable(aKey, table);
        if (content) {
            //保存文字颜色
            UIColor *color = self.textColor;
            [self setTextKey:aKey];
            //此处文字颜色会被更改掉
            [self skin_setText:content];
            //重新设置保存的文字颜色
            [self setTextColor:color];
            
            [[_HSkin share] addObject:self];
        }
    }else {
        [self skin_setText:aKey];
        [[_HSkin share] removeObject:self];
    }
}
@end

@implementation UITextView (HSkin)
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
        NSString *content = HLocalizedStringFromTable(aKey, table);
        if (content) {
            //保存文字颜色
            UIColor *color = self.textColor;
            [self setTextKey:aKey];
            //此处文字颜色会被更改掉
            [self skin_setText:content];
            //重新设置保存的文字颜色
            [self setTextColor:color];
            
            [[_HSkin share] addObject:self];
        }
    }else {
        [self skin_setText:aKey];
        [[_HSkin share] removeObject:self];
    }
}
@end

@interface HSwitchLanguage ()
@property (nonatomic) NSBundle *currentBundle;
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
- (NSBundle *)currentBundle {
    if (!_currentBundle) {
        NSString *aKey = NSStringFromClass(self.class);
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *currentLanguage = [userDefaults valueForKey:aKey];
        if(!currentLanguage){
            currentLanguage = KLanguageBase;
            [userDefaults setValue:currentLanguage forKey:aKey];
            [userDefaults synchronize];
        }
        //获取文件路径
        NSString *path = [[NSBundle mainBundle] pathForResource:currentLanguage ofType:@"lproj"];
        _currentBundle = [NSBundle bundleWithPath:path];
    }
    return _currentBundle;
}
+ (NSBundle *)currentBundle {
    return [HSwitchLanguage share].currentBundle;
}
//获取当前语言
+ (NSString *)userLanguage {
    NSString *aKey = NSStringFromClass(self.class);
    return [[NSUserDefaults standardUserDefaults] valueForKey:aKey];
}
//设置语言
+ (void)setUserlanguage:(NSString *)language {
    NSString *aKey = NSStringFromClass(self.class);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *currentLanguage = [userDefaults valueForKey:aKey];
    if (![currentLanguage isEqualToString:language]) {
        
        [userDefaults setValue:language forKey:aKey];
        [userDefaults synchronize];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
        [HSwitchLanguage share].currentBundle = [NSBundle bundleWithPath:path];
        [[_HSkin share] enumerateOperation];
    }
}
@end
