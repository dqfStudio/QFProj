//
//  HResultView.m
//  HProjectModel1
//
//  Created by wind on 2018/12/30.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HResultView.h"

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
    //添加手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
    [self.tupleView addGestureRecognizer:tapGesture];
    //添加view
    [self addSubview:self.tupleView];
}

- (void)tapGestureAction {
    if (self.clickedBlock) {
        [self.tupleView setUserInteractionEnabled:NO];
        self.clickedBlock();
        [self.tupleView setUserInteractionEnabled:YES];
    }
}

- (void)setClickedBlock:(HResultClickedBlock)clickedBlock {
    if (_clickedBlock != clickedBlock) {
        _clickedBlock = nil;
        _clickedBlock = clickedBlock;
        [self.tupleView setUserInteractionEnabled:YES];
    }
    if (!_clickedBlock) {
        [self.tupleView setUserInteractionEnabled:NO];
    }
}

+ (void)showInView:(UIView *)view withType:(HResultType)type {
    [HResultView showInView:view withType:type hideImage:NO clickedBlock:nil];
}
+ (void)showInView:(UIView *)view withType:(HResultType)type clickedBlock:(HResultClickedBlock)clickedBlock {
    [HResultView showInView:view withType:type hideImage:NO clickedBlock:clickedBlock];
}
+ (void)showInView:(UIView *)view withType:(HResultType)type hideImage:(BOOL)yn clickedBlock:(HResultClickedBlock)clickedBlock {
    if (view) {
        HResultView *resultView = [[HResultView alloc] initWithFrame:view.frame];
        if (![AFNetworkReachabilityManager sharedManager].isReachable && type != HResultTypeNoData) {
            resultView.resultType = KNoNetwork;
        }else {
            resultView.resultType = type;
        }
        resultView.hideImage = yn;
        resultView.clickedBlock = clickedBlock;
        [view addSubview:resultView];
        [view setMgResultView:resultView];
    }
}


- (NSInteger)tupleView:(UICollectionView *)tupleView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (CGSize)tupleView:(UICollectionView *)tupleView sizeForHeaderInSection:(NSInteger)section {

    NSInteger height = 0;
    
    //第一个CELL
    if (!_hideImage) height += KImageHeight;
    else height += 1;
    
    //第二三个CELL
    height += 2*KTextHeight;
    
    //header高度
    height = (tupleView.height-height)*KMarginTop;
    
    return CGSizeMake(tupleView.width, height);
}

- (CGSize)tupleView:(UICollectionView *)tupleView sizeForFooterInSection:(NSInteger)section {
    
    NSInteger height = 0;
    
    //第一个CELL
    if (!_hideImage) height += KImageHeight;
    else height += 1;
    
    //第二三个CELL
    height += 2*KTextHeight;
    
    //footer高度
    height = (tupleView.height-height)*(1-KMarginTop);
    
    return CGSizeMake(tupleView.width, height);
}

- (CGSize)tupleView:(UICollectionView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            if (!_hideImage) {
                return CGSizeMake(tupleView.width, KImageHeight);
            }else {
                return CGSizeMake(tupleView.width, 1);
            }
        }
            break;
        case 1: {
            return CGSizeMake(tupleView.width, KTextHeight);
        }
            break;
        case 2: {
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
            if (!_hideImage) {
                return UIEdgeInsetsMake(0, tupleView.width/2-KImageWidth/2, 10, tupleView.width/2-KImageWidth/2);
            }else {
                return UIEdgeInsetsMake(0, tupleView.width/2-KImageWidth/2, 0, tupleView.width/2-KImageWidth/2);
            }
        }
            break;
        case 1: {
            return UIEdgeInsetsMake(0, tupleView.width/2-KTextWidth/2, 0, tupleView.width/2-KTextWidth/2);
        }
            break;
        case 2: {
            return UIEdgeInsetsMake(0, tupleView.width/2-KTextWidth/2, 0, tupleView.width/2-KTextWidth/2);
        }
            break;
            
        default:
            break;
    }
    return UIEdgeInsetsZero;
}

- (void)tupleView:(UICollectionView *)tupleView initTuple:(void (^)(HTupleCellInitBlock initBlock))initBlock headerTuple:(id (^)(Class aClass))headerBlock inSection:(NSInteger)section {
    headerBlock(HViewCell.class);
}

- (void)tupleView:(UICollectionView *)tupleView initTuple:(void (^)(HTupleCellInitBlock initBlock))initBlock footerTuple:(id (^)(Class aClass))footerBlock inSection:(NSInteger)section {
    footerBlock(HViewCell.class);
}

- (void)tupleView:(UICollectionView *)tupleView initTuple:(void (^)(HTupleCellInitBlock initBlock))initBlock itemTuple:(id (^)(Class aClass))itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            if (!_hideImage) {
                HImageViewCell *cell = itemBlock(HImageViewCell.class);
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
                itemBlock(HViewCell.class);
            }
        }
            break;
        case 1: {
            HLabelViewCell *cell = itemBlock(HLabelViewCell.class);
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
            HLabelViewCell *cell = itemBlock(HLabelViewCell.class);
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
}

@end

@implementation UIView (HResultView)
- (HResultView *)mgResultView {
    return [self getAssociatedValueForKey:_cmd];
}
- (void)setMgResultView:(HResultView *)mgResultView {
    [self setAssociateValue:mgResultView withKey:@selector(mgResultView)];
}
@end
