//
//  NVCoursesToAddViewController.m
//  41-44.CoreData
//
//  Created by Admin on 25.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "NVPerson.h"
#import "NVCourse.h"
#import "NVStudentsToAddForCourseViewController.h"
#import "NVCourseDetailViewController.h"
#import "NVCoursesToAddAsStudentViewController.h"

@interface NVStudentsToAddForCourseViewController ()

@end

@implementation NVStudentsToAddForCourseViewController
@synthesize fetchedResultsController=_fetchedResultsController;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayToRemove=[NSMutableArray new];
    self.arrayToAdd=[NSMutableArray new];
    
    UIBarButtonItem* buttonDone=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone:)];
    UIBarButtonItem* buttonCancel=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionCancel:)];
    self.navigationItem.rightBarButtonItems=@[buttonDone];
    self.navigationItem.leftBarButtonItems=@[buttonCancel];
}
#pragma mark - actions
- (void) actionDone: (UIBarButtonItem*) sender {
    [self.course addStudents:[NSSet setWithArray:self.arrayToAdd]];
    [self.course removeStudents:[NSSet setWithArray:self.arrayToRemove]];
    [self.delegate refreshTableView];
    //[self.delegate.tableView reloadData];
    /*
    NSError* error=[NSError errorWithDomain:@"NVCoursesVC" code:111 userInfo:nil];
    if ([self.person.managedObjectContext hasChanges]) {
        //[self.person.managedObjectContext save:&error];
    }
    */
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) actionCancel: (UIBarButtonItem*) sender {
    [self.course.managedObjectContext rollback];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"NVPerson" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    //[fetchRequest setRelationshipKeyPathsForPrefetching:@[@"coursesAsStudent",@"coursesAsTeacher"]];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    //NSManagedObjectID *moID=[self.person objectID];
    //NSPredicate* predicate=[NSPredicate predicateWithFormat:@"(SELF = %@)",self.person];
    //[fetchRequest setPredicate:predicate];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return _fetchedResultsController;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    NVPerson* selectedObject=[self.fetchedResultsController objectAtIndexPath:indexPath];
    if (cell.accessoryType==UITableViewCellAccessoryCheckmark) {
        if ([self.arrayToAdd containsObject:selectedObject]) {
            [self.arrayToAdd removeObject:selectedObject];
        } else {
            [self.arrayToRemove addObject:selectedObject];
        }
        //[self.person removeCoursesAsStudentObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        cell.accessoryType=UITableViewCellAccessoryNone;
    } else {
        if ([self.arrayToRemove containsObject:selectedObject]) {
            [self.arrayToRemove removeObject:selectedObject];
        } else {
            [self.arrayToAdd addObject:selectedObject];
        }
        //[self.person addCoursesAsStudentObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
         cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NVPerson *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([self.course.students containsObject:object]) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",object.firstName,object.lastName];

}
@end
