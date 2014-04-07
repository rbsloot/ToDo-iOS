//
//  BoardController.m
//  ToDo
//
//  Created by Remi Sloot on 14/03/14.
//  Copyright (c) 2014 Avans. All rights reserved.
//

#import "BoardController.h"
#import "APIController.h"
#import "LoginController.h"
#import "ListController.h"
#import "UserController.h"
#import "Board.h"

@interface BoardController ()

@property (nonatomic, strong) NSMutableArray *boards;
@property (nonatomic) NSNumber *lastSelectedBoardId;

@property (weak, nonatomic) UITextField *addBoardTextField;
@property (strong, nonatomic) UIAlertView *alert;

@property (nonatomic) BOOL isDeleting;

@end

@implementation BoardController

//-(NSMutableArray *)boards {
//    if(!_boards) {
//        _boards = [[NSMutableArray alloc] init];
//    }
//    return _boards;
//}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isDeleting = NO;
    [self initDialogs];
}

-(void)initDialogs {
    self.alert = [[UIAlertView alloc] initWithTitle:@"Add board"
                                            message:@"Please enter the name:"
                                           delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:nil];
    
    self.alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    self.addBoardTextField = [self.alert textFieldAtIndex:0];
    self.addBoardTextField.keyboardType = UIKeyboardTypeDefault;
    self.addBoardTextField.placeholder = @"Board name";
    
    [self.alert addButtonWithTitle:@"Add"];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(self.boards.count == 0)
        [self loadBoards];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadBoards {
    // Load boards from api
    
    NSString *token =[[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    //NSString *token = @"c4ca4238a0b923820dcc509a6f75849b";
    
    if(token) {
        NSMutableDictionary *qs = [[NSMutableDictionary alloc] init];
        [qs setObject:token forKey:@"token"];
        
        [APIController request:GET controller:@"board" action:nil queryString:qs args:nil callback:^(NSData *data, int statusCode) {
        
            if(statusCode >= 200 && statusCode < 300) {
                NSError *error = nil;
                NSArray *boards = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
                NSMutableArray *boardObjs = [[NSMutableArray alloc]init];
                for(NSDictionary *boardData in boards) {
                    Board *boardObj = [[Board alloc] init];
                    [boardObj setValues:boardData];
                    [boardObjs addObject:boardObj];
                }
                
                self.boards = boardObjs;
                [self.tableView reloadData];
            } else if(statusCode == 404) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
                
                [self goToLogin];
            }
        }];
    } else {
        // Go back to LoginController
        [self goToLogin];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.boards.count; // Board count
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Board"forIndexPath:indexPath];
    
    // Get board name
    
    // Configure the cell...
    if(self.boards.count > 0) {
        Board *board = [self.boards objectAtIndex:indexPath.item];
        cell.textLabel.text = board.name;
    } else {
        cell.textLabel.text = @"Loading...";
    }
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Board *board = [self.boards objectAtIndex:indexPath.item];
    self.lastSelectedBoardId = board.id;
    return indexPath;
}

- (IBAction)addBoardClick:(id)sender {
    // Create dialog
    [self.alert show];
}

-(IBAction)logoutClick:(id)sender {
    [UserController logout:^{
        [self goToLogin];
    }];
}

-(void)goToLogin {
    UINavigationController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginController"];
    [self presentViewController:login animated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {  //Add Button
        if(self.addBoardTextField.text)
            [self addBoard:self.addBoardTextField.text];
    }
}

-(void)addBoard:(NSString *)name {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults stringForKey:@"token"];
    
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setObject:name forKey:@"bName"];
    [args setObject:token forKey:@"token"];
    
    [APIController request:POST controller:@"board" action:nil queryString:nil args:args callback:^(NSData *data, int statusCode) {
        if(statusCode >= 200 && statusCode < 300) {
            NSError *error = nil;
            NSDictionary *idDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSNumber *bid = [idDic objectForKey:@"id"];
            
            Board *board = [[Board alloc] init];
            board.id = bid;
            board.name = name;
            
            [self.boards addObject:board];
            [self.tableView reloadData];
        }
    }];
}

- (void)tableView:(UITableView *)tv
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if(!self.isDeleting) {
        self.isDeleting = YES;
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            // delete your data item here
            // Animate the deletion from the table.
            Board *board = [self.boards objectAtIndex:indexPath.item];
            if(board) {
                NSMutableDictionary *args = [[NSMutableDictionary alloc]init];
                [args setObject:board.id forKey:@"bid"];
            
                [APIController request:DELETE controller:@"board" action:nil queryString:nil args:args callback:^(NSData *data, int statusCode) {
                
                    if(statusCode >= 200 && statusCode < 300) {
                        [self.boards removeObjectAtIndex:indexPath.item];
                        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        
                        self.isDeleting = NO;
                    }
                }];
            }
        }
    }
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //if ([[segue identifier] isEqualToString: @"boardToList"]) {
        ListController *listController = (ListController *)[segue destinationViewController];
        listController.board_id = self.lastSelectedBoardId;
    //}
}

@end
