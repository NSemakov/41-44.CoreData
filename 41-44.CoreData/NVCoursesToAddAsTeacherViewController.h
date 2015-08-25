//
//  NVCoursesToAddAsTeacherViewController.h
//  41-44.CoreData
//
//  Created by Admin on 25.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "NVParentViewController.h"
@class NVPerson;
@class NVPersonDetailViewController;
@interface NVCoursesToAddAsTeacherViewController : NVParentViewController
@property (strong,nonatomic) NVPerson* person;
@property (strong,nonatomic) NVPersonDetailViewController* delegate;
@end
