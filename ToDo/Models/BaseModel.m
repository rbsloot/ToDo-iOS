//
//  BaseModel.m
//  ToDo
//
//  Created by Remi Sloot on 04/04/14.
//  Copyright (c) 2014 Avans. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

-(void)setValues:(NSDictionary *)values {
}

-(NSObject *)checkValue:(NSDictionary *)values valueName:(NSString *)valueName {
    return ([values objectForKey:valueName]) ? [values objectForKey:valueName] : nil;
}

@end
