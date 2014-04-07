//
//  LoginController.m
//  ToDo
//
//  Created by Remi Sloot on 12/03/14.
//  Copyright (c) 2014 Avans. All rights reserved.
//

#import "LoginController.h"
#import "APIController.h"
#import "BoardController.h"
#import "UserController.h"
#import "DialogHandler.h"


@interface LoginController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) NSUserDefaults *defaults;

@end

@implementation LoginController

-(NSUserDefaults *)defaults {
    return [NSUserDefaults standardUserDefaults];
}

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

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if([self.defaults objectForKey:@"token"]) {
        [self goTo:@"RootView"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginClick:(UIButton *)sender {
    NSString *name = [self.usernameTextField text];
    NSString *password = [self.passwordTextField text];
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
    
    if(valid) {
        [UserController login:name password:password onComplete:^(NSString *token) {
            [self.defaults setObject:token forKey:@"token"];
            [self.defaults synchronize];
        
            [self goTo:@"RootView"];
        }];
    } else {
        [[DialogHandler showErrorDialog:@"Input error" message:message] show];
    }
}

- (IBAction)registerClick:(id)sender {
    [self goTo:@"RegisterController"];
}

-(void)goTo:(NSString *)controller {
    UINavigationController *rootController = [self.storyboard instantiateViewControllerWithIdentifier:controller];
    [self presentViewController:rootController animated:NO completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [segue destinationViewController];
}
 */


@end
