//
//  APIController.m
//  ToDo
//
//  Created by Remi Sloot on 12/03/14.
//  Copyright (c) 2014 Avans. All rights reserved.
//

#import "APIController.h"
#import "MainUtils.h"

@interface APIController()


@end

@implementation APIController

//static NSString *host;
+(NSString *)host {
    return @"http://sloot.homeip.net/todo/api";
}


extern NSString * const REQUEST_METHOD_toString[];
NSString * const REQUEST_METHOD_toString[] = {
    [GET] = @"GET",
    [POST] = @"POST",
    [PUT] = @"PUT",
    [DELETE] = @"DELETE"
};

+(void)request:(REQUEST_METHOD)method
          controller:(NSString *)controller
              action:(NSString *) action
         queryString:(NSMutableDictionary *) queryString
                args:(NSMutableDictionary *)args
            callback:(APICallback)callback
{
    NSString *urlString = [self createAPIURLFromControllerAction:method controller:controller action:action];
    if(queryString) {
        urlString = [urlString stringByAppendingString:[MainUtils dictionaryToQueryString:queryString]];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    request.HTTPMethod = REQUEST_METHOD_toString[method];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"utf-8" forHTTPHeaderField:@"Charset"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    
    if(method != GET) {
        if(args) {
            request.HTTPBody = [MainUtils dictionaryToJSONData:args];
        }
    }
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        // Code for the response
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        int statusCode = [httpResponse statusCode];
        
        if(connectionError) {
            NSLog(@"Error, %@", [connectionError localizedDescription]);
        } else {
            //NSLog(@"Response, %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            if(callback)
                callback(data, statusCode);
        }
        
    }];
}

+(NSString *)createAPIURLFromControllerAction:(REQUEST_METHOD) method controller:(NSString *) controller action:(NSString *) action
{
    controller = [NSString stringWithFormat:@"/%@/", controller];
    action = (action) ? action : [REQUEST_METHOD_toString[method] lowercaseString];
    NSString *url = [[APIController.host stringByAppendingString:controller] stringByAppendingString:action];
    
    return url;
}

@end
