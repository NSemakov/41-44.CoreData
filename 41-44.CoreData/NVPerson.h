//
//  NVPerson.h
//  41-44.CoreData
//
//  Created by Admin on 24.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NVParentObject.h"

@class NVCourse;

@interface NVPerson : NVParentObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSDate * dateOfBirth;
@property (nonatomic, retain) NSString * mail;
@property (nonatomic, retain) NSSet *coursesAsStudent;
@property (nonatomic, retain) NSSet *coursesAsTeacher;
@end

@interface NVPerson (CoreDataGeneratedAccessors)

- (void)addCoursesAsStudentObject:(NVCourse *)value;
- (void)removeCoursesAsStudentObject:(NVCourse *)value;
- (void)addCoursesAsStudent:(NSSet *)values;
- (void)removeCoursesAsStudent:(NSSet *)values;

- (void)addCoursesAsTeacherObject:(NVCourse *)value;
- (void)removeCoursesAsTeacherObject:(NVCourse *)value;
- (void)addCoursesAsTeacher:(NSSet *)values;
- (void)removeCoursesAsTeacher:(NSSet *)values;

@end
