//
//  APIController.h
//  ToDo
//
//  Created by Remi Sloot on 12/03/14.
//  Copyright (c) 2014 Avans. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum REQUEST_METHOD{GET, POST, PUT, DELETE} REQUEST_METHOD;
typedef void(^APICallback)(NSData *, int);

@interface APIController : NSObject

+(void)request:(REQUEST_METHOD)method
    controller:(NSString *)controller
        action:(NSString *) action
   queryString:(NSMutableDictionary *) queryString
          args:(NSMutableDictionary *)args
      callback:() callback;

@end
