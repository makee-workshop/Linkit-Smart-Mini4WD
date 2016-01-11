//
//  API.h
//  mini4wdUsingGPchip
//
//  Created by ArcherHuang on 2015/5/26.
//  Copyright (c) 2015年 Makee.io All rights reserved.
//

#import <Foundation/Foundation.h>

@interface API : NSObject

+ (instancetype)sharedInstance;

-(void)getVideo:(NSString *)getUrl completion:(void (^)(id response))completion error:(void (^)(NSError *error))error;
-(void)setEngine:(NSString *)url completion:(void (^)(id response))completion error:(void (^)(NSError *error))error;

@end
