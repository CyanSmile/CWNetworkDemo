//
//  CWNetworking.h
//  NetworkDemo
//
//  Created by wangcyan on 16/12/22.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <Foundation/Foundation.h>

//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wnullability-completeness"

typedef NS_ENUM(NSInteger, CWErrorCode) {
    CWErrorCodeLink = 0,
    CWErrorCodeSuccess = 200,
    CWErrorCodeFailed = 500
};

@interface CWNetworkError : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic,assign) NSInteger subcode;
@property (nonatomic,strong) NSArray <NSString *> *errorMsg;

- (NSString *)toString;

@end

typedef NS_ENUM(NSInteger, CWHTTPRequestMethod){
    
    POST = 0,
    GET,
    PUT,
    DELETE,
    HEAD,
    PATCH
};

typedef NS_ENUM(NSInteger,CWUploadFileType){
    CWUploadFileTypeImage = 0,
    CWUploadFileTypeVideo,
    CWUploadFileTypeAudio
};

typedef void(^CWLoadingShow)(BOOL isShow);
typedef void(^CWRequestSuccess)(id model);
typedef void(^CWConverToModel)(NSDictionary *data);
typedef void(^CWRequestFailed)(CWNetworkError *error);
typedef void(^CWRequestProgress)(NSProgress *progress);

@interface CWNetworking<__covariant ObjectType> : NSObject

@property (nonatomic, copy) CWLoadingShow loadingShow;
@property (nonatomic, copy) id (^converBlock)(id data);
@property (nonatomic, copy) void(^successBlock)(ObjectType model);;
@property (nonatomic, copy) CWRequestFailed failedBlock;
@property (nonatomic, copy) CWRequestProgress progressBlock;
@property (nonatomic,strong) NSDictionary *files;

@property (nonatomic, copy) dispatch_block_t finallyBlock;

- (void)request:(NSString *)path
     withMethod:(CWHTTPRequestMethod)methodName
     withParams:(id)params;

//上传图片、音乐、视频等
- (void)request:(NSString *)path
   withFileType:(CWUploadFileType)fileType
     withParams:(id)params;

//取消当前任务
- (void)cancelCurrentTask;

// 取消所有请求任务
- (void)cancelAllTask;

@end
//#pragma clang diagnostic pop
