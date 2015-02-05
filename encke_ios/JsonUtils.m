//
//  JsonUtils.m
//  encke_ios
//
//  Created by Michael on 14/12/15.
//  Copyright (c) 2014年 MichealXie. All rights reserved.
//

#import "JsonUtils.h"
#import "objc/runtime.h"

@implementation JsonUtils

+ (id) objectWithDict:(NSDictionary*)dict withClassName:(NSString*)className{
    Class objClass = NSClassFromString(className);
    JsonUtils* object = nil;
    if(objClass){
        object = [[objClass alloc] initWithDict:dict];
    }else{
        NSAssert(0, @"Unknown class:%@",className);
    }
    
    return object;
}

+ (NSArray*) objectsWithArray:(NSArray*)array withClassName:(NSString*)className{
    
    Class objClass = NSClassFromString(className);
    JsonUtils* object = nil;
    NSMutableArray* objArray = nil;
    
    if(objClass){
        objArray = [NSMutableArray new];
        for (NSDictionary* dict in array){
            object = [[objClass alloc] initWithDict:dict];
            [objArray addObject:object];
        }
    }else{
        NSAssert(0, @"Unknown class:%@",className);
    }
    
    
    return objArray;
}

+ (NSArray*) getPropertyNameList:(id) object
{
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
    
    NSMutableArray * propertyNames = [NSMutableArray array];
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        const char * attr = property_getAttributes(property);
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
    }
    
    return propertyNames;
}

- (NSString*) description{
    
    NSMutableString* desc = [NSMutableString new];
    NSArray* propertyArray = [JsonUtils getPropertyNameList:self];
    [desc appendString:@"{\r"];
    
    
    for (NSString* key in propertyArray) {
        [desc appendFormat:@"  %@ : %@\r",key,[self valueForKey:key]];
    }
    
    
    [desc appendString:@"\r}"];
    
    return desc ;
}


- (id) initWithDict:(NSDictionary*)dict{
    NSArray* propertyArray = [JsonUtils getPropertyNameList:self];
    for (NSString* key in propertyArray) {
        @try{
            if([dict[key] isKindOfClass:[NSArray class]]){
                NSString* className = [self propertyClassName:key];
                NSArray* array = [JsonUtils objectsWithArray:dict[key] withClassName:className?className:key];
                [self setValue:array forKey:key];
            }else if([dict[key] isKindOfClass:[NSDictionary class]]){
                [self setValue:[JsonUtils objectWithDict:dict[key] withClassName:key]forKey:key];
            }else{
                [self setValue:dict[key] forKey:key];
            }
        }@catch (NSException *exception) {
            NSLog(@"except:%@:%@",key,dict[key]);
        }
    }
    
    return self;
}
- (NSString*) propertyClassName:(NSString*)propertyName{
    return nil;
}

@end
