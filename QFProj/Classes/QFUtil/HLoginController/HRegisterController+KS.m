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
        case 0: return 1;
        case 1: return 6;
        case 2: return 1;
        default:break;
    }
    return 0;
}

- (CGSize)tuple0_tupleView:(HTupleView *)tupleView sizeForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return CGSizeMake(tupleView.width, 10);
        case 1: return CGSizeMake(tupleView.width, 5);
        case 2: return CGSizeZero;
        default: return CGSizeZero;
    }
}
- (CGSize)tuple0_tupleView:(HTupleView *)tupleView sizeForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0: return CGSizeZero;
        case 1: return CGSizeMake(tupleView.width, 15);
        case 2: return CGSizeZero;
        default:return CGSizeZero;
    }
}
- (CGSize)tuple0_tupleView:(HTupleView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: return CGSizeMake(tupleView.width, 55);
        case 1: return CGSizeMake(tupleView.width, 25);
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

- (void)tuple0_tupleView:(HTupleView *)tupleView headerTuple:(HTupleHeader)headerBlock inSection:(NSInteger)section {
    headerBlock(nil, HTupleBaseApex.class, nil, NO);
}
- (void)tuple0_tupleView:(HTupleView *)tupleView footerTuple:(HTupleFooter)footerBlock inSection:(NSInteger)section {
    footerBlock(nil, HTupleBaseApex.class, nil, NO);
}
- (void)tuple0_tupleView:(HTupleView *)tupleView itemTuple:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self tuple_tupleView:tupleView itemTuple:itemBlock atIndexPath:indexPath];
    }else {
        HTupleTextFieldCell *cell = itemBlock(nil, HTupleTextFieldCell.class, nil, YES);
        [cell.textField setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
        
        [cell.textField.leftLabel setFrame:CGRectMake(0, 0, 80, 60)];
        [cell.textField.leftLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textField.leftLabel setText:@"昵称"];
        [cell.textField.leftLabel setFont:[UIFont systemFontOfSize:14]];
        
        [cell.textField setPlaceholder:@"请输入昵称"];
        [cell.textField setTextColor:[UIColor colorWithString:@"#BABABF"]];
        [cell.textField setFont:[UIFont systemFontOfSize:14]];
        
        [cell setSignalBlock:^(HTupleTextFieldCell *cell, HTupleSignal *signal) {
            
        }];
    }
}

@end
