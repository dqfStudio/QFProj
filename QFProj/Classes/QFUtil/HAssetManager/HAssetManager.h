//
//  HAssetManager.h
//  QFProj
//
//  Created by dqf on 2020/3/13.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HAssetModel.h"
#import "UIAlertController+HUtil.h"

NS_ASSUME_NONNULL_BEGIN

@interface HAssetManager : NSObject

@property (nonatomic, copy) NSString *albumsName;

+ (instancetype)share;

//创建一个相册
- (void)createAlbums;

//获取相册里面的图片和视频
- (NSArray <HAssetModel *>* _Nullable )getImagesAndVideoFromFolder;

//保存图片到系统默认相册
- (void)saveImageToDefaultAlbum:(UIImage *)image completionHandler:(nullable void(^)(BOOL success, NSError * _Nullable error))completionHandler;

//保存图片到指定相册
- (void)saveImage:(UIImage *)image completionHandler:(nullable void(^)(BOOL success, NSError * _Nullable error))completionHandler;

//保存视频到系统相册
- (void)saveVideoPath:(NSString *)videoPath completionHandler:(nullable void(^)(BOOL success,  NSError * _Nullable  error))completionHandler;

- (void)saveVideoPathURL:(NSURL *)videoPathURL completionHandler:(nullable void(^)(BOOL success, NSError * _Nullable error))completionHandler;

/**
 *  删除系统相册中的文件
 *  @param localIdentifier  本地相册中相片的标识
 *  @param completionHandler 删除后的回调
 */
- (void)deleteFileWith:(NSString *)localIdentifier completionHandler:(void(^)(BOOL success, NSError * _Nullable error))completionHandler;

- (void)deleteAlbumsAllFileWithCompletionHandler:(void(^)(BOOL success, NSError *_Nullable error))completionHandler;

/// gif 文件保存
/// @param path path
/// @param completion 回调
+ (void)saveGif:(NSString *)path completion:(nullable void(^)(BOOL success, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
