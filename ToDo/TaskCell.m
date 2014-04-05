//
//  TaskCell.m
//  ToDo
//
//  Created by Remi Sloot on 02/04/14.
//  Copyright (c) 2014 Avans. All rights reserved.
//

#import "TaskCell.h"
#import "APIController.h"

@implementation TaskCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)toggleSwitch:(id)sender {
    NSString *status = ([self.uiswitch isOn]) ? @"completed" : @"not_completed";
    
    //id, list_id, name, description, end_date, status
    NSMutableDictionary *args = [[NSMutableDictionary alloc]init];
    [args setObject:status forKey:@"status"];
    [args setObject:self.taskId forKey:@"id"];
    
    [APIController request:PUT controller:@"task" action:@"putStatus" queryString:nil args:args callback:^(NSData *data, int statusCode) {
        
    }];
}

-(void)setSwitch:(NSString *)state {
    // Check if Not is NSNull && Not is empty && Is "completed"
    if(state) {
        [self.uiswitch setOn:(![state isEqual:[NSNull null]] && [state length] && [state isEqualToString:@"completed"])];
    }
}

@end
