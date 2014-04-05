//
//  Board.m
//  ToDo
//
//  Created by Remi Sloot on 31/03/14.
//  Copyright (c) 2014 Avans. All rights reserved.
//

#import "Board.h"

@implementation Board

-(void)setValues:(NSDictionary *)values {
    self.id = [values objectForKey:@"id"];
    self.name = [values objectForKey:@"name"];
}

@end
