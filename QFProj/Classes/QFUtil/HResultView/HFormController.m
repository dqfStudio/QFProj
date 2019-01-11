//
//  HFormController.m
//  HProjectModel1
//
//  Created by wind on 2018/12/31.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HFormController.h"

#define KItemHeight     80
#define KFooterHeight   50

#define HIPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

@interface HFormController () <HTupleViewDelegate>
@property (nonatomic) HTupleView *tupleView;
@property (nonatomic) NSInteger numberOfRows;
@end

@implementation HFormController

static HFormController *formController = nil;

- (instancetype)init {
    self = [super init];
    if (self) {
        formController = nil;
        formController = self;
        [self setup];
    }
    return self;
}

+ (HFormController *)formInstance {
     return HFormController.new;
}

- (HTupleView *)tupleView {
    if (!_tupleView) {
        CGRect frame = [UIScreen mainScreen].bounds;
        _tupleView = [[HTupleView alloc] initWithFrame:frame];
        [_tupleView setTupleDelegate:self];
        [_tupleView setScrollEnabled:NO];
    }
    return _tupleView;
}

- (void)setup {
    //默认为1
    self.numberOfRows = 1;
    //添加view
    [[UIApplication sharedApplication].delegate.window addSubview:self.tupleView];
}

- (NSInteger)tupleView:(UICollectionView *)tupleView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (CGSize)tupleView:(UICollectionView *)tupleView sizeForHeaderInSection:(NSInteger)section {
    NSInteger height = KFooterHeight;
    if (HIPhoneX) {
        height += 34;
    }
    return CGSizeMake(tupleView.width, tupleView.height-KItemHeight*self.numberOfRows-height);
}

- (CGSize)tupleView:(UICollectionView *)tupleView sizeForFooterInSection:(NSInteger)section {
    NSInteger height = KFooterHeight;
    if (HIPhoneX) {
        height += 34;
    }
    return CGSizeMake(tupleView.width, height);
}

- (CGSize)tupleView:(UICollectionView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(tupleView.width, KItemHeight*self.numberOfRows);
}

- (UIEdgeInsets)tupleView:(UICollectionView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsZero;
}

- (UIEdgeInsets)tupleView:(UICollectionView *)tupleView edgeInsetsForFooterInSection:(NSInteger)section {
    NSInteger height = 0;
    if (HIPhoneX) {
        height += 34;
    }
    return UIEdgeInsetsMake(10, 0, height, 0);
}

- (void)tupleView:(UICollectionView *)tupleView initTuple:(void (^)(HTupleCellInitBlock initBlock))initBlock headerTuple:(id (^)(Class aClass))headerBlock inSection:(NSInteger)section {
    HReusableButtonView *cell = headerBlock(HReusableButtonView.class);
    [cell.buttonView setBackgroundColor:[UIColor clearColor]];
//    [cell.buttonView setPressed:^(id sender, id data) {
//        //销毁对象
//        [self destroy];
//    }];
}

- (void)tupleView:(UICollectionView *)tupleView initTuple:(void (^)(HTupleCellInitBlock initBlock))initBlock footerTuple:(id (^)(Class aClass))footerBlock inSection:(NSInteger)section {
    HReusableButtonView *cell = footerBlock(HReusableButtonView.class);
    [cell.buttonView setBackgroundColor:[UIColor whiteColor]];
    [cell.buttonView.button setTitleColor:[UIColor blackColor]];
    [cell.buttonView.button setTitle:@"取消"];
    [cell.buttonView setPressed:^(id sender, id data) {
        //销毁对象
        [self destroy];
    }];
}

- (void)tupleView:(UICollectionView *)tupleView initTuple:(void (^)(HTupleCellInitBlock initBlock))initBlock itemTuple:(id (^)(Class aClass))itemBlock atIndexPath:(NSIndexPath *)indexPath {
    
    HFormCell *cell = itemBlock(HFormCell.class);

    NSMutableArray *mutableArr = NSMutableArray.array;
    
    HFormModel *model = [HFormModel modelWithTitle:@"title" icon:nil];
    [mutableArr addObject:model];
    model = [HFormModel modelWithTitle:@"title" icon:nil];
    [mutableArr addObject:model];
    model = [HFormModel modelWithTitle:@"title" icon:nil];
    [mutableArr addObject:model];
    model = [HFormModel modelWithTitle:@"title" icon:nil];
    [mutableArr addObject:model];
    model = [HFormModel modelWithTitle:@"title" icon:nil];
    [mutableArr addObject:model];
    model = [HFormModel modelWithTitle:@"title" icon:nil];
    [mutableArr addObject:model];
    model = [HFormModel modelWithTitle:@"title" icon:nil];
    [mutableArr addObject:model];
    model = [HFormModel modelWithTitle:@"title" icon:nil];
    [mutableArr addObject:model];
    
    [cell setModelArr:mutableArr];
    
    //配置参数
    [cell setRows:1];
    [self setNumberOfRows:cell.rows];
    
    [cell setFormCellBlock:^(NSIndexPath *idxPath, HFormModel *model) {
        
        //销毁对象
        [self destroy];
    }];
}

//销毁对象
- (void)destroy {
    //弹框消失
    [self.tupleView removeFromSuperview];
    //释放对象
    formController = nil;
}

@end
