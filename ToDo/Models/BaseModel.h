//
//  BaseModel.h
//  ToDo
//
//  Created by Remi Sloot on 04/04/14.
//  Copyright (c) 2014 Avans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

-(void)setValues:(NSDictionary *)values;
-(NSObject *)checkValue:(NSDictionary *)values
              valueName:(NSString *)valueName;

@end
