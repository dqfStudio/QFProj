// The MIT License (MIT)
//
// Copyright (c) 2015 Alexander Grebenyuk .

#import "HValueTransformerFactory.h"

#if TARGET_OS_IOS || TARGET_OS_TV
#import <UIKit/UIKit.h>
#endif

@implementation HValueTransformerFactory {
    NSMutableDictionary *_transformers;
}

static id<HValueTransformerFactory> _sharedFactory;

+ (void)initialize {
    [self setDefaultFactory:[HValueTransformerFactory new]];
}

- (instancetype)init {
    if (self = [super init]) {
        _transformers = [NSMutableDictionary new];

        [self registerValueTransformer:[HValueTransformerNSCoding new] forName:HValueTransformerNSCodingName];
        [self registerValueTransformer:[HValueTransformerJSON new] forName:HValueTransformerJSONName];
        
#if TARGET_OS_IOS || TARGET_OS_TV
        HValueTransformerUIImage *transformerUIImage = [HValueTransformerUIImage new];
        transformerUIImage.compressionQuality = 0.75f;
        transformerUIImage.allowsImageDecompression = YES;
        [self registerValueTransformer:transformerUIImage forName:HValueTransformerUIImageName];
#endif
    }
    return self;
}

- (void)registerValueTransformer:(id<HValueTransforming>)valueTransformer forName:(NSString *)name {
    _transformers[name] = valueTransformer;
}

- (id<HValueTransforming>)valueTransformerForName:(NSString *)name {
    return _transformers[name];
}

#pragma mark - <HValueTransformerFactory>

- (NSString *)valueTransformerNameForValue:(id)value {
#if TARGET_OS_IOS || TARGET_OS_TV
    if ([value isKindOfClass:[UIImage class]]) {
        return HValueTransformerUIImageName;
    }
#endif
    
    if ([value conformsToProtocol:@protocol(NSCoding)]) {
        return HValueTransformerNSCodingName;
    }
    
    return nil;
}

#pragma mark - Dependency Injectors

+ (id<HValueTransformerFactory>)defaultFactory {
    return _sharedFactory;
}

+ (void)setDefaultFactory:(id<HValueTransformerFactory>)factory {
    _sharedFactory = factory;
}

@end
