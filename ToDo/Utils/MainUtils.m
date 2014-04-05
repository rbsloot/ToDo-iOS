//
//  MainUtils.m
//  ToDo
//
//  Created by Remi Sloot on 21/03/14.
//  Copyright (c) 2014 Avans. All rights reserved.
//

#import "MainUtils.h"

@implementation MainUtils

+(NSData *)dictionaryToJSONData:(NSMutableDictionary *) data
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:0
                                                         error:&error];
    
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    }
    
    return jsonData;
}

+(NSString *)dictionaryToQueryString:(NSMutableDictionary *) data
{
    NSString *queryString = nil;
    
    for( id key in data) {
        if(!queryString) {
            queryString = @"?";
            
        } else {
            queryString = [queryString stringByAppendingString:@"&"];
        }
        queryString = [[[queryString stringByAppendingString:key] stringByAppendingString:@"="] stringByAppendingString:[data objectForKey:key]];
    }
    
    return queryString;
}


@end
