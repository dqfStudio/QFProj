//
//  HTextRunDelegate.m
//
//  Created by ibireme on 14/10/14.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "HTextRunDelegate.h"

static void HDeallocCallback(void *ref) {
    HTextRunDelegate *self = (__bridge_transfer HTextRunDelegate *)(ref);
    self = nil; // release
}

static CGFloat HGetAscentCallback(void *ref) {
    HTextRunDelegate *self = (__bridge HTextRunDelegate *)(ref);
    return self.ascent;
}

static CGFloat HGetDecentCallback(void *ref) {
    HTextRunDelegate *self = (__bridge HTextRunDelegate *)(ref);
    return self.descent;
}

static CGFloat HGetWidthCallback(void *ref) {
    HTextRunDelegate *self = (__bridge HTextRunDelegate *)(ref);
    return self.width;
}

@implementation HTextRunDelegate

- (CTRunDelegateRef)CTRunDelegate CF_RETURNS_RETAINED {
    CTRunDelegateCallbacks callbacks;
    callbacks.version = kCTRunDelegateCurrentVersion;
    callbacks.dealloc = HDeallocCallback;
    callbacks.getAscent = HGetAscentCallback;
    callbacks.getDescent = HGetDecentCallback;
    callbacks.getWidth = HGetWidthCallback;
    return CTRunDelegateCreate(&callbacks, (__bridge_retained void *)(self.copy));
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(_ascent) forKey:@"ascent"];
    [aCoder encodeObject:@(_descent) forKey:@"descent"];
    [aCoder encodeObject:@(_width) forKey:@"width"];
    [aCoder encodeObject:_userInfo forKey:@"userInfo"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    _ascent = ((NSNumber *)[aDecoder decodeObjectForKey:@"ascent"]).floatValue;
    _descent = ((NSNumber *)[aDecoder decodeObjectForKey:@"descent"]).floatValue;
    _width = ((NSNumber *)[aDecoder decodeObjectForKey:@"width"]).floatValue;
    _userInfo = [aDecoder decodeObjectForKey:@"userInfo"];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    typeof(self) one = [self.class new];
    one.ascent = self.ascent;
    one.descent = self.descent;
    one.width = self.width;
    one.userInfo = self.userInfo;
    return one;
}

@end
