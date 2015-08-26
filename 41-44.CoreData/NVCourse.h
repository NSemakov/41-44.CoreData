//
//  NVCourse.h
//  41-44.CoreData
//
//  Created by Admin on 26.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NVParentObject.h"

@class NVPerson;

@interface NVCourse : NVParentObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *students;
@property (nonatomic, retain) NVPerson *teachers;
@end

@interface NVCourse (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(NVPerson *)value;
- (void)removeStudentsObject:(NVPerson *)value;
- (void)addStudents:(NSSet *)values;
- (void)removeStudents:(NSSet *)values;

@end
