//
//  HWaitingView.m
//  HProjectModel1
//
//  Created by wind on 2018/12/30.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HWaitingView.h"

#define KImageWidth  130
#define KImageHeight 33

#define KTextWidth   130
#define KTextHeight  24

#define KMarginTop  1/2

@interface HWaitingView ()
@property (nonatomic) HTupleView *tupleView;
@property (nonatomic) HWaitingType waitingType;
@end

@implementation HWaitingView
- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:self.bounds];
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
    //添加view
    [self addSubview:self.tupleView];
    
    @www
    //section
    [self.tupleView tupleWithSections:^CGFloat{
        return 1;
    } items:^CGFloat(NSInteger section) {
        return 2;
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
        height += KImageHeight;
        //第二个CELL
        height += KTextHeight;
        //header高度
        height = (self.tupleView.height-height)*KMarginTop;
        return CGSizeMake(self.tupleView.width, height);
    } edgeInsets:^UIEdgeInsets(NSInteger section) {
        return UIEdgeInsetsZero;
    } tuple:^(HHeaderTuple  _Nonnull headerBlock, NSInteger section) {
        headerBlock(nil, HViewCell.class, nil, YES);
    }];
    
    
    //footer
    [self.tupleView footerWithSize:^CGSize(NSInteger section) {
        @sss
        NSInteger height = 0;
        //第一个CELL
        height += KImageHeight;
        //第二个CELL
        height += KTextHeight;
        //footer高度
        height = (self.tupleView.height-height)*(1-KMarginTop);
        return CGSizeMake(self.tupleView.width, height);
    } edgeInsets:^UIEdgeInsets(NSInteger section) {
        return UIEdgeInsetsZero;
    } tuple:^(HFooterTuple  _Nonnull footerBlock, NSInteger section) {
        footerBlock(nil, HViewCell.class, nil, YES);
    }];
    
    
    //item
    [self.tupleView itemWithSize:^CGSize(NSIndexPath * _Nonnull indexPath) {
        @sss
        switch (indexPath.row) {
            case 0: return CGSizeMake(self.tupleView.width, KImageHeight);
            case 1: return CGSizeMake(self.tupleView.width, KTextHeight);
            default: return CGSizeZero;
        }
    } edgeInsets:^UIEdgeInsets(NSIndexPath * _Nonnull indexPath) {
        @sss
        switch (indexPath.row) {
            case 0: return UIEdgeInsetsMake(0, self.tupleView.width/2-KImageWidth/2, 0, self.tupleView.width/2-KImageWidth/2);
            case 1: return UIEdgeInsetsMake(0, self.tupleView.width/2-KTextWidth/2, 0, self.tupleView.width/2-KTextWidth/2);
            default: return UIEdgeInsetsZero;
        }
    } tuple:^(HItemTuple  _Nonnull itemBlock, NSIndexPath * _Nonnull indexPath) {
        @sss
        switch (indexPath.row) {
            case 0: {
                HImageViewCell *cell = itemBlock(nil, HImageViewCell.class, nil, YES);
                [cell.imageView.imageView setContentMode:UIViewContentModeScaleAspectFit];
                [cell.imageView setBackgroundColor:[UIColor clearColor]];
                
                NSMutableArray *images = [NSMutableArray array];
                for (int i = 1; i <= 16; i++) {
                    NSString *imageName = [NSString stringWithFormat:@"loading_new_%d", i];
                    UIImage *image = [UIImage imageNamed:imageName];
                    switch (_waitingType) {
                        case HWaitingTypeWhite: {
                            image = [self reDrawImage:image withColor:[UIColor whiteColor]];
                        }
                            break;
                        case HWaitingTypeGray: {
                            image = [self reDrawImage:image withColor:[UIColor lightGrayColor]];
                        }
                            break;
                        case HWaitingTypeBlack: {
                            image = [self reDrawImage:image withColor:[UIColor blackColor]];
                        }
                            break;
                        default:
                            break;
                    }
                    if (image) {
                        [images addObject:image];
                    }
                }
                cell.imageView.imageView.animationImages = images;
                cell.imageView.imageView.animationDuration = 1.0f;
                [cell.imageView.imageView startAnimating];
            }
                break;
            case 1: {
                HLabelViewCell *cell = itemBlock(nil, HLabelViewCell.class, nil, YES);
                [cell.label setText:@"请稍候..."];
                [cell.label setFont:[UIFont systemFontOfSize:14]];
                [cell.label setTextAlignment:NSTextAlignmentCenter];
                
                switch (_waitingType) {
                    case HWaitingTypeWhite: {
                        [cell.label setTextColor:[UIColor whiteColor]];
                    }
                        break;
                    case HWaitingTypeGray: {
                        [cell.label setTextColor:[UIColor lightGrayColor]];
                    }
                        break;
                    case HWaitingTypeBlack: {
                        [cell.label setTextColor:[UIColor blackColor]];
                    }
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

+ (void)showInView:(UIView *)view withType:(HWaitingType)type {
    if (view) {
        HWaitingView *waitingView = [[HWaitingView alloc] initWithFrame:view.frame];
        waitingView.waitingType = type;
        [view addSubview:waitingView];
        [view setMgWaitingView:waitingView];
    }
}

//重新绘制图片
- (UIImage *)reDrawImage:(UIImage *)image withColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

@implementation UIView (HWaitingView)
- (HWaitingView *)mgWaitingView {
    return [self getAssociatedValueForKey:_cmd];
}
- (void)setMgWaitingView:(HWaitingView *)mgWaitingView {
    [self setAssociateValue:mgWaitingView withKey:@selector(mgWaitingView)];
}
@end
