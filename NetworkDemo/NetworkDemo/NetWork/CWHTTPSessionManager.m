//
//  CWHTTPSessionManager.m
//  NetworkDemo
//
//  Created by wangcyan on 16/12/22.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "CWHTTPSessionManager.h"
#import "netconfig.h"

@implementation CWHTTPSessionManager

+ (instancetype)defaultManager {
    static CWHTTPSessionManager *_defaultManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultManager = [[CWHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:SERVER_URL]];
        // HTTPS
        _defaultManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        // Serializer
        _defaultManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _defaultManager.responseSerializer = [AFJSONResponseSerializer serializer];
        // TimeoutInterval
        [_defaultManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _defaultManager.requestSerializer.timeoutInterval = 15.0f;
        [_defaultManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        // AcceptContentType
        _defaultManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    });
    return _defaultManager;
}

@end
