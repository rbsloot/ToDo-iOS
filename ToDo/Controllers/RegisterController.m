//
//  RegisterController.m
//  ToDo
//
//  Created by Remi Sloot on 04/04/14.
//  Copyright (c) 2014 Avans. All rights reserved.
//

#import "RegisterController.h"
#import "APIController.h"
#import "DialogHandler.h"
#import "APIController.h"

@interface RegisterController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repasswordTextField;

@end

@implementation RegisterController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backClick:(id)sender {
    [self goToLogin];
}

- (IBAction)registerClick:(id)sender {
    
    NSString *name = [self.usernameTextField text];
    NSString *password = [self.passwordTextField text];
    NSString *repassword = [self.repasswordTextField text];
    
    BOOL valid = YES;
    
    NSString *message = @"";
    if(!name || [name isEqualToString:@""]) {
        message = [message stringByAppendingString:@"Username cannot be empty\n"];
        valid = NO;
    }
    if(!password || [password isEqualToString:@""]) {
        message = [message stringByAppendingString:@"Password cannot be empty\n"];
        valid = NO;
    }
    
    if(!repassword || [repassword isEqualToString:@""]) {
        message = [message stringByAppendingString:@"Retyped password cannot be empty\n"];
        valid = NO;
    }
    
    if(![password isEqualToString:repassword]) {
        message = [message stringByAppendingString:@"Passwords not matching\n"];
        valid = NO;
    }
    
    if(valid) {
        NSMutableDictionary *args = [[NSMutableDictionary alloc]init];
        [args setObject:name forKey:@"name"];
        [args setObject:password forKey:@"password"];
        
        [APIController request:POST controller:@"user" action:@"register" queryString:nil args:args callback:^(NSData *data, int statusCode) {
            
            if(statusCode >= 200 && statusCode < 300) {
                [self goToLogin];
            } else if(statusCode == 409) {
                [[DialogHandler showErrorDialog:@"Conflict error" message:@"This username already exists"] show];
            }
        }];
    } else {
        [[DialogHandler showErrorDialog:@"Input error" message:message] show];
    }
    
}

-(void)goToLogin {
    UINavigationController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginController"];
    [self presentViewController:controller animated:NO completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
