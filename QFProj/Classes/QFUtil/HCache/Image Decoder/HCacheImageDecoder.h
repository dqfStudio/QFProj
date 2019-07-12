// The MIT License (MIT)
//
// Copyright (c) 2015 Alexander Grebenyuk .

#import <Foundation/Foundation.h>
#if TARGET_OS_IOS || TARGET_OS_TV
#import <UIKit/UIKit.h>
#endif

#if TARGET_OS_IOS || TARGET_OS_TV
@interface HCacheImageDecoder : NSObject

+ (nullable UIImage *)decompressedImageWithData:(nonnull NSData *)data;

@end
#endif
