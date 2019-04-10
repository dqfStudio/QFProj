//
//  HTupleViewCell.m
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleViewCell.h"

@implementation HViewCell
- (UIView *)view {
    if (!_view) {
        _view = [UIView new];
        [_view setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_view];
    }
    return _view;
}
- (void)layoutContentView {
    HLayoutTupleView(self.view)
}
@end

@implementation HLabelViewCell
- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        [_label setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_label];
    }
    return _label;
}
//- (YYLabel *)label {
//    if (!_label) {
//        _label = [YYLabel new];
//        [self addSubview:_label];
//    }
//    return _label;
//}
- (void)layoutContentView {
    HLayoutTupleView(self.label)
}
@end

@implementation HTextViewCell
- (UITextView *)textView {
    if (!_textView) {
        _textView = [UITextView new];
        [_textView setScrollEnabled:NO];
        [_textView setUserInteractionEnabled:NO];
        [_textView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_textView];
    }
    return _textView;
}
- (void)layoutContentView {
    HLayoutTupleView(self.textView)
}
@end

@implementation HButtonViewCell
- (HWebButtonView *)buttonView {
    if (!_buttonView) {
        _buttonView = [HWebButtonView new];
        @weakify(self)
        [_buttonView setPressed:^(id sender, id data) {
            @strongify(self)
            if (self.buttonViewBlock) {
                self.buttonViewBlock(self.buttonView, self);
            }
        }];
        [_buttonView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_buttonView];
    }
    return _buttonView;
}
- (void)layoutContentView {
    HLayoutTupleView(self.buttonView)
}
@end

@interface HImageViewCell ()
@property (nonatomic) UITapGestureRecognizer *tapGesture;
@end

@implementation HImageViewCell
- (HWebImageView *)imageView {
    if (!_imageView) {
        _imageView = [HWebImageView new];
        [_imageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_imageView];
    }
    return _imageView;
}
- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] init];
        _tapGesture.numberOfTapsRequired = 1;
        _tapGesture.numberOfTouchesRequired = 1;
        [_tapGesture addTarget:self action:@selector(tapGestureAction)];
    }
    return _tapGesture;
}
- (void)tapGestureAction {
    if (_imageViewBlock) {
        _imageViewBlock(self.imageView, self);
    }
}
- (void)setImageViewBlock:(HImageViewBlock)imageViewBlock {
    if (_imageViewBlock != imageViewBlock) {
        _imageViewBlock = nil;
        _imageViewBlock = imageViewBlock;
        if (!self.tapGesture.view) {
            [self.imageView addGestureRecognizer:self.tapGesture];
        }
    }
}
- (void)layoutContentView {
    HLayoutTupleView(self.imageView)
}
@end

@interface HTextFieldCell () <UITextFieldDelegate>

@end

@implementation HTextFieldCell

- (UITextField *)textField {
    if (!_textField) {
        _textField = UITextField.new;
        [_textField setDelegate:self];
        [_textField setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_textField];
    }
    return _textField;
}

- (void)layoutContentView {
    HLayoutTupleView(self.textField)
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.maxInput > 0) {
        NSInteger strLength = textField.text.length - range.length + string.length;
        if (strLength > self.maxInput) {
            NSString *tmpString = nil;
            if (string.length > 1) {//复制字符串
                NSCharacterSet *characterSet = [NSCharacterSet whitespaceCharacterSet];
                string = [string stringByTrimmingCharactersInSet:characterSet];
                tmpString = [textField.text stringByAppendingString:string];
                //赋值
                textField.text = [tmpString substringToIndex:self.maxInput];
                //异步移动光标
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self cursorLocation:textField index:textField.text.length];
                });
            }else {//输入字符串
                tmpString = [textField.text stringByAppendingString:string];
                textField.text = [tmpString substringToIndex:self.maxInput];
            }
        }
        return (strLength <= self.maxInput);
    }
    return YES;
}
//移动光标
- (void)cursorLocation:(UITextField *)textField index:(NSInteger)index {
    NSRange range = NSMakeRange(index, 0);
    UITextPosition *start = [textField positionFromPosition:[textField beginningOfDocument] offset:range.location];
    UITextPosition *end = [textField positionFromPosition:start offset:range.length];
    [textField setSelectedTextRange:[textField textRangeFromPosition:start toPosition:end]];
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (self.forbidPaste) {
        if([UIMenuController sharedMenuController]) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
            }];
            return NO;
        }
    }
    return [super canPerformAction:action withSender:sender];
}
@end

@interface HTupleViewCell ()
@property (nonatomic) HTupleView *tuple;
@end

@implementation HTupleViewCell
- (HTupleView *)tuple {
    if (!_tuple) {
        _tuple = [[HTupleView alloc] initWithFrame:self.bounds];
        [_tuple setScrollEnabled:NO];
        [self addSubview:_tuple];
    }
    return _tuple;
}
- (void)layoutContentView {
    HLayoutTupleView(self.tuple)
}
- (UIEdgeInsets)accessoryInsets {
    if (UIEdgeInsetsEqualToEdgeInsets(_accessoryInsets, UIEdgeInsetsZero)) {
        _accessoryInsets = UIEdgeInsetsMake(self.tuple.height/2-15/2, 0, self.tuple.height/2-15/2, 10);
    }
    return _accessoryInsets;
}
-  (CGSize)imageSize {
    CGFloat height = self.tuple.height-self.imageInsets.top-self.imageInsets.bottom;
    CGFloat width = height+self.imageInsets.left+self.imageInsets.right;
    return CGSizeMake(width, self.tuple.height);
}
- (CGSize)accessorySize {
    CGFloat defaultWidth = 15;
    CGFloat width = defaultWidth+self.accessoryInsets.left+self.accessoryInsets.right;
    return CGSizeMake(width, self.tuple.height);
}
- (CGSize)cellSize {
    CGFloat width = self.tuple.width-self.imageSize.width-self.accessorySize.width;
    return CGSizeMake(width, self.tuple.height);
}
- (void)setup {
    [self.tuple tupleWithSections:^CGFloat{
        return 1;
    } items:^CGFloat(NSInteger section) {
        return 3;
    } color:^UIColor * _Nullable(NSInteger section) {
        return nil;
    } inset:^UIEdgeInsets(NSInteger section) {
        return UIEdgeInsetsZero;
    }];
    
    [self.tuple itemWithSize:^CGSize(NSIndexPath * _Nonnull indexPath) {
        switch (indexPath.row) {
            case 0: return self.imageSize;
            case 1: return self.cellSize;
            case 2: return self.accessorySize;
            default: return CGSizeZero;
        }
    } edgeInsets:^UIEdgeInsets(NSIndexPath * _Nonnull indexPath) {
        switch (indexPath.row) {
            case 0: return self.imageInsets;
            case 1: return UIEdgeInsetsZero;
            case 2: return self.accessoryInsets;
            default: return UIEdgeInsetsZero;
        }
    } tuple:^(HItemTuple  _Nonnull itemBlock, NSIndexPath * _Nonnull indexPath) {
        switch (indexPath.row) {
            case 0: {
                HImageViewCell *cell = itemBlock(nil, HImageViewCell.class, nil, YES);
                [cell.imageView setImageUrlString:self.image];
            }
                break;
            case 1: {
                HLabelViewCell *cell = itemBlock(nil, HLabelViewCell.class, nil, YES);
                if (self.title) {
                    [cell.label setNumberOfLines:self.numberOfLines];
                    [cell.label setTextAlignment:self.textAlignment];
                    if (self.titleColor) {
                        [cell.label setTextColor:self.titleColor];
                    }
                    if (self.titleFont) {
                        [cell.label setFont:self.titleFont];
                    }
                    if (self.detailTitle.length > 0) {
                        NSString *content = [self.title stringByAppendingString:@"\n"];
                        content = [content stringByAppendingString:self.detailTitle];
                        [cell.label setText:content];
                        [cell.label setKeywords:self.detailTitle];
                        if (self.detailTitleColor) {
                            [cell.label setKeywordsColor:self.detailTitleColor];
                        }
                        if (self.detailTitleFont) {
                            [cell.label setKeywordsFont:self.detailTitleFont];
                        }
                        [cell.label setLineSpace:self.lineSpace];
                        [cell.label formatThatFits];
                    }else {
                        [cell.label setText:self.title];
                    }
                }else {
                    [cell.label setText:nil];
                }
            }
                break;
            case 2: {
                HButtonViewCell *cell = itemBlock(nil, HButtonViewCell.class, nil, YES);
                [cell.buttonView setImageUrlString:@"icon_tuple_arrow_right"];
            }
                break;
                
            default:
                break;
        }
    }];
}
- (void)synchronize {
    [self setup];
}
@end
