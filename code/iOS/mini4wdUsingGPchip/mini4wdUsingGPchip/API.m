//
//  API.m
//  mini4wdUsingGPchip
//
//  Created by ArcherHuang on 2015/5/26.
//  Copyright (c) 2015年 Makee.io All rights reserved.
//

#import "API.h"
#import "AFNetworking.h"

@implementation API

+ (instancetype)sharedInstance{
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^
                  {
                      sharedInstance = [self new];
                  });
    
    return sharedInstance;
}

-(void)getVideo:(NSString *)url completion:(void (^)(id response))completion error:(void (^)(NSError *error))error
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             completion(@"Success");
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *err) {
             
             NSLog(@"getDataErr %@",err);
             error(err);
             
         }];
    
}

-(void)setEngine:(NSString *)url completion:(void (^)(id response))completion error:(void (^)(NSError *error))error
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             completion(@"Success");
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *err) {
             
             NSLog(@"getDataErr %@",err);
             error(err);
             
         }];
    
}

@end
