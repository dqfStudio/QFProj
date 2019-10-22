//
//  HRegisterController+KS.m
//  QFProj
//
//  Created by wind on 2019/7/15.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HRegisterController+KS.h"

@interface HRegisterController ()

@end

@implementation HRegisterController (KS)
- (NSInteger)tuple0_numberOfSectionsIntupleView:(HTupleView *)tupleView {
    return 3;
}
- (NSInteger)tuple0_tupleView:(HTupleView *)tupleView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 1: return 6;
        case 2: return 1;
        default:break;
    }
    return 0;
}

- (CGSize)tuple0_tupleView:(HTupleView *)tupleView sizeForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 1: return CGSizeMake(tupleView.width, 5);
        case 2: return CGSizeZero;
        default: return CGSizeZero;
    }
}
- (CGSize)tuple0_tupleView:(HTupleView *)tupleView sizeForFooterInSection:(NSInteger)section {
    switch (section) {
        case 1: return CGSizeMake(tupleView.width, 15);
        case 2: return CGSizeZero;
        default:return CGSizeZero;
    }
}
- (CGSize)tuple0_tupleView:(HTupleView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 1: return CGSizeMake(tupleView.width, 55);
        case 2: return CGSizeMake(tupleView.width, 55);
        default: return CGSizeZero;
    }
}

- (UIEdgeInsets)tuple0_tupleView:(HTupleView *)tupleView edgeInsetsForHeaderInSection:(NSInteger)section {
    return UIEdgeInsetsZero;
}
- (UIEdgeInsets)tuple0_tupleView:(HTupleView *)tupleView edgeInsetsForFooterInSection:(NSInteger)section {
    return UIEdgeInsetsZero;
}
- (UIEdgeInsets)tuple0_tupleView:(HTupleView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 2: return UIEdgeInsetsMake(0, 60, 0, 60);
        default: return UIEdgeInsetsZero;
    }
}

- (UIEdgeInsets)tuple0_tupleView:(HTupleView *)tupleView insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (void)tuple0_tupleView:(HTupleView *)tupleView tupleHeader:(HTupleHeader)headerBlock inSection:(NSInteger)section {
    headerBlock(nil, HTupleBaseApex.class, nil, NO);
}
- (void)tuple0_tupleView:(HTupleView *)tupleView tupleFooter:(HTupleFooter)footerBlock inSection:(NSInteger)section {
    footerBlock(nil, HTupleBaseApex.class, nil, NO);
}
- (void)tuple0_tupleView:(HTupleView *)tupleView tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    HTupleTextFieldCell *cell = itemBlock(nil, HTupleTextFieldCell.class, @"tuple0", YES);
    [cell.textField setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];

    [cell.textField setLeftWidth:80];
    [cell.textField.leftLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.textField.leftLabel setText:@"昵称"];

    [cell.textField setTextColor:[UIColor colorWithString:@"#BABABF"]];
    [cell.textField setFont:[UIFont systemFontOfSize:14]];
    [cell.textField setText:[self.tupleView objectForKey:@"state"]];

    [cell setSignalBlock:^(HTupleTextFieldCell *cell, HTupleSignal *signal) {
        
    }];
}

@end
