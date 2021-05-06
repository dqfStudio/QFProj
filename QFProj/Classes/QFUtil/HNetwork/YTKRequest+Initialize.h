//
//  YTKRequest+Initialize.h
//  QFProj
//
//  Created by dqf on 2021/5/6.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YTKBaseRequest (Tag)
//身份标识，通过该字段区别另外一个请求
@property(nonatomic) NSString *identify;
@end

@interface YTKRequest (Initialize)

@end

NS_ASSUME_NONNULL_END
