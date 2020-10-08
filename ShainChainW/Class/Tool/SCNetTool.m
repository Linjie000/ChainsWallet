//
//  SCNetTool.m
//  ShainChainW
//
//  Created by 闪链 on 2019/6/20.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "SCNetTool.h"

@interface SCNetTool ()

@end

@implementation SCNetTool

static BOOL _Reachable = YES;
+ (void)AFNetworkReachability
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*
         AFNetworkReachabilityStatusUnknown          = -1,
         AFNetworkReachabilityStatusNotReachable     = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,
         */
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: 
                break;
            case AFNetworkReachabilityStatusNotReachable:
                _Reachable = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                if (!_Reachable) {
                    [self postNotificationForName:KEY_SCWALLET_NETWORK_STATE userInfo:@{}];
                }
                _Reachable = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                if (!_Reachable) {
                    [self postNotificationForName:KEY_SCWALLET_NETWORK_STATE userInfo:@{}];
                }
                _Reachable = YES;
                break;
            default:
                break;
        }
    }];
    [manager startMonitoring];
}
@end
