//
//  CWNetworking.m
//  NetworkDemo
//
//  Created by wangcyan on 16/12/22.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "CWNetworking.h"
#import <AFNetworking/AFNetworking.h>
#import "CWHTTPSessionManager.h"

@implementation CWNetworkError

- (NSString *)toString {
    NSMutableString *string = [NSMutableString string];
    [self.errorMsg enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [string appendString:obj];
        [string appendString:@"\n"];
    }];
    return string;
}
@end

@interface CWNetworking ()
{
    __strong id _self;
    NSURLSessionDataTask *_sessionDataTask;
}

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation CWNetworking

- (void)request:(NSString *)path withMethod:(CWHTTPRequestMethod)methodName withParams:(id)params {
    
    switch (methodName) {
        case POST: {
           _sessionDataTask = [self POST:path withParams:params];
        }
            break;
        case GET: {
            _sessionDataTask = [self GET:path withParams:params];
        }
            break;
        case PUT: {
            _sessionDataTask = [self PUT:path withParams:params];
        }
            break;
        case DELETE: {
            _sessionDataTask = [self DELETE:path withParams:params];
        }
            break;
        case HEAD: {
            _sessionDataTask = [self HEAD:path withParams:params];
        }
            break;
        case PATCH: {
            _sessionDataTask = [self PATCH:path withParams:params];
        }
            break;
        default:
            _sessionDataTask = nil;
            break;
    }
}

#define SAFE_EXEC_BLOCK(x,params...) \
if (x != nil) \
{ \
x(params); \
x = nil; \
}

#define CLEAN_TEMP_DATA \
_self = nil;

- (void)request:(NSString *)path withFileType:(CWUploadFileType)fileType withParams:(id)params {
    CWHTTPSessionManager *manager = [CWHTTPSessionManager defaultManager];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [manager POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [weakSelf appendPartWithFile:self.files withType:fileType withFormData:formData];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        SAFE_EXEC_BLOCK(_progressBlock, uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf successRequestWithTask:task withResponseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf failureRequestWithTask:task withError:error];
    }];
    _sessionDataTask = task;
}

- (NSURLSessionDataTask *)POST:(NSString *)path withParams:(id)params {
    CWHTTPSessionManager *manager = [CWHTTPSessionManager defaultManager];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [manager POST:path parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        SAFE_EXEC_BLOCK(_progressBlock, uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf successRequestWithTask:task withResponseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf failureRequestWithTask:task withError:error];
    }];
    return task;
}

- (NSURLSessionDataTask *)GET:(NSString *)path withParams:(id)params {
    CWHTTPSessionManager *manager = [CWHTTPSessionManager defaultManager];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [manager GET:path parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        SAFE_EXEC_BLOCK(_progressBlock, downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf successRequestWithTask:task withResponseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf failureRequestWithTask:task withError:error];
    }];
    return task;
}

- (NSURLSessionDataTask *)PUT:(NSString *)path withParams:(id)params {
    CWHTTPSessionManager *manager = [CWHTTPSessionManager defaultManager];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [manager PUT:path parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf successRequestWithTask:task withResponseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf failureRequestWithTask:task withError:error];
    }];
    return task;
}

- (NSURLSessionDataTask *)DELETE:(NSString *)path withParams:(id)params {
    CWHTTPSessionManager *manager = [CWHTTPSessionManager defaultManager];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [manager DELETE:path parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf successRequestWithTask:task withResponseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf failureRequestWithTask:task withError:error];
    }];
    return task;
}

- (NSURLSessionDataTask *)HEAD:(NSString *)path withParams:(id)params {
    CWHTTPSessionManager *manager = [CWHTTPSessionManager defaultManager];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [manager HEAD:path parameters:params success:^(NSURLSessionDataTask * _Nonnull task) {
        [weakSelf successRequestWithTask:task withResponseObject:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf failureRequestWithTask:task withError:error];
    }];
    return task;
}

- (NSURLSessionDataTask *)PATCH:(NSString *)path withParams:(id)params {
    CWHTTPSessionManager *manager = [CWHTTPSessionManager defaultManager];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [manager PATCH:path parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf successRequestWithTask:task withResponseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf failureRequestWithTask:task withError:error];
    }];
    return task;
}

- (void)failureRequestWithTask:(NSURLSessionDataTask *)task withError:(NSError *)error {
    CWNetworkError *networkError = [[CWNetworkError alloc] init];
    networkError.code = CWErrorCodeLink;
    networkError.subcode = error.code;
    networkError.errorMsg = @[error.domain];
    [self _RequestFailed:networkError];
}

- (void)successRequestWithTask:(NSURLSessionDataTask *)task withResponseObject:(id)responseObject {
    
    if ([responseObject[@"StatusCode"] integerValue] == CWErrorCodeSuccess) {
        responseObject = [self _converToModel:responseObject];
        [self _RequestSuccess:responseObject];
    } else if ([responseObject[@"StatusCode"] integerValue] == CWErrorCodeFailed) {
        CWNetworkError *networkError = [[CWNetworkError alloc] init];
        networkError.code = CWErrorCodeFailed;
        networkError.errorMsg = responseObject[@"ErrorList"];
        [self _RequestFailed:networkError];
    } else {
        //其他状态码逻辑的处理
    }
}

- (void)appendPartWithFile:(NSDictionary *)file withType:(CWUploadFileType)fileType withFormData:(id)formData {
    if ((file != nil)&&(file.count != 0)) {
        NSArray *allkey = [file allKeys];
        for (NSString *key in allkey) {
            switch (fileType) {
                case CWUploadFileTypeImage:
                    [formData appendPartWithFileData:file[key] name:key fileName:@"file.jpeg" mimeType:@"image/jpeg"];
                    break;
                case CWUploadFileTypeVideo:
                    [formData appendPartWithFileData:file[key] name:key fileName:@"audio.amr" mimeType:@"audio/AMR"];
                    break;
                case CWUploadFileTypeAudio:
                    [formData appendPartWithFileData:file[key] name:key fileName:@"video.mov" mimeType:@"video/quicktime"];
                    break;
                default:
                    break;
            }
        }
    }
}

#pragma mark -- 请求结果处理
- (void)_RequestSuccess:(id)data {
    SAFE_EXEC_BLOCK(_successBlock, data);
    SAFE_EXEC_BLOCK(_finallyBlock);
    CLEAN_TEMP_DATA
}

- (id)_converToModel:(id)data {
    if (_converBlock != nil) {
        data = _converBlock(data[@"Data"]);
    }else{
        data = data[@"Data"];
    }
    return data;
}

- (void)_RequestFailed:(CWNetworkError *)error {
    SAFE_EXEC_BLOCK(_failedBlock, error);
    SAFE_EXEC_BLOCK(_finallyBlock);
    CLEAN_TEMP_DATA
}

- (void)cancelCurrentTask {
    [_sessionDataTask cancel];
}

- (void)cancelAllTask {
    CWHTTPSessionManager *manager = [CWHTTPSessionManager defaultManager];
    for (NSURLSessionDataTask *task in [manager tasks]) {
        [task cancel];
    }
}

@end
