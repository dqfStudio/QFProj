//
//  HPrinterManager.h
//  QFProj
//
//  Created by dqf on 2018/8/7.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPrinterManager : NSObject

@property (nonatomic, weak) UIView *view;

+ (instancetype)share;

- (void)setObject:(id)anObject forKey:(NSString *)aKey;

- (NSString *)objectForKey:(NSString *)aKey;

@end

