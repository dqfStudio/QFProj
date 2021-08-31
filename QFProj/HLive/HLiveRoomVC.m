//
//  HLiveRoomVC.m
//  QFProj
//
//  Created by dqf on 2021/8/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HLiveRoomVC.h"
#import "HLiveRoomBgCell.h"
#import "HLiveRoomCell.h"

@interface HLiveRoomVC ()

@end

@implementation HLiveRoomVC

- (HTextField *)textField {
    if (!_textField) {
        CGRect frame = CGRectMake(0, UIScreen.height, UIScreen.width, 40);
        _textField = [[HTextField alloc] initWithFrame:frame];
        [_textField setBackgroundColor:UIColor.whiteColor];
        [_textField setPlaceholderFont:[UIFont systemFontOfSize:14.f]];
        [_textField setPlaceholder:@"请输入内容..."];
        
        _textField.leftWidth = 10;
        [_textField.leftLabel setText:@""];
        
        // 去掉键盘上的toolBar
        _textField.inputAccessoryView = [[UIView alloc] initWithFrame:CGRectZero];
        [_textField reloadInputViews];
        
        [_textField setRightWidth:60];
        [_textField.rightLabel setText:@"完成"];
        [_textField.rightLabel setTextAlignment:NSTextAlignmentCenter];
        [_textField.rightLabel setFont:[UIFont systemFontOfSize:17.f]];
        @www
        [_textField.rightLabel setTextTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @sss
            [self->_textField resignFirstResponder];
        }];
    }
    return _textField;
}

- (void)setLiveStatus:(HLiveStatus)liveStatus {
    if (_liveStatus != liveStatus) {
        _liveStatus = liveStatus;
        [self.tupleView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.topExtendedLayout = NO;
    self.tupleView.pagingEnabled = YES;
    [self.tupleView setTupleDelegate:self];
    
    //添加键盘
    [self addKeyboardObserver];
    [self hideKeyboardWhenTapBackground];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboardNotifyAction) name:@"KShowKeyboardNotify" object:nil];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tupleView.contentSize = CGSizeMake(0, self.tupleView.height*3);
    self.tupleView.contentOffset = CGPointMake(0, self.tupleView.height);
}

- (void)showKeyboardNotifyAction {
    [[UIApplication getKeyWindow] addSubview:self.textField];
    [self.textField becomeFirstResponder];
}

- (void)dealloc {
    [self removeKeyboardObserver];
}

- (BOOL)prefersNavigationBarHidden {
    return YES;
}

- (void)keyboardWillShowWithRect:(CGRect)keyboardRect animationDuration:(CGFloat)duration {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = CGRectMake(0, keyboardRect.origin.y-40, UIScreen.width, 40);
        self.textField.frame = frame;
    }];
}

- (void)keyboardWillHideWithRect:(CGRect)keyboardRect animationDuration:(CGFloat)duration {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = CGRectMake(0, UIScreen.height, UIScreen.width, 40);
        self.textField.frame = frame;
    } completion:^(BOOL finished) {
        [self.textField removeFromSuperview];
        self.textField.text = @"";
    }];
}

- (void)tupleScrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= 2*self.view.viewHeight) {//向上滚动
        [scrollView setContentOffset:CGPointMake(0, self.view.viewHeight) animated:NO];
        [self tupleScrollViewDidScrollToTop:scrollView];
    }else if (offsetY <= 0) {//向下滚动
        [scrollView setContentOffset:CGPointMake(0, self.view.viewHeight) animated:NO];
        [self tupleScrollViewDidScrollToBottom:scrollView];
    }
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return 3;
}
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.tupleView.size;
}
- (void)tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            itemBlock(nil, HLiveRoomBgCell.class, nil, YES);
        }
            break;
        case 2: {
            itemBlock(nil, HLiveRoomBgCell.class, nil, YES);
        }
            break;
        case 1: {
            if (self.liveStatus == HLiveStatusLoading) {
                HLiveRoomBgCell *cell = itemBlock(nil, HLiveRoomBgCell.class, nil, YES);
                
                void (^setScrollParams)(void) = ^(void){
                    // 禁止滚动
                    self.tupleView.scrollEnabled = NO;
                    // 开始旋转
                    [cell.activityIndicator startAnimating];
                    //可反复加载内容的直播功能
                    [self reloadLiveBroadcast:^{
                        // 解除禁止滚动
                        self.tupleView.scrollEnabled = YES;
                        // 停止旋转
                        [cell.activityIndicator stopAnimating];
                        // 更改直播状态
                        self.liveStatus = HLiveStatusLiveing;
                    }];
                };
                
                //设置滚动相关属性
                setScrollParams();
                
            }else if (self.liveStatus == HLiveStatusLiveing) {
                itemBlock(nil, HLiveRoomCell.class, nil, YES);
            }
        }
            break;

        default:
            break;
    }

}

//向上滚动
- (void)tupleScrollViewDidScrollToTop:(UIScrollView *)scrollView {
    // 更改直播状态
    self.liveStatus = HLiveStatusLoading;
}
//向下滚动
- (void)tupleScrollViewDidScrollToBottom:(UIScrollView *)scrollView {
    // 更改直播状态
    self.liveStatus = HLiveStatusLoading;
}
//可反复加载内容的直播功能
- (void)reloadLiveBroadcast:(void (^)(void))completion {
    dispatchAfter(3, ^{
        completion();
    });
}

@end
