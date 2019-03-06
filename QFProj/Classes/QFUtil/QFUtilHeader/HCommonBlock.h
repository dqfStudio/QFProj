//
//  HCommonBlock.h
//  QFProj
//
//  Created by dqf on 2018/4/27.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#ifndef HFramework_HCommonBlock_h
#define HFramework_HCommonBlock_h

#import <Foundation/Foundation.h>

// universal block define

typedef void (^min_callback)(void);

typedef void (^callback)(id sender, id data);

typedef void (^callback2)(id sender, id data, id data2);

typedef void (^simple_callback)(id sender);

typedef void (^fail_callback)(id sender, NSError *error);

typedef id (^returnback)(id sender, id data);

typedef void (^finish_callback)(id sender, id data, NSError *error);

#endif


