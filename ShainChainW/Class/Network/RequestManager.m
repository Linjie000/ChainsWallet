//
//  RequestManager.m
//  TronWallet
//
//  Created by 闪链 on 2019/2/13.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "RequestManager.h"
#import "AFNetworking.h"


@implementation RequestManager

+ (void)get:(NSString *)url parameters:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError * _Nonnull))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", @"text/plain", nil];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    AFSecurityPolicy *security = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [security setValidatesDomainName:NO];
    security.allowInvalidCertificates = YES;
    manager.securityPolicy = security;
    SCLog(@"get  :%@",url);
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        SCLog(@"responseObject  :%@",responseObject);
        if (success&&responseObject) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
//            [TKCommonTools showToast:@"请检查您的网络设置"];
            SCLog(@"=========================== \n\n   请检查您的网络设置 \n\n   error:%@\n\n =================================",error);
            failure(error);
        }
    }];
 
}

+ (void)post:(NSString *)url parameters:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError * _Nonnull))failure
{
//    SCLog(@"POST ----> %@",url);
//    SCLog(@"参数----> %@",params);
    //1.创建会话对象
    NSURLSession*session = [NSURLSession sharedSession];
    //2.根据会话对象创建
    NSURL*url2 = [NSURL URLWithString:url];
    //3.创建可变的请求对象
    NSMutableURLRequest*request = [NSMutableURLRequest requestWithURL:url2];
    //4.修改请求方法为
    request.HTTPMethod =@"POST";
    //5.设置请求体//告诉服务器数据为json类型
    [request setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"text/html; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    //设置请求体(json类型)
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSUTF8StringEncoding error:nil];
    request.HTTPBody= jsonData;
    //6.根据会话对象创建一个Task(发送请求）
    NSURLSessionDataTask*dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData* _Nullable data,NSURLResponse* _Nullable response,NSError* _Nullable error) {
        if (error || !data) {
            failure(error);
            return ;
        }
        else{
            //8.解析数据
            NSDictionary*dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            success(dict);
//            NSLog(@"-------- %@",dict);
        }
    }];
    //7.执行任务
    [dataTask resume];
}

+ (void)postData:(NSString *)url parameters:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError * _Nonnull))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", @"text/plain", nil];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    AFSecurityPolicy *security = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [security setValidatesDomainName:NO];
    security.allowInvalidCertificates = YES;
    manager.securityPolicy = security;
    //    SCLog(@"get  :%@",url);
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        SCLog(@"responseObject  :%@",responseObject);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            //            [RewardHelper showTextWithHUD:@"请检查您的网络"];
            failure(error);
        }
    }];
    
}

+ (void)Post:(NSString *)url parameters:(TronTransaction *)tronTransaction success:(void (^)(id responseObject))success failure:(void (^)(NSError * _Nonnull))failure
{
 
    NSURL *url2 = [NSURL URLWithString:url];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url2 cachePolicy:1 timeoutInterval:2.0f];
    request.HTTPMethod=@"POST";//设置请求方法是POST
    request.timeoutInterval=15.0;//设置请求超时
    //    NSData *imageData = UIImagePNGRepresentation(self.photoImage);
    
    
    NSData *imageData = tronTransaction.signature;
    tronTransaction.signature = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    tronTransaction.signature = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[tronTransaction keyValues] options:NSUTF8StringEncoding error:nil];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    [myRequestData appendData:jsonData];
    //将image的data加入
    [myRequestData appendData:imageData];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"application/json"];
    
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    
    //设置http body
    [request setHTTPBody:myRequestData];
    
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        id result=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"post==%@",result);
        
        
        NSString *tips = result[@"tips"];
        if ([tips isEqualToString:@"上传成功"]) {
            
            
        }
        
    }];
    //7.执行任务
    [dataTask resume];
    
}



+ (void)uploadHeadUrlString:(NSString *)url parameters:(TronTransaction *)tronTransaction back:(void(^)(NSDictionary * dic))block
{
    NSString *headUrl = url;
    NSData *signatureData = tronTransaction.signature;
    tronTransaction.signature = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    tronTransaction.signature = nil;
 
    NSDictionary *params = [tronTransaction keyValues];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",nil];
        [manager POST:headUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:signatureData
                                        name:@"signature"
                                    fileName:@"signature"
                                    mimeType:@"signature"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            //            NSLog(@"%@",uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            block(responseObject);
            if (responseObject && [responseObject[@"status"] isEqualToString:@"1"]) {
                
            }else {
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    });
    
}


@end
