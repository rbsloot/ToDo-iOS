//
//  List.m
//  ToDo
//
//  Created by Remi Sloot on 04/04/14.
//  Copyright (c) 2014 Avans. All rights reserved.
//

#import "List.h"

@implementation List

-(void)setValues:(NSDictionary *)values {
    self.id = [values objectForKey:@"id"];
    self.name = [values objectForKey:@"name"];
    self.board_id = [values objectForKey:@"board_id"];
}

@end
