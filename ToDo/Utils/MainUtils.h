//
//  MainUtils.h
//  ToDo
//
//  Created by Remi Sloot on 21/03/14.
//  Copyright (c) 2014 Avans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainUtils : NSObject

+(NSData *)dictionaryToJSONData:(NSMutableDictionary *)data;
+(NSString *)dictionaryToQueryString:(NSMutableDictionary *)data;

@end
