//
//  HttpUtils.h
//  encke_ios
//
//  Created by Michael on 14/12/12.
//  Copyright (c) 2014年 MichealXie. All rights reserved.
//

#ifndef encke_ios_HttpUtils_h
#define encke_ios_HttpUtils_h

#import <Foundation/Foundation.h>



@interface HttpUtils : NSObject

@property (nonatomic) NSMutableData *receiveData;

+(NSData *) syncHttpGet: (NSString *) strUrl;

- (void) asyncHttpGet: (NSString *) strUrl;

//接收到服务器回应的时候调用此方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;

//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

//数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
#endif
