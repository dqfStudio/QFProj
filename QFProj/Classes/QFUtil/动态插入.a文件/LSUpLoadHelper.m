//
//  LSUpLoadHelper.m
//  RenCheRen
//
//  Created by 王隆帅 on 15/8/19.
//  Copyright (c) 2015年 王隆帅. All rights reserved.
//

#import "LSUpLoadHelper.h"

#define MJFileBoundary @"Boundary+B81926F7C8FD324C"
#define MJNewLine @"\r\n"
#define MJEncode(str) [str dataUsingEncoding:NSUTF8StringEncoding]

@implementation LSUpLoadHelper

- (NSString *)MIMEType:(NSURL *)url {
    
    // 1.创建一个请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2.发送请求（返回响应）
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    // 3.获得MIMEType
    return response.MIMEType;
}

- (void)upload:(NSString *)filename mimeType:(NSString *)mimeType fileData:(NSData *)fileData params:(NSDictionary *)params {
    
    // 1.请求路径
    NSString *REQUEST_URL = @"http://111.231.33.42/2.php";
    NSURL *url = [NSURL URLWithString:REQUEST_URL];
    
    // 2.创建一个POST请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 3.设置请求体
    NSMutableData *body = [NSMutableData data];
    
    // 3.1.文件参数
    [body appendData:MJEncode(@"--")];
    [body appendData:MJEncode(MJFileBoundary)];
    [body appendData:MJEncode(MJNewLine)];
    
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"", filename];
    [body appendData:MJEncode(disposition)];
    [body appendData:MJEncode(MJNewLine)];
    
    NSString *type = [NSString stringWithFormat:@"Content-Type: %@", mimeType];
    [body appendData:MJEncode(type)];
    [body appendData:MJEncode(MJNewLine)];
    
    [body appendData:MJEncode(MJNewLine)];
    [body appendData:fileData];
    [body appendData:MJEncode(MJNewLine)];
    
    // 3.2.非文件参数
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [body appendData:MJEncode(@"--")];
        [body appendData:MJEncode(MJFileBoundary)];
        [body appendData:MJEncode(MJNewLine)];
        
        NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"", key];
        [body appendData:MJEncode(disposition)];
        [body appendData:MJEncode(MJNewLine)];
        
        [body appendData:MJEncode(MJNewLine)];
        [body appendData:MJEncode([obj description])];
        [body appendData:MJEncode(MJNewLine)];
    }];
    
    // 3.3.结束标记
    [body appendData:MJEncode(@"--")];
    [body appendData:MJEncode(MJFileBoundary)];
    [body appendData:MJEncode(@"--")];
    [body appendData:MJEncode(MJNewLine)];
    
    request.HTTPBody = body;
    
    // 4.设置请求头(告诉服务器这次传给你的是文件数据，告诉服务器现在发送的是一个文件上传请求)
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", MJFileBoundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // 5.发送请求
    
    // 实例方法 设置代理 并获取 进度
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
    
    
    // 类方法 上传文件 但是 没有代理 不能记录进度
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves er ror:nil];
//        NSLog(@"%@", dict);
//
//    }];
    
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ls_upLoad:progress:)]) {
        
        [self.delegate ls_upLoad:self progress:1 - (CGFloat)bytesWritten/(CGFloat)totalBytesWritten];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ls_upLoad:failedWithError:)]) {
        
        [self.delegate ls_upLoad:self failedWithError:error];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {

    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ls_upLoad:finishedWithDict:)]) {
        
        [self.delegate ls_upLoad:self finishedWithDict:dict];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

    NSLog(@"上传完成后续处理");
}

#pragma mark - 请求示例
- (void)upload {
    
    // 非文件的其他详细参数
    NSDictionary *params = @{
                             @"" : @"",
                             @"" : @"",
                             };
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"filename" withExtension:@"txt"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSString *MIMEType = [self MIMEType:url];
    [self upload:@"filename.txt" mimeType:MIMEType fileData:data params:params];
}

@end
