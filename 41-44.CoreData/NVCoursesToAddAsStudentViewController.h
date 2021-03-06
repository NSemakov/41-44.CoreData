//
//  NVCoursesToAddViewController.h
//  41-44.CoreData
//
//  Created by Admin on 25.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "NVParentViewController.h"
@class NVPerson;
@class NVPersonDetailViewController;
@interface NVCoursesToAddAsStudentViewController : NVParentViewController
@property (strong,nonatomic) NVPerson* person;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray* arrayToRemove;
@property (strong, nonatomic) NSMutableArray* arrayToAdd;
@property (strong,nonatomic) NVPersonDetailViewController* delegate;

@end


@protocol NVCoursesToAddAsStudentViewControllerDelegate
- (void) refreshTableView;
@end