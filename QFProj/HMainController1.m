//
//  HMainController1.m
//  QFProj
//
//  Created by wind on 2019/9/4.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HMainController1.h"

@interface HMainController1 ()

@end

@implementation HMainController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.leftNaviButton setHidden:YES];
    [self setTitle:@"第一页"];
    [self.tupleView setTupleDelegate:self];
}

- (NSInteger)numberOfSectionsInTupleView:(HTupleView *)tupleView {
    return 1;
}
- (NSInteger)tupleView:(HTupleView *)tupleView numberOfItemsInSection:(NSInteger)section {
    return 8;
}
- (CGSize)tupleView:(HTupleView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        case 1:
        case 2:
            return CGSizeMake(self.tupleView.width, 65);
            break;
        case 3:
        case 4:
        case 5:
            return CGSizeMake(self.tupleView.width/3, 120);
            break;
            
        default:
            break;
    }
    return CGSizeMake(self.tupleView.width, 65);
}
- (UIEdgeInsets)tupleView:(HTupleView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 3:
            return UIEdgeInsetsMake(10, 10, 10, 5);
        case 4:
            return UIEdgeInsetsMake(10, 5, 10, 5);
        case 5:
            return UIEdgeInsetsMake(10, 5, 10, 10);
        default:
            break;
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (void)tupleView:(HTupleView *)tupleView tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            HTupleViewCellDefault1 *cell = itemBlock(nil, HTupleViewCellDefault1.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
            [cell loadCell];

//            [cell.imageView setBackgroundColor:UIColor.redColor];
//            [cell.imageView setImageWithName:@"icon_no_server"];
////
//            [cell.detailView setImageWithName:@"icon_no_server"];
            
            [cell.label setBackgroundColor:UIColor.redColor];

//            [cell.detailLabel setBackgroundColor:UIColor.yellowColor];

//            [cell.accessoryLabel setBackgroundColor:UIColor.greenColor];
            
            //接收信号
            [cell setSignalBlock:^(HTupleViewCell *cell, HTupleSignal *signal) {
                
            }];
        }
            break;
        case 1: {
            HTupleViewCell *cell = itemBlock(nil, HTupleViewCell.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
            
            CGRect frame = [cell getContentBounds];
            
            CGRect tmpFrame = frame;
            tmpFrame.size.width = CGRectGetHeight(tmpFrame);
            [cell.imageView setFrame:tmpFrame];
            [cell.imageView setBackgroundColor:UIColor.redColor];
            [cell.imageView setImageWithName:@"icon_no_server"];
            
            CGRect tmpFrame2 = CGRectMake(0, 0, 10, 18);
            tmpFrame2.origin.x = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame2);
            tmpFrame2.origin.y = CGRectGetHeight(frame)/2-CGRectGetHeight(tmpFrame2)/2;
            [cell.accessoryView setFrame:tmpFrame2];
            [cell.accessoryView setImageWithName:@"icon_tuple_arrow_right"];
            
            CGRect tmpFrame3 = frame;
            tmpFrame3.origin.x += CGRectGetMaxX(tmpFrame)+10;
            tmpFrame3.size.width = CGRectGetMinX(tmpFrame2)-CGRectGetMinX(tmpFrame3)-10;
            tmpFrame3.size.height = tmpFrame.size.height/2;
            [cell.label setFrame:tmpFrame3];
            [cell.label setBackgroundColor:UIColor.redColor];
            
            CGRect tmpFrame4 = tmpFrame3;
            tmpFrame4.origin.y += CGRectGetMaxY(tmpFrame3);
            [cell.detailLabel setFrame:tmpFrame4];
            [cell.detailLabel setBackgroundColor:UIColor.yellowColor];
            
            //接收信号
            [cell setSignalBlock:^(HTupleViewCell *cell, HTupleSignal *signal) {
                
            }];
            
            //发送信号
            //[self.tupleView signal:nil indexPath:NSIndexPath.getValue(0, 0)];
        }
            break;
        case 2: {
            HTupleViewCell *cell = itemBlock(nil, HTupleViewCell.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
            
            CGRect frame = [cell getContentBounds];
            
            CGRect tmpFrame = frame;
            tmpFrame.size.width = CGRectGetHeight(tmpFrame);
            [cell.imageView setFrame:tmpFrame];
            [cell.imageView setBackgroundColor:UIColor.redColor];
            [cell.imageView setImageWithName:@"icon_no_server"];
            
            CGRect tmpFrame2 = CGRectMake(0, 0, 10, 18);;
            tmpFrame2.origin.x = CGRectGetWidth(frame)-CGRectGetWidth(tmpFrame2);
            tmpFrame2.origin.y = CGRectGetHeight(frame)/2-CGRectGetHeight(tmpFrame2)/2;
            [cell.accessoryView setFrame:tmpFrame2];
            [cell.accessoryView setImageWithName:@"icon_tuple_arrow_right"];
            
            CGRect tmpFrame3 = tmpFrame;
            tmpFrame3.origin.x = CGRectGetMinX(tmpFrame2)-CGRectGetWidth(tmpFrame3)-10;
            [cell.detailView setFrame:tmpFrame3];
            [cell.detailView setBackgroundColor:UIColor.redColor];
            [cell.detailView setImageWithName:@"icon_no_server"];
            
            CGRect tmpFrame4 = frame;
            tmpFrame4.origin.x += CGRectGetMaxX(tmpFrame)+10;
            tmpFrame4.size.width = CGRectGetMinX(tmpFrame3)-CGRectGetWidth(tmpFrame)-10-10;
            tmpFrame4.size.height = CGRectGetHeight(tmpFrame)/2;
            [cell.label setFrame:tmpFrame4];
            [cell.label setBackgroundColor:UIColor.redColor];
            
            CGRect tmpFrame5 = tmpFrame4;
            tmpFrame5.origin.y += CGRectGetMaxY(tmpFrame4);
            [cell.detailLabel setFrame:tmpFrame5];
            [cell.detailLabel setBackgroundColor:UIColor.yellowColor];
        }
            break;
        case 3: {
            HTupleViewCell *cell = itemBlock(nil, HTupleViewCell.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
            
            CGRect frame = [cell getContentBounds];
            
            CGRect tmpFrame = frame;
            tmpFrame.size.height = CGRectGetHeight(frame)-25;
            [cell.imageView setFrame:tmpFrame];
            [cell.imageView setBackgroundColor:UIColor.redColor];
            [cell.imageView setImageWithName:@"icon_no_server"];
            [cell.imageView setFillet:YES];
            
            CGRect tmpFrame2 = frame;
            tmpFrame2.origin.y += CGRectGetMaxY(tmpFrame)+5;
            tmpFrame2.size.height = 20;
            [cell.label setFrame:tmpFrame2];
            [cell.label setFont:[UIFont systemFontOfSize:14]];
            [cell.label setTextAlignment:NSTextAlignmentCenter];
            [cell.label setText:@"黑客帝国"];
        }
            break;
        case 4: {
            HTupleViewCell *cell = itemBlock(nil, HTupleViewCell.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            
            CGRect frame = [cell getContentBounds];
            
            CGRect tmpFrame = frame;
            tmpFrame.size.height = CGRectGetHeight(frame)-25;
            [cell.imageView setFrame:tmpFrame];
            [cell.imageView setBackgroundColor:UIColor.redColor];
            [cell.imageView setImageWithName:@"icon_no_server"];
            [cell.imageView setFillet:YES];
            
            CGRect tmpFrame2 = frame;
            tmpFrame2.origin.y += CGRectGetMaxY(tmpFrame)+5;
            tmpFrame2.size.height = 20;
            [cell.label setFrame:tmpFrame2];
            [cell.label setFont:[UIFont systemFontOfSize:14]];
            [cell.label setTextAlignment:NSTextAlignmentCenter];
            [cell.label setText:@"黑客帝国"];
        }
            break;
        case 5: {
            HTupleViewCell *cell = itemBlock(nil, HTupleViewCell.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 10)];

            CGRect frame = [cell getContentBounds];

            CGRect tmpFrame = frame;
            tmpFrame.size.height = CGRectGetHeight(frame)-25;
            [cell.imageView setFrame:tmpFrame];
            [cell.imageView setBackgroundColor:UIColor.redColor];
            [cell.imageView setImageWithName:@"icon_no_server"];
            [cell.imageView setFillet:YES];

            CGRect tmpFrame2 = frame;
            tmpFrame2.origin.y += CGRectGetMaxY(tmpFrame)+5;
            tmpFrame2.size.height = 20;
            [cell.label setFrame:tmpFrame2];
            [cell.label setFont:[UIFont systemFontOfSize:14]];
            [cell.label setTextAlignment:NSTextAlignmentCenter];
            [cell.label setText:@"黑客帝国"];
        }
            break;
        case 6: {
            HTupleViewCell *cell = itemBlock(nil, HTupleViewCell.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
            
            CGRect frame = [cell getContentBounds];
            
            CGRect tmpFrame = frame;
            tmpFrame.size.width = tmpFrame.size.width/3-20/3;
            [cell.label setFrame:tmpFrame];
            [cell.label setBackgroundColor:UIColor.greenColor];
            [cell.label setText:@"header"];
            [cell.label setTextAlignment:NSTextAlignmentCenter];
            
            CGRect tmpFrame2 = frame;
            tmpFrame2.origin.x = CGRectGetMaxX(tmpFrame)+10;
            tmpFrame2.size.width = tmpFrame.size.width;
            [cell.detailLabel setFrame:tmpFrame2];
            [cell.detailLabel setBackgroundColor:UIColor.redColor];
            [cell.detailLabel setText:@"cell"];
            [cell.detailLabel setTextAlignment:NSTextAlignmentCenter];
            
            CGRect tmpFrame3 = frame;
            tmpFrame3.origin.x = CGRectGetMaxX(tmpFrame2)+10;
            tmpFrame3.size.width = tmpFrame.size.width;
            [cell.accessoryLabel setFrame:tmpFrame3];
            [cell.accessoryLabel setBackgroundColor:UIColor.yellowColor];
            [cell.accessoryLabel setText:@"footer"];
            [cell.accessoryLabel setTextAlignment:NSTextAlignmentCenter];
        }
            break;
        case 7: {
            HTupleTextFieldCell *cell = itemBlock(nil, HTupleTextFieldCell.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell.textField setBackgroundColor:UIColor.redColor];
            
            CGRect frame = [cell getContentBounds];
            
            [cell.textField.leftLabel setFrame:CGRectMake(0, 0, 50, CGRectGetHeight(frame))];
            [cell.textField.leftLabel setTextAlignment:NSTextAlignmentCenter];
            [cell.textField.leftLabel setText:@"验证码"];
            [cell.textField.leftLabel setFont:[UIFont systemFontOfSize:14]];
            [cell.textField.leftLabel setBackgroundColor:UIColor.greenColor];
            cell.textField.leftInsets = UIEdgeInsetsMake(0, 0, 0, 5);
            
            [cell.textField setPlaceholder:@"请输入验证码"];
            [cell.textField setPlaceholderColor:[UIColor whiteColor]];
            [cell.textField setTextColor:[UIColor whiteColor]];
            [cell.textField setFont:[UIFont systemFontOfSize:14]];
            
            [cell.textField.rightButton setFrame:CGRectMake(0, 0, 90, CGRectGetHeight(frame))];
            [cell.textField.rightButton setTitle:@"获取验证码"];
            [cell.textField.rightButton setFont:[UIFont systemFontOfSize:14]];
            [cell.textField.rightButton setBackgroundColor:UIColor.greenColor];
            [cell.textField.rightButton setPressed:^(id sender, id data) {

            }];
        }
            break;
            
        default:
            break;
    }
    
}
- (void)tupleView:(HTupleView *)tupleView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

@end
