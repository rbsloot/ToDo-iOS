//
//  Task.h
//  ToDo
//
//  Created by Remi Sloot on 04/04/14.
//  Copyright (c) 2014 Avans. All rights reserved.
//

#import "BaseModel.h"

@interface Task : BaseModel

@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *end_date;
@property (strong, nonatomic) NSNumber *list_id;

@end
