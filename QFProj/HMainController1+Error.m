//
//  HMainController1+Error.m
//  QFProj
//
//  Created by wind on 2020/3/18.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HMainController1+Error.h"

@implementation HMainController1 (Error)

- (NSInteger)tuple0_numberOfSectionsInTupleView {
    return 1;
}
- (NSInteger)tuple0_numberOfItemsInSection:(NSInteger)section {
    return 8;
}
- (UIEdgeInsets)tuple0_insetForSection:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
- (UIColor *)tuple0_colorForSection:(NSInteger)section {
    return UIColor.redColor;
}
- (CGSize)tuple0_sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case HCell0:
        case HCell1:
        case HCell2:
            return CGSizeMake(self.tupleView.sectionWidth(indexPath.section), 65);
            break;
        case HCell3:
        case HCell4:
        case HCell5: {
            CGFloat width = self.tupleView.sectionWidth(indexPath.section);
            width = [self.tupleView fixSlitWith:width colCount:3 index:indexPath.row-3];
            return CGSizeMake(width, 120);
        }
            break;
            
        default:
            break;
    }
    return CGSizeMake(self.tupleView.sectionWidth(indexPath.section), 65);
}
- (UIEdgeInsets)tuple0_edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case HCell3:
            return UIEdgeInsetsMake(10, 10, 10, 5);
        case HCell4:
            return UIEdgeInsetsMake(10, 5, 10, 5);
        case HCell5:
            return UIEdgeInsetsMake(10, 5, 10, 10);
        default:
            break;
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (void)tuple0_tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case HCell0: {
            HTupleViewCellHoriValue4 *cell = itemBlock(nil, HTupleViewCellHoriValue4.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UILREdgeInsetsMake(10, 10)];
            
            [cell.imageView setBackgroundColor:HColorHexAlpha(#E8E7EE, 0.6)];

            [cell.detailView setBackgroundColor:HColorHexAlpha(#E8E7EE, 0.6)];
            
            cell.showAccessoryArrow = YES;
            
            cell.labelInsets = UIEdgeInsetsMake(2.5, 0, 2.5, 30);
            [cell.label setBackgroundColor:HColorHexAlpha(#E8E7EE, 0.6)];
            
            cell.detailLabelInsets = UIEdgeInsetsMake(2.5, 0, 2.5, 100);
            [cell.detailLabel setBackgroundColor:HColorHexAlpha(#E8E7EE, 0.6)];

            cell.accessoryLabelInsets = UIEdgeInsetsMake(2.5, 0, 2.5, 180);
            [cell.accessoryLabel setBackgroundColor:HColorHexAlpha(#E8E7EE, 0.6)];
            
            //接收信号
            [cell setSignalBlock:^(HTupleViewCellHoriValue4 *cell, HTupleSignal *signal) {
                
            }];
        }
            break;
        case HCell1: {
            HTupleViewCellHoriValue4 *cell = itemBlock(nil, HTupleViewCellHoriValue4.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UILREdgeInsetsMake(10, 10)];
            
            [cell.imageView setBackgroundColor:HColorHexAlpha(#E8E7EE, 0.6)];
            
            cell.labelInsets = UIEdgeInsetsMake(2.5, 0, 2.5, 30);
            [cell.label setBackgroundColor:HColorHexAlpha(#E8E7EE, 0.6)];
            
            cell.detailLabelInsets = UIEdgeInsetsMake(2.5, 0, 2.5, 100);
            [cell.detailLabel setBackgroundColor:HColorHexAlpha(#E8E7EE, 0.6)];

            cell.accessoryLabelInsets = UIEdgeInsetsMake(2.5, 0, 2.5, 180);
            [cell.accessoryLabel setBackgroundColor:HColorHexAlpha(#E8E7EE, 0.6)];
            
            //接收信号
            [cell setSignalBlock:^(HTupleViewCellHoriValue4 *cell, HTupleSignal *signal) {
                
            }];
            
            //发送信号
            //[self.tupleView signal:nil toRow:HCell0 inSection:HSection0];
        }
            break;
        case HCell2: {
            HTupleViewCellHoriValue4 *cell = itemBlock(nil, HTupleViewCellHoriValue4.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UILREdgeInsetsMake(10, 10)];

            [cell.imageView setBackgroundColor:HColorHexAlpha(#E8E7EE, 0.6)];

            [cell.detailView setBackgroundColor:HColorHexAlpha(#E8E7EE, 0.6)];

            cell.labelInsets = UIEdgeInsetsMake(2.5, 0, 2.5, 30);
            [cell.label setBackgroundColor:HColorHexAlpha(#E8E7EE, 0.6)];
            
            cell.detailLabelInsets = UIEdgeInsetsMake(2.5, 0, 2.5, 100);
            [cell.detailLabel setBackgroundColor:HColorHexAlpha(#E8E7EE, 0.6)];

            cell.accessoryLabelInsets = UIEdgeInsetsMake(2.5, 0, 2.5, 180);
            [cell.accessoryLabel setBackgroundColor:HColorHexAlpha(#E8E7EE, 0.6)];
        }
            break;
        case HCell3: {
            HTupleViewCellVertValue1 *cell = itemBlock(nil, HTupleViewCellVertValue1.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UILREdgeInsetsMake(10, 0)];
            
            [cell.imageView setImage:[UIImage imageWithColor:HColorHexAlpha(#E8E7EE, 0.6)]];
            [cell.imageView setFillet:YES];
            
            cell.labelHeight = 25;
            cell.labelInsets = UITBEdgeInsetsMake(10, 0);
            [cell.label setTextAlignment:NSTextAlignmentCenter];
            [cell.label setBackgroundColor:HColorHexAlpha(#E8E7EE, 0.6)];
        }
            break;
        case HCell4: {
            HTupleViewCellVertValue1 *cell = itemBlock(nil, HTupleViewCellVertValue1.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            
            [cell.imageView setImage:[UIImage imageWithColor:HColorHexAlpha(#E8E7EE, 0.6)]];
            [cell.imageView setFillet:YES];
            
            cell.labelHeight = 25;
            cell.labelInsets = UITBEdgeInsetsMake(10, 0);
            [cell.label setTextAlignment:NSTextAlignmentCenter];
            [cell.label setBackgroundColor:HColorHexAlpha(#E8E7EE, 0.6)];
        }
            break;
        case HCell5: {
            HTupleViewCellVertValue1 *cell = itemBlock(nil, HTupleViewCellVertValue1.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UILREdgeInsetsMake(0, 10)];

            [cell.imageView setImage:[UIImage imageWithColor:HColorHexAlpha(#E8E7EE, 0.6)]];
            [cell.imageView setFillet:YES];

            cell.labelHeight = 25;
            cell.labelInsets = UITBEdgeInsetsMake(10, 0);
            [cell.label setTextAlignment:NSTextAlignmentCenter];
            [cell.label setBackgroundColor:HColorHexAlpha(#E8E7EE, 0.6)];

            cell.didSelectCell = ^(HTupleViewCellVertValue1 *cell, NSIndexPath *indexPath) {
                NSLog(@"选中黑客帝国");
            };
        }
            break;
        case HCell6: {
            HTupleViewCellHoriValue3 *cell = itemBlock(nil, HTupleViewCellHoriValue3.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UILREdgeInsetsMake(10, 10)];
            
            cell.detailWidth  = CGRectGetWidth(cell.layoutViewBounds)/3;
            cell.accessoryWidth = CGRectGetWidth(cell.layoutViewBounds)/3;
            
            cell.centralInsets = UIEdgeInsetsMake(12.5, 10, 12.5, 10);
            
            cell.labelInsets = UILREdgeInsetsMake(5, 5);
            [cell.label setBackgroundColor:HColorHexAlpha(#E8E7EE, 0.6)];

            cell.detailLabelInsets = UILREdgeInsetsMake(5, 0);
            [cell.detailLabel setBackgroundColor:HColorHexAlpha(#E8E7EE, 0.6)];
            
            cell.accessoryLabelInsets = UILREdgeInsetsMake(0, 5);
            [cell.accessoryLabel setBackgroundColor:HColorHexAlpha(#E8E7EE, 0.6)];
        }
            break;
        case HCell7: {
            HTupleTextFieldCell *cell = itemBlock(nil, HTupleTextFieldCell.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell.textField setBackgroundColor:HColorHexAlpha(#E8E7EE, 0.6)];
            cell.textField.editEnabled = NO;
        }
            break;
            
        default:
            break;
    }
    
}

@end
