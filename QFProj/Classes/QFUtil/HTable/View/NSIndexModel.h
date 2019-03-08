//
//  NSIndexModel.h
//  QFProj
//
//  Created by dqf on 2018/8/27.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KSectionModelName @"sectionMode"
#define KCellModelName    @"cellMode"

@interface NSIndexModel : NSObject

//标识row model
@property (nonatomic) NSString *rowModel;
//标识section model
@property (nonatomic) NSString *sectionModel;
//cell所在的section
@property (nonatomic) NSString *section;

+ (instancetype)indexModelForRow:(NSInteger)rowModel andSection:(NSInteger)sectionModel inSection:(NSInteger)section;
+ (instancetype (^)(NSInteger rowModel, NSInteger sectionModel, NSInteger section))indexModel;

@end
