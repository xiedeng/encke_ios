//
//  LoginInfo.h
//  encke_ios
//
//  Created by Michael on 14/12/15.
//  Copyright (c) 2014年 MichealXie. All rights reserved.
//

#ifndef encke_ios_LoginInfo_h
#define encke_ios_LoginInfo_h

#import <Foundation/Foundation.h>
#import "User.h"

@interface LoginInfo : NSObject

@property (nonatomic) NSString *message;
@property (nonatomic) NSString *link;
@property (nonatomic) BOOL success;
@property (nonatomic) User *data;

@end

#endif
