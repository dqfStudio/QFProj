//
//  HLiveRoomCell+HSection2.m
//  QFProj
//
//  Created by Jovial on 2021/8/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HLiveRoomCell+HSection2.h"

@interface HLiveRoomBottomBarView : UIView
@property (nonatomic) HWebButtonView *chatView;
@property (nonatomic) HWebButtonView *mailView;
@property (nonatomic) HWebButtonView *exitView;
@end

@implementation HLiveRoomBottomBarView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.chatView];
        [self addSubview:self.mailView];
        [self addSubview:self.exitView];
    }
    return self;
}
- (HWebButtonView *)chatView {
    if (!_chatView) {
        CGRect frame = CGRectMake(5, 5, self.viewHeight-10, self.viewHeight-10);
        _chatView = [[HWebButtonView alloc] initWithFrame:frame];
        _chatView.backgroundColor = UIColor.blackColor;
        [_chatView setCornerRadius:_chatView.viewWidth/2];
    }
    return _chatView;
}
- (HWebButtonView *)mailView {
    if (!_mailView) {
        CGRect frame = CGRectMake(self.viewWidth-self.viewHeight*2, 5, self.viewHeight-10, self.viewHeight-10);
        _mailView = [[HWebButtonView alloc] initWithFrame:frame];
        _mailView.backgroundColor = UIColor.blueColor;
        [_mailView setCornerRadius:_mailView.viewWidth/2];
    }
    return _mailView;
}
- (HWebButtonView *)exitView {
    if (!_exitView) {
        CGRect frame = CGRectMake(self.viewWidth-self.viewHeight, 5, self.viewHeight-10, self.viewHeight-10);
        _exitView = [[HWebButtonView alloc] initWithFrame:frame];
        _exitView.backgroundColor = UIColor.redColor;
        [_exitView setCornerRadius:_exitView.viewWidth/2];
    }
    return _exitView;
}
@end

@implementation HLiveRoomCell (HSection2)
- (NSInteger)tupleExa2_numberOfItemsInSection:(NSInteger)section {
    return 1;
}
- (CGSize)tupleExa2_sizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(self.liveRightView.width, UIScreen.bottomBarHeight+5);
}
- (CGSize)tupleExa2_sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.liveRightView.width, 40);
}
- (void)tupleExa2_tupleFooter:(HTupleFooter)footerBlock inSection:(NSInteger)section {
    HTupleBaseApex *cell = footerBlock(nil, HTupleBaseApex.class, nil, YES);
    [cell setBackgroundColor:UIColor.clearColor];
}
- (void)tupleExa2_tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    HTupleBaseCell *cell = itemBlock(nil, HTupleBaseCell.class, nil, YES);
    HLiveRoomBottomBarView *bottomBarView = [cell viewWithTag:123456];
    if (!bottomBarView) {
        bottomBarView = [[HLiveRoomBottomBarView alloc] initWithFrame:cell.bounds];
        [cell addSubview:bottomBarView];
    }
    [bottomBarView.chatView setPressed:^(id sender, id data) {
        NSLog(@"");
    }];
    [bottomBarView.mailView setPressed:^(id sender, id data) {
        NSLog(@"");
    }];
    [bottomBarView.exitView setPressed:^(id sender, id data) {
        NSLog(@"");
    }];
    
}
@end
