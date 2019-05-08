//
//  HFormCell.m
//  HProjectModel1
//
//  Created by wind on 2018/12/31.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HFormCell.h"

@implementation HFormModel
+ (HFormModel *)modelWithTitle:(NSString *)title icon:(NSString *)icon {
    HFormModel *model = HFormModel.new;
    model.title = title;
    model.icon  = icon;
    return model;
}
@end

@implementation HFormCell

- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:self.bounds scrollDirection:HTupleViewScrollDirectionHorizontal];
        [_tupleView setBackgroundColor:[UIColor whiteColor]];
        _tupleView.bounces = NO;
        [_tupleView setPagingEnabled:YES];
        [_tupleView setTupleDelegate:self];
        // 设置默认参数
        [self setup];
        [self addSubview:_tupleView];
    }
    return _tupleView;
}

- (void)layoutContentView {
    HLayoutTupleView(self.tupleView)
}

- (void)setup {
    self.rows = 1;
    self.rowItems = 4;
}

- (void)setModelArr:(NSArray<HFormModel *> *)modelArr {
    if (_modelArr != modelArr) {
        _modelArr = nil;
        _modelArr = modelArr;
        [self.tupleView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTupleView:(HTupleView *)tupleView {
    NSInteger pages = 1;
    if (self.modelArr) {

        NSInteger items = self.modelArr.count;
        NSInteger tmpItems = self.rows*self.rowItems;
        
        pages = items/tmpItems;
        tmpItems = pages*tmpItems;
        
        if (tmpItems != items) {
            pages += 1;
        }
    }
    return pages;
}

- (NSInteger)tupleView:(HTupleView *)tupleView numberOfItemsInSection:(NSInteger)section {
    return self.rows*self.rowItems;
}

- (CGSize)tupleView:(HTupleView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(tupleView.width/self.rowItems-1, tupleView.height/self.rows-1);
}
- (UIEdgeInsets)tupleView:(HTupleView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsZero;
}
- (void)tupleView:(HTupleView *)tupleView itemTuple:(HItemTuple)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = indexPath.section*self.rows*self.rowItems + indexPath.row;
    
    if (index < self.modelArr.count) {
        
        HButtonViewCell *cell = itemBlock(nil, HButtonViewCell.class, nil, YES);
        [cell.buttonView setBackgroundColor:[UIColor clearColor]];
        [cell.buttonView.button setTitleColor:[UIColor blackColor]];
        
        HFormModel *model = [self.modelArr objectAtIndex:index];
        
        [cell.buttonView.button setImage:[UIImage imageNamed:model.icon]];
        [cell.buttonView.button setTitle:model.title];
        
        [cell setButtonViewBlock:^(HWebButtonView *webButtonView, HButtonViewCell *buttonCell) {
            if (self.formCellBlock) {
                self.formCellBlock(indexPath, model);
            }
        }];
        
    }else {
        itemBlock(nil, HViewCell.class, nil, YES);
    }
    
}

@end
