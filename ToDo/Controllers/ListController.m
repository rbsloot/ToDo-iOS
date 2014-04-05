//
//  ListController.m
//  ToDo
//
//  Created by Remi Sloot on 14/03/14.
//  Copyright (c) 2014 Avans. All rights reserved.
//

#import "ListController.h"
#import "APIController.h"
#import "TaskController.h"
#import "List.h";

@interface ListController ()

@property (nonatomic, strong) NSMutableArray *lists;
@property (nonatomic) NSNumber *lastSelectedListId;

@property (weak, nonatomic) UITextField *addListTextField;
@property (strong, nonatomic) UIAlertView *alert;

@end

@implementation ListController

//-(NSMutableArray *)boards {
//    if(!_lists) {
//        _lists = [[NSMutableArray alloc] init];
//    }
//    return _lists;
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
    
    [self initDialogs];
}

-(void)initDialogs {
    self.alert = [[UIAlertView alloc] initWithTitle:@"Add list"
                                            message:@"Please enter the name:"
                                           delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:nil];
    
    self.alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    self.addListTextField = [self.alert textFieldAtIndex:0];
    self.addListTextField.keyboardType = UIKeyboardTypeDefault;
    self.addListTextField.placeholder = @"List name";
    
    [self.alert addButtonWithTitle:@"Add"];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(self.lists.count == 0)
        [self loadLists];
}

-(void)loadLists {
    // Load lists from api
    if(self.board_id) {
        NSMutableDictionary *qs = [[NSMutableDictionary alloc] init];
        [qs setValue:self.board_id forKey:@"bid"];
        
        [APIController request:GET controller:@"list" action:@"listsonly" queryString:qs args:nil callback:^(NSData *data, int statusCode) {
            
            if(statusCode >= 200 && statusCode < 300) {
                NSError *error = nil;
                NSArray *lists = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                
                NSMutableArray *listObjs = [[NSMutableArray alloc]init];
                for(NSDictionary *listData in lists) {
                    List *listObj = [[List alloc] init];
                    [listObj setValues:listData];
                    [listObjs addObject:listObj];
                }
                
                self.lists = listObjs;
                [self.tableView reloadData];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return self.lists.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"List" forIndexPath:indexPath];
    
    // Configure the cell...
    if(self.lists.count > 0) {
        List *list = [self.lists objectAtIndex:indexPath.item];
        cell.textLabel.text = list.name;
    } else {
        cell.textLabel.text = @"Loading...";
    }
    
    return cell;
}

- (IBAction)addListClick:(id)sender {
    [self.alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {  //Add Button
        if(self.addListTextField.text)
            [self addList:self.addListTextField.text];
    }
}

-(void)addList:(NSString *)name {
    
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setObject:name forKey:@"name"];
    [args setObject:self.board_id forKey:@"board_id"];
    
    [APIController request:POST controller:@"list" action:nil queryString:nil args:args callback:^(NSData *data, int statusCode) {
        if(statusCode >= 200 && statusCode < 300) {
            NSError *error = nil;
            NSDictionary *idDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSNumber *lid = [idDic objectForKey:@"id"];
            
            List *list = [[List alloc] init];
            list.id = lid;
            list.name = name;
            list.board_id = self.board_id;
            
            [self.lists addObject:list];
            [self.tableView reloadData];
        }
    }];
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        List *list = [self.lists objectAtIndex:indexPath.item];
        if(list) {
            NSMutableDictionary *args = [[NSMutableDictionary alloc]init];
            [args setObject:list.id forKey:@"id"];
            
            [APIController request:DELETE controller:@"list" action:nil queryString:nil args:args callback:^(NSData *data, int statusCode) {
                
                if(statusCode >= 200 && statusCode < 300) {
                    [self.lists removeObjectAtIndex:indexPath.item];
                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
            }];
            
        }
        
        
        
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    List *list = [self.lists objectAtIndex:indexPath.item];
    self.lastSelectedListId = list.id;
    return indexPath;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //if ([[segue identifier] isEqualToString: @"boardToList"]) {
    TaskController *taskController = (TaskController *)[segue destinationViewController];
    taskController.list_id = self.lastSelectedListId;
    //}
}

@end
