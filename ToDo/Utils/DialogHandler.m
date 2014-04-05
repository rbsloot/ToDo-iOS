//
//  DialogHandler.m
//  ToDo
//
//  Created by Remi Sloot on 04/04/14.
//  Copyright (c) 2014 Avans. All rights reserved.
//

#import "DialogHandler.h"

@implementation DialogHandler

+(UIAlertView *)showErrorDialog:(NSString *)title message:(NSString *)message {
    
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:title
                                                         message:message
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
    return errorAlert;
}

@end
