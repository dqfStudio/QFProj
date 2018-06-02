//
//  HTableView.m
//  TableModel
//
//  Created by dqf on 2017/7/14.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HTableView.h"
#import <objc/runtime.h>

#define KDefaultPageSize 20

@interface NSString (util)
- (NSString *(^)(id))append;
- (NSArray<NSString *> *(^)(NSString *))componentsBySetString;
@end

@interface HTableView ()
@property (nonatomic, weak)   id objc;
@property (nonatomic, strong) HTableModel *tableModel;
@end

@implementation HTableView

#pragma --mark init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        self.tableModel = [[HTableModel alloc] init];
        self.tableFooterView = [UIView new];
        self.delegate = self.tableModel;
        self.dataSource = self.tableModel;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        self.tableModel = [[HTableModel alloc] init];
        self.tableFooterView = [UIView new];
        self.delegate = self.tableModel;
        self.dataSource = self.tableModel;
    }
    return self;
}

#pragma --mark register cell

- (id)registerCell:(Class)cellClass indexPath:(NSIndexPath *)indexPath {
    return [self registerCell:cellClass indexPath:indexPath style:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(cellClass) initBlock:nil];
}



- (id)registerCell:(Class)cellClass indexPath:(NSIndexPath *)indexPath style:(UITableViewCellStyle)style {
    return [self registerCell:cellClass indexPath:indexPath style:style reuseIdentifier:NSStringFromClass(cellClass) initBlock:nil];
}
- (id)registerCell:(Class)cellClass indexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier {
    return [self registerCell:cellClass indexPath:indexPath style:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier initBlock:nil];
}
- (id)registerCell:(Class)cellClass indexPath:(NSIndexPath *)indexPath initBlock:(HCellInitBlock)block {
    return [self registerCell:cellClass indexPath:indexPath style:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(cellClass) initBlock:block];
}



- (id)registerCell:(Class)cellClass indexPath:(NSIndexPath *)indexPath style:(UITableViewCellStyle)style initBlock:(HCellInitBlock)block {
    return [self registerCell:cellClass indexPath:indexPath style:style reuseIdentifier:NSStringFromClass(cellClass) initBlock:block];
}
- (id)registerCell:(Class)cellClass indexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier initBlock:(HCellInitBlock)block {
    return [self registerCell:cellClass indexPath:indexPath style:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier initBlock:block];
}
- (id)registerCell:(Class)cellClass indexPath:(NSIndexPath *)indexPath style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [self registerCell:cellClass indexPath:indexPath style:style reuseIdentifier:reuseIdentifier initBlock:nil];
}



- (id)registerCell:(Class)cellClass indexPath:(NSIndexPath *)indexPath style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier initBlock:(HCellInitBlock)block {
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[cellClass alloc] initWithStyle:style reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([cell respondsToSelector:@selector(model)]) {
            HBaseCell *tmpCell = (HBaseCell *)cell;
            tmpCell.table = self;
            tmpCell.indexPath = indexPath;
            tmpCell.model = [self cellAtIndexPath:indexPath];
        }
        if (block) {
            block(cell);
        }
    }
    return cell;
}


- (id)registerHeader:(Class)cellClass section:(NSInteger)section {
    return [self registerHeaderFooter:cellClass section:section isHeader:YES reuseIdentifier:NSStringFromClass(cellClass) initBlock:nil];
}
- (id)registerHeader:(Class)cellClass section:(NSInteger)section initBlock:(HCHeaderFooterInitBlock)block {
    return [self registerHeaderFooter:cellClass section:section isHeader:YES reuseIdentifier:NSStringFromClass(cellClass) initBlock:block];
}
- (id)registerHeader:(Class)cellClass section:(NSInteger)section reuseIdentifier:(NSString *)reuseIdentifier initBlock:(HCHeaderFooterInitBlock)block {
    return [self registerHeaderFooter:cellClass section:section isHeader:YES reuseIdentifier:reuseIdentifier initBlock:block];
}



- (id)registerFooter:(Class)cellClass section:(NSInteger)section {
    return [self registerHeaderFooter:cellClass section:section isHeader:NO reuseIdentifier:NSStringFromClass(cellClass) initBlock:nil];
}
- (id)registerFooter:(Class)cellClass section:(NSInteger)section initBlock:(HCHeaderFooterInitBlock)block {
    return [self registerHeaderFooter:cellClass section:section isHeader:NO reuseIdentifier:NSStringFromClass(cellClass) initBlock:block];
}
- (id)registerFooter:(Class)cellClass section:(NSInteger)section reuseIdentifier:(NSString *)reuseIdentifier initBlock:(HCHeaderFooterInitBlock)block {
    return [self registerHeaderFooter:cellClass section:section isHeader:NO reuseIdentifier:reuseIdentifier initBlock:block];
}


- (id)registerHeaderFooter:(Class)cellClass section:(NSInteger)section isHeader:(BOOL)header reuseIdentifier:(NSString *)reuseIdentifier initBlock:(HCHeaderFooterInitBlock)block {
    UITableViewHeaderFooterView *headerFooterView = [self dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
    if (!headerFooterView) {
        headerFooterView = [[cellClass alloc] initWithReuseIdentifier:reuseIdentifier];
        [headerFooterView setIsHeader:header];
        if ([headerFooterView respondsToSelector:@selector(model)]) {
            HBaseHeaderFooterView *tmpCell = (HBaseHeaderFooterView *)headerFooterView;
            tmpCell.table = self;
            tmpCell.section = section;
        }
        if (block) {
            block(headerFooterView);
        }
    }
    return headerFooterView;
}

#pragma --mark other methods

//add HSectionModel
- (void)addModel:(HSectionModel*)anObject {
    [self.tableModel addModel:anObject];
}

- (HSectionModel *)sectionAtIndex:(NSUInteger)index {
    return [self.tableModel sectionAtIndex:index];
}

- (NSUInteger)indexOfSection:(HSectionModel *)anObject {
    return [self.tableModel indexOfSection:anObject];
}

- (HCellModel *)cellAtIndexPath:(NSIndexPath *)indexPath {
    HSectionModel *sectionModel = [self sectionAtIndex:indexPath.section];
    return [sectionModel cellAtIndex:indexPath.row];
}

- (void)cellAtIndexPath:(NSIndexPath *)indexPath resetHeight:(NSInteger)height {
    HCellModel *cellModel = [self cellAtIndexPath:indexPath];;
    cellModel.height = height;
}

- (void)reloadModel {
    for (int i=0; i<[self.tableModel sections]; i++) {
        HSectionModel *sectionModel = [self.tableModel sectionAtIndex:i];
        NSString *sectionSelector = sectionModel.selector;
        if (sectionSelector.length > 0 && sectionModel) {
            SEL sel = NSSelectorFromString(sectionModel.selector);
            if([self.objc respondsToSelector:sel]){
                [self.objc performSelector:sel withObjects:@[sectionModel]];
            }
            
            for (int j=0; j<[sectionModel cells]; j++) {
                HCellModel *cellModel = [sectionModel cellAtIndex:j];
                NSString *cellSelector = cellModel.selector;
                if (cellSelector.length > 0 && cellModel) {
                    SEL sel = NSSelectorFromString(cellModel.selector);
                    if([self.objc respondsToSelector:sel]){
                        [self.objc performSelector:sel withObjects:@[cellModel]];
                    }
                }
            }
        }
    }
    //刷新列表
    [self reloadData];
}

//clear all model
- (void)clearModel {
    [self.tableModel clearModel];
    //刷新列表
    [self reloadData];
}

- (void)refreshView:(id)object withArr:(NSArray *)arr {
    //先清除数据
    [self clearModel];
    [self loadView:object withArr:arr];
}

- (void)loadView:(id)object withArr:(NSArray *)arr {
    
    if (!self.objc || self.objc != object) self.objc = object;
    
    for (NSString *url in arr) {
        
        NSArray<NSString *> *tmpArr = url.componentsBySetString(@"<>");
        
        NSString *sectionSelector = tmpArr[0].append(@":");
        NSString *section = tmpArr[1];
        NSString *cellSelector = tmpArr[2].append(@":");
        
        HSectionModel *sectionModel = [self sectionAtIndex:section.integerValue];
        if (!sectionModel) {
            sectionModel = [HSectionModel new];
            [sectionModel setSelector:sectionSelector];
            [self addModel:sectionModel];
            
            if([object respondsToSelector:NSSelectorFromString(sectionSelector)]){
                [object performSelector:NSSelectorFromString(sectionSelector) withObjects:@[sectionModel]];
            }else {
                sectionModel.headerHeight = 0;
                sectionModel.footerHeight = 0;
            }
        }
        
        HCellModel *cellModel = [HCellModel new];
        [cellModel setSelector:cellSelector];
        [sectionModel addModel:cellModel];
        
        if([object respondsToSelector:NSSelectorFromString(cellSelector)]){
            [object performSelector:NSSelectorFromString(cellSelector) withObjects:@[cellModel]];
            if (!cellModel.renderBlock) {
                cellModel.renderBlock = [self renderBlock];
            }
            if (!cellModel.selectionBlock) {
                cellModel.selectionBlock = [self selectionBlock];
            }
        }else {
            cellModel.renderBlock = [self renderBlock];
            cellModel.selectionBlock = [self selectionBlock];
        }

    }
    
    //刷新列表
    [self reloadData];
    [self endRefresh];
}

- (HCellRenderBlock)renderBlock {
    return ^UITableViewCell *(NSIndexPath *indexPath, HTableView *table) {
        UITableViewCell *cell = [table registerCell:UITableViewCell.class indexPath:indexPath];
        return cell;
    };
}

- (HCellSelectionBlock)selectionBlock {
    return ^(NSIndexPath *indexPath, HTableView *table) {
        [table deselectRowAtIndexPath:indexPath animated:YES];
    };
}

- (NSUInteger)pageNo {
    NSNumber *page = objc_getAssociatedObject(self, _cmd);
    if (!page) {
        [self setPageNo:1];
    }
    return [objc_getAssociatedObject(self, _cmd) unsignedIntegerValue];
}

- (void)setPageNo:(NSUInteger)pageNo {
    objc_setAssociatedObject(self, @selector(pageNo), @(pageNo), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)pageSize {
    NSNumber *pageSize = objc_getAssociatedObject(self, _cmd);
    if (!pageSize) {
        return KDefaultPageSize;
    }
    return [pageSize unsignedIntegerValue];
}

- (void)setPageSize:(NSUInteger)pageSize {
    objc_setAssociatedObject(self, @selector(pageSize), @(pageSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)beginRefresh {
    if (_refreshBlock) {
        [self setPageNo:1];
        [self.mj_header beginRefreshing];
    }
}

//stop refresh
-(void)endRefresh {
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

- (void)setRefreshBlock:(HRefreshBlock)refreshBlock {
    _refreshBlock = refreshBlock;
    if (_refreshBlock) {
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self setPageNo:1];
            _refreshBlock();
        }];
    }else {
        self.mj_header = nil;
    }
}

- (void)setLoadMoreBlock:(HLoadMoreBlock)loadMoreBlock {
    _loadMoreBlock = loadMoreBlock;
    if (_loadMoreBlock) {
        [self setPageNo:1];
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.pageNo += 1;
           _loadMoreBlock();
        }];
    }else {
        self.mj_footer = nil;
    }
}

#pragma mark - signal
- (void)signalToTable:(HTableSignal *)signal {
    if (self.signalBlock) {
        self.signalBlock(signal);
    }
}
- (void)signalToAllItems:(HTableSignal *)signal {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSInteger sections = [self numberOfSections];
        for (int i=0; i<sections; i++) {
            NSInteger items = [self numberOfRowsInSection:i];
            for (int j=0; j<items; j++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
                if (cell.signalBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.signalBlock(signal);
                    });
                }
            }
        }
    });
}
- (void)signal:(HTableSignal *)signal itemSection:(NSInteger)section {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSInteger items = [self numberOfRowsInSection:section];
        for (int i=0; i<items; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
            UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
            if (cell.signalBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.signalBlock(signal);
                });
            }
        }
    });
}
- (void)signal:(HTableSignal *)signal indexPath:(NSIndexPath *)indexPath  {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
        if (cell.signalBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.signalBlock(signal);
            });
        }
    });
}
- (void)signalToAllHeader:(HTableSignal *)signal {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSInteger sections = [self numberOfSections];
        for (int i=0; i<sections; i++) {
            UITableViewHeaderFooterView *header = [self headerViewForSection:i];
            if (header) {
                if (header.signalBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        header.signalBlock(signal);
                    });
                }
            }
        }
    });
}
- (void)signal:(HTableSignal *)signal headerSection:(NSInteger)section {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        UITableViewHeaderFooterView *header = [self headerViewForSection:section];
        if (header) {
            if (header.signalBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    header.signalBlock(signal);
                });
            }
        }
    });
}
- (void)signalToAllFooter:(HTableSignal *)signal {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSInteger sections = [self numberOfSections];
        for (int i=0; i<sections; i++) {
            UITableViewHeaderFooterView *footer = [self footerViewForSection:i];
            if (footer) {
                if (footer.signalBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        footer.signalBlock(signal);
                    });
                }
            }
        }
    });
}
- (void)signal:(HTableSignal *)signal footerSection:(NSInteger)section {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        UITableViewHeaderFooterView *footer = [self footerViewForSection:section];
        if (footer) {
            if (footer.signalBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    footer.signalBlock(signal);
                });
            }
        }
    });
}

@end

@implementation NSString (util)
- (NSString *(^)(id))append {
    return ^NSString *(id obj) {
        return [NSString stringWithFormat:@"%@%@", self,obj];
    };
}
- (NSArray<NSString *> *(^)(NSString *))componentsBySetString {
    return ^NSArray<NSString *> *(NSString *separator) {
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:separator];
        NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSArray *arr = [self componentsSeparatedByCharactersInSet:characterSet];
        NSMutableArray *mutablerArr = [NSMutableArray new];
        //过滤掉为空的字符串
        for (int i=0; i<arr.count; i++) {
            NSString *str = arr[i];
            if (str.length > 0) {
                //过滤掉字符串两端为空的字符
                NSString *trimStr = [str stringByTrimmingCharactersInSet:charSet];
                if (trimStr.length > 0) {
                    [mutablerArr addObject:trimStr];
                }
            }
        }
        return mutablerArr;
    };
}

@end

@interface NSArray ()
@property (nonatomic) NSInteger section;
@property (nonatomic) NSString *sectionModel;
@end

@implementation NSArray (HTableView)
- (NSInteger)section {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (void)setSection:(NSInteger)section {
    objc_setAssociatedObject(self, @selector(section), @(section), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)sectionModel {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setSectionModel:(NSString *)sectionModel {
    objc_setAssociatedObject(self, @selector(sectionModel), sectionModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *(^)(NSArray *))linkCell {
    return ^NSArray *(NSArray *obj) {
        NSMutableArray *mutableArr = [[NSMutableArray alloc] init];
        for (int i=0; i<self.count; i++) {
            NSString *model = self.sectionModel.append(@"<").append(@(self.section)).append(@">").append(self[i]);
            [mutableArr addObject:model];
        }
        for (int i=0; i<obj.count; i++) {
            NSString *model = obj.sectionModel.append(@"<").append(@(obj.section)).append(@">").append(obj[i]);
            [mutableArr addObject:model];
        }
        return mutableArr;
    };
}
- (void (^)(NSUInteger section, NSString *sectionModel))setSectionModel {
    return ^void (NSUInteger section, NSString *sectionModel) {
        self.section = section;
        self.sectionModel = sectionModel;
    };
}
@end

@implementation NSString (HTableView)
- (NSArray *(^)(NSUInteger))multiple {
    return ^NSArray *(NSUInteger count) {
        NSMutableArray *mutableArr = [[NSMutableArray alloc] init];
        for (int i=0; i<count; i++) {
            [mutableArr addObject:self];
        }
        return mutableArr;
    };
}
@end
