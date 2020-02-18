//
//  HRegisterController.m
//  QFProj
//
//  Created by dqf on 2019/7/15.
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
        //方式一
        _tupleView = [HTupleView tupleFrame:^CGRect{
            return frame;
        } exclusiveSections:^NSArray * _Nullable{
            return @[@0];
        }];
        //方式二
        /*
        _tupleView = [HTupleView tupleFrame:^CGRect{
            return frame;
        } exclusiveSections:^NSArray * _Nullable{
            return nil;
        }];
        */
        //方式三
        //_tupleView = [[HTupleView alloc] initWithFrame:frame];
    }
    return _tupleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.leftNaviButton setHidden:YES];
    [self setTitle:@"注册"];
    [self.tupleView setTupleDelegate:(id<HTupleViewDelegate>)self];
    [self.view addSubview:self.tupleView];
    
    [self.tupleView setObject:@"分身状态一" forKey:@"state" state:0];
    [self.tupleView setObject:@"分身状态二" forKey:@"state" state:1];
}

- (void)vcWillDisappear:(HVCDisappearType)type {
    if (type == HVCDisappearTypePop || type == HVCDisappearTypeDismiss) {
        [self.tupleView releaseTupleBlock];
    }
}

- (YPTabBar *)tabBarView {
    CGRect frame = CGRectZero;
    frame.origin.x = self.tupleView.width/2-200/2;
    frame.origin.y = 55/2-35/2;
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

- (NSInteger)tupleExa0_numberOfItemsInSection:(NSInteger)section {
    return 1;
}
- (CGSize)tupleExa0_sizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.tupleView.width, 10);
}
- (CGSize)tupleExa0_sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.tupleView.width, 55);
}
- (void)tupleExa0_tupleHeader:(HTupleHeader)headerBlock inSection:(NSInteger)section {
    headerBlock(nil, HTupleBaseApex.class, nil, NO);
}
- (void)tupleExa0_tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    HTupleBaseCell *cell = itemBlock(nil, HTupleBaseCell.class, nil, YES);
    YPTabBar *tabBar = [cell viewWithTag:12345];
    if (!tabBar) {
        [cell addSubview:[self tabBarView]];
    }
}

@end
