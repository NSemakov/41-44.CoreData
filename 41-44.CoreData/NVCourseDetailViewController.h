//
//  NVPersonDetailViewController.h
//  41-44.CoreData
//
//  Created by Admin on 25.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NVParentViewController.h"
#import <CoreData/CoreData.h>
@class NVCourse;
@interface NVCourseDetailViewController : NVParentViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
- (IBAction)actionCancelButton:(UIBarButtonItem *)sender;

//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NVCourse* course;

@property (strong,nonatomic) UITextField* fieldName;

@end
