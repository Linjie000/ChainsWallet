//
//  EOSRequestManager.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/27.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSRequestManager.h"
 
@interface EOSRequestManager ()
@property(strong, nonatomic) AFHTTPSessionManager *networkingManager;

@end

@implementation EOSRequestManager

#pragma mark Build request interface address
- (NSString *)requestUrlPath{
    return @"";
}

#pragma mark Build request parameters
- (id)parameters{
    return @{};
}

- (AFHTTPSessionManager *)networkingManager{
    if(!_networkingManager){
        _networkingManager = [[AFHTTPSessionManager alloc] initWithBaseURL: [NSURL URLWithString: REQUEST_BASEURL]];
        _networkingManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", @"text/plain", nil];
    }
    return _networkingManager;
}
 
- (void)postOuterDataSuccess:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure{
    if (![self buildRequestConfigInfo]) {
        return;
    }
    WeakSelf(weakSelf);
    id parameters = [self parameters];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL: [NSURL URLWithString: REQUEST_BASEURL]];
    [self configTimeOut:manager];
#pragma mark -- 单向验证
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    //客服端利用p12验证服务器 , 双向验证
    //    [self checkCredential:manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", @"text/plain", nil];
    // request Json 序列化
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
//
//    if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
//        [manager.requestSerializer setValue:CURRENT_WALLET_UID forHTTPHeaderField:@"uid"];
//
//    }else if(LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
        [manager.requestSerializer setValue:@"6f1a8e0eb24afb7ddc829f96f9f74e9d" forHTTPHeaderField:@"uid"];
//    }
    
//    if ([NSBundle isChineseLanguage]) {
        [manager.requestSerializer setValue:@"chinese" forHTTPHeaderField:@"language"];
//    }else{
//        [manager.requestSerializer setValue:@"english" forHTTPHeaderField:@"language"];
//    }
    
    [manager POST:[self requestUrlPath] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([self validateResponseData:responseObject HttpURLResponse:task.response]) {
            if (!(success)) {
                return ;
            }
            if ([responseObject isKindOfClass:[NSData class]]) {
                
            }
            success(weakSelf.networkingManager, responseObject);
        }
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        SCLog(@"error ==%@", [error userInfo][@"com.alamofire.serialization.response.error.string"]);
        if (!failure) {
            return ;
        }
        if(error.code == -1001){
            [TKCommonTools showToast:NSLocalizedString(@"请求超时, 请稍后再试!", nil)];
        }
        
        failure(weakSelf.networkingManager , error);
    }];
}

#pragma mark The Post method request data
- (void)postDataSuccess:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure{
 
    //Start a Post request data interface
    id parameters = [self parameters];
    SCLog(@"parameters = %@", parameters);
    SCLog(@"REQUEST_APIPATH = %@", REQUEST_APIPATH);
    WeakSelf(weakSelf);
    NSString *url = [NSString stringWithFormat:@"%@%@?name=%@",REQUEST_BASEURL,REQUEST_APIPATH,parameters[@"name"]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFSecurityPolicy *security = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [security setValidatesDomainName:NO];
    security.allowInvalidCertificates = YES;
    manager.securityPolicy = security;
 
    //    SCLog(@"get  :%@",url);
    [manager POST:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        SCLog(@"responseObject  :%@",responseObject);
        if (success) {
            success(nil,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            //            [RewardHelper showTextWithHUD:@"请检查您的网络"];
            failure(nil,error);
        }
    }];
}

- (void)getDataSusscess:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure{
    if (![self buildRequestConfigInfo]) {
        return;
    }
    WeakSelf(weakSelf);
    id parameters = [self parameters];
    SCLog(@"REQUEST_APIPATH = %@", [self requestUrlPath]);
    SCLog(@"parameters = %@", parameters);
    // 设置超时时间
    [self.networkingManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.networkingManager.requestSerializer.timeoutInterval = 30.f;
    [self.networkingManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    [self.networkingManager GET:REQUEST_APIPATH parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject:%@", responseObject);
        if ([self validateResponseData:responseObject HttpURLResponse:task.response]) {
            if (IsNilOrNull(success)) {
                return ;
            }
            success(weakSelf.networkingManager, responseObject);
        }
 
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (IsNilOrNull(failure)) {
            return ;
        }
        if(error.code == -1001){
            [TKCommonTools showToast:LocalizedString(@"请求超时, 请稍后再试!")];
        }
        failure(weakSelf.networkingManager, error);
        
    }];
}

- (void)postRequestDataSuccess:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure
{
    id parameters = [self parameters];
    SCLog(@"parameters = %@", parameters);
    NSString *url = [NSString stringWithFormat:@"%@%@",eosnewyork_BASEURL,eosnewyork_APIPATH];
    SCLog(@"url = %@", url);
    [RequestManager post:url parameters:parameters success:^(id  _Nonnull responseObject) {
        if (IsNilOrNull(success)) {
            return ;
        }
        success(nil, responseObject);
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (IsNilOrNull(failure)) {
            return ;
        }
        if(error.code == -1001){
            [TKCommonTools showToast:LocalizedString(@"请求超时, 请稍后再试!")];
        }
        failure(nil, error);
    }];
}

- (void)getRequestDataSuccess:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure
{
    id parameters = [self parameters];
    SCLog(@"parameters = %@", parameters);
    NSString *url = [NSString stringWithFormat:@"%@%@",eosnewyork_BASEURL,eosnewyork_APIPATH];
    SCLog(@"url = %@", url);
    [RequestManager get:url parameters:parameters success:^(id  _Nonnull responseObject) {
        if (IsNilOrNull(success)) {
            return ;
        }
        success(nil, responseObject);
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (IsNilOrNull(failure)) {
            return ;
        }
        if(error.code == -1001){
            [TKCommonTools showToast:LocalizedString(@"请求超时, 请稍后再试!")];
        }
        failure(nil, error);
    }];
}

- (void)postEosparkRequestSuccess:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure
{
    id parameters = [self parameters];
    SCLog(@"parameters = %@", parameters);
    NSString *url = [NSString stringWithFormat:@"%@%@",eospark_BASEURL,eosnewyork_APIPATH];
    SCLog(@"url = %@", url);
    [RequestManager post:url parameters:parameters success:^(id  _Nonnull responseObject) {
        if (IsNilOrNull(success)) {
            return ;
        }
        success(nil, responseObject);
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (IsNilOrNull(failure)) {
            return ;
        }
        if(error.code == -1001){
            [TKCommonTools showToast:LocalizedString(@"请求超时, 请稍后再试!")];
        }
        failure(nil, error);
    }];
}

- (void)postRequestHistorySuccess:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure
{
    id parameters = [self parameters];
    SCLog(@"parameters = %@", parameters);
    NSString *url = [NSString stringWithFormat:@"%@%@",eosinfra_BASEURL,eoshistory_APIPATH];
    SCLog(@"url = %@", url);
    [RequestManager post:url parameters:parameters success:^(id  _Nonnull responseObject) {
        if (IsNilOrNull(success)) {
            return ;
        }
        success(nil, responseObject);
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (IsNilOrNull(failure)) {
            return ;
        }
        if(error.code == -1001){
            [TKCommonTools showToast:LocalizedString(@"请求超时, 请稍后再试!")];
        }
        failure(nil, error);
    }];
}


// 请求超时时间
- (void)configTimeOut:(AFHTTPSessionManager *)manager{
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    ((AFJSONResponseSerializer *)self.networkingManager.responseSerializer).removesKeysWithNullValues = YES;
}

- (BOOL)validateResponseData:(id) returnData HttpURLResponse: (NSURLResponse *)response{
    //获取http 状态码
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    SCLog(@"HttpCode: %ld", (long)httpResponse.statusCode);
    if(httpResponse.statusCode > 300){
        return NO;
    }
    return YES;
}

// 配置请求
- (BOOL)buildRequestConfigInfo{
 
    [self configTimeOut:self.networkingManager];
    // 单向验证
    [self.networkingManager setSecurityPolicy:[self customSecurityPolicy]];
    // 设置自动管理Cookies
    self.networkingManager.requestSerializer.HTTPShouldHandleCookies = YES;
    // 如果已有Cookie, 则把你的cookie符上
    NSString *cookie = [[NSUserDefaults standardUserDefaults] objectForKey:@"Set-Cookie"];
    SCLog(@"sendCookie::%@", cookie);
    if (cookie != nil) {
        [self.networkingManager.requestSerializer setValue:cookie forHTTPHeaderField:@"Set-Cookie"];
    }
    
    [self.networkingManager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"system_version"];
 
    [self.networkingManager.requestSerializer setValue:@"6f1a8e0eb24afb7ddc829f96f9f74e9d" forHTTPHeaderField:@"uid"];
  
    
//    if ([NSBundle isChineseLanguage]) {
        [self.networkingManager.requestSerializer setValue:@"chinese" forHTTPHeaderField:@"language"];
//    }else{
//        [self.networkingManager.requestSerializer setValue:@"english" forHTTPHeaderField:@"language"];
//    }
    
    self.networkingManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", @"text/plain", nil];
    
    return YES;
}

- (AFSecurityPolicy*)customSecurityPolicy {
    
    // AFSSLPinningModeCertificate:需要客户端预先保存服务端的证书(自建证书)
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    NSString * cerPath  = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];
    NSData *certData    = [NSData dataWithContentsOfFile:cerPath];
    NSSet   *dataSet    = [NSSet setWithArray:@[certData]];
    // 自建证书的时候，提供相应的证书
    [securityPolicy setPinnedCertificates:dataSet];
    // 是否允许无效证书(自建证书)
    [securityPolicy setAllowInvalidCertificates:YES];
    // 是否需要验证域名
    [securityPolicy setValidatesDomainName:NO];
    
    return securityPolicy;
}

- (NSMutableArray *)responseArray{
    if (!_responseArray) {
        _responseArray = [[NSMutableArray alloc] init];
    }
    return _responseArray;
}

- (NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] init];
    }
    return _dataSourceArray;
}

- (void)buildDataSource:(CompleteBlock)complete{}

@end
