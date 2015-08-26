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
#import "NVCourse.h"
//@class NVCourse;
@protocol NVCoursesToAddAsStudentViewControllerDelegate;

@interface NVCourseDetailViewController : NVParentViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NVCoursesToAddAsStudentViewControllerDelegate>
- (IBAction)actionCancelButton:(UIBarButtonItem *)sender;

//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NVCourse* course;

@property (strong,nonatomic) UITextField* fieldName;

@end
