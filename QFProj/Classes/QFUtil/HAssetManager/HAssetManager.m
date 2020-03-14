//
//  HAssetManager.m
//  QFProj
//
//  Created by dqf on 2020/3/13.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HAssetManager.h"
#import <Photos/Photos.h>

#define KInOperationKey @"inOperation"
#define KExecutingKey   @"executing"

@interface HAssetManager()
@property (nonatomic) NSMutableArray <HAssetModel *> *modelArray;
@end

@implementation HAssetManager

+ (instancetype)share {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
            [UIAlertController showAlertWithTitle:@"未获得照片使用权限" message:@"请在iOS 设置-隐私-照片 中打开" style:UIAlertControllerStyleAlert cancelButtonTitle:@"好的" otherButtonTitles:nil completion:nil];
        }
    }];
    static HAssetManager *operator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        operator = [[HAssetManager alloc] init];
        operator.modelArray = [NSMutableArray array];
        operator.albumsName = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
    });
    return operator;
}

- (void)createAlbums {
    [self exclusive:KInOperationKey block:^{
        if (![self isExistAlbums]) {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [self exclusive:KExecutingKey block:^{
                    //创建相册文件夹
                    [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:self.albumsName];
                }];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                [self removeExclusive:KExecutingKey];
                [self removeExclusive:KInOperationKey];
            }];
        }
    }];
}

- (NSArray <HAssetModel *>* _Nullable )getImagesAndVideoFromFolder {
    
    if (![self checkShouldCreateAlbums]) {
        return nil;
    }
    
    [self.modelArray removeAllObjects];
    
    //首先获取用户手动创建相册的集合
    PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    // 创建的相册
    __block PHAssetCollection *assetCollection = nil;
    //对获取到集合进行遍历
    [collectonResuts enumerateObjectsUsingBlock:^(PHAssetCollection *obj, NSUInteger idx, BOOL *stop) {
        //albumsName是我们写入照片的相册
        if ([obj.localizedTitle isEqualToString:self.albumsName])  {
            assetCollection = obj;
            *stop = YES;
        }
    }];
    
    PHFetchResult *res = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    [res enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_semaphore_t sem = dispatch_semaphore_create(0);
        [self getAssetWith:obj semaphore:sem];
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    }];
    
    //用dispatch_semaphore_t来保证同步
    return self.modelArray.copy;
}


- (void)getAssetWith:(PHAsset *)asset semaphore:(dispatch_semaphore_t)sem {
    
    if (asset.mediaType == PHAssetMediaTypeImage) {
        CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
        
        PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
        imageOptions.synchronous = YES; //YES 一定是同步    NO不一定是异步
        imageOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
        imageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;//imageOptions.synchronous = NO的情况下最终决定是否是异步
        
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:imageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            HAssetModel *model = [HAssetModel new];
            model.localIdentifier = asset.localIdentifier;
            model.image = result;
            model.avAsset = nil;
            [self.modelArray addObject:model];
            dispatch_semaphore_signal(sem);
        }];
    }else if (asset.mediaType == PHAssetMediaTypeVideo) {
        
        PHVideoRequestOptions *videoRequsetOptions = [[PHVideoRequestOptions alloc] init];
        videoRequsetOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        videoRequsetOptions.networkAccessAllowed = false;
        
        [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:videoRequsetOptions resultHandler:^(AVAsset * _Nullable avasset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            
            AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:avasset];
            gen.appliesPreferredTrackTransform = YES;
            CMTime time = CMTimeMakeWithSeconds(0.0, 600);
            NSError *error = nil;
            CMTime actualTime;
            CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
            UIImage *shotImage = [[UIImage alloc] initWithCGImage:image];
            CGImageRelease(image);
            
            HAssetModel *model = [HAssetModel new];
            model.assetType = HAssetType_Video;
            model.localIdentifier = asset.localIdentifier;
            model.image = shotImage;
            model.avAsset = avasset;
            [self.modelArray addObject:model];
            
            dispatch_semaphore_signal(sem);
        }];
    }
}

//保存图片到系统默认相册
- (void)saveImageToDefaultAlbum:(UIImage *)image completionHandler:(nullable void(^)(BOOL success, NSError * _Nullable error))completionHandler {
    if (image == nil) {
        if (completionHandler) {
            NSError *error = [NSError errorWithDomain:@"HAssetOperator" code:-999 userInfo:@{NSLocalizedDescriptionKey : @"图片不能为空"}];
            completionHandler(NO, error);
        }
        return;
    }
    [self exclusive:KInOperationKey block:^{
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [self exclusive:KExecutingKey block:^{
                [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            }];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            [self removeExclusive:KExecutingKey];
            [self removeExclusive:KInOperationKey];
            if (completionHandler) {
                completionHandler(success, error);
            }
        }];
    }];
}

//保存图片到指定相册
- (void)saveImage:(UIImage *)image completionHandler:(nullable void(^)(BOOL success, NSError * _Nullable error))completionHandler {
    if ([self checkShouldCreateAlbums]) {
        if (image == nil) {
            if (completionHandler) {
                NSError *error = [NSError errorWithDomain:@"HAssetOperator" code:-999 userInfo:@{NSLocalizedDescriptionKey : @"图片不能为空"}];
                completionHandler(NO, error);
            }
            return;
        }
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [self _saveFile:YES image:image videoPathURL:nil semaphore:semaphore completionHandler:completionHandler];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
}

- (void)saveVideoPath:(NSString *)videoPath completionHandler:(nullable void(^)(BOOL success, NSError *_Nullable error))completionHandler {
    if (videoPath == nil) {
        if (completionHandler) {
            NSError *error = [NSError errorWithDomain:@"HAssetOperator" code:-999 userInfo:@{NSLocalizedDescriptionKey : @"视频路径不能为空"}];
            completionHandler(NO, error);
        }
        return;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath] == NO) {
        if (completionHandler) {
            NSError *error = [NSError errorWithDomain:@"HAssetOperator" code:-999 userInfo:@{NSLocalizedDescriptionKey : @"该路径下的文件不存在"}];
            completionHandler(NO, error);
        }
        return;
    }
    [self saveVideoPathURL:[NSURL fileURLWithPath:videoPath] completionHandler:completionHandler];
}

- (void)saveVideoPathURL:(NSURL *)videoPathURL completionHandler:(nullable void(^)(BOOL success, NSError *_Nullable error))completionHandler {
    if (![self checkShouldCreateAlbums]) {
        return;
    }
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [self _saveFile:NO image:nil videoPathURL:videoPathURL semaphore:semaphore completionHandler:completionHandler];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

- (void)deleteFileWith:(NSString *)localIdentifier completionHandler:(void(^)(BOOL success, NSError *_Nullable error))completionHandler {
    if (![self checkShouldCreateAlbums]) {
        return;
    }
    PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    [collectonResuts enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger idx, BOOL *collectionStop) {
        if ([assetCollection.localizedTitle isEqualToString:self.albumsName])  {
            *collectionStop = YES;
            PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:[PHFetchOptions new]];
            [assetResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *assetStop) {
                if ([localIdentifier isEqualToString:asset.localIdentifier]) {
                    *assetStop = YES;
                    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                        [PHAssetChangeRequest deleteAssets:@[asset]];
                    } completionHandler:^(BOOL success, NSError *error) {
                        if (completionHandler != nil) {
                            completionHandler(success, error);
                        }
                    }];
                }
            }];
        }
    }];
}

- (void)deleteAlbumsAllFileWithCompletionHandler:(void(^)(BOOL success, NSError *_Nullable error))completionHandler {
    NSArray *albumArrar = [[HAssetManager share] getImagesAndVideoFromFolder];
    for (int i=0; i<albumArrar.count; i++) {
        HAssetModel *model = albumArrar[i];
        [[HAssetManager share] deleteFileWith:model.localIdentifier completionHandler:^(BOOL success, NSError * _Nullable error) {}];
    }
    if (completionHandler) {
        completionHandler(YES, nil);
    }
}

- (void)_saveFile:(BOOL)isImage image:(UIImage *)image videoPathURL:(NSURL *)videoPathURL semaphore:(dispatch_semaphore_t)semaphore completionHandler:(nullable void(^)(BOOL success, NSError *_Nullable error))completionHandler {
    [self exclusive:KInOperationKey block:^{
        //首先获取相册的集合
        PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        //对获取到集合进行遍历
        [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            PHAssetCollection *assetCollection = obj;
            //Camera Roll是我们写入照片的相册
            if ([assetCollection.localizedTitle isEqualToString:self.albumsName])  {
                *stop = YES;
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    [self exclusive:KExecutingKey block:^{
                        //请求创建一个Asset
                        PHAssetChangeRequest *assetRequest;
                        if (isImage) {
                            assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
                        }else {
                            assetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:videoPathURL];
                        }
                        //请求编辑相册
                        PHAssetCollectionChangeRequest *collectonRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                        //为Asset创建一个占位符，放到相册编辑请求中
                        PHObjectPlaceholder *placeHolder = [assetRequest placeholderForCreatedAsset];
                        //相册中添加照片 或者 视频
                        [collectonRequest insertAssets:@[placeHolder] atIndexes:[NSIndexSet indexSetWithIndex:0]];
                        //[collectonRequest addAssets:@[placeHolder]];
                    }];
                } completionHandler:^(BOOL success, NSError *error) {
                    [self removeExclusive:KExecutingKey];
                    [self removeExclusive:KInOperationKey];
                    dispatch_semaphore_signal(semaphore);
                    if (completionHandler != nil) {
                        completionHandler(success, error);
                    }
                }];
            }
        }];
    }];
}

- (BOOL)checkShouldCreateAlbums {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status != PHAuthorizationStatusAuthorized) {
        return NO;
    }else {
        [self createAlbums];
    }
    return YES;
}

- (BOOL)isExistAlbums {
    //首先获取用户手动创建相册的集合
    PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    __block BOOL isExisted = NO;
    //对获取到集合进行遍历
    [collectonResuts enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger idx, BOOL *stop) {
        //albumsName是我们写入照片的相册
        if ([assetCollection.localizedTitle isEqualToString:self.albumsName])  {
            isExisted = YES;
            *stop = YES;
        }
    }];
    return isExisted;
}

+ (void)saveGif:(NSString *)path completion:(nullable void(^)(BOOL success, NSError *_Nullable error))completion {
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error = [NSError errorWithDomain:@"QMNL" code:-99 userInfo:@{NSLocalizedDescriptionKey: @"path路径下文件不存在"}];
        completion(NO, error);
        return;
    }
    
    [self exclusive:KInOperationKey block:^{
        PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            PHAssetCollection *assetCollection = obj;
            *stop = YES;
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [self exclusive:KExecutingKey block:^{
                    NSURL *url = [NSURL fileURLWithPath:path];
                    PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:url];
                    
                    //请求编辑相册
                    PHAssetCollectionChangeRequest *collectonRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                    //为Asset创建一个占位符，放到相册编辑请求中
                    PHObjectPlaceholder *placeHolder = [assetRequest placeholderForCreatedAsset];
                    //相册中添加照片 或者 视频
                    [collectonRequest addAssets:@[placeHolder]];
                }];
            } completionHandler:^(BOOL success, NSError *error) {
                [self removeExclusive:KExecutingKey];
                [self removeExclusive:KInOperationKey];
                if (completion) {
                    completion(success, error);
                }
            }];
        }];
    }];

}

@end
