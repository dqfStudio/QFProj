//
//  NSBlockChain.m
//  TestProject
//
//  Created by dqf on 2018/6/26.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "NSBlockChain.h"
#import <CommonCrypto/CommonDigest.h>

@interface NSString (chain)
- (NSString *)sha1Hash;
@end

@interface NSDate (chain)
+ (NSString *)toTimeString;
@end

@interface NSBlock ()
@property (nonatomic) NSString *key;
@end

@implementation NSBlock
- (id)init {
    self = [super init];
    if (self) {
        self.index = 0;
        self.nonce = 0;
        self.dateCreated = [NSDate toTimeString];
        self.previousHash = @"0";
    }
    return self;
}
- (NSString *)key {
    return [NSString stringWithFormat:@"%@%@%@%@",@(self.index),self.dateCreated,self.previousHash,@(self.nonce)];
}
@end

@interface NSBlockChain ()
@property (nonatomic) NSMutableArray *blocks;
@end

@implementation NSBlockChain

- (NSMutableArray *)blocks {
    if (!_blocks) {
        _blocks = NSMutableArray.new;
    }
    return _blocks;
}

- (id)initWithBlock:(NSBlock *)genesisBlock {
    self = [super init];
    if (self) {
        [self addBlock:genesisBlock];
    }
    return self;
}

- (void)addBlock:(NSBlock *)block {

    if (self.blocks.count == 0) {
        // 添加创世区块
        // 第一个区块没有 previous hash
        block.hashString = [self generateHash:block];
    }else {
        NSBlock *previousBlock = [self getPreviousBlock];
        block.previousHash = previousBlock.hashString;
        block.index = self.blocks.count;
        block.hashString = [self generateHash:block];
    }

    [self.blocks addObject:block];

}

- (NSArray *)allBlocks {
    return self.blocks;
}

- (NSBlock *)getPreviousBlock {
    return [self.blocks lastObject];
}

- (NSString *)generateHash:(NSBlock *)block {
    NSString *hash = [block.key sha1Hash];
    while (![hash hasPrefix:@"00"]) {
        block.nonce += 1;
        hash = [block.key sha1Hash];
    }
    return hash;
}

@end

@implementation NSString (chain)
- (NSString *)sha1Hash {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes,(unsigned int)data.length,digest);
    NSMutableString *outputString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];

    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [outputString appendFormat:@"%02x",digest[i]];
    }
    return [outputString lowercaseString];
}
@end

@implementation NSDate (chain)
+ (NSString *)toTimeString {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:[NSDate date]];
}
@end
