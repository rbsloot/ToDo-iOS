//
//  UserController.m
//  ToDo
//
//  Created by Remi Sloot on 04/04/14.
//  Copyright (c) 2014 Avans. All rights reserved.
//

#import "UserController.h"
#import "APIController.h"
#import "DialogHandler.h"

@implementation UserController

+(void)logout:(callbackLogout)onComplete {
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    
    NSMutableDictionary *qs = [[NSMutableDictionary alloc]init];
    [qs setObject:token forKey:@"token"];
    
    [APIController request:GET controller:@"user" action:@"logout" queryString:qs args:nil callback:^(NSData *data, int statusCode) {
        
        if(statusCode >= 200 && statusCode < 300) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            onComplete();
        }
    }];
}

+(void)login:(NSString *)name password:(NSString *)password onComplete:(callbackLogin)onComplete {
    NSMutableDictionary *qs = [[NSMutableDictionary alloc] init];
    [qs setObject:name forKey:@"name"];
    [qs setObject:password forKey:@"password"];
    
    [APIController request:GET controller:@"user" action:@"login" queryString:qs args:nil callback:^(NSData *data, int statusCode) {
        if(statusCode >= 200 && statusCode < 300) {
            NSError *error = nil;
            NSDictionary *tokenDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSString *token = [tokenDic objectForKey:@"token"];
            //        NSString *token = @"c4ca4238a0b923820dcc509a6f75849b";
            
            onComplete(token);
            
        } else if(statusCode == 404) {
            // Wrong username or password
            
            [[DialogHandler showErrorDialog:@"Error" message:@"Wrong username or password"] show];
        }
    }];
}



@end
