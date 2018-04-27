//
//  HGoToApp.m
//  Camera360
//
//  Created by zhangchutian on 14-6-20.
//  Copyright (c) 2014年 Pinguo. All rights reserved.
//

#import "HGoToApp.h"
#import "HGoTo.h"
#import "NSString+HUtil.h"

@interface HGoToApp () <SKStoreProductViewControllerDelegate>

@property (nonatomic) id mHolder;
@property (nonatomic, weak) SKStoreProductViewController *mSkStoreProductViewController;
@end

@implementation HGoToApp

HGotoReg(@"app")

+ (void)hgoto_schema:(NSString *)schema url:(NSString *)url {
    if (schema && [self canOpenURL:schema]) {
        [self openURL:schema];
    }else if (url) {
        [self openURL:url];
    }
}

+ (BOOL)canOpenURL:(NSString *)url {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
}

+ (BOOL)openURL:(NSString *)url {
    SuppressWdeprecatedDeclarationsWarning(
        return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url decode]]];
    );
}

@end
