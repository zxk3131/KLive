//
//  RequestTool.m
//  KLive
//
//  Created by zxk on 16/06/25.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import "RequestTool.h"
#import "AFHTTPSessionManager.h"
#import "AFURLRequestSerialization.h"
#import "ResultModel.h"


@implementation RequestTool

+ (AFHTTPSessionManager *)afhttpSessionManager{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    
    manager.requestSerializer.HTTPShouldHandleCookies = NO;
    manager.requestSerializer.HTTPShouldUsePipelining = YES;
    [manager.operationQueue cancelAllOperations];
    
    manager.requestSerializer.timeoutInterval = 5;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    return manager;
}

+ (void)getHotWithPage:(NSInteger)page completionDataBlock:(CompletionDataBlock)completionDataBlock
{
    AFHTTPSessionManager * manager = [self afhttpSessionManager];
    
    [manager GET:[NSString stringWithFormat:@"http://live.9158.com/Fans/GetHotLive?page=%ld", page] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [responseObject objectForKey:@"data"];
        ResultModel * result = [ResultModel mj_objectWithKeyValues:responseObject];
        completionDataBlock(result,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionDataBlock(nil,error);
    }];
}

+ (void)getLiveURL:(NSString *)url completionDataBlock:(CompletionDataBlock)completionDataBlock{
    AFHTTPSessionManager * manager = [self afhttpSessionManager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionDataBlock(responseObject,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        completionDataBlock(nil,error);
    }];
}

@end
