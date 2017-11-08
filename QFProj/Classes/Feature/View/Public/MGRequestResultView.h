//
//  MGRequestResultView.h
//  MGMobileMusic
//
//  Created by 喻平 on 2016/12/5.
//  Copyright © 2016年 migu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>

typedef NS_ENUM(NSInteger, MGRequestResultViewType) {
    MGRequestResultViewTypeNoData, // 没有数据
    MGRequestResultViewTypeLoadError, // 请求失败
    MGRequestResultViewTypeNoNetwork, // 没有网络
};

@interface MGRequestResultView : UIView
@property (nonatomic, weak) IBOutlet UIView * backView;
@property (nonatomic, weak) IBOutlet UIImageView *activeImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *reloadLabel;

@property (nonatomic, assign) MGRequestResultViewType type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void (^clickedBlock)(void);

@property (nonatomic, assign) CGFloat yOffset;  // 内容的居中的y偏移。在style之后设置

@end
