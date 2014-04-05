//
//  TaskController.m
//  ToDo
//
//  Created by Remi Sloot on 02/04/14.
//  Copyright (c) 2014 Avans. All rights reserved.
//

#import "TaskController.h"
#import "APIController.h"
#import "TaskCell.h"
#import "Task.h"

@interface TaskController ()

@property (strong, nonatomic) NSMutableArray *tasks;
@property (nonatomic) NSNumber *lastSelectedTaskId;

@property (weak, nonatomic) UITextField *addTaskTextField;
@property (strong, nonatomic) UIAlertView *alert;

@end

@implementation TaskController

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
    self.alert = [[UIAlertView alloc] initWithTitle:@"Add task"
                                            message:@"Please enter the name:"
                                           delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:nil];
    
    self.alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    self.addTaskTextField = [self.alert textFieldAtIndex:0];
    self.addTaskTextField.keyboardType = UIKeyboardTypeDefault;
    self.addTaskTextField.placeholder = @"Task name";
    
    [self.alert addButtonWithTitle:@"Add"];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(self.tasks.count == 0)
        [self loadTasks];
}

-(void)loadTasks {
    // load tasks from api
    if(self.list_id) {
        NSMutableDictionary *qs = [[NSMutableDictionary alloc] init];
        [qs setValue:self.list_id forKey:@"lid"];
        
        [APIController request:GET controller:@"task" action:nil queryString:qs args:nil callback:^(NSData *data, int statusCode) {
            
            if(statusCode >= 200 && statusCode < 300) {
                NSError *error = nil;
                NSArray *tasks = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                
                NSMutableArray *taskObjs = [[NSMutableArray alloc]init];
                for(NSDictionary *taskData in tasks) {
                    Task *taskObj = [[Task alloc] init];
                    [taskObj setValues:taskData];
                    [taskObjs addObject:taskObj];
                }
                
                self.tasks = taskObjs;
                [self.tableView reloadData];
            }
        }];
    } else {
        NSLog(@"List_id is null or something");
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
    return self.tasks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskCell *cell = (TaskCell *)[tableView dequeueReusableCellWithIdentifier:@"Task" forIndexPath:indexPath];
    
    // Configure the cell...
    if(self.tasks.count > 0) {
        Task *task = [self.tasks objectAtIndex:indexPath.item];
        cell.nameText.text = task.name;
        cell.descText.text = task.end_date;
        cell.taskId = task.id;
        [cell setSwitch:task.status];
    } else {
        cell.textLabel.text = @"Loading...";
    }
    
    return cell;
}


- (IBAction)addTaskClick:(id)sender {
    // name, list_id
    [self.alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {  //Add Button
        if(self.addTaskTextField.text)
            [self addTask:self.addTaskTextField.text];
    }
}


-(void)addTask:(NSString *)name {
    
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setObject:name forKey:@"name"];
    [args setObject:self.list_id forKey:@"list_id"];
    
    [APIController request:POST controller:@"task" action:nil queryString:nil args:args callback:^(NSData *data, int statusCode) {
        if(statusCode >= 200 && statusCode < 300) {
            NSError *error = nil;
            NSDictionary *idDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSNumber *tid = [idDic objectForKey:@"id"];
            
            Task *task = [[Task alloc] init];
            task.id = tid;
            task.name = name;
            task.end_date = @"00-00-0000 00:00:00";
            task.list_id = self.list_id;
            
            [self.tasks addObject:task];
            [self.tableView reloadData];
        }
    }];
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Task *task = [self.tasks objectAtIndex:indexPath.item];
        if(task) {
            NSMutableDictionary *args = [[NSMutableDictionary alloc]init];
            [args setObject:task.id forKey:@"id"];
            
            [APIController request:DELETE controller:@"task" action:nil queryString:nil args:args callback:^(NSData *data, int statusCode) {
                
                if(statusCode >= 200 && statusCode < 300) {
                    [self.tasks removeObjectAtIndex:indexPath.item];
                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
            }];
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
