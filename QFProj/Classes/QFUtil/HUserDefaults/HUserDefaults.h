//
//  HUserDefaults.h
//  QFProj
//
//  Created by dqf on 2018/9/27.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUserDefaults : NSObject

@property (nonatomic, weak) NSString *userName;
@property (nonatomic, weak) NSNumber *userId;
@property (nonatomic) NSInteger integerValue;
@property (nonatomic) BOOL boolValue;
@property (nonatomic) float floatValue;

+ (HUserDefaults *)defaults;

@end
