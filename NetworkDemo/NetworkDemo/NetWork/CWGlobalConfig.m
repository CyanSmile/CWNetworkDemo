//
//  CWGlobalConfig.m
//  NetworkDemo
//
//  Created by wangcyan on 16/12/22.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "CWGlobalConfig.h"
#import <AFNetworking/AFNetworking.h>
#import "CWHTTPSessionManager.h"
#import "netconfig.h"

#define Token @"Token"
#define DeviceId @"DeviceId"
#define App_Version @"Version"
#define Device_Model @"DeviceModel"
#define Current_Uid @"Uid"


@implementation CWGlobalConfig
@dynamic token;
@dynamic version;
@dynamic deviceModel;
@dynamic deviceId;
@dynamic uid;

static CWGlobalConfig *_shareInstance;

- (void)setToken:(NSString *)token {
    [[CWHTTPSessionManager defaultManager].requestSerializer setValue:token forHTTPHeaderField:Token];
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:Token];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)token {
    return [[CWHTTPSessionManager defaultManager].requestSerializer valueForKey:Token];
}

- (void)setDeviceId:(NSString *)deviceId {
    [[CWHTTPSessionManager defaultManager].requestSerializer setValue:deviceId forHTTPHeaderField:DeviceId];
    [[NSUserDefaults standardUserDefaults] setObject:deviceId forKey:DeviceId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)deviceId {
    return [[CWHTTPSessionManager defaultManager].requestSerializer valueForKey:DeviceId];
}

- (void)setUid:(NSString *)uid {
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:Current_Uid];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)uid {
    return [[NSUserDefaults standardUserDefaults] objectForKey:Current_Uid];
}

- (NSString *)version {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:(NSString *)kCFBundleVersionKey];
    return app_Version;
}

- (NSString *)deviceModel {
    return @"5";
}

+ (instancetype)shareInstance {
    return _shareInstance;
}

+ (void)load {
    _shareInstance = [[self alloc] init];
    //初始化一些参数
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:Token];
    NSString *deviceId = [[UIDevice currentDevice].identifierForVendor UUIDString];
    if (token != nil) {
        [[CWHTTPSessionManager defaultManager].requestSerializer setValue:token forHTTPHeaderField:Token];
    }
    
    if (deviceId != nil) {
        [[CWHTTPSessionManager defaultManager].requestSerializer setValue:deviceId forHTTPHeaderField:DeviceId];
    }
    
    [[CWHTTPSessionManager defaultManager].requestSerializer setValue:_shareInstance.version forHTTPHeaderField:App_Version];
    [[CWHTTPSessionManager defaultManager].requestSerializer setValue:_shareInstance.deviceModel forHTTPHeaderField:Device_Model];
}

+ (void)getAppstoreVersion{
    
    NSString *URL = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",APP_ID];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data && !error) {
            NSLog(@"访问AppStore成功");
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            NSArray *infoArray = [dic objectForKey:@"results"];
            if ([infoArray count]) {
                NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
                NSString *lastVersion = [releaseInfo objectForKey:@"version"];
                if ([lastVersion floatValue] > [_shareInstance.version floatValue]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // show alertView
                        // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@""]];
                    });
                }
            }
        }else{
            NSLog(@"访问失败");
        }
        
    }] resume];
    
}

+ (NSString *)getUnixTimestamp {
    NSDate *date = [NSDate date];
    
    //设置转换后的目标日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:-sourceGMTOffset sinceDate:date] ;
    return [NSString stringWithFormat:@"%ld",(long)[destinationDateNow timeIntervalSince1970]];
}

+ (void)checkAppToUpdate {
    [CWGlobalConfig getAppstoreVersion];
}

@end
