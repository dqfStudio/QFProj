//
//  HHostUrlManager.m
//  MGMobileMusic
//
//  Created by dqf on 17/1/18.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HHostUrlManager.h"

@interface NSString (hostVersion)
- (NSString *(^)(NSString *))appendVersion;
@end

@interface HHostUrlManager ()

@property (nonatomic, readwrite) NSString *kContentServerHost;
@property (nonatomic, readwrite) NSString *kProductServerHost;
@property (nonatomic, readwrite) NSString *kUserServerHost;
@property (nonatomic, readwrite) NSString *kBarrageServerHost;
@property (nonatomic, readwrite) NSString *kResourceServerHost;
@property (nonatomic, readwrite) NSString *kH5ServerHost;

@end

@implementation HHostUrlManager

- (NSString *(^)(NSString *))contentServerBaseUrl {
    return ^NSString *(NSString *org) {
        return self->_kContentServerHost.appendVersion(org);
    };
}

- (NSString *(^)(NSString *))productServerBaseUrl {
    return ^NSString *(NSString *org) {
        return self->_kProductServerHost.appendVersion(org);
    };
}

- (NSString *(^)(NSString *))userServerBaseUrl {
    return ^NSString *(NSString *org) {
        return self->_kUserServerHost.appendVersion(org);;
    };
}

- (NSString *(^)(NSString *))barrageServerBaseUrl {
    return ^NSString *(NSString *org) {
        return self->_kBarrageServerHost.appendVersion(org);;
    };
}

- (NSString *(^)(NSString *))resourceServerBaseUrl {
    return ^NSString *(NSString *org) {
        return self->_kResourceServerHost.appendVersion(org);;
    };
}

- (NSString *(^)(void))h5ServerBaseUrl {
    return ^NSString *(void) {
        return self->_kH5ServerHost;
    };
}


+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static HHostUrlManager *_instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [[HHostUrlManager alloc] init];
    });
    return _instance;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        id obj = [[NSUserDefaults standardUserDefaults] objectForKey:KHostURLModelKey];
        if (obj) {
            self.hostUrlMode = [obj integerValue];
        }
        else {
#ifdef DEBUG
            self.hostUrlMode = EHostUrlModeTest;
#else
            self.hostUrlMode = EHostUrlModeRelease;
#endif
        }
    }

    return self;
}


- (void)setHostUrlMode:(THostUrlMode)hostUrlMode {
    if (_hostUrlMode != hostUrlMode) {
        _hostUrlMode = hostUrlMode;
        [[NSUserDefaults standardUserDefaults] setInteger:self.hostUrlMode forKey:KHostURLModelKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self update];
}


- (void)update {
    switch (_hostUrlMode) {
        case EHostUrlModeDebug:
            _kContentServerHost = @"";
            _kProductServerHost = _kContentServerHost;
            _kUserServerHost = _kContentServerHost;
            _kBarrageServerHost = _kContentServerHost;
            _kResourceServerHost = _kContentServerHost;
            _kH5ServerHost = @"";
            break;
        case EHostUrlModeTest:
        case EHostUrlModeSimulation:
            _kContentServerHost = @"";
            _kProductServerHost = @"";
            _kUserServerHost = @"";
            _kBarrageServerHost = @"";
            _kResourceServerHost = @"";
            _kH5ServerHost = @"";
            break;
        case EHostUrlModeRelease:
        default:
            _kContentServerHost = @"";
            _kProductServerHost = @"";
            _kUserServerHost = @"";
            _kBarrageServerHost = @"";
            _kResourceServerHost = @"";
//            _kH5ServerHost = NSStringFromServerHostType(EMGServerHostTypeH5);
            break;
    }
}

@end

@implementation NSString (hostVersion)

- (NSString *(^)(NSString *))appendVersion {
    return ^NSString *(NSString *org) {
        return [NSString stringWithFormat:@"%@%@", self, org];
    };
}

@end
