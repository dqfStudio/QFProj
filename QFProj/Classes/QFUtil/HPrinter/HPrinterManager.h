//
//  HPrinterManager.h
//  QFProj
//
//  Created by dqf on 2018/8/7.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

#if DEBUG

@interface HPrinterManager : NSObject
+ (instancetype)share;
- (void)setObject:(id)anObject forKey:(NSString *)aKey;
- (BOOL)containsObject:(id)anObject;
- (NSString *)objectForKey:(NSString *)aKey;
@end

#endif
