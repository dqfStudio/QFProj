//
//  HRegisterController+SJ.m
//  QFProj
//
//  Created by dqf on 2019/7/15.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HRegisterController+SJ.h"

@interface HRegisterController ()

@end

@implementation HRegisterController (SJ)
- (NSInteger)tuple1_numberOfSectionsInTupleView {
    return 3;
}
- (NSInteger)tuple1_numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case HCell1: return 5;
        case HCell2: return 1;
        default: return 0;
    }
}

- (CGSize)tuple1_sizeForHeaderInSection:(NSInteger)section {
    switch (section) {
        case HCell1: return CGSizeMake(self.tupleView.width, 5);
        case HCell2: return CGSizeZero;
        default: return CGSizeZero;
    }
}
- (CGSize)tuple1_sizeForFooterInSection:(NSInteger)section {
    switch (section) {
        case HCell1: return CGSizeMake(self.tupleView.width, 15);
        case HCell2: return CGSizeZero;
        default: return CGSizeZero;
    }
}
- (CGSize)tuple1_sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case HCell1: {
            if (indexPath.row == 0) {
                return CGSizeMake(self.tupleView.width, 55);
            }else if (indexPath.row == 3) {
                return CGSizeMake(self.tupleView.width-100, 55);
            }else if (indexPath.row == 4) {
                return CGSizeMake(100, 55);
            }
            return CGSizeMake(self.tupleView.width, 55);
        }
            break;
        case HCell2: return CGSizeMake(self.tupleView.width, 55);
        default: return CGSizeZero;
    }
}

- (UIEdgeInsets)tuple1_edgeInsetsForHeaderInSection:(NSInteger)section {
    return UIEdgeInsetsZero;
}
- (UIEdgeInsets)tuple1_edgeInsetsForFooterInSection:(NSInteger)section {
    return UIEdgeInsetsZero;
}
- (UIEdgeInsets)tuple1_edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case HCell2: return UIEdgeInsetsMake(0, 30, 0, 30);
        default: return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsZero;
}

- (UIEdgeInsets)tuple1_insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (void)tuple1_tupleHeader:(HTupleHeader)headerBlock inSection:(NSInteger)section {
    headerBlock(nil, HTupleBaseApex.class, nil, NO);
}
- (void)tuple1_tupleFooter:(HTupleFooter)footerBlock inSection:(NSInteger)section {
    footerBlock(nil, HTupleBaseApex.class, nil, NO);
}
- (void)tuple1_tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
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
