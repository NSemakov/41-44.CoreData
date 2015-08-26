//
//  NVCoursesToAddAsTeacherViewController.h
//  41-44.CoreData
//
//  Created by Admin on 25.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "NVParentViewController.h"
@class NVCourse;
@class NVCourseDetailViewController;
@class NVPerson;


@interface NVTeacherToAddForCourseViewController : NVParentViewController
@property (strong,nonatomic) NVCourse* course;
@property (strong,nonatomic) NVCourseDetailViewController* delegate;

@property (strong,nonatomic) NVPerson* selectedTeacher;

@end

