//
//  HRegisterController+SJ.m
//  QFProj
//
//  Created by wind on 2019/7/15.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HRegisterController+SJ.h"

@interface HRegisterController ()

@end

@implementation HRegisterController (SJ)
- (NSInteger)tuple1_numberOfSectionsIntupleView:(HTupleView *)tupleView {
    return 3;
}
- (NSInteger)tuple1_tupleView:(HTupleView *)tupleView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 1: return 5;
        case 2: return 1;
        default: return 0;
    }
}

- (CGSize)tuple1_tupleView:(HTupleView *)tupleView sizeForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 1: return CGSizeMake(tupleView.width, 5);
        case 2: return CGSizeZero;
        default: return CGSizeZero;
    }
}
- (CGSize)tuple1_tupleView:(HTupleView *)tupleView sizeForFooterInSection:(NSInteger)section {
    switch (section) {
        case 1: return CGSizeMake(tupleView.width, 15);
        case 2: return CGSizeZero;
        default: return CGSizeZero;
    }
}
- (CGSize)tuple1_tupleView:(HTupleView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 1: {
            if (indexPath.row == 0) {
                return CGSizeMake(tupleView.width, 55);
            }else if (indexPath.row == 3) {
                return CGSizeMake(tupleView.width-100, 55);
            }else if (indexPath.row == 4) {
                return CGSizeMake(100, 55);
            }
            return CGSizeMake(tupleView.width, 55);
        }
            break;
        case 2: return CGSizeMake(tupleView.width, 55);
        default: return CGSizeZero;
    }
}

- (UIEdgeInsets)tuple1_tupleView:(HTupleView *)tupleView edgeInsetsForHeaderInSection:(NSInteger)section {
    return UIEdgeInsetsZero;
}
- (UIEdgeInsets)tuple1_tupleView:(HTupleView *)tupleView edgeInsetsForFooterInSection:(NSInteger)section {
    return UIEdgeInsetsZero;
}
- (UIEdgeInsets)tuple1_tupleView:(HTupleView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 2: return UIEdgeInsetsMake(0, 30, 0, 30);
        default: return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsZero;
}

- (UIEdgeInsets)tuple1_tupleView:(HTupleView *)tupleView insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (void)tuple1_tupleView:(HTupleView *)tupleView tupleHeader:(HTupleHeader)headerBlock inSection:(NSInteger)section {
    headerBlock(nil, HTupleBaseApex.class, nil, NO);
}
- (void)tuple1_tupleView:(HTupleView *)tupleView tupleFooter:(HTupleFooter)footerBlock inSection:(NSInteger)section {
    footerBlock(nil, HTupleBaseApex.class, nil, NO);
}
- (void)tuple1_tupleView:(HTupleView *)tupleView tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    HTupleTextFieldCell *cell = itemBlock(nil,HTupleTextFieldCell.class, @"tuple1", YES);
    [cell.textField setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
    
    [cell.textField setLeftWidth:80];
    [cell.textField.leftLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.textField.leftLabel setText:@"+86"];
    
    [cell.textField setTextColor:[UIColor colorWithString:@"#BABABF"]];
    [cell.textField setFont:[UIFont systemFontOfSize:14]];
    [cell.textField setText:[self.tupleView objectForKey:@"state"]];
    
    [cell setSignalBlock:^(HTupleTextFieldCell *cell, HTupleSignal *signal) {
        
    }];
}

@end
