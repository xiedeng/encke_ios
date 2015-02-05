//
//  User.h
//  encke_ios
//
//  Created by Michael on 14/12/15.
//  Copyright (c) 2014年 MichealXie. All rights reserved.
//

#ifndef encke_ios_User_h
#define encke_ios_User_h

#import <Foundation/Foundation.h>
#import "LogicGroup.h"

@interface User : NSObject

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *token;
@property (nonatomic) int userId;
@property (nonatomic) NSArray *logicGroups;

@end


#endif
