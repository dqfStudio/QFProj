//
//  HGoToSupport.m
//  Camera360
//
//  Created by zhangchutian on 14-4-3.
//  Copyright (c) 2014年 Pinguo. All rights reserved.
//

#import "HGoTo.h"
#import "NSObject+annotation.h"
#import "HGotoRuntimeSupport.h"
#import "NSString+HUtil.h"
#import "NSString+HChain.h"
#import "NSError+HUtil.h"
#import "NSObject+HAutoFill.h"

@interface HGoToPathNode : NSObject
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *param;
@property (nonatomic) HGoToPathNode *next;
@property (nonatomic) NSDictionary *paramsMap;
- (instancetype)initWithNodeString:(NSString *)nodeString;
@end


@interface HGoto ()
@property (nonatomic, readwrite) id<HGotoConfig> config;
@property (nonatomic) NSMutableDictionary *pasteboard;
@property (nonatomic, weak) UIViewController *autoRoutedVC;
@end

@implementation HGoto

+ (instancetype)center {
    static dispatch_once_t pred;
    static HGoto *o = nil;
    
    dispatch_once(&pred, ^{
        o = [HGoto new];
    });
    return o;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _config = HProtocalInstance(HGotoConfig);
        NSAssert(_config, @"没找到配置类,请实现配置类,并使用HRegForProtocal注册");
        _pasteboard = [NSMutableDictionary new];
    }
    return self;
}

+ (HGoToPathNode *)stringToNodes:(NSString *)pathString {
    HGoToPathNode *head = nil;
    HGoToPathNode *currentNode = nil;
    NSArray *components = [pathString componentsSeparatedByString:@"/"];
    for (NSString *nodeString in components) {
        NSString *trimNodeString = [nodeString trim];
        if ([trimNodeString length] > 0) {
            HGoToPathNode *node = [[HGoToPathNode alloc] initWithNodeString:trimNodeString];
            if (!head) head = node;
            if (!currentNode) currentNode = node;
            else{
                currentNode.next = node;
            }
        }
    }
    return head;
}
- (id)route:(NSString *)path doJump:(BOOL)doJump finish:(finish_callback)finish {
    if (![path hasPrefix:self.config.appSchema]) {
        //TODO 其他schema统一交外部处理
        if ([path hasPrefix:@"http://"] || [path hasPrefix:@"https://"]) {
            if ([self.config respondsToSelector:@selector(openHttpURL:)]) {
                [self.config openHttpURL:path];
            }
            return nil;
        }
        if (finish) {
            finish(self, nil, herr(kDataFormatErrorCode, ([NSString stringWithFormat:@"wrong protocal only support %@",self.config.appSchema])));
        }
        return nil;
    }
    if (path.length == self.config.appSchema.length) {
        if (finish)
        {finish(self, nil, herr(kNoDataErrorCode, ([NSString stringWithFormat:@"path not found : %@", path])));}
        return nil;
    }
    
    path = [path substringFromIndex:self.config.appSchema.length];
    HGoToPathNode *head = [HGoto stringToNodes:path];
    @weakify(self)
    return [self routeWithNode:head doJump:doJump finish:^(id sender, id data, NSError *error) {
        @strongify(self)
        if (error) {
            if (finish) finish(sender, data, error);
        }else {
            NSString *next = [head paramsMap][HGotoKeyword_Next];
            if (next) {
                if (data) [self.pasteboard setObject:data forKey:HGotoPreStepDataKey];
                [self route:next doJump:doJump finish:finish];
            }else {
                if (finish) finish(sender, data, error);
            }
        }
    }];
}
- (id)routeWithNode:(HGoToPathNode *)node doJump:(BOOL)doJump finish:(finish_callback)finish {
    //搜索全局节点
    NSString *nodeName = node.name;
    NSString *nodeRegName = [NSString stringWithFormat:@"%@_%@",HGOTO_NODE_REG_PREFIX,nodeName];
    __block NSString *className = nil;
    __block NSArray *options = nil;
    [HClassManager scanClassNameForKey:nodeRegName fetchblock:^(NSString *aclassName, id userInfo) {
        NSAssert(className == nil, @"存在多个路径注册点");
        className = aclassName;
        options = userInfo;
    }];
    if (!className) {
        NSAssert(NO, @"没找到对应的注册路径点");
        if (finish) finish(self, nil, herr(kDataFormatErrorCode, ([NSString stringWithFormat:@"没找到对应的注册路径点 %@",nodeName])));
        return nil;
    }
    
    Class klass = NSClassFromString(className);
    
    if (!klass) {
        NSAssert(NO, @"无法初始化类");
        if (finish) finish(self, nil, herr(kDataFormatErrorCode, ([NSString stringWithFormat:@"无法初始化类 %@", className])));
        return nil;
    }
    
    //应用选项
    self.autoRoutedVC = [self applyOptions:options doJump:doJump targetClass:klass node:node];
    
    
    //模式1 +[xxClass hgoto_p1:(NSString *)p1 p2:(NSString *)p2 p3:(NSString *)p3 finish:(finish_callback)finish]
    //模式1 +[xxClass hgoto_P1:(NSString *)p1 p2:(NSString *)p2 p3:(NSString *)p3]
    //模式2 +[xxClass hgotoWithParams:(NSDictionary *)paramMap finish:(finish_callback)finish]
    //模式2 +[xxClass hgotoWithParams:(NSDictionary *)paramMap]
    //模式3 +[xxClass hgoto:(NSString *)params finish:(finish_callback)finish]
    //模式3 +[xxClass hgoto:(NSString *)params]
    //模式4 +[xxClass hgotoWithFinish:(finish_callback)finish]
    //模式4 +[xxClass hgoto]
    
    static NSString *methodMode1Prefix = @"hgoto_";
    static NSString *methodMode2Prefix = @"hgotoWithParams:";
    static NSString *methodMode3Prefix = @"hgoto:";
    static NSString *methodMode4Prefix = @"hgotoWithFinish:";
    NSDictionary *params = [node paramsMap];
    
    NSArray *classMethods = [NSObject hClassMethodNames:klass];
    
    NSString *(^getMethodName)(NSString *filter) = ^(NSString *filter){
        for (NSString *methodName in classMethods) {
            if ([methodName hasPrefix:filter]) {
                return methodName;
            }
        }
        return @"";
    };
    
    void (^performOtherModelSelector)(void) = ^(void){
        SEL modeSelector = NSSelectorFromString(@"hgoto");
        SEL modeSelectorWithFinish = NSSelectorFromString(@"hgotoWithFinish:");
        if ([klass respondsToSelector:modeSelector]) {
            [klass performClassSelector:modeSelector withObjects:@[]];
        }else if ([klass respondsToSelector:modeSelectorWithFinish]) {
            [klass performClassSelector:modeSelectorWithFinish withObjects:@[]];
        }
    };
    
    if (params.count > 0) {
        NSString *modeMethod  = nil;
        NSString *methodModePrefix = nil;
        
        NSString *modeMethod1 = getMethodName(methodMode1Prefix);
        NSString *modeMethod2 = getMethodName(methodMode2Prefix);
        NSString *modeMethod3 = getMethodName(methodMode3Prefix);
        NSString *modeMethod4 = getMethodName(methodMode4Prefix);
        
        if (modeMethod1.length > 0) {
            modeMethod = modeMethod1;
            methodModePrefix = methodMode1Prefix;
        }else if (modeMethod2.length > 0) {
            modeMethod = modeMethod2;
            methodModePrefix = methodMode2Prefix;
        }else if (modeMethod3.length > 0) {
            modeMethod = modeMethod3;
            methodModePrefix = methodMode3Prefix;
        }else if (modeMethod4.length > 0) {
            modeMethod = modeMethod4;
            methodModePrefix = methodMode4Prefix;
        }
        
        if (modeMethod.length > 0 && methodModePrefix.length > 0) {
            NSArray *comp = [[modeMethod fromSubString:methodModePrefix] componentsByString:@":"];
            
            NSMutableArray *valueArr = [[NSMutableArray alloc] init];
            for (NSString *paramKey in comp) {
                id value = params[paramKey];
                if ([paramKey isEqualToString:@"finish"]) {
                    [valueArr addObject:finish];
                } else if (value){
                    [valueArr addObject:value];
                }
            }
            [klass performClassSelector:NSSelectorFromString(modeMethod) withObjects:valueArr];
        }else {
            performOtherModelSelector();
        }
    }else {
        performOtherModelSelector();
    }
    
    [self.pasteboard removeAllObjects];
    id res = self.autoRoutedVC;
    self.autoRoutedVC = nil;
    return res;
}

+ (void)route:(NSString *)path {
    [HGoto route:path finish:nil];
}

+ (void)route:(NSString *)path success:(callback)success faile:(fail_callback)faile {
    [[HGoto center] route:path doJump:YES finish:^(id sender, id data, NSError *error) {
        if (error) {
            if (faile) faile(sender, error);
        }else {
            if (success) success(sender, data);
        }
    }];
}
+ (void)route:(NSString *)path finish:(finish_callback)finish {
    [[HGoto center] route:path doJump:YES finish:finish];
}
+ (UIViewController *)getViewController:(NSString *)path {
    return [[HGoto center] route:path doJump:NO finish:nil];
}
- (id)applyOptions:(NSArray *)options doJump:(BOOL)doJump targetClass:(Class)klass node:(HGoToPathNode *)node {
    if ([klass isSubclassOfClass:[UIViewController class]]) {
        UIViewController *targetVC = nil;
        BOOL needPopAction = NO;
        if (![options containsObject:HGotoOpt_ManualRoute]) {
            //处理autopop
            if ([options containsObject:HGOtoOpt_AutoPop]) {
                NSArray *vcs = self.config.navi.viewControllers;
                BOOL found = NO;
                for (UIViewController *vc in vcs) {
                    if ([vc isKindOfClass:klass]) {
                        found = YES;
                        targetVC = vc;
                        needPopAction = YES;
                        break;
                    }
                }
                if (!found) {
                    targetVC = [klass new];
                }
            }else {
                targetVC = [klass new];
            }
            
            //处理autofill
            if ([options containsObject:HGOtoOpt_AutoFill]) {
                NSDictionary *params = [node paramsMap];
                NSDictionary *keyMaping = [self getOptKeyMap:options];
                [targetVC autoFill:params map:keyMaping];
            }
            if (doJump) {
                if (needPopAction) {
                    [self.config.navi popToViewController:targetVC animated:YES];
                }else {
                    [self.config.navi pushViewController:targetVC animated:YES];
                }
            }
        }
        return targetVC;
    }else {
        return nil;
    }
}
- (NSDictionary *)getOptKeyMap:(NSArray *)options {
    for (id obj in options) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *keyMap = [(NSDictionary *)obj objectForKey:@"HGOtoOpt_KeyMap"];
            if (keyMap) {
                NSMutableDictionary *revertKeyMap = [NSMutableDictionary new];
                [keyMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    [revertKeyMap setObject:key forKey:obj];
                }];
                return revertKeyMap;
            }
        }
    }
    return nil;
}
+ (void)pushObject:(id)object forkey:(NSString *)key {
    [[HGoto center].pasteboard setObject:object forKey:key];
}
+ (id)getObject:(id)object forkey:(NSString *)key {
    return [[HGoto center].pasteboard objectForKey:key];
}
+ (id)autoRoutedVC {
    return [HGoto center].autoRoutedVC;
}
@end


@implementation HGoToPathNode

- (instancetype)initWithNodeString:(NSString *)nodeString {
    self = [super init];
    if (self) {
        NSMutableArray *components = [NSMutableArray new];
        NSMutableString *tempStr = [NSMutableString new];
        int kuohaoCount = 0;
        for (int i = 0; i < nodeString.length; i ++) {
            NSString *ch = [nodeString substringWithRange:NSMakeRange(i, 1)];
            if (kuohaoCount > 0) {
                if ([ch isEqualToString:@"("]) {
                    kuohaoCount ++;
                }else if([ch isEqualToString:@")"]) {
                    kuohaoCount --;
                    if (kuohaoCount == 0) continue;
                }
                [tempStr appendString:ch];
            }else {
                if ([ch isEqualToString:@"("]) {
                    kuohaoCount ++;
                }else if ([ch isEqualToString:@":"]) {
                    [components addObject:tempStr];
                    tempStr = [NSMutableString new];
                }else if ([ch isEqualToString:@"?"]) {
                    [components addObject:tempStr];
                    tempStr = [NSMutableString new];
                }else {
                    [tempStr appendString:ch];
                }
            }
        }
        if (tempStr.length > 0) [components addObject:tempStr];
        int index = 0;
        for (NSString *value in components) {
            if (value.length > 0) {
                if (index == 0) {
                    self.name = value;
                }else if (index == 1) {
                    self.param = [value trim];
                    break;
                }
            }
            index++;
        }
    }
    return self;
}

- (NSDictionary *)paramsMap {
    if (!_paramsMap) {
        if (self.param.length == 0) {
            _paramsMap = [NSDictionary new];
        }else {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            NSArray *segments = [self.param componentsSeparatedByString:@"&"];
            for(NSString *segment in segments) {
                NSArray *kv = [segment componentsSeparatedByString:@"="];
                if (kv.count >= 2) {
                    NSString *key = [kv[0] decode];
                    NSString *value = [kv[1] decode];
                    [dict setObject:value forKey:key];
                }
            }
            _paramsMap = dict;
        }
    }
    return _paramsMap;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"action:%@\nparam:%@", _name, _param];
}

@end

#import <objc/runtime.h>
@implementation UIViewController (hgoto)

@dynamic gotoCallback;

static const void *gotoCallbackAddress = &gotoCallbackAddress;

- (finish_callback)gotoCallback {
    return objc_getAssociatedObject(self, gotoCallbackAddress);
}

- (void)setGotoCallback:(finish_callback)gotoCallback {
    objc_setAssociatedObject(self, gotoCallbackAddress, gotoCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
