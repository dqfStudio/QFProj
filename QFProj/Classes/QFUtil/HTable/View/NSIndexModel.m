//
//  NSIndexModel.m
//  QFProj
//
//  Created by dqf on 2018/8/27.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "NSIndexModel.h"

@interface NSIndexModel (util)
- (NSString *(^)(id))append;
@end

@implementation NSString (util)
- (NSString *(^)(id))append {
    return ^NSString *(id obj) {
        return [NSString stringWithFormat:@"%@%@", self,obj];
    };
}
@end

@implementation NSIndexModel
+ (instancetype)indexModelForRow:(NSInteger)rowModel andSection:(NSInteger)sectionModel inSection:(NSInteger)section {
    NSIndexModel *indexModel = NSIndexModel.new;
    indexModel.rowModel = KCellModelName.append(@(rowModel)).append(@":");
    indexModel.sectionModel = KSectionModelName.append(@(sectionModel)).append(@":");
    indexModel.section = @(section).stringValue;
    return indexModel;
}
@end
