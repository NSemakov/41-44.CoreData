//
//  NVCoursesToAddViewController.h
//  41-44.CoreData
//
//  Created by Admin on 25.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "NVParentViewController.h"
@class NVCourse;
@class NVCourseDetailViewController;
@interface NVStudentsToAddForCourseViewController : NVParentViewController
@property (strong,nonatomic) NVCourse* course;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray* arrayToRemove;
@property (strong, nonatomic) NSMutableArray* arrayToAdd;
@property (strong,nonatomic) NVCourseDetailViewController* delegate;

@end

