//
//  HFormController.m
//  HProjectModel1
//
//  Created by dqf on 2018/12/31.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HFormController.h"
#import "UIDevice+HUtil.h"
#import "UIButton+HUtil.h"
#import "HTupleView.h"

#define KItemHeight     80
#define KFooterHeight   50

@interface HFormController ()
@property (nonatomic) HTupleView *tupleView;
@property (nonatomic) NSInteger numberOfRows;
@property (nonatomic) NSInteger rowItems;
@property (nonatomic, copy) NSArray *sourceArr;
@property (nonatomic, copy) HFormCellBlock cellBlock;
@end

@implementation HFormController

+ (instancetype)formControllerWithModel:(NSArray<HFormModel *> *)models
                           numberOfRows:(NSInteger)rows
                               rowItems:(NSInteger)items
                            buttonBlock:(HFormCellBlock)buttonBlock {
    HFormController *formController = HFormController.new;
    formController.sourceArr = models;
    formController.numberOfRows = rows;
    formController.rowItems = items;
    [formController setup];
    return formController;
}

- (HTupleView *)tupleView {
    if (!_tupleView) {
        CGRect frame = [UIScreen mainScreen].bounds;
        _tupleView = [[HTupleView alloc] initWithFrame:frame];
        [_tupleView setScrollEnabled:NO];
        [_tupleView setDelegate:(id<HTupleViewDelegate>)self];
    }
    return _tupleView;
}

- (void)setup {
    //添加view
    [[UIApplication sharedApplication].delegate.window addSubview:self.tupleView];
}

- (NSInteger)numberOfSectionsInTupleView:(HTupleView *)tupleView {
    return 1;
}
- (NSInteger)tupleView:(HTupleView *)tupleView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (CGSize)tupleView:(HTupleView *)tupleView sizeForHeaderInSection:(NSInteger)section {
    NSInteger height = KFooterHeight;
    if (UIDevice.isIPhoneX) height += UIDevice.bottomBarHeight;
    return CGSizeMake(self.tupleView.width, self.tupleView.height-KItemHeight*self.numberOfRows-height);
}
- (CGSize)tupleView:(HTupleView *)tupleView sizeForFooterInSection:(NSInteger)section {
    NSInteger height = KFooterHeight;
    if (UIDevice.isIPhoneX) height += UIDevice.bottomBarHeight;
    return CGSizeMake(self.tupleView.width, height);
}
- (CGSize)tupleView:(HTupleView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.tupleView.width, KItemHeight*self.numberOfRows);
}

- (UIEdgeInsets)tupleView:(HTupleView *)tupleView edgeInsetsForFooterInSection:(NSInteger)section {
    NSInteger height = 0;
    if (UIDevice.isIPhoneX) height += UIDevice.bottomBarHeight;
    return UIEdgeInsetsMake(10, 0, height, 0);
}

- (void)tupleView:(HTupleView *)tupleView tupleHeader:(HTupleHeader)headerBlock inSection:(NSInteger)section {
    headerBlock(nil, HTupleButtonApex.class, nil, YES);
//    HTupleButtonApex *cell = headerBlock(nil, HTupleButtonApex.class, nil, YES);
//    [cell.buttonView setPressed:^(id sender, id data) {
//        //销毁对象
//        [self destroy];
//    }];
}
- (void)tupleView:(HTupleView *)tupleView tupleFooter:(HTupleFooter)footerBlock inSection:(NSInteger)section {
    HTupleButtonApex *cell = footerBlock(nil, HTupleButtonApex.class, nil, YES);
    [cell.buttonView setBackgroundColor:[UIColor whiteColor]];
    [cell.buttonView setTitleColor:[UIColor blackColor]];
    [cell.buttonView setTitle:@"取消"];
    [cell.buttonView setPressed:^(id sender, id data) {
        //销毁对象
        [self destroy];
    }];
}
- (void)tupleView:(HTupleView *)tupleView tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    HFormCell *cell = itemBlock(nil, HFormCell.class, nil, YES);
    [cell setModelArr:self.sourceArr];
    
    //配置参数
    [cell setRows:self.numberOfRows];
    [cell setRowItems:self.rowItems];
    @www
    [cell setFormCellBlock:^(NSIndexPath *idxPath, HFormModel *model) {
        @sss
        if (self.cellBlock) {
            self.cellBlock(indexPath, model);
        }
    }];
}

//销毁对象
- (void)destroy {
    //弹框消失
    [self.tupleView removeFromSuperview];
}

@end
