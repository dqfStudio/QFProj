//
//  HSort.h
//  MGMobileMusic
//
//  Created by dqf on 2018/5/16.
//  Copyright © 2018年 migu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class HSortModel;

/**
 返回需要排序的值

 @param obj 数组中的每一项
 @param idx 数组每一项的index
 @return 返回需要排序的值
 */
typedef NSString *(^HEnumeratebBlock)(id obj, NSUInteger idx);


/**
 返回排序后的结果

 @param model 排序结果model
 */
typedef void (^HResultBlock)(HSortModel *model);

@interface HSortModel : NSObject
//排序后的字母数据
@property (nonatomic) NSArray *sortedIndexs;
//排序后的数据源
@property (nonatomic) NSArray *sortedDataSource;
@end

@interface HSort : NSObject

/**
 根据关键词对数据源按照A~Z的顺序进行排序

 @param dataSource 需要排序的数据源
 @param enumeratebBlock 对数据源中的元素进行排序
 @param resultBlock 返回排序的结果
 */
+ (void)sortDataSource:(NSArray *)dataSource enumerateObjectsUsingBlock:(HEnumeratebBlock)enumeratebBlock resultBlock:(HResultBlock)resultBlock;
@end
