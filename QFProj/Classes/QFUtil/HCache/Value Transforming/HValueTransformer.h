// The MIT License (MIT)
//
// Copyright (c) 2015 Alexander Grebenyuk .

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const HValueTransformerNSCodingName;
extern NSString *const HValueTransformerJSONName;

#if TARGET_OS_IOS || TARGET_OS_TV
extern NSString *const HValueTransformerUIImageName;
#endif


@protocol HValueTransforming <NSObject>

- (nullable NSData *)transformedValue:(id)value;
- (nullable id)reverseTransfomedValue:(NSData *)data;

@optional
/*! The cost that is associated with the value in the memory cache. Typically, the obvious cost is the size of the object in bytes.
 */
- (NSUInteger)costForValue:(id)value;

@end


@interface HValueTransformer : NSObject <HValueTransforming>

@end


@interface HValueTransformerNSCoding : HValueTransformer

@end


@interface HValueTransformerJSON : HValueTransformer

@end


#if TARGET_OS_IOS || TARGET_OS_TV

@interface HValueTransformerUIImage : HValueTransformer

/*! The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality).
 @discussion Applies only or images that don't have an alpha channel and cab be encoded in JPEG format.
 */
@property (nonatomic) float compressionQuality;

@property (nonatomic) BOOL allowsImageDecompression;

@end

#endif

NS_ASSUME_NONNULL_END
