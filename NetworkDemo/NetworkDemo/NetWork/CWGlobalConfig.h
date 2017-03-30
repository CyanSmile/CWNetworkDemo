//
//  CWGlobalConfig.h
//  NetworkDemo
//
//  Created by wangcyan on 16/12/22.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWGlobalConfig : NSObject

@property (nonatomic,strong) NSString *token; //用户登录后的token
@property (nonatomic,readonly) NSString *deviceId;    //当前设备的id
@property (nonatomic,readonly) NSString *deviceModel;//当前设备取值
@property (nonatomic,readonly) NSString *version;   //当前app版本
@property (nonatomic,strong) NSString *uid;//当前用户uid

+ (instancetype)shareInstance;

/** 检查新版本更新*/
+ (void)checkAppToUpdate;
/**  获取时间戳*/
+ (NSString *)getUnixTimestamp;

@end
