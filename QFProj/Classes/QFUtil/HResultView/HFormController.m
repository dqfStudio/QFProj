//
//  HFormController.m
//  HProjectModel1
//
//  Created by wind on 2018/12/31.
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
    }
    return _tupleView;
}

- (void)setup {
    //添加view
    [[UIApplication sharedApplication].delegate.window addSubview:self.tupleView];
    
    @www
    [self.tupleView tupleWithSections:^CGFloat{
        return 1;
    } items:^CGFloat(NSInteger section) {
        return 1;
    } color:^UIColor * _Nullable(NSInteger section) {
        return nil;
    } inset:^UIEdgeInsets(NSInteger section) {
        return UIEdgeInsetsZero;
    }];
    
//    [self.tupleView headerWithSize:^CGSize(NSInteger section) {
//        @sss
//        NSInteger height = KFooterHeight;
//        if (UIDevice.isIPhoneX) height += UIDevice.bottomBarHeight;
//        return CGSizeMake(self.tupleView.width, self.tupleView.height-KItemHeight*self.numberOfRows-height);
//    } edgeInsets:^UIEdgeInsets(NSInteger section) {
//        return UIEdgeInsetsZero;
//    } tupleHeader:^(HTupleHeader  _Nonnull headerBlock, NSInteger section) {
//        headerBlock(nil, HTupleButtonView.class, nil, YES);
////        HTupleButtonView *cell = headerBlock(nil, HTupleButtonView.class, nil, YES);
////        [cell.buttonView setPressed:^(id sender, id data) {
////            //销毁对象
////            [self destroy];
////        }];
//    }];
    
    [self.tupleView footerWithSize:^CGSize(NSInteger section) {
        @sss
        NSInteger height = KFooterHeight;
        if (UIDevice.isIPhoneX) height += UIDevice.bottomBarHeight;
        return CGSizeMake(self.tupleView.width, height);
    } edgeInsets:^UIEdgeInsets(NSInteger section) {
        NSInteger height = 0;
        if (UIDevice.isIPhoneX) height += UIDevice.bottomBarHeight;
        return UIEdgeInsetsMake(10, 0, height, 0);
    } tupleFooter:^(HTupleFooter  _Nonnull footerBlock, NSIndexPath *indexPath) {
        @sss
        HTupleButtonView *cell = footerBlock(nil, HTupleButtonView.class, nil, YES);
        [cell.buttonView setBackgroundColor:[UIColor whiteColor]];
        [cell.buttonView setTitleColor:[UIColor blackColor]];
        [cell.buttonView setTitle:@"取消"];
        [cell.buttonView setPressed:^(id sender, id data) {
            //销毁对象
            [self destroy];
        }];
    }];
    
    [self.tupleView itemWithSize:^CGSize(NSIndexPath * _Nonnull indexPath) {
        @sss
        return CGSizeMake(self.tupleView.width, KItemHeight*self.numberOfRows);
    } edgeInsets:^UIEdgeInsets(NSIndexPath * _Nonnull indexPath) {
        return UIEdgeInsetsZero;
    } tupleItem:^(HTupleItem  _Nonnull itemBlock, NSIndexPath * _Nonnull indexPath) {
        @sss
        HFormCell *cell = itemBlock(nil, HFormCell.class, nil, YES);
        [cell setModelArr:self.sourceArr];
        
        //配置参数
        [cell setRows:self.numberOfRows];
        [cell setRowItems:self.rowItems];
        
        [cell setFormCellBlock:^(NSIndexPath *idxPath, HFormModel *model) {
            @sss
            if (self.cellBlock) {
                self.cellBlock(indexPath, model);
            }
        }];
    }];
}

//销毁对象
- (void)destroy {
    //弹框消失
    [self.tupleView removeFromSuperview];
}

@end
