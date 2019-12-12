//
//  HRequestDAOFactory.m
//  QFProj
//
//  Created by dqf on 2019/7/11.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HRequestDAOFactory.h"

@implementation HRequestDAOFactory
+ (HRequestDAO *)createSimpleRequest {
    return HRequestDAO.new;
}
+ (HRequestDAO *)createRetryRequest:(NSInteger)count {
    HRequestDAO *httpRequest = HRequestDAO.new;
    
//#if DEBUG
//    HDebugStrategy *debugStrgy = HDebugStrategy.new;
//    [httpRequest.request addAccessory:debugStrgy];
//    [httpRequest addStrategy:debugStrgy];
//#endif
    
    HLogErrorStrategy *logStrgy = HLogErrorStrategy.new;
    [httpRequest addAccessory:logStrgy];
    [httpRequest addStrategy:logStrgy];
    
    HRetryStrategy *retryStrgy = HRetryStrategy.new;
    retryStrgy.tryMax = count;
    [httpRequest addAccessory:retryStrgy];
    [httpRequest addStrategy:retryStrgy];
    
    return httpRequest;
}
+ (HRequestDAO *)createPollingRequest:(NSArray *)pollingArr {
    HRequestDAO *httpRequest = HRequestDAO.new;
    
//#if DEBUG
//    HDebugStrategy *debugStrgy = HDebugStrategy.new;
//    [httpRequest.request addAccessory:debugStrgy];
//    [httpRequest addStrategy:debugStrgy];
//#endif
    
    HLogErrorStrategy *logStrgy = HLogErrorStrategy.new;
    [httpRequest addAccessory:logStrgy];
    [httpRequest addStrategy:logStrgy];
    
    HPollingStrategy *pollingStrgy = HPollingStrategy.new;
    pollingStrgy.pollingArr = pollingArr;
    [httpRequest addAccessory:pollingStrgy];
    [httpRequest addStrategy:pollingStrgy];
    
    return httpRequest;
}
@end
