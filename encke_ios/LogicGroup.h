//
//  LogicGroup.h
//  encke_ios
//
//  Created by Michael on 14/12/15.
//  Copyright (c) 2014年 MichealXie. All rights reserved.
//

#ifndef encke_ios_LogicGroup_h
#define encke_ios_LogicGroup_h

#import <Foundation/Foundation.h>

@interface LogicGroup : NSObject

@property (nonatomic) int logicGroupId;
@property (nonatomic) NSString *siteId;
@property (nonatomic) NSString *logicGroupName;
@property (nonatomic) int logicGroupType;
@property (nonatomic) NSArray *logicGroups;

@end

#endif
