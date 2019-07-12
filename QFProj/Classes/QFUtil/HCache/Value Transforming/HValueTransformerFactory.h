// The MIT License (MIT)
//
// Copyright (c) 2015 Alexander Grebenyuk .

#import <Foundation/Foundation.h>
#import "HValueTransformer.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HValueTransformerFactory <NSObject>

- (nullable NSString *)valueTransformerNameForValue:(id)value;

/*! Returns value transformer registered for a given name.
 */
- (nullable id<HValueTransforming>)valueTransformerForName:(nullable NSString *)name;

@end


@interface HValueTransformerFactory : NSObject <HValueTransformerFactory>

/*! Dependency injector.
 */
+ (id<HValueTransformerFactory>)defaultFactory;

/*! Dependency injector.
 */
+ (void)setDefaultFactory:(id<HValueTransformerFactory>)factory;

/*! Registers the provided value transformer with a given identifier.
 */
- (void)registerValueTransformer:(id<HValueTransforming>)valueTransformer forName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
