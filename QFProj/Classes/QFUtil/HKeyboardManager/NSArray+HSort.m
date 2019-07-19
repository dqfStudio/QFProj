//
//  NSArray+HSort.m
//
//  Created by Guangquan Yu on 2018/4/9.
//  Copyright © 2018年 yugq. All rights reserved.
//

#import "NSArray+HSort.h"
#import "UIView+HResponder.h"
#import <UIKit/UIView.h>

@implementation NSArray (HSort)

- (NSArray*)h_sortedUIViewArrayByTag {
    return [self sortedArrayUsingComparator:^NSComparisonResult(UIView *view1, UIView *view2) {
        
        if ([view1 respondsToSelector:@selector(tag)] && [view2 respondsToSelector:@selector(tag)])
        {
            if ([view1 tag] < [view2 tag])    return NSOrderedAscending;
            
            else if ([view1 tag] > [view2 tag])    return NSOrderedDescending;
            
            else    return NSOrderedSame;
        }
        else
            return NSOrderedSame;
    }];
}

- (NSArray*)h_sortedUIViewArrayByPosition {
    return [self sortedArrayUsingComparator:^NSComparisonResult(UIView *view1, UIView *view2) {
        
        CGFloat x1 = CGRectGetMinX(view1.frame);
        CGFloat y1 = CGRectGetMinY(view1.frame);
        CGFloat x2 = CGRectGetMinX(view2.frame);
        CGFloat y2 = CGRectGetMinY(view2.frame);
        
        if (y1 < y2)  return NSOrderedAscending;
        
        else if (y1 > y2) return NSOrderedDescending;

        else if (x1 < x2)  return NSOrderedAscending;
        
        else if (x1 > x2) return NSOrderedDescending;
        
        else    return NSOrderedSame;
    }];
}

- (NSArray*)h_sortedUIViewArrayByPositionForWindow {
    NSMutableArray * filtrate = @[].mutableCopy;
    [self enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect viewWindow1 = [[view superview] convertRect:view.frame toView:[UIWindow h_getWindow]];
        if (viewWindow1.origin.x>=0 && viewWindow1.origin.x <= [UIScreen mainScreen].bounds.size.width) {
            [filtrate addObject:view];
        }
    }];
    
    return [filtrate sortedArrayUsingComparator:^NSComparisonResult(UIView *view1, UIView *view2) {
        
        CGRect viewWindow1 = [[view1 superview] convertRect:view1.frame toView:[UIWindow h_getWindow]];
        CGRect viewWindow2 = [[view2 superview] convertRect:view2.frame toView:[UIWindow h_getWindow]];
        CGFloat x1 = CGRectGetMinX(viewWindow1);
        CGFloat y1 = CGRectGetMinY(viewWindow1);
        CGFloat x2 = CGRectGetMinX(viewWindow2);
        CGFloat y2 = CGRectGetMinY(viewWindow2);
        
        if (y1 < y2)  return NSOrderedAscending;
        
        else if (y1 > y2) return NSOrderedDescending;

        else if (x1 < x2)  return NSOrderedAscending;
        
        else if (x1 > x2) return NSOrderedDescending;
        
        else    return NSOrderedSame;
    }];
}

@end
