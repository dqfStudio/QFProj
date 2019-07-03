//
//  HResultView.m
//  HProjectModel1
//
//  Created by wind on 2018/12/30.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HResultView.h"
#import <objc/runtime.h>

#define KImageWidth  165
#define KImageHeight 140

#define KTextWidth   200
#define KTextHeight  20

#define KMarginTop  1/2

#define KNoNetwork  1000

@interface HResultView () <HTupleViewDelegate>
@property (nonatomic) HTupleView *tupleView;
@property (nonatomic) HResultType resultType;
@property (nonatomic) BOOL hideImage; //Default is NO
@property (nonatomic, copy) HResultClickedBlock clickedBlock;
@end

@implementation HResultView
- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:self.bounds];
        [_tupleView setTupleDelegate:self];
        [_tupleView setScrollEnabled:NO];
        [_tupleView setUserInteractionEnabled:NO];
    }
    return _tupleView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setFrame:(CGRect)frame {
    if(!CGRectEqualToRect(frame, self.frame)) {
        [super setFrame:frame];
        [self.tupleView setFrame:self.bounds];
    }
}
- (void)setup {
    //添加手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
    [self.tupleView addGestureRecognizer:tapGesture];
    
    //添加view
    [self addSubview:self.tupleView];
    
    @www
    //section
    [self.tupleView tupleWithSections:^CGFloat{
        return 1;
    } items:^CGFloat(NSInteger section) {
        return 3;
    } color:^UIColor * _Nullable(NSInteger section) {
        return nil;
    } inset:^UIEdgeInsets(NSInteger section) {
        return UIEdgeInsetsZero;
    }];
    
    
    //header
    [self.tupleView headerWithSize:^CGSize(NSInteger section) {
        @sss
        NSInteger height = 0;
        //第一个CELL
        if (!_hideImage) height += KImageHeight;
        else height += 1;
        //第二三个CELL
        height += 2*KTextHeight;
        //header高度
        height = (self.tupleView.height-height)*KMarginTop;
        return CGSizeMake(self.tupleView.width, height);
    } edgeInsets:^UIEdgeInsets(NSInteger section) {
        return UIEdgeInsetsZero;
    } tuple:^(HHeaderTuple  _Nonnull headerBlock, NSInteger section) {
        headerBlock(nil, HTupleBaseCell.class, nil, YES);
    }];
    
    
    //footer
    [self.tupleView footerWithSize:^CGSize(NSInteger section) {
        @sss
        NSInteger height = 0;
        //第一个CELL
        if (!_hideImage) height += KImageHeight;
        else height += 1;
        //第二三个CELL
        height += 2*KTextHeight;
        //footer高度
        height = (self.tupleView.height-height)*(1-KMarginTop);
        return CGSizeMake(self.tupleView.width, height);
    } edgeInsets:^UIEdgeInsets(NSInteger section) {
        return UIEdgeInsetsZero;
    } tuple:^(HFooterTuple  _Nonnull footerBlock, NSInteger section) {
        footerBlock(nil, HTupleBaseCell.class, nil, YES);
    }];
    
    
    //item
    [self.tupleView itemWithSize:^CGSize(NSIndexPath * _Nonnull indexPath) {
        @sss
        switch (indexPath.row) {
            case 0: {
                if (!_hideImage) return CGSizeMake(self.tupleView.width, KImageHeight);
                else return CGSizeMake(self.tupleView.width, 1);
            }
                break;
            case 1: return CGSizeMake(self.tupleView.width, KTextHeight);
            case 2: return CGSizeMake(self.tupleView.width, KTextHeight);
            default: return CGSizeZero;
        }
    } edgeInsets:^UIEdgeInsets(NSIndexPath * _Nonnull indexPath) {
        @sss
        switch (indexPath.row) {
            case 0: {
                if (!_hideImage) {
                    return UIEdgeInsetsMake(0, self.tupleView.width/2-KImageWidth/2, 10, self.tupleView.width/2-KImageWidth/2);
                }else {
                    return UIEdgeInsetsMake(0, self.tupleView.width/2-KImageWidth/2, 0, self.tupleView.width/2-KImageWidth/2);
                }
            }
                break;
            case 1: return UIEdgeInsetsMake(0, self.tupleView.width/2-KTextWidth/2, 0, self.tupleView.width/2-KTextWidth/2);
            case 2: return UIEdgeInsetsMake(0, self.tupleView.width/2-KTextWidth/2, 0, self.tupleView.width/2-KTextWidth/2);
            default: return UIEdgeInsetsZero;
        }
    } tuple:^(HItemTuple  _Nonnull itemBlock, NSIndexPath * _Nonnull indexPath) {
        switch (indexPath.row) {
            case 0: {
                if (!_hideImage) {
                    HTupleImageCell *cell = itemBlock(nil, HTupleImageCell.class, nil, YES);
                    switch (_resultType) {
                        case HResultTypeNoData:
                            [cell.imageView setImage:[UIImage imageNamed:@"mgf_icon_load_nothing"]];
                            break;
                        case HResultTypeLoadError:
                            [cell.imageView setImage:[UIImage imageNamed:@"mgf_icon_no_server"]];
                            break;
                        case KNoNetwork:
                            [cell.imageView setImage:[UIImage imageNamed:@"mgf_icon_no_network"]];
                            break;
                        default:
                            break;
                    }
                    
                }else {
                    itemBlock(nil, HTupleBaseCell.class, nil, YES);
                }
            }
                break;
            case 1: {
                HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
                [cell.label setTextColor:[UIColor blackColor]];
                [cell.label setFont:[UIFont systemFontOfSize:14]];
                [cell.label setTextAlignment:NSTextAlignmentCenter];
                
                switch (_resultType) {
                    case HResultTypeNoData:
                        [cell.label setText:@"这里好像什么都没有呢⋯"];
                        break;
                    case HResultTypeLoadError:
                        [cell.label setText:@"服务器开小差了，请稍后再试~"];
                        break;
                    case KNoNetwork:
                        [cell.label setText:@"网络已断开"];
                        break;
                    default:
                        break;
                }
            }
                break;
            case 2: {
                HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
                [cell.label setTextColor:[UIColor blackColor]];
                [cell.label setFont:[UIFont systemFontOfSize:14]];
                [cell.label setTextAlignment:NSTextAlignmentCenter];
                
                switch (_resultType) {
                    case HResultTypeNoData:
                        [cell.label setText:nil];
                        break;
                    case HResultTypeLoadError:
                        [cell.label setText:nil];
                        break;
                    case KNoNetwork:
                        [cell.label setText:@"点击重试"];
                        break;
                    default:
                        break;
                }
            }
                break;
                
            default:
                break;
        }
    }];
}
- (void)tapGestureAction {
    if (self.clickedBlock) {
        [_tupleView setUserInteractionEnabled:NO];
        self.clickedBlock();
        [_tupleView setUserInteractionEnabled:YES];
    }
}
- (void)setClickedBlock:(HResultClickedBlock)clickedBlock {
    if (_clickedBlock != clickedBlock) {
        _clickedBlock = nil;
        _clickedBlock = clickedBlock;
        [_tupleView setUserInteractionEnabled:YES];
    }
    if (!_clickedBlock) {
        [_tupleView setUserInteractionEnabled:NO];
    }
}
+ (void)showInView:(UIView *)view withType:(HResultType)type {
    [HResultView showInView:view withType:type imageHidden:NO clickedBlock:nil];
}
+ (void)showInView:(UIView *)view withType:(HResultType)type clickedBlock:(HResultClickedBlock)clickedBlock {
    [HResultView showInView:view withType:type imageHidden:NO clickedBlock:clickedBlock];
}
+ (void)showInView:(UIView *)view
          withType:(HResultType)type
       imageHidden:(BOOL)hidden
      clickedBlock:(HResultClickedBlock)clickedBlock {
    if (view) {
        HResultView *resultView = [[HResultView alloc] initWithFrame:view.frame];
        if (![AFNetworkReachabilityManager sharedManager].isReachable && type != HResultTypeNoData) {
            resultView.resultType = KNoNetwork;
        }else {
            resultView.resultType = type;
        }
        resultView.hideImage = hidden;
        resultView.clickedBlock = clickedBlock;
        [view addSubview:resultView];
        [view setMgResultView:resultView];
    }
}
@end

@implementation UIView (HResultView)
- (HResultView *)mgResultView {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setMgResultView:(HResultView *)mgResultView {
    objc_setAssociatedObject(self, @selector(mgResultView), mgResultView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
