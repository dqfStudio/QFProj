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

@interface HWaitingView () <HTupleViewDelegate>
@property (nonatomic) HTupleView *tupleView;
@property (nonatomic) HWaitingType waitingType;
@end

@implementation HWaitingView

- (instancetype)init {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:self.bounds];
        [_tupleView setTupleDelegate:self];
        [_tupleView setScrollEnabled:NO];
        [_tupleView setUserInteractionEnabled:NO];
    }
    return _tupleView;
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
}

+ (void)showInView:(UIView *)view withType:(HWaitingType)type {
    if (view) {
        HWaitingView *waitingView = [[HWaitingView alloc] initWithFrame:view.frame];
        waitingView.waitingType = type;
        [view addSubview:waitingView];
        [view setMgWaitingView:waitingView];
    }
}

- (NSInteger)tupleView:(UICollectionView *)tupleView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (CGSize)tupleView:(UICollectionView *)tupleView sizeForHeaderInSection:(NSInteger)section {
    
    NSInteger height = 0;
    
    //第一个CELL
    height += KImageHeight;
    
    //第二个CELL
    height += KTextHeight;
    
    //header高度
    height = (tupleView.height-height)*KMarginTop;
    
    return CGSizeMake(tupleView.width, height);
}

- (CGSize)tupleView:(UICollectionView *)tupleView sizeForFooterInSection:(NSInteger)section {
    
    NSInteger height = 0;
    
    //第一个CELL
    height += KImageHeight;
    
    //第二个CELL
    height += KTextHeight;
    
    //footer高度
    height = (tupleView.height-height)*(1-KMarginTop);
    
    return CGSizeMake(tupleView.width, height);
}

- (CGSize)tupleView:(UICollectionView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            return CGSizeMake(tupleView.width, KImageHeight);
        }
            break;
        case 1: {
            return CGSizeMake(tupleView.width, KTextHeight);
        }
            break;
            
        default:
            break;
    }
    return CGSizeZero;
}

- (UIEdgeInsets)tupleView:(UICollectionView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            return UIEdgeInsetsMake(0, tupleView.width/2-KImageWidth/2, 0, tupleView.width/2-KImageWidth/2);
        }
            break;
        case 1: {
            return UIEdgeInsetsMake(0, tupleView.width/2-KTextWidth/2, 0, tupleView.width/2-KTextWidth/2);
        }
            break;
            
        default:
            break;
    }
    return UIEdgeInsetsZero;
}

- (void)tupleView:(UICollectionView *)tupleView headerTuple:(HHeaderBlock)headerBlock inSection:(NSInteger)section {
    headerBlock(nil, HViewCell.class, nil, YES);
}

- (void)tupleView:(UICollectionView *)tupleView footerTuple:(HFooterBlock)footerBlock inSection:(NSInteger)section {
    footerBlock(nil, HViewCell.class, nil, YES);
}

- (void)tupleView:(UICollectionView *)tupleView itemTuple:(HItemBlock)itemBlock atIndexPath:(NSIndexPath *)indexPath {
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
}

/**
 *  重新绘制图片
 *
 *  @param color 填充色
 *
 *  @return UIImage
 */
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
