//
//  HFormController.m
//  HProjectModel1
//
//  Created by wind on 2018/12/31.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HFormController2.h"

#define KItemHeight     80
#define KFooterHeight   50

#define HIPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

@interface HFormController2 () <HTupleViewDelegate>
@property (nonatomic) HTupleView *tupleView;
@property (nonatomic) NSInteger numberOfRows;
@end

@implementation HFormController2

static HFormController2 *formController = nil;

- (instancetype)init {
    self = [super init];
    if (self) {
        formController = nil;
        formController = self;
        [self setup];
    }
    return self;
}

+ (HFormController2 *)formInstance {
     return HFormController2.new;
}

- (HTupleView *)tupleView {
    if (!_tupleView) {
        CGRect frame = [UIScreen mainScreen].bounds;
        _tupleView = [[HTupleView alloc] initWithFrame:frame];
        [_tupleView setTupleDelegate:self];
        [_tupleView setScrollEnabled:NO];
    }
    return _tupleView;
}

- (void)setup {
    //默认为1
    self.numberOfRows = 1;
    //添加view
    [[UIApplication sharedApplication].delegate.window addSubview:self.tupleView];
}

- (NSInteger)tupleView:(HTupleView *)tupleView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (CGSize)tupleView:(HTupleView *)tupleView sizeForHeaderInSection:(NSInteger)section {
    NSInteger height = KFooterHeight;
    if (HIPhoneX) {
        height += 34;
    }
    return CGSizeMake(tupleView.width, tupleView.height-KItemHeight*self.numberOfRows-height);
}

- (CGSize)tupleView:(HTupleView *)tupleView sizeForFooterInSection:(NSInteger)section {
    NSInteger height = KFooterHeight;
    if (HIPhoneX) {
        height += 34;
    }
    return CGSizeMake(tupleView.width, height);
}

- (CGSize)tupleView:(HTupleView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(tupleView.width, KItemHeight*self.numberOfRows);
}

- (UIEdgeInsets)tupleView:(HTupleView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsZero;
}

- (UIEdgeInsets)tupleView:(HTupleView *)tupleView edgeInsetsForFooterInSection:(NSInteger)section {
    NSInteger height = 0;
    if (HIPhoneX) {
        height += 34;
    }
    return UIEdgeInsetsMake(10, 0, height, 0);
}

- (void)tupleView:(HTupleView *)tupleView headerTuple:(HHeaderTuple)headerBlock inSection:(NSInteger)section {
    HReusableButtonView *cell = headerBlock(nil, HReusableButtonView.class, nil, YES);
    [cell.buttonView setBackgroundColor:[UIColor clearColor]];
//    [cell.buttonView setPressed:^(id sender, id data) {
//        //销毁对象
//        [self destroy];
//    }];
}

- (void)tupleView:(HTupleView *)tupleView footerTuple:(HFooterTuple)footerBlock inSection:(NSInteger)section {
    HReusableButtonView *cell = footerBlock(nil, HReusableButtonView.class, nil, YES);
    [cell.buttonView setBackgroundColor:[UIColor whiteColor]];
    [cell.buttonView.button setTitleColor:[UIColor blackColor]];
    [cell.buttonView.button setTitle:@"取消"];
    [cell.buttonView setPressed:^(id sender, id data) {
        //销毁对象
        [self destroy];
    }];
}

- (void)tupleView:(HTupleView *)tupleView itemTuple:(HItemTuple)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    
    HFormCell *cell = itemBlock(nil, HFormCell.class, nil, YES);

    NSMutableArray *mutableArr = NSMutableArray.array;
    
    HFormModel *model = [HFormModel modelWithTitle:@"title" icon:nil];
    [mutableArr addObject:model];
    model = [HFormModel modelWithTitle:@"title" icon:nil];
    [mutableArr addObject:model];
    model = [HFormModel modelWithTitle:@"title" icon:nil];
    [mutableArr addObject:model];
    model = [HFormModel modelWithTitle:@"title" icon:nil];
    [mutableArr addObject:model];
    model = [HFormModel modelWithTitle:@"title" icon:nil];
    [mutableArr addObject:model];
    model = [HFormModel modelWithTitle:@"title" icon:nil];
    [mutableArr addObject:model];
    model = [HFormModel modelWithTitle:@"title" icon:nil];
    [mutableArr addObject:model];
    model = [HFormModel modelWithTitle:@"title" icon:nil];
    [mutableArr addObject:model];
    
    [cell setModelArr:mutableArr];
    
    //配置参数
    [cell setRows:1];
    [self setNumberOfRows:cell.rows];
    
    [cell setFormCellBlock:^(NSIndexPath *idxPath, HFormModel *model) {
        
        //销毁对象
        [self destroy];
    }];
}

//销毁对象
- (void)destroy {
    //弹框消失
    [self.tupleView removeFromSuperview];
    //释放对象
    formController = nil;
}

@end
