//
//  HSort.m
//  MGMobileMusic
//
//  Created by dqf on 2018/5/16.
//  Copyright © 2018年 migu. All rights reserved.
//

#import "HSort.h"

@interface NSString (HSort)
- (NSString *)getSortableString;
@end

@implementation HSortModel

@end

@implementation HSort

+ (void)sortDataSource:(NSArray *)dataSource enumerateObjectsUsingBlock:(HEnumeratebBlock)enumeratebBlock resultBlock:(HResultBlock)resultBlock {
    
    //block不能为nil
    if (!enumeratebBlock || !resultBlock) return;
    
    NSArray *objects = dataSource;
    NSInteger objectCount = [objects count];
    
    //获取系统字母索引a-z
    NSMutableArray *sectionTitles = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] mutableCopy];
    
    //初始化具体业务字母索引数组
    NSMutableArray *showIndexs = [NSMutableArray arrayWithCapacity:sectionTitles.count];
    
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    NSInteger groupCount = [[theCollation sectionTitles] count];
    
    //初始化一个数组，数组大小为系统字母索引个数
    NSMutableArray *groups = [NSMutableArray arrayWithCapacity:groupCount];
    
    //每个数组元素也为一个数组，数组元素默认大小为10
    for (NSInteger i = 0; i < groupCount; i++) {
        [groups addObject:[NSMutableArray arrayWithCapacity:10]];
    }
    
    //遍历业务数据源
    for (int i = 0; i < objectCount; i++) {
        NSDictionary *info = [objects objectAtIndex:i];
        
        //外部返回需要排序的值
        NSString *sortKey = enumeratebBlock(info, i);
        
        //排序，并根据序号将业务数据加入到groups中
        NSInteger sect = [theCollation sectionForObject:sortKey collationStringSelector:@selector(getSortableString)];
        [[groups objectAtIndex:sect] addObject:info];
        
        //将用到的字母保存起来，如a.b.d
        NSString *aTitle = [sectionTitles objectAtIndex:sect];
        if (![showIndexs containsObject:aTitle]) {
            [showIndexs addObject:aTitle];
        }
    }
    
    //获取groups中无数据的元素并删除
    NSMutableArray *needRemoves = [NSMutableArray arrayWithCapacity:groups.count];
    for (NSArray *group in groups) {
        if (group.count <= 0) {
            [needRemoves addObject:group];
        }
    }
    [groups removeObjectsInArray:needRemoves];
    
    //对获取的字母排序
    [showIndexs sortUsingComparator:^(NSString *obj1, NSString *obj2) {
        if ([obj1 isEqualToString:@"#"]) {
            return NSOrderedDescending;
        }
        else if ([obj2 isEqualToString:@"#"]) {
            return NSOrderedAscending;
        }
        else {
            return [obj1 compare:obj2];
        }
    }];
    
    //初始化模型并返回给业务层
    HSortModel *model = [HSortModel new];
    model.sortedIndexs = showIndexs;
    model.sortedDataSource = groups;
    
    if (resultBlock) {
        resultBlock(model);
    }
    
}

@end

@implementation NSString (HSort)

- (NSString *)getSortableString {
    if (self.length == 0) {
        return @"";
    }
    NSString *firstString = [self substringToIndex:1];
    
    if (firstString.length <= 0 || [firstString canBeConvertedToEncoding:NSASCIIStringEncoding]) {//如果是英语
        return firstString;
    }else { //如果是非英语
        // 处理姓氏多音字
        return [firstString firstLettersForSort:YES];
    }
}

- (NSString *)firstLettersForSort:(BOOL)isForSurname {
    NSString* convertString = self;
    if (isForSurname) {
        //如果是姓名优先去掉“·”符号
        convertString = [self stringByReplacingOccurrencesOfString:@"·" withString:@""];
    }
    NSMutableString* resultString = [NSMutableString string];
    if (convertString.length > 0) {
        unichar indexChar;
        for (NSUInteger nIndex = 0; nIndex < convertString.length; ++nIndex) {
            indexChar = [convertString characterAtIndex:nIndex];
            //判断字符是否为英文字母
            if ((indexChar >= 'A' && indexChar <= 'Z') ||
                (indexChar >= 'a' && indexChar <= 'z')) {
                [resultString appendString:[NSString stringWithFormat:@"%c", indexChar]];
            }
            //判断字符是否为汉字
//            else if (isFirstLetterHANZI(indexChar))
//            {
//                NSString* firstCharacterInPinYin = [NSString stringWithFormat:@"%c",pinyinFirstLetter(indexChar)];//从第三方库中匹配这个汉子的拼音首字母
//                if (firstCharacterInPinYin)
//                {
//                    [resultString appendString:firstCharacterInPinYin];
//                }
//                else//未识别字符保持不变
//                {
//                    [resultString appendString:[convertString substringWithRange:NSMakeRange(nIndex, 1)]];
//                }
//            }
            //其他字符保持不变
            else {
                [resultString appendString:[convertString substringWithRange:NSMakeRange(nIndex, 1)]];
            }
        }
        if (isForSurname) {
            //处理姓氏多音字
            NSArray* allPolyphoneSurname = [[NSString getDicForAllPolyphoneSurnameFirstLetters] allKeys];
            for (NSString* tempPolyphoneSurname in allPolyphoneSurname) {
                if ([convertString hasPrefix:tempPolyphoneSurname]) {
                    [resultString replaceCharactersInRange:NSMakeRange(0, tempPolyphoneSurname.length) withString:[[NSString getDicForAllPolyphoneSurnameFirstLetters] valueForKey:tempPolyphoneSurname]];
                    break;
                }
            }
        }
    }
    return resultString;
}

/**
 *  所有的多音字匹配的拼音首字母键值对，每个姓氏多音字对应一字符串
 *  多音字姓氏使用第三方平台转换时，如果转换错误，将使用该键值对匹配替换
 */
+ (NSDictionary*)getDicForAllPolyphoneSurnameFirstLetters {
    static NSDictionary* g_pAllPolyphoneSurnameFirstLetters = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^
                  {
                      g_pAllPolyphoneSurnameFirstLetters = [NSMutableDictionary dictionaryWithObjectsAndKeys
                                                            :@"p",@"繁"
                                                            ,@"o",@"区"
                                                            ,@"q",@"仇"
                                                            ,@"c",@"种"
                                                            ,@"s",@"单"
                                                            ,@"x",@"解"
                                                            ,@"z",@"查"
                                                            ,@"z",@"曾"
                                                            ,@"b",@"秘"
                                                            ,@"y",@"乐"
                                                            ,@"c",@"重"
                                                            ,@"x",@"冼"
                                                            ,@"z",@"翟"
                                                            ,@"s",@"折"
                                                            ,@"s",@"沈"
                                                            ,@"yc",@"尉迟"
                                                            ,@"mq",@"万俟"
                                                            ,nil];
                  });
    return g_pAllPolyphoneSurnameFirstLetters;
}

@end
