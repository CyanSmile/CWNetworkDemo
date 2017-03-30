//
//  CWHTTPSessionManager.h
//  NetworkDemo
//
//  Created by wangcyan on 16/12/22.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface CWHTTPSessionManager : AFHTTPSessionManager

+ (instancetype)defaultManager;

@end
