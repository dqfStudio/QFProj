//
//  MGWaitingView.h
//  MGMobileMusic
//
//  Created by 喻平 on 2016/11/28.
//  Copyright © 2016年 migu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>

typedef NS_ENUM(NSInteger, MGWaitingViewStyle) {
    MGWaitingViewStyleGray,
    MGWaitingViewStyleWhite,
};

@interface MGWaitingView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *whiteLoadingImageView;

@property (nonatomic, weak) IBOutlet UIView *grayLoadingView;
@property (nonatomic, weak) IBOutlet UIImageView *grayLoadingImageView;
@property (nonatomic, weak) IBOutlet UILabel *grayLoadingLabel;

@property (nonatomic, assign) MGWaitingViewStyle style;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) CGFloat yOffset;  // 内容的居中的y偏移。在style之后设置

@end
