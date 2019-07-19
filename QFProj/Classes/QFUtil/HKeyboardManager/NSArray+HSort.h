//
//  NSArray+HSort.h
//
//  Created by Guangquan Yu on 2018/4/9.
//  Copyright © 2018年 yugq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (HSort)

- (nonnull NSArray*)h_sortedUIViewArrayByTag;

- (nonnull NSArray*)h_sortedUIViewArrayByPosition;

- (nonnull NSArray*)h_sortedUIViewArrayByPositionForWindow;

@end
