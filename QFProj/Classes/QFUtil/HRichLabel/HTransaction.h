//
//  HTransaction.h
//  HAsyncLayer
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTransaction : NSObject

+ (instancetype)transactionWithTarget:(id)target selector:(SEL)selector;

- (void)commit;

@end

NS_ASSUME_NONNULL_END
