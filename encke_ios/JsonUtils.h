//
//  JsonUtils.h
//  encke_ios
//
//  Created by Michael on 14/12/15.
//  Copyright (c) 2014年 MichealXie. All rights reserved.
//

#ifndef encke_ios_JsonUtils_h
#define encke_ios_JsonUtils_h

#import <Foundation/Foundation.h>

@interface JsonUtils : NSObject

+ (id) objectWithDict:(NSDictionary*)dict withClassName:(NSString*)className;
+ (NSArray*) objectsWithArray:(NSArray*)array withClassName:(NSString*)className;

- (id) initWithDict:(NSDictionary*)dict;
- (NSString*) propertyClassName:(NSString*)propertyName;
+ (NSArray*) getPropertyNameList:(id)object;

@end


#endif
