// The MIT License (MIT)
//
// Copyright (c) 2015 Alexander Grebenyuk .

#import "HCache.h"
#import "HCachePrivate.h"
#import "HCacheTimer.h"
#import "HValueTransformer.h"
#import "HValueTransformerFactory.h"
#import "NSURL+HExtendedFileAttributes.h"


NSString *const HCacheAttributeMetadataKey = @"_h_cache_metadata_key";

/*! Extended attribute name used to store value transformer associated with data.
 */
static NSString *const HCacheAttributeValueTransformerNameKey = @"_h_cache_value_transformer_name_key";


@implementation HCache {
    BOOL _cleanupTimerEnabled;
    NSTimeInterval _cleanupTimeInterval;
    NSTimer *__weak _cleanupTimer;
    
    /*! Serial dispatch queue used for all disk IO operations. If you store the object using HCache asynchronous API and then immediately try to retrieve it then you are guaranteed to get the object back.
     */
    dispatch_queue_t _ioQueue;
    
    /*! Concurrent dispatch queue used for dispatching blocks that decode cached data.
     */
    dispatch_queue_t _processingQueue;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_cleanupTimer invalidate];
}

- (instancetype)initWithDiskCache:(HDiskCache *)diskCache memoryCache:(NSCache *)memoryCache {
    if (self = [super init]) {
        _diskCache = diskCache;
        _memoryCache = memoryCache;
        
        _valueTransfomerFactory = [HValueTransformerFactory defaultFactory];
        
        _ioQueue = dispatch_queue_create("HCache::IOQueue", DISPATCH_QUEUE_SERIAL);
        _processingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        _cleanupTimeInterval = 60.f;
        _cleanupTimerEnabled = YES;
        [self _scheduleCleanupTimer];
        
#if TARGET_OS_IOS || TARGET_OS_TV
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
#endif
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name memoryCache:(NSCache *)memoryCache {
    if (!name.length) {
        [NSException raise:NSInvalidArgumentException format:@"Attemting to initialize HCache without a name"];
    }
    HDiskCache *diskCache = [[HDiskCache alloc] initWithName:name];
    diskCache.capacity = 1024 * 1024 * 100; // 100 Mb
    diskCache.cleanupRate = 0.5f;
    return [self initWithDiskCache:diskCache memoryCache:memoryCache];
}

- (instancetype)initWithName:(NSString *)name {
    NSCache *memoryCache = [NSCache new];
    memoryCache.name = name;
    return [self initWithName:name memoryCache:memoryCache];
}

- (instancetype)init {
    [NSException raise:NSInternalInconsistencyException format:@"Please use designated initialzier"];
    return nil;
}

#pragma mark - Read

- (void)cachedObjectForKey:(NSString *)key completion:(void (^)(id))completion {
    if (!key.length) {
        _dwarf_cache_callback(completion, nil);
        return;
    }
    id object = [self.memoryCache objectForKey:key];
    if (object) {
        _dwarf_cache_callback(completion, object);
        return;
    }
    dispatch_async(_processingQueue, ^{
        @autoreleasepool {
            id object = [self _cachedObjectForKey:key];
            _dwarf_cache_callback(completion, object);
        }
    });
}

- (id)cachedObjectForKey:(NSString *)key {
    if (!key.length) {
        return nil;
    }
    id object = [self.memoryCache objectForKey:key];
    if (object) {
        return object;
    }
    @autoreleasepool {
        return [self _cachedObjectForKey:key];
    }
}

- (id)_cachedObjectForKey:(NSString *)key {
    NSData *__block data;
    NSString *__block valueTransformerName;
    dispatch_sync(_ioQueue, ^{
        NSURL *fileURL = [self.diskCache URLForKey:key];
        data = [NSData dataWithContentsOfURL:fileURL];
        if (data) {
            valueTransformerName = [fileURL h_extendedAttributeValueForKey:HCacheAttributeValueTransformerNameKey error:nil];
        }
    });
    id<HValueTransforming> valueTransformer = [self.valueTransfomerFactory valueTransformerForName:valueTransformerName];
    id object = [valueTransformer reverseTransfomedValue:data];
    [self _setObject:object forKey:key valueTransformer:valueTransformer];
    return object;
}

#pragma mark - Write

- (void)storeObject:(id)object forKey:(NSString *)key {
    [self storeObject:object forKey:key data:nil];
}

- (void)storeObject:(id)object forKey:(NSString *)key data:(NSData *)data {
    if (!key.length) {
        return;
    }
    NSString *valueTransformerName = [self.valueTransfomerFactory valueTransformerNameForValue:object];
    id<HValueTransforming> valueTransformer = [self.valueTransfomerFactory valueTransformerForName:valueTransformerName];
    
    [self _setObject:object forKey:key valueTransformer:valueTransformer];
    
    if (!data && !valueTransformer) {
        return;
    }
    dispatch_async(_ioQueue, ^{
        @autoreleasepool {
            NSData *encodedData = data;
            if (!encodedData) {
                encodedData = [valueTransformer transformedValue:object];
            }
            if (encodedData) {
                NSURL *fileURL = [self.diskCache URLForKey:key];
                [encodedData writeToURL:fileURL atomically:YES];
                if (valueTransformerName) {
                    [fileURL h_setExtendedAttributeValue:valueTransformerName forKey:HCacheAttributeValueTransformerNameKey];
                }
            }
        }
    });
}

- (void)setObject:(id)object forKey:(NSString *)key {
    [self _setObject:object forKey:key valueTransformer:nil];
}

- (void)_setObject:(id)object forKey:(NSString *)key valueTransformer:(id<HValueTransforming>)valueTransformer {
    if (!object || !key.length) {
        return;
    }
    if (!valueTransformer) {
        NSString *valueTransformerName = [self.valueTransfomerFactory valueTransformerNameForValue:object];
        valueTransformer = [self.valueTransfomerFactory valueTransformerForName:valueTransformerName];
    }
    NSUInteger cost = 0;
    if ([valueTransformer respondsToSelector:@selector(costForValue:)]) {
        cost = [valueTransformer costForValue:object];
    }
    [self.memoryCache setObject:object forKey:key cost:cost];
}

#pragma mark - Remove

- (void)removeObjectsForKeys:(NSArray *)keys {
    if (!keys.count) {
        return;
    }
    for (NSString *key in keys) {
        [self.memoryCache removeObjectForKey:key];
    }
    dispatch_async(_ioQueue, ^{
        for (NSString *key in keys) {
            [self.diskCache removeDataForKey:key];
        }
    });
}

- (void)removeObjectForKey:(NSString *)key {
    if (key) {
        [self removeObjectsForKeys:@[key]];
    }
}

- (void)removeAllObjects {
    [self.memoryCache removeAllObjects];
    dispatch_async(_ioQueue, ^{
        [self.diskCache removeAllData];
    });
}

#pragma mark - Metadata

- (NSDictionary *)metadataForKey:(NSString *)key {
    if (!key.length) {
        return nil;
    }
    NSDictionary *__block metadata;
    dispatch_sync(_ioQueue, ^{
        NSURL *fileURL = [self.diskCache URLForKey:key];
        metadata = [fileURL h_extendedAttributeValueForKey:HCacheAttributeMetadataKey error:nil];
    });
    return metadata;
}

- (void)setMetadata:(NSDictionary *)metadata forKey:(NSString *)key {
    if (!metadata || !key.length) {
        return;
    }
    dispatch_async(_ioQueue, ^{
        NSURL *fileURL = [self.diskCache URLForKey:key];
        [fileURL h_setExtendedAttributeValue:metadata forKey:HCacheAttributeMetadataKey];
    });
}

- (void)setMetadataValues:(NSDictionary *)keyedValues forKey:(NSString *)key {
    if (!keyedValues.count || !key.length) {
        return;
    }
    dispatch_async(_ioQueue, ^{
        NSURL *fileURL = [self.diskCache URLForKey:key];
        NSDictionary *metadata = [fileURL h_extendedAttributeValueForKey:HCacheAttributeMetadataKey error:nil];
        NSMutableDictionary *mutableMetadata = [[NSMutableDictionary alloc] initWithDictionary:metadata];
        [mutableMetadata addEntriesFromDictionary:keyedValues];
        [fileURL h_setExtendedAttributeValue:mutableMetadata forKey:HCacheAttributeMetadataKey];
    });
}

- (void)removeMetadataForKey:(NSString *)key {
    if (!key.length) {
        return;
    }
    dispatch_async(_ioQueue, ^{
        NSURL *fileURL = [self.diskCache URLForKey:key];
        [fileURL h_removeExtendedAttributeForKey:HCacheAttributeMetadataKey];
    });
}

#pragma mark - Cleanup

- (void)setCleanupTimerInterval:(NSTimeInterval)timeInterval {
    if (_cleanupTimeInterval != timeInterval) {
        _cleanupTimeInterval = timeInterval;
        [self _scheduleCleanupTimer];
    }
}

- (void)setCleanupTimerEnabled:(BOOL)enabled {
    if (_cleanupTimerEnabled != enabled) {
        _cleanupTimerEnabled = enabled;
        [self _scheduleCleanupTimer];
    }
}

- (void)_scheduleCleanupTimer {
    [_cleanupTimer invalidate];
    if (_cleanupTimerEnabled) {
        HCache *__weak weakSelf = self;
        _cleanupTimer = [HCacheTimer scheduledTimerWithTimeInterval:_cleanupTimeInterval block:^{
            [weakSelf cleanupDiskCache];
        } userInfo:nil repeats:YES];
    }
}

- (void)cleanupDiskCache {
    dispatch_async(_ioQueue, ^{
        [self.diskCache cleanup];
    });
}

#if TARGET_OS_IOS || TARGET_OS_TV
- (void)_didReceiveMemoryWarning:(NSNotification *__unused)notification {
    [self.memoryCache removeAllObjects];
}
#endif

#pragma mark - Data

- (void)cachedDataForKey:(NSString *)key completion:(void (^)(NSData *))completion {
    if (!completion) {
        return;
    }
    if (!key.length) {
        _dwarf_cache_callback(completion, nil);
        return;
    }
    dispatch_async(_ioQueue, ^{
        NSData *data = [self.diskCache dataForKey:key];
        _dwarf_cache_callback(completion, data);
    });
}

- (NSData *)cachedDataForKey:(NSString *)key {
    if (!key.length) {
        return nil;
    }
    NSData *__block data;
    dispatch_sync(_ioQueue, ^{
        data = [self.diskCache dataForKey:key];
    });
    return data;
}

- (void)storeData:(NSData *)data forKey:(NSString *)key {
    if (!data || !key.length) {
        return;
    }
    dispatch_async(_ioQueue, ^{
        [self.diskCache setData:data forKey:key];
    });
}

#pragma mark - Miscellaneous

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<%@ %p> { disk_cache = %@ }", [self class], self, [self.diskCache debugDescription]];
}

@end


#if TARGET_OS_IOS || TARGET_OS_TV
@implementation HCache (UIImage)

- (void)setAllowsImageDecompression:(BOOL)allowsImageDecompression {
    HValueTransformerUIImage *transformer = [self.valueTransfomerFactory valueTransformerForName:HValueTransformerUIImageName];
    if ([transformer isKindOfClass:[HValueTransformerUIImage class]]) {
        transformer.allowsImageDecompression = allowsImageDecompression;
    }else {
        NSLog(@"Failed to set allowsImageDecompression. %@", self);
    }
}

@end
#endif


@implementation HCache (HCacheExtended)

- (void)batchCachedDataForKeys:(NSArray *)keys completion:(void (^)(NSDictionary *batch))completion {
    if (!keys.count) {
        _dwarf_cache_callback(completion, nil);
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *batch = [self batchCachedDataForKeys:keys];
        _dwarf_cache_callback(completion, batch);
    });
}

- (NSDictionary *)batchCachedDataForKeys:(NSArray *)keys {
    if (!keys.count) {
        return nil;
    }
    NSMutableDictionary *batch = [NSMutableDictionary new];
    for (NSString *key in keys) {
        NSData *data = [self cachedDataForKey:key];
        if (data) {
            batch[key] = data;
        }
    }
    return [batch copy];
}

- (void)batchCachedObjectsForKeys:(NSArray *)keys completion:(void (^)(NSDictionary *))completion {
    if (!keys.count) {
        _dwarf_cache_callback(completion, nil);
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *batch = [self batchCachedObjectsForKeys:keys];
        _dwarf_cache_callback(completion, batch);
    });
}

- (NSDictionary *)batchCachedObjectsForKeys:(NSArray *)keys {
    if (!keys.count) {
        return nil;
    }
    NSMutableDictionary *batch = [NSMutableDictionary new];
    for (NSString *key in keys) {
        id object = [self cachedObjectForKey:key];
        if (object) {
            batch[key] = object;
        }
    }
    return batch;
}

- (void)firstCachedObjectForKeys:(NSArray *)keys completion:(void (^)(id, NSString *))completion {
    [self _firstCachedObjectForKeys:[keys mutableCopy] completion:completion];
}

- (void)_firstCachedObjectForKeys:(NSMutableArray *)keys completion:(void (^)(id, NSString *))completion {
    if (!keys.count) {
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, nil);
            });
        }
        return;
    }
    NSString *key = keys[0];
    [keys removeObjectAtIndex:0];
    HCache *__weak weakSelf = self;
    [self cachedObjectForKey:key completion:^(id object) {
        if (object) {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(object, key);
                });
            }
        }else {
            [weakSelf _firstCachedObjectForKeys:keys completion:completion];
        }
    }];
}

@end
