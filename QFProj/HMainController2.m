//
//  HMainController2.m
//  QFProj
//
//  Created by wind on 2019/9/4.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HMainController2.h"

@interface HMainController2 ()

@end

@implementation HMainController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.leftNaviButton setHidden:YES];
    [self setTitle:@"第二页"];
    [self.tupleView setTupleDelegate:self];
}

- (NSInteger)numberOfSectionsInTupleView:(HTupleView *)tupleView {
    return 1;
}
- (NSInteger)tupleView:(HTupleView *)tupleView numberOfItemsInSection:(NSInteger)section {
    return 7;
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
            HTupleHorizontalCell *cell = itemBlock(nil, HTupleHorizontalCell.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UILREdgeInsetsMake(10, 10)];
            
            CGRect frame = [cell getContentBounds];
            
            [cell.tupleView tupleWithSections:^CGFloat{
                return 1;
            } items:^CGFloat(NSInteger section) {
                return 3;
            } color:^UIColor * _Nullable(NSInteger section) {
                return nil;
            } inset:^UIEdgeInsets(NSInteger section) {
                return UIEdgeInsetsZero;
            }];

            [cell.tupleView headerWithSize:^CGSize(NSInteger section) {
                return CGSizeMake(CGRectGetHeight(frame), CGRectGetHeight(frame));
            } edgeInsets:^UIEdgeInsets(NSInteger section) {
                return UIEdgeInsetsZero;
            } tupleHeader:^(HTupleHeader  _Nonnull headerBlock, NSIndexPath *indexPath) {
                HTupleImageView *cell = headerBlock(nil, HTupleImageView.class, nil, YES);
                [cell setBackgroundColor:UIColor.redColor];
            }];

            [cell.tupleView itemWithSize:^CGSize(NSIndexPath * _Nonnull indexPath) {
                return CGSizeMake(CGRectGetWidth(frame)-CGRectGetHeight(frame), CGRectGetHeight(frame)/3);
            } edgeInsets:^UIEdgeInsets(NSIndexPath * _Nonnull indexPath) {
                return UIEdgeInsetsMake(0, 10, 0, 0);
            } tupleItem:^(HTupleItem  _Nonnull itemBlock, NSIndexPath * _Nonnull indexPath) {
                HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
                switch (indexPath.row) {
                    case 0: {
                        [cell.label setBackgroundColor:UIColor.redColor];
                    }
                        break;
                    case 1: {
                        [cell.label setBackgroundColor:UIColor.yellowColor];
                    }
                        break;
                    case 2: {
                        [cell.label setBackgroundColor:UIColor.greenColor];
                    }
                        break;

                    default:
                        break;
                }
            }];            
        }
            break;
        case 1: {
            HTupleHorizontalCell *cell = itemBlock(nil, HTupleHorizontalCell.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UILREdgeInsetsMake(10, 10)];
            
            CGRect frame = [cell getContentBounds];
            
            [cell.tupleView tupleWithSections:^CGFloat{
                return 1;
            } items:^CGFloat(NSInteger section) {
                return 2;
            } color:^UIColor * _Nullable(NSInteger section) {
                return nil;
            } inset:^UIEdgeInsets(NSInteger section) {
                return UIEdgeInsetsZero;
            }];
            
            [cell.tupleView headerWithSize:^CGSize(NSInteger section) {
                return CGSizeMake(CGRectGetHeight(frame), CGRectGetHeight(frame));
            } edgeInsets:^UIEdgeInsets(NSInteger section) {
                return UIEdgeInsetsZero;
            } tupleHeader:^(HTupleHeader  _Nonnull headerBlock, NSIndexPath *indexPath) {
                HTupleImageView *cell = headerBlock(nil, HTupleImageView.class, nil, YES);
                [cell setBackgroundColor:UIColor.redColor];
            }];
            
            [cell.tupleView footerWithSize:^CGSize(NSInteger section) {
                return CGSizeMake(CGRectGetHeight(frame), CGRectGetHeight(frame));
            } edgeInsets:^UIEdgeInsets(NSInteger section) {
                return UIEdgeInsetsZero;
            } tupleFooter:^(HTupleFooter  _Nonnull footerBlock, NSIndexPath *indexPath) {
                HTupleImageView *cell = footerBlock(nil, HTupleImageView.class, nil, YES);
                [cell setBackgroundColor:UIColor.greenColor];
            }];
            
            [cell.tupleView itemWithSize:^CGSize(NSIndexPath * _Nonnull indexPath) {
                return CGSizeMake(CGRectGetWidth(frame)-CGRectGetHeight(frame)*2, CGRectGetHeight(frame)/2);
            } edgeInsets:^UIEdgeInsets(NSIndexPath * _Nonnull indexPath) {
                return UIEdgeInsetsMake(0, 10, 0, 10);
            } tupleItem:^(HTupleItem  _Nonnull itemBlock, NSIndexPath * _Nonnull indexPath) {
                HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
                switch (indexPath.row) {
                    case 0: {
                        [cell.label setBackgroundColor:UIColor.redColor];
                    }
                        break;
                    case 1: {
                        [cell.label setBackgroundColor:UIColor.yellowColor];
                    }
                        break;
                        
                    default:
                        break;
                }
            }];
        }
            break;
        case 2: {
            HTupleHorizontalCell *cell = itemBlock(nil, HTupleHorizontalCell.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UILREdgeInsetsMake(10, 10)];
            
            CGRect frame = [cell getContentBounds];
            
            [cell.tupleView tupleWithSections:^CGFloat{
                return 2;
            } items:^CGFloat(NSInteger section) {
                if (section == 0) {
                    return 2;
                }
                return 1;
            } color:^UIColor * _Nullable(NSInteger section) {
                return nil;
            } inset:^UIEdgeInsets(NSInteger section) {
                return UIEdgeInsetsZero;
            }];
            
            [cell.tupleView headerWithSize:^CGSize(NSInteger section) {
                return CGSizeMake(CGRectGetHeight(frame), CGRectGetHeight(frame));
            } edgeInsets:^UIEdgeInsets(NSInteger section) {
                return UIEdgeInsetsZero;
            } tupleHeader:^(HTupleHeader  _Nonnull headerBlock, NSIndexPath *indexPath) {
                HTupleImageView *cell = headerBlock(nil, HTupleImageView.class, nil, YES);
                [cell setBackgroundColor:UIColor.redColor];
            }];
            
            [cell.tupleView itemWithSize:^CGSize(NSIndexPath * _Nonnull indexPath) {
                if (indexPath.section == 0) {
                    return CGSizeMake(CGRectGetWidth(frame)-CGRectGetHeight(frame)*3-10, CGRectGetHeight(frame)/2);
                }else {
                    return CGSizeMake(CGRectGetHeight(frame)+10, CGRectGetHeight(frame));
                }
                return CGSizeZero;
            } edgeInsets:^UIEdgeInsets(NSIndexPath * _Nonnull indexPath) {
                if (indexPath.section == 0) {
                    return UIEdgeInsetsMake(0, 10, 0, 10);
                }else {
                    return UIEdgeInsetsMake(0, 10, 0, 0);
                }
                return UIEdgeInsetsZero;
            } tupleItem:^(HTupleItem  _Nonnull itemBlock, NSIndexPath * _Nonnull indexPath) {
                if (indexPath.section == 0) {
                    HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
                    switch (indexPath.row) {
                        case 0:
                            [cell.label setBackgroundColor:UIColor.redColor];
                            break;
                        case 1:
                            [cell.label setBackgroundColor:UIColor.yellowColor];
                            break;
                            
                        default:
                            break;
                    }
                }else {
                    HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
                    [cell.label setBackgroundColor:UIColor.redColor];
                }
            }];
        }
            break;
        case 3: {
            HTupleVerticalCell *cell = itemBlock(nil, HTupleVerticalCell.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UILREdgeInsetsMake(10, 0)];
            
            CGRect frame = [cell getContentBounds];
            
            [cell.tupleView tupleWithSections:^CGFloat{
                return 1;
            } items:^CGFloat(NSInteger section) {
                return 2;
            } color:^UIColor * _Nullable(NSInteger section) {
                return nil;
            } inset:^UIEdgeInsets(NSInteger section) {
                return UIEdgeInsetsZero;
            }];
            
            [cell.tupleView itemWithSize:^CGSize(NSIndexPath * _Nonnull indexPath) {
                switch (indexPath.row) {
                    case 0:
                        return CGSizeMake(CGRectGetWidth(frame), CGRectGetHeight(frame)-20);
                        break;
                    case 1:
                        return CGSizeMake(CGRectGetWidth(frame), 20);
                        break;
                        
                    default:
                        break;
                }
                return CGSizeZero;
            } edgeInsets:^UIEdgeInsets(NSIndexPath * _Nonnull indexPath) {
                return UIEdgeInsetsZero;
            } tupleItem:^(HTupleItem  _Nonnull itemBlock, NSIndexPath * _Nonnull indexPath) {
                switch (indexPath.row) {
                    case 0: {
                        HTupleImageCell *cell = itemBlock(nil, HTupleImageCell.class, nil, YES);
                        [cell.imageView setBackgroundColor:UIColor.redColor];
                    }
                        break;
                    case 1: {
                        HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
                        [cell.label setBackgroundColor:UIColor.greenColor];
                    }
                        break;
                        
                    default:
                        break;
                }
            }];
        }
            break;
        case 4: {
            HTupleVerticalCell *cell = itemBlock(nil, HTupleVerticalCell.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            
            CGRect frame = [cell getContentBounds];
            
            [cell.tupleView tupleWithSections:^CGFloat{
                return 1;
            } items:^CGFloat(NSInteger section) {
                return 2;
            } color:^UIColor * _Nullable(NSInteger section) {
                return nil;
            } inset:^UIEdgeInsets(NSInteger section) {
                return UIEdgeInsetsZero;
            }];
            
            [cell.tupleView itemWithSize:^CGSize(NSIndexPath * _Nonnull indexPath) {
                switch (indexPath.row) {
                    case 0:
                        return CGSizeMake(CGRectGetWidth(frame), CGRectGetHeight(frame)-20);
                        break;
                    case 1:
                        return CGSizeMake(CGRectGetWidth(frame), 20);
                        break;
                        
                    default:
                        break;
                }
                return CGSizeZero;
            } edgeInsets:^UIEdgeInsets(NSIndexPath * _Nonnull indexPath) {
                return UIEdgeInsetsZero;
            } tupleItem:^(HTupleItem  _Nonnull itemBlock, NSIndexPath * _Nonnull indexPath) {
                switch (indexPath.row) {
                    case 0: {
                        HTupleImageCell *cell = itemBlock(nil, HTupleImageCell.class, nil, YES);
                        [cell.imageView setBackgroundColor:UIColor.redColor];
                    }
                        break;
                    case 1: {
                        HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
                        [cell.label setBackgroundColor:UIColor.greenColor];
                    }
                        break;
                        
                    default:
                        break;
                }
            }];
        }
            break;
        case 5: {
            HTupleVerticalCell *cell = itemBlock(nil, HTupleVerticalCell.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UILREdgeInsetsMake(0, 10)];
            
            CGRect frame = [cell getContentBounds];
            
            [cell.tupleView tupleWithSections:^CGFloat{
                return 1;
            } items:^CGFloat(NSInteger section) {
                return 2;
            } color:^UIColor * _Nullable(NSInteger section) {
                return nil;
            } inset:^UIEdgeInsets(NSInteger section) {
                return UIEdgeInsetsZero;
            }];
            
            [cell.tupleView itemWithSize:^CGSize(NSIndexPath * _Nonnull indexPath) {
                switch (indexPath.row) {
                    case 0:
                        return CGSizeMake(CGRectGetWidth(frame), CGRectGetHeight(frame)-20);
                        break;
                    case 1:
                        return CGSizeMake(CGRectGetWidth(frame), 20);
                        break;
                        
                    default:
                        break;
                }
                return CGSizeZero;
            } edgeInsets:^UIEdgeInsets(NSIndexPath * _Nonnull indexPath) {
                return UIEdgeInsetsZero;
            } tupleItem:^(HTupleItem  _Nonnull itemBlock, NSIndexPath * _Nonnull indexPath) {
                switch (indexPath.row) {
                    case 0: {
                        HTupleImageCell *cell = itemBlock(nil, HTupleImageCell.class, nil, YES);
                        [cell.imageView setBackgroundColor:UIColor.redColor];
                    }
                        break;
                    case 1: {
                        HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
                        [cell.label setBackgroundColor:UIColor.greenColor];
                    }
                        break;
                        
                    default:
                        break;
                }
            }];
        }
            break;
        case 6: {
            HTupleVerticalCell *cell = itemBlock(nil, HTupleVerticalCell.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            
            CGRect frame = [cell getContentBounds];
            
            [cell.tupleView tupleWithSections:^CGFloat{
                return 1;
            } items:^CGFloat(NSInteger section) {
                return 3;
            } color:^UIColor * _Nullable(NSInteger section) {
                return nil;
            } inset:^UIEdgeInsets(NSInteger section) {
                return UIEdgeInsetsZero;
            }];
            
            [cell.tupleView itemWithSize:^CGSize(NSIndexPath * _Nonnull indexPath) {
                return CGSizeMake(CGRectGetWidth(frame)/3, CGRectGetHeight(frame));
            } edgeInsets:^UIEdgeInsets(NSIndexPath * _Nonnull indexPath) {
                switch (indexPath.row) {
                    case 0:
                        return UIEdgeInsetsMake(0, 0, 0, 20/3);
                    case 1:
                        return UIEdgeInsetsMake(0, 20/6, 0, 20/6);
                    case 2:
                        return UIEdgeInsetsMake(0, 20/3, 0, 0);
                        
                    default:
                        break;
                }
                return UIEdgeInsetsZero;
            } tupleItem:^(HTupleItem  _Nonnull itemBlock, NSIndexPath * _Nonnull indexPath) {
                HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
                switch (indexPath.row) {
                    case 0: {
                        [cell.label setBackgroundColor:UIColor.greenColor];
                    }
                        break;
                    case 1: {
                        [cell.label setBackgroundColor:UIColor.redColor];
                    }
                        break;
                    case 2: {
                        [cell.label setBackgroundColor:UIColor.yellowColor];
                    }
                        break;
                        
                    default:
                        break;
                }
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
