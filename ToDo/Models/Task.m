//
//  Task.m
//  ToDo
//
//  Created by Remi Sloot on 04/04/14.
//  Copyright (c) 2014 Avans. All rights reserved.
//

#import "Task.h"

@implementation Task

-(void)setValues:(NSDictionary *)values {
    self.id = [values objectForKey:@"id"];
    self.name = [values objectForKey:@"name"];
    self.description = (NSString *)[self checkValue:values valueName:@"description"];
    self.status = (NSString *)[self checkValue:values valueName:@"status"];
    self.end_date = (NSString *)[self checkValue:values valueName:@"end_date"];
    self.list_id = [values objectForKey:@"list_id"];
}

@end
