//
//  UserController.h
//  ToDo
//
//  Created by Remi Sloot on 04/04/14.
//  Copyright (c) 2014 Avans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserController : NSObject

typedef void(^callbackLogout)();
typedef void(^callbackLogin)(NSString *);

+(void)logout:(callbackLogout)onComplete;
+(void)login:(NSString *) name
    password:(NSString *) password
  onComplete:(callbackLogin) onComplete;

@end
