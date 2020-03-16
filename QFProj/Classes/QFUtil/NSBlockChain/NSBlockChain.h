//
//  NSBlockChain.h
//  HProj
//
//  Created by dqf on 2018/6/26.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBlock : NSObject
@property (nonatomic) NSInteger index;
@property (nonatomic) NSString *dateCreated;
@property (nonatomic) NSString *previousHash;
@property (nonatomic) NSString *hashString;
@property (nonatomic) NSInteger nonce;
@end

@interface NSBlockChain : NSObject
- (id)initWithBlock:(NSBlock *)genesisBlock;
- (void)addBlock:(NSBlock *)block;
- (NSArray *)allBlocks;
@end
