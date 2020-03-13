//
//  HAssetModel.h
//  QFProj
//
//  Created by dqf on 2020/3/13.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSUInteger, HAssetType) {
    HAssetType_Photo = 1,
    HAssetType_Video = 2
};


NS_ASSUME_NONNULL_BEGIN

@interface HAssetModel : NSObject

/** asset的类别 */
@property (nonatomic, assign) HAssetType assetType;

/** asset的标识 */
@property (nonatomic, copy) NSString *localIdentifier;

/**
 assetType == photo, imagew为照片;
 assetType == video, imagew为视频的缩略图;
 */
@property (nonatomic, strong) UIImage *image;

/**
 assetType == photo, avAsset为空;
 assetType == video, avAsset为本地相册的视频
 你可以这样使用 AVAsset: [[AVPlayer alloc] initWithPlayerItem: [AVPlayerItem playerItemWithAsset:avAsset]]
 */
@property (nonatomic, strong, nullable) AVAsset *avAsset;

@end

NS_ASSUME_NONNULL_END
