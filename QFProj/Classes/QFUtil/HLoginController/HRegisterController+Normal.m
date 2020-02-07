//
//  HRegisterController+Normal.m
//  QFProj
//
//  Created by wind on 2020/2/5.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HRegisterController+Normal.h"

@implementation HRegisterController (Normal)

//- (NSInteger)numberOfSectionsInTupleView {
//    return 3;
//}
//- (NSInteger)numberOfItemsInSection:(NSInteger)section {
//    switch (section) {
//        case 1: return 6;
//        case 2: return 1;
//        default:break;
//    }
//    return 0;
//}
//
//- (CGSize)sizeForHeaderInSection:(NSInteger)section {
//    switch (section) {
//        case 1: return CGSizeMake(tupleView.width, 5);
//        case 2: return CGSizeZero;
//        default: return CGSizeZero;
//    }
//}
//- (CGSize)sizeForFooterInSection:(NSInteger)section {
//    switch (section) {
//        case 1: return CGSizeMake(tupleView.width, 15);
//        case 2: return CGSizeZero;
//        default:return CGSizeZero;
//    }
//}
//- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    switch (indexPath.section) {
//        case 1: return CGSizeMake(tupleView.width, 55);
//        case 2: return CGSizeMake(tupleView.width, 55);
//        default: return CGSizeZero;
//    }
//}
//
//- (UIEdgeInsets)edgeInsetsForHeaderInSection:(NSInteger)section {
//    return UIEdgeInsetsZero;
//}
//- (UIEdgeInsets)edgeInsetsForFooterInSection:(NSInteger)section {
//    return UIEdgeInsetsZero;
//}
//- (UIEdgeInsets)edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
//    switch (indexPath.section) {
//        case 2: return UIEdgeInsetsMake(0, 60, 0, 60);
//        default: return UIEdgeInsetsZero;
//    }
//}
//
//- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsZero;
//}
//
//- (void)tupleHeader:(HTupleHeader)headerBlock inSection:(NSInteger)section {
//    headerBlock(nil, HTupleBaseApex.class, nil, NO);
//}
//- (void)tupleFooter:(HTupleFooter)footerBlock inSection:(NSInteger)section {
//    footerBlock(nil, HTupleBaseApex.class, nil, NO);
//}
//- (void)tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
//    HTupleTextFieldCell *cell = itemBlock(nil, HTupleTextFieldCell.class, @"tuple0", YES);
//    [cell.textField setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
//
//    [cell.textField setLeftWidth:80];
//    [cell.textField.leftLabel setTextAlignment:NSTextAlignmentCenter];
//    [cell.textField.leftLabel setText:@"昵称"];
//
//    [cell.textField setTextColor:[UIColor colorWithString:@"#BABABF"]];
//    [cell.textField setFont:[UIFont systemFontOfSize:14]];
//    [cell.textField setText:[self.tupleView objectForKey:@"state"]];
//
//    [cell setSignalBlock:^(HTupleTextFieldCell *cell, HTupleSignal *signal) {
//
//    }];
//}

@end
