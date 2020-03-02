//
//  HTextArchiver.m
//
//  Created by ibireme on 15/3/16.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "HTextArchiver.h"
#import "HTextRunDelegate.h"
#import "HTextRubyAnnotation.h"

/**
 When call CTRunDelegateGetTypeID() on some devices (runs iOS6), I got the error:
 "dyld: lazy symbol binding failed: Symbol not found: _CTRunDelegateGetTypeID"
 
 Here's a workaround for this issue.
 */
static CFTypeID CTRunDelegateTypeID() {
    static CFTypeID typeID;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /*
        if ((long)CTRunDelegateGetTypeID + 1 > 1) { //avoid compiler optimization
            typeID = CTRunDelegateGetTypeID();
        }
         */
        HTextRunDelegate *delegate = [HTextRunDelegate new];
        CTRunDelegateRef ref = delegate.CTRunDelegate;
        typeID = CFGetTypeID(ref);
        CFRelease(ref);
    });
    return typeID;
}

static CFTypeID CTRubyAnnotationTypeID() {
    static CFTypeID typeID;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ((long)CTRubyAnnotationGetTypeID + 1 > 1) { //avoid compiler optimization
            typeID = CTRunDelegateGetTypeID();
        }else {
            typeID = kCFNotFound;
        }
    });
    return typeID;
}

/**
 A wrapper for CGColorRef. Used for Archive/Unarchive/Copy.
 */
@interface _HCGColor : NSObject <NSCopying, NSCoding>
@property (nonatomic, assign) CGColorRef CGColor;
+ (instancetype)colorWithCGColor:(CGColorRef)CGColor;
@end

@implementation _HCGColor

+ (instancetype)colorWithCGColor:(CGColorRef)CGColor {
    _HCGColor *color = [self new];
    color.CGColor = CGColor;
    return color;
}

- (void)setCGColor:(CGColorRef)CGColor {
    if (_CGColor != CGColor) {
        if (CGColor) CGColor = (CGColorRef)CFRetain(CGColor);
        if (_CGColor) CFRelease(_CGColor);
        _CGColor = CGColor;
    }
}

- (void)dealloc {
    if (_CGColor) CFRelease(_CGColor);
    _CGColor = NULL;
}

- (id)copyWithZone:(NSZone *)zone {
    _HCGColor *color = [self.class new];
    color.CGColor = self.CGColor;
    return color;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    UIColor *color = [UIColor colorWithCGColor:_CGColor];
    [aCoder encodeObject:color forKey:@"color"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    UIColor *color = [aDecoder decodeObjectForKey:@"color"];
    self.CGColor = color.CGColor;
    return self;
}

@end

/**
 A wrapper for CGImageRef. Used for Archive/Unarchive/Copy.
 */
@interface _HCGImage : NSObject <NSCoding, NSCopying>
@property (nonatomic, assign) CGImageRef CGImage;
+ (instancetype)imageWithCGImage:(CGImageRef)CGImage;
@end

@implementation _HCGImage

+ (instancetype)imageWithCGImage:(CGImageRef)CGImage {
    _HCGImage *image = [self new];
    image.CGImage = CGImage;
    return image;
}

- (void)setCGImage:(CGImageRef)CGImage {
    if (_CGImage != CGImage) {
        if (CGImage) CGImage = (CGImageRef)CFRetain(CGImage);
        if (_CGImage) CFRelease(_CGImage);
        _CGImage = CGImage;
    }
}

- (void)dealloc {
    if (_CGImage) CFRelease(_CGImage);
}

- (id)copyWithZone:(NSZone *)zone {
    _HCGImage *image = [self.class new];
    image.CGImage = self.CGImage;
    return image;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    UIImage *image = [UIImage imageWithCGImage:_CGImage];
    [aCoder encodeObject:image forKey:@"image"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    UIImage *image = [aDecoder decodeObjectForKey:@"image"];
    self.CGImage = image.CGImage;
    return self;
}

@end


@implementation HTextArchiver

+ (NSData *)archivedDataWithRootObject:(id)rootObject {
    if (!rootObject) return nil;
    NSMutableData *data = [NSMutableData data];
    HTextArchiver *archiver = [[[self class] alloc] initForWritingWithMutableData:data];
    [archiver encodeRootObject:rootObject];
    [archiver finishEncoding];
    return data;
}

+ (BOOL)archiveRootObject:(id)rootObject toFile:(NSString *)path {
    NSData *data = [self archivedDataWithRootObject:rootObject];
    if (!data) return NO;
    return [data writeToFile:path atomically:YES];
}

- (instancetype)init {
    self = [super init];
    self.delegate = self;
    return self;
}

- (instancetype)initForWritingWithMutableData:(NSMutableData *)data {
    self = [super initForWritingWithMutableData:data];
    self.delegate = self;
    return self;
}

- (id)archiver:(NSKeyedArchiver *)archiver willEncodeObject:(id)object {
    CFTypeID typeID = CFGetTypeID((CFTypeRef)object);
    if (typeID == CTRunDelegateTypeID()) {
        CTRunDelegateRef runDelegate = (__bridge CFTypeRef)(object);
        id ref = CTRunDelegateGetRefCon(runDelegate);
        if (ref) return ref;
    } else if (typeID == CTRubyAnnotationTypeID()) {
        CTRubyAnnotationRef ctRuby = (__bridge CFTypeRef)(object);
        HTextRubyAnnotation *ruby = [HTextRubyAnnotation rubyWithCTRubyRef:ctRuby];
        if (ruby) return ruby;
    } else if (typeID == CGColorGetTypeID()) {
        return [_HCGColor colorWithCGColor:(CGColorRef)object];
    } else if (typeID == CGImageGetTypeID()) {
        return [_HCGImage imageWithCGImage:(CGImageRef)object];
    }
    return object;
}

@end


@implementation HTextUnarchiver

+ (id)unarchiveObjectWithData:(NSData *)data {
    if (data.length == 0) return nil;
    HTextUnarchiver *unarchiver = [[self alloc] initForReadingWithData:data];
    return [unarchiver decodeObject];
}

+ (id)unarchiveObjectWithFile:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [self unarchiveObjectWithData:data];
}

- (instancetype)init {
    self = [super init];
    self.delegate = self;
    return self;
}

- (instancetype)initForReadingWithData:(NSData *)data {
    self = [super initForReadingWithData:data];
    self.delegate = self;
    return self;
}

- (id)unarchiver:(NSKeyedUnarchiver *)unarchiver didDecodeObject:(id)NS_RELEASES_ARGUMENT object NS_RETURNS_RETAINED {
    if ([object class] == [HTextRunDelegate class]) {
        HTextRunDelegate *runDelegate = object;
        CTRunDelegateRef ct = runDelegate.CTRunDelegate;
        id ctObj = (__bridge id)ct;
        if (ct) CFRelease(ct);
        return ctObj;
    } else if ([object class] == [HTextRubyAnnotation class]) {
        HTextRubyAnnotation *ruby = object;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8) {
            CTRubyAnnotationRef ct = ruby.CTRubyAnnotation;
            id ctObj = (__bridge id)(ct);
            if (ct) CFRelease(ct);
            return ctObj;
        }else {
            return object;
        }
    } else if ([object class] == [_HCGColor class]) {
        _HCGColor *color = object;
        return (id)color.CGColor;
    } else if ([object class] == [_HCGImage class]) {
        _HCGImage *image = object;
        return (id)image.CGImage;
    }
    return object;
}

@end
