//
//  HAcceptVideoVC+HStatus1.m
//  QFProj
//
//  Created by owner on 2023/2/23.
//  Copyright © 2023 dqfStudio. All rights reserved.
//

#import "HAcceptVideoVC+HStatus1.h"

@implementation HAcceptVideoVC (HStatus1)

- (NSInteger)tuple0_numberOfItemsInSection:(NSInteger)section {
    return 8;
}
- (CGSize)tuple0_sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: return CGSizeMake(self.tupleView.width, UIScreen.naviBarHeight+65); break;
        case 1: return CGSizeMake(self.tupleView.width, UIScreen.height-UIScreen.naviBarHeight-65-30-70-(KButtonHeight1+25)-40-(KButtonHeight2+25)-30); break;
        case 2: return CGSizeMake(self.tupleView.width, 30); break;
        case 3: return CGSizeMake(self.tupleView.width, 70); break;
        case 4: return CGSizeMake(self.tupleView.width, KButtonHeight1+25); break;
        case 5: return CGSizeMake(self.tupleView.width, 40); break;
        case 6: return CGSizeMake(self.tupleView.width, KButtonHeight2+25); break;
        case 7: return CGSizeMake(self.tupleView.width, 30); break;
        default:break;
    }
    return CGSizeZero;
}
- (void)tuple0_tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            HTupleViewCell *cell = itemBlock(nil, HTupleViewCell.class, nil, YES);
            CGRect frame = CGRectMake(20, UIScreen.naviBarHeight+15, 30, 30);
            [cell.buttonView setFrame:frame];
            [cell.buttonView setImageWithName:@"mdeia-reduce"];
            [cell.buttonView setPressed:^(id sender, id data) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }
            break;
        case 1: {
            HTupleViewCell *cell = itemBlock(nil, HTupleViewCell.class, nil, YES);
            
            CGRect bounds = cell.layoutViewBounds;
            
            CGRect frame1 = CGRectMake(bounds.size.width/2-40/2, 0, KButtonHeight2, KButtonHeight2);
            [cell.buttonView setFrame:frame1];
            [cell.buttonView setImageWithName:@"mdeia-button"];
            [cell.buttonView setPressed:^(id sender, id data) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
            CGRect frame2 = CGRectMake(bounds.size.width/2-40/2, KButtonHeight2, KButtonHeight2, 25);
            [cell.label setFrame:frame2];
            [cell.label setText:@"昵称"];
            [cell.label setTextColor:UIColor.whiteColor];
            [cell.label setFont:[UIFont systemFontOfSize:12]];
            [cell.label setTextAlignment:NSTextAlignmentCenter];
        }
            break;
        case 2: {
            HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
            [cell.label setText:@"邀请你视频通话..."];
            [cell.label setTextColor:UIColor.whiteColor];
            [cell.label setFont:[UIFont systemFontOfSize:14]];
            [cell.label setTextAlignment:NSTextAlignmentCenter];
            [cell setEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        }
            break;
        case 3: {
            itemBlock(nil, HTupleBlankCell.class, nil, YES);
        }
            break;
        case 4: {
            HTupleViewCell *cell = itemBlock(nil, HTupleViewCell.class, nil, YES);
            
            CGRect bounds = cell.layoutViewBounds;
            
            CGRect frame1 = CGRectMake(bounds.size.width/2-40-KButtonHeight1, 0, KButtonHeight1, KButtonHeight1);
            [cell.buttonView setFrame:frame1];
            [cell.buttonView setImageWithName:@"mdeia-button"];
            [cell.buttonView setPressed:^(id sender, id data) {
                            
            }];
            CGRect frame2 = CGRectMake(bounds.size.width/2-40-KButtonHeight1, KButtonHeight1, KButtonHeight1, 25);
            [cell.label setFrame:frame2];
            [cell.label setText:@"翻转"];
            [cell.label setTextColor:UIColor.whiteColor];
            [cell.label setFont:[UIFont systemFontOfSize:12]];
            [cell.label setTextAlignment:NSTextAlignmentCenter];
            
            
            CGRect frame3 = CGRectMake(bounds.size.width/2+40, 0, KButtonHeight1, KButtonHeight1);
            [cell.detailButtonView setFrame:frame3];
            [cell.detailButtonView setImageWithName:@"mdeia-button"];
            [cell.detailButtonView setPressed:^(id sender, id data) {
                            
            }];
            CGRect frame4 = CGRectMake(bounds.size.width/2+32, KButtonHeight1, KButtonHeight1+20, 25);
            [cell.detailLabel setFrame:frame4];
            [cell.detailLabel setText:@"摄像头已开"];
            [cell.detailLabel setTextColor:UIColor.whiteColor];
            [cell.detailLabel setFont:[UIFont systemFontOfSize:12]];
            [cell.detailLabel setTextAlignment:NSTextAlignmentCenter];
        }
            break;
        case 5: {
            itemBlock(nil, HTupleBlankCell.class, nil, YES);
        }
            break;
        case 6: {
            HTupleViewCell *cell = itemBlock(nil, HTupleViewCell.class, nil, YES);
            
            CGRect bounds = cell.layoutViewBounds;
            
            CGRect frame1 = CGRectMake(40, 0, KButtonHeight2, KButtonHeight2);
            [cell.buttonView setFrame:frame1];
            [cell.buttonView setImageWithName:@"mdeia-button"];
            [cell.buttonView setPressed:^(id sender, id data) {
                
            }];
            CGRect frame2 = CGRectMake(40, KButtonHeight2, KButtonHeight2, 25);
            [cell.label setFrame:frame2];
            [cell.label setText:@"拒绝"];
            [cell.label setTextColor:UIColor.whiteColor];
            [cell.label setFont:[UIFont systemFontOfSize:12]];
            [cell.label setTextAlignment:NSTextAlignmentCenter];
            
            CGRect frame3 = CGRectMake(bounds.size.width-40-KButtonHeight2, 0, KButtonHeight2, KButtonHeight2);
            [cell.detailButtonView setFrame:frame3];
            [cell.detailButtonView setImageWithName:@"mdeia-button"];
            [cell.detailButtonView setPressed:^(id sender, id data) {
                            
            }];
            CGRect frame4 = CGRectMake(bounds.size.width-30-(KButtonHeight2+20), KButtonHeight2, KButtonHeight2+20, 25);
            [cell.detailLabel setFrame:frame4];
            [cell.detailLabel setText:@"接受"];
            [cell.detailLabel setTextColor:UIColor.whiteColor];
            [cell.detailLabel setFont:[UIFont systemFontOfSize:12]];
            [cell.detailLabel setTextAlignment:NSTextAlignmentCenter];
        }
            break;
        case 7: {
            itemBlock(nil, HTupleBlankCell.class, nil, YES);
        }
            break;

        default:
            break;
    }
}

@end
