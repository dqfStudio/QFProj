//
//  HRequestHUD.m
//  QFProj
//
//  Created by dqf on 2019/3/29.
//  Copyright © 2019年 dqfStudio. All rights reserved.
//

#import "HRequestHUD.h"

@interface HRequestHUD ()
@property (nonatomic) HTupleView *requestTuple;
@end

@implementation HRequestHUD
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self addSubview:self.requestTuple];
    }
    return self;
}
- (HTupleView *)requestTuple {
    if (!_requestTuple) {
        _requestTuple = [[HTupleView alloc] initWithFrame:CGRectZero];
        [_requestTuple setScrollEnabled:NO];
        [_requestTuple setScrollsToTop:NO];
    }
    return _requestTuple;
}
- (void)setRequestTupleFrame {
    CGRect frame = _requestTuple.frame;;
    frame.size.height += _tupleHeaderSize.height+_imageSize.height;
    frame.size.height += _titleHeaderSize.height+_titleSize.height;
    frame.size.height += _subTitleHeaderSize.height+_subTitleSize.height;
    if(!CGRectEqualToRect(frame, self.frame)) {
        [_requestTuple setFrame:frame];
    }
    [_requestTuple reloadData];
}
- (void)setup {
    
}
- (void)reloadData {
    [self performSelector:@selector(setup) withPre:self.modePrefix withMethodArgments:nil];
    [self setRequestTupleFrame];
}
- (void)setDisplayCancelButton:(BOOL)displayCancelButton {
    if (_displayCancelButton != displayCancelButton) {
        _displayCancelButton = displayCancelButton;
        if (_displayCancelButton) {
            _tupleHeaderSize = CGSizeMake(_requestTuple.width, 20);
        }else {
            _tupleHeaderSize = CGSizeMake(_requestTuple.width, 5);
        }
        [self reloadData];
    }
}
- (void)setMode:(HRequestHUDMode)mode {
    if (_mode != mode) {
        _mode = mode;
        [self reloadData];
    }
}
- (NSString *)modePrefix {
    return [self prefixWithMode:_mode];
}
- (NSString *)prefixWithMode:(HRequestHUDMode)mode {
    switch (mode) {
        case HRequestHUDMode1: return @"mode1";
        case HRequestHUDMode2: return @"mode2";
        case HRequestHUDMode3: return @"mode3";
        case HRequestHUDMode4: return @"mode4";
        case HRequestHUDMode5: return @"mode5";
        default: {
#if DEBUG
            NSAssert(NO,nil);
#endif
             return @"mode1";
        }
            break;
    }
}
- (void)didSelectedItem {
    
}
- (NSInteger)numberOfSectionsInTupleView {
    return [[self performSelector:_cmd withPre:self.modePrefix] integerValue];
}
- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return [[self performSelector:_cmd withPre:self.modePrefix withMethodArgments:&section] integerValue];
}
- (CGSize)sizeForHeaderInSection:(NSInteger)section {
    return [[self performSelector:_cmd withPre:self.modePrefix withMethodArgments:&section] CGSizeValue];
}
- (CGSize)sizeForFooterInSection:(NSInteger)section {
    return [[self performSelector:_cmd withPre:self.modePrefix withMethodArgments:&section] CGSizeValue];
}
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [[self performSelector:_cmd withPre:self.modePrefix withMethodArgments:&indexPath] CGSizeValue];
}
- (UIEdgeInsets)edgeInsetsForHeaderInSection:(NSInteger)section {
    return [[self performSelector:_cmd withPre:self.modePrefix withMethodArgments:&section] UIEdgeInsetsValue];
}
- (UIEdgeInsets)edgeInsetsForFooterInSection:(NSInteger)section {
    return [[self performSelector:_cmd withPre:self.modePrefix withMethodArgments:&section] UIEdgeInsetsValue];
}
- (UIEdgeInsets)edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [[self performSelector:_cmd withPre:self.modePrefix withMethodArgments:&indexPath] UIEdgeInsetsValue];
}
- (void)headerTuple:(HTupleHeader)headerBlock inSection:(NSInteger)section {
    [self performSelector:_cmd withPre:self.modePrefix withMethodArgments:&headerBlock, &section];
}
- (void)footerTuple:(HTupleFooter)footerBlock inSection:(NSInteger)section {
    [self performSelector:_cmd withPre:self.modePrefix withMethodArgments:&footerBlock, &section];
}
- (void)itemTuple:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    [self performSelector:_cmd withPre:self.modePrefix withMethodArgments:&itemBlock, &indexPath];
}
- (void)didSelectCell:(HTupleBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [self performSelector:_cmd withPre:self.modePrefix withMethodArgments:&indexPath];
}
@end

@interface HRequestHUD (HMode1)

@end

@implementation HRequestHUD (HMode1)
- (void)mode1_setup {
    if (_displayCancelButton) {
        _tupleHeaderSize = CGSizeMake(_requestTuple.width, 20);
    }else {
        _tupleHeaderSize = CGSizeMake(_requestTuple.width, 5);
    }
    _imageSize = CGSizeMake(_requestTuple.width, 100);
    _tupleFooterSize = CGSizeMake(_requestTuple.width, 5);
    
    _titleHeaderSize = CGSizeZero;
    _titleSize = CGSizeZero;
    
    _subTitleHeaderSize = CGSizeZero;
    _subTitleSize = CGSizeZero;
}
- (NSInteger)mode1_numberOfSectionsInTupleView {
    return 1;
}
- (NSInteger)mode1_numberOfItemsInSection:(NSInteger)section {
    return 1;
}
- (CGSize)mode1_sizeForHeaderInSection:(NSInteger)section {
    return _tupleHeaderSize;
}
- (CGSize)mode1_sizeForFooterInSection:(NSInteger)section {
    return _tupleFooterSize;
}
- (CGSize)mode1_sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return _imageSize;
}

- (UIEdgeInsets)mode1_edgeInsetsForHeaderInSection:(NSInteger)section {
    return UIEdgeInsetsZero;
}
- (UIEdgeInsets)mode1_edgeInsetsForFooterInSection:(NSInteger)section {
    return UIEdgeInsetsZero;
}
- (UIEdgeInsets)mode1_edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return _imageEdgeInsets;
}

- (void)mode1_headerTuple:(HTupleHeader)headerBlock inSection:(NSInteger)section {
    headerBlock(nil, HTupleBlankApex.class, self.modePrefix, YES);
}
- (void)mode1_footerTuple:(HTupleFooter)footerBlock inSection:(NSInteger)section {
    footerBlock(nil, HTupleBlankApex.class, self.modePrefix, YES);
}
- (void)mode1_itemTuple:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    itemBlock(nil, HTupleImageCell.class, self.modePrefix, YES);
}
- (void)mode1_didSelectCell:(HTupleBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [self didSelectedItem];
}
@end

@interface HRequestHUD (HMode2)

@end

@implementation HRequestHUD (HMode2)
- (void)mode2_setup {
    if (_displayCancelButton) {
        _tupleHeaderSize = CGSizeMake(_requestTuple.width, 20);
    }else {
        _tupleHeaderSize = CGSizeMake(_requestTuple.width, 5);
    }
    _imageSize = CGSizeMake(_requestTuple.width, 100);
    _tupleFooterSize = CGSizeMake(_requestTuple.width, 5);
    
    _titleHeaderSize = CGSizeMake(_requestTuple.width, 10);
    _titleSize = CGSizeMake(_requestTuple.width, 20);
    
    _subTitleHeaderSize = CGSizeZero;
    _subTitleSize = CGSizeZero;
}
- (NSInteger)mode2_numberOfSectionsInTupleView {
    return 2;
}
- (NSInteger)mode2_numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (CGSize)mode2_sizeForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return _tupleHeaderSize;
        case 1: return _titleHeaderSize;
        default: return CGSizeZero;
    }
}
- (CGSize)mode2_sizeForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0: return CGSizeZero;
        case 1: return _tupleFooterSize;
        default: return CGSizeZero;
    }
}
- (CGSize)mode2_sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: return _imageSize;
        case 1: return _titleSize;
        default: return CGSizeZero;
    }
}

- (UIEdgeInsets)mode2_edgeInsetsForHeaderInSection:(NSInteger)section {
    return UIEdgeInsetsZero;
}
- (UIEdgeInsets)mode2_edgeInsetsForFooterInSection:(NSInteger)section {
    return UIEdgeInsetsZero;
}
- (UIEdgeInsets)mode2_edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: return _imageEdgeInsets;
        case 1: return UIEdgeInsetsZero;
        default: return UIEdgeInsetsZero;
    }
}

- (void)mode2_headerTuple:(HTupleHeader)headerBlock inSection:(NSInteger)section {
    headerBlock(nil, HTupleBlankApex.class, self.modePrefix, YES);
}
- (void)mode2_footerTuple:(HTupleFooter)footerBlock inSection:(NSInteger)section {
    footerBlock(nil, HTupleBlankApex.class, self.modePrefix, YES);
}
- (void)mode2_itemTuple:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    itemBlock(nil, HTupleImageCell.class, self.modePrefix, YES);
}
- (void)mode2_didSelectCell:(HTupleBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [self didSelectedItem];
}
@end

@interface HRequestHUD (HMode3)

@end

@implementation HRequestHUD (HMode3)
- (void)mode3_setup {
    if (_displayCancelButton) {
        _tupleHeaderSize = CGSizeMake(_requestTuple.width, 20);
    }else {
        _tupleHeaderSize = CGSizeMake(_requestTuple.width, 5);
    }
    _imageSize = CGSizeMake(_requestTuple.width, 100);
    _tupleFooterSize = CGSizeMake(_requestTuple.width, 5);
    
    _titleHeaderSize = CGSizeMake(_requestTuple.width, 10);
    _titleSize = CGSizeMake(_requestTuple.width, 20);
    
    _subTitleHeaderSize = CGSizeMake(_requestTuple.width, 5);
    _subTitleSize = CGSizeMake(_requestTuple.width, 20);
}
- (NSInteger)mode3_numberOfSectionsInTupleView {
    return 3;
}
- (NSInteger)mode3_numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (CGSize)mode3_sizeForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return _tupleHeaderSize;
        case 1: return _titleHeaderSize;
        case 2: return _subTitleHeaderSize;
        default: return CGSizeZero;
    }
}
- (CGSize)mode3_sizeForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0: return CGSizeZero;
        case 1: return CGSizeZero;
        case 2: return _tupleFooterSize;
        default: return CGSizeZero;
    }
}
- (CGSize)mode3_sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: return _imageSize;
        case 1: return _titleSize;
        case 2: return _subTitleSize;
        default: return CGSizeZero;
    }
}

- (UIEdgeInsets)mode3_edgeInsetsForHeaderInSection:(NSInteger)section {
    return UIEdgeInsetsZero;
}
- (UIEdgeInsets)mode3_edgeInsetsForFooterInSection:(NSInteger)section {
    return UIEdgeInsetsZero;
}
- (UIEdgeInsets)mode3_edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: return _imageEdgeInsets;
        case 1: return UIEdgeInsetsZero;
        case 2: return UIEdgeInsetsZero;
        default: return UIEdgeInsetsZero;
    }
}

- (void)mode3_headerTuple:(HTupleHeader)headerBlock inSection:(NSInteger)section {
    headerBlock(nil, HTupleBlankApex.class, self.modePrefix, YES);
}
- (void)mode3_footerTuple:(HTupleFooter)footerBlock inSection:(NSInteger)section {
    footerBlock(nil, HTupleBlankApex.class, self.modePrefix, YES);
}
- (void)mode3_itemTuple:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    itemBlock(nil, HTupleImageCell.class, self.modePrefix, YES);
}
- (void)mode3_didSelectCell:(HTupleBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [self didSelectedItem];
}
@end

@interface HRequestHUD (HMode4)

@end

@implementation HRequestHUD (HMode4)
- (void)mode4_setup {
    if (_displayCancelButton) {
        _tupleHeaderSize = CGSizeMake(_requestTuple.width, 20);
    }else {
        _tupleHeaderSize = CGSizeMake(_requestTuple.width, 5);
    }
    _imageSize = CGSizeZero;
    _tupleFooterSize = CGSizeMake(_requestTuple.width, 5);
    
    _titleHeaderSize = CGSizeMake(_requestTuple.width, 10);
    _titleSize = CGSizeMake(_requestTuple.width, 20);
    
    _subTitleHeaderSize = CGSizeZero;
    _subTitleSize = CGSizeZero;
}
- (NSInteger)mode4_numberOfSectionsInTupleView {
    return 1;
}
- (NSInteger)mode4_numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (CGSize)mode4_sizeForHeaderInSection:(NSInteger)section {
    return _tupleHeaderSize;
}
- (CGSize)mode4_sizeForFooterInSection:(NSInteger)section {
    return _tupleFooterSize;
}
- (CGSize)mode4_sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return _titleSize;
}

- (UIEdgeInsets)mode4_edgeInsetsForHeaderInSection:(NSInteger)section {
    return UIEdgeInsetsZero;
}
- (UIEdgeInsets)mode4_edgeInsetsForFooterInSection:(NSInteger)section {
    return UIEdgeInsetsZero;
}
- (UIEdgeInsets)mode4_edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsZero;
}

- (void)mode4_headerTuple:(HTupleHeader)headerBlock inSection:(NSInteger)section {
    headerBlock(nil, HTupleBlankApex.class, self.modePrefix, YES);
}
- (void)mode4_footerTuple:(HTupleFooter)footerBlock inSection:(NSInteger)section {
    footerBlock(nil, HTupleBlankApex.class, self.modePrefix, YES);
}
- (void)mode4_itemTuple:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    itemBlock(nil, HTupleLabelCell.class, self.modePrefix, YES);
}
- (void)mode4_didSelectCell:(HTupleBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [self didSelectedItem];
}
@end

@interface HRequestHUD (HMode5)

@end

@implementation HRequestHUD (HMode5)
- (void)mode5_setup {
    if (_displayCancelButton) {
        _tupleHeaderSize = CGSizeMake(_requestTuple.width, 20);
    }else {
        _tupleHeaderSize = CGSizeMake(_requestTuple.width, 5);
    }
    _imageSize = CGSizeZero;
    _tupleFooterSize = CGSizeMake(_requestTuple.width, 5);
    
    _titleHeaderSize = CGSizeMake(_requestTuple.width, 10);
    _titleSize = CGSizeMake(_requestTuple.width, 20);
    
    _subTitleHeaderSize = CGSizeMake(_requestTuple.width, 5);
    _subTitleSize = CGSizeMake(_requestTuple.width, 20);
}
- (NSInteger)mode5_numberOfSectionsInTupleView {
    return 2;
}
- (NSInteger)mode5_numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (CGSize)mode5_sizeForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return _tupleHeaderSize;
        case 1: return _subTitleHeaderSize;
        default: return CGSizeZero;
    }
}
- (CGSize)mode5_sizeForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0: return CGSizeZero;
        case 1: return _tupleFooterSize;
        default: return CGSizeZero;
    }
}
- (CGSize)mode5_sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: return _titleSize;
        case 1: return _subTitleSize;
        default: return CGSizeZero;
    }
}

- (UIEdgeInsets)mode5_edgeInsetsForHeaderInSection:(NSInteger)section {
    return UIEdgeInsetsZero;
}
- (UIEdgeInsets)mode5_edgeInsetsForFooterInSection:(NSInteger)section {
    return UIEdgeInsetsZero;
}
- (UIEdgeInsets)mode5_edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsZero;
}

- (void)mode5_headerTuple:(HTupleHeader)headerBlock inSection:(NSInteger)section {
    headerBlock(nil, HTupleBlankApex.class, self.modePrefix, YES);
}
- (void)mode5_footerTuple:(HTupleFooter)footerBlock inSection:(NSInteger)section {
    footerBlock(nil, HTupleBlankApex.class, self.modePrefix, YES);
}
- (void)mode5_itemTuple:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    itemBlock(nil, HTupleLabelCell.class, self.modePrefix, YES);
}
- (void)mode5_didSelectCell:(HTupleBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [self didSelectedItem];
}
@end
