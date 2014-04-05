//
//  Board.h
//  ToDo
//
//  Created by Remi Sloot on 31/03/14.
//  Copyright (c) 2014 Avans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface Board : BaseModel

@property (nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *name;

@end
