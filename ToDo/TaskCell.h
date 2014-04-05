//
//  TaskCell.h
//  ToDo
//
//  Created by Remi Sloot on 02/04/14.
//  Copyright (c) 2014 Avans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UISwitch *uiswitch;
@property (strong, nonatomic) IBOutlet UILabel *nameText;
@property (strong, nonatomic) IBOutlet UILabel *descText;

@property (strong, nonatomic) NSNumber *taskId;

-(void)setSwitch:(NSString *)state;

@end
