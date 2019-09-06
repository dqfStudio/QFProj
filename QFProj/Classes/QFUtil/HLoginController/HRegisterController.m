//
//  HRegisterController.m
//  QFProj
//
//  Created by wind on 2019/7/15.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HRegisterController.h"
#import "YPTabBar.h"

@interface HRegisterController ()

@end

@implementation HRegisterController

- (HTupleView *)tupleView {
    if (!_tupleView) {
        CGRect frame = UIScreen.bounds;
        frame.origin.y += UIDevice.topBarHeight;
        frame.size.height -= UIDevice.topBarHeight;
        _tupleView = [HTupleView tupleDesignWith:^CGRect{
            return frame;
        } exclusiveHeaders:^NSArray * _Nullable{
            return nil;
        } exclusiveFooters:^NSArray * _Nullable{
            return nil;
        } exclusiveItems:^NSArray * _Nullable{
            return @[NSIndexPath.stringValue(0, 0)];
        }];
    }
    return _tupleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.leftNaviButton setHidden:YES];
    [self setTitle:@"注册"];
    [self.view addSubview:self.tupleView];
}

- (void)vcWillDisappear:(HVCDisappearType)type {
    if (type == HVCDisappearTypePop || type == HVCDisappearTypeDismiss) {
        [self.tupleView releaseTupleBlock];
    }
}

- (YPTabBar *)tabBarView {
    CGRect frame = CGRectZero;
    frame.origin.x = self.tupleView.width/2-200/2;
    frame.origin.y = 110/2-35/2;
    frame.size.width  = 200;
    frame.size.height = 35;
    
    YPTabBar *tabBar = [[YPTabBar alloc] initWithFrame:frame];
    [tabBar setCornerRadius:35/2];
    [tabBar setTag:12345];
    
    YPTabItem *item1 = YPTabItem.new;
    item1.title = @"快速注册";
    item1.backgroundColor = [UIColor yellowColor];
    
    YPTabItem *item2 = YPTabItem.new;
    item2.title = @"手机注册";
    item2.backgroundColor = [UIColor whiteColor];
    
    @www
    [tabBar setTabbardSelectedBlock:^(NSInteger idx) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @sss
            switch (idx) {
                case 0: {
                    item1.backgroundColor = [UIColor yellowColor];
                    item2.backgroundColor = [UIColor whiteColor];
                }
                    break;
                case 1: {
                    item1.backgroundColor = [UIColor whiteColor];
                    item2.backgroundColor = [UIColor yellowColor];
                }
                    break;
                default:
                    break;
            }
            self.tupleView.tupleState = idx;
        });
    }];
    
    [tabBar setItems:@[item1, item2]];
    tabBar.itemTitleColor = [UIColor blackColor];
    tabBar.itemTitleSelectedColor = [UIColor whiteColor];
    tabBar.itemTitleFont = [UIFont systemFontOfSize:17];
    tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:17];
    tabBar.leadingSpace = 0;
    tabBar.trailingSpace = 0;
    
    tabBar.itemFontChangeFollowContentScroll = YES;
    tabBar.indicatorScrollFollowContent = YES;
    tabBar.indicatorColor = [UIColor clearColor];
    [tabBar setBackgroundColor:[UIColor whiteColor]];
    
    [tabBar setSelectedItemIndex:0];
    
    [tabBar setScrollEnabledAndItemWidth:frame.size.width/2];
    return tabBar;
}

- (void)tuple_tupleView:(HTupleView *)tupleView itemTuple:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        HTupleBaseCell *cell = itemBlock(nil, HTupleBaseCell.class, nil, YES);
        YPTabBar *tabBar = [cell viewWithTag:12345];
        if (!tabBar) {
            [cell addSubview:[self tabBarView]];
        }
    }
}

@end

