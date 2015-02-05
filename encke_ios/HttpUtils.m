//
//  HttpUitls.m
//  encke_ios
//
//  Created by Michael on 14/12/12.
//  Copyright (c) 2014年 MichealXie. All rights reserved.
//

#import "HttpUtils.h"
@implementation HttpUtils

+(NSData *) syncHttpGet: (NSString *) strUrl
{
    NSURL *url = [NSURL URLWithString:strUrl];
    //第二步，通过URL创建网络请求
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //NSURLRequest初始化方法第一个参数：请求访问路径，第二个参数：缓存协议，第三个参数：网络请求超时时间（秒）
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return received;
}

-(void) asyncHttpGet: (NSString *) strUrl
{
    NSURL *url = [NSURL URLWithString:strUrl];
    
    //第二步，创建请求
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:100];
    
    //第三步，连接服务器
   [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

//接收到服务器回应的时候调用此方法

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    NSLog(@"%@",[res allHeaderFields]);
    self.receiveData = [NSMutableData data];
}

//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receiveData appendData:data];
}

//数据传完之后调用此方法

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *receiveStr = [[NSString alloc]initWithData:self.receiveData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",receiveStr);
}

@end


