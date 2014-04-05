//
//  DialogHandler.h
//  ToDo
//
//  Created by Remi Sloot on 04/04/14.
//  Copyright (c) 2014 Avans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DialogHandler : NSObject

+(UIAlertView *)showErrorDialog:(NSString *)title
                        message:(NSString *)message;

@end
