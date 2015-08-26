//
//  NVCoursesToAddAsTeacherViewController.m
//  41-44.CoreData
//
//  Created by Admin on 25.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "NVTeacherToAddForCourseViewController.h"
#import "NVPerson.h"
#import "NVCourse.h"
#import "NVCourseDetailViewController.h"
#import "NVCoursesToAddAsStudentViewController.h"
@interface NVTeacherToAddForCourseViewController ()

@end

@implementation NVTeacherToAddForCourseViewController
@synthesize fetchedResultsController=_fetchedResultsController;
- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    UIBarButtonItem* buttonDone=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone:)];
    UIBarButtonItem* buttonCancel=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionCancel:)];
    self.navigationItem.rightBarButtonItems=@[buttonDone];
    self.navigationItem.leftBarButtonItems=@[buttonCancel];
}
#pragma mark - actions
- (void) actionDone: (UIBarButtonItem*) sender {
    self.course.teachers = self.selectedTeacher;

    //NSLog(@"all courses as teacher after %@",[self.course.teachers firstName]);
    [self.delegate refreshTableView];
    //[self.delegate.tableView reloadData];
    /*
    NSError* error=[NSError errorWithDomain:@"NVCoursesAsTeacherVC" code:111 userInfo:nil];
    NSLog(@"array %@",self.person.coursesAsTeacher);
    if ([self.person.managedObjectContext hasChanges]) {
        //[self.person.managedObjectContext save:&error];
    }
    [self.delegate.tableView setNeedsDisplay];
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
    //
    NVPerson* selectedObject=[self.fetchedResultsController objectAtIndexPath:indexPath];
    if (cell.accessoryType==UITableViewCellAccessoryCheckmark) {
        self.selectedTeacher=nil;
        cell.accessoryType=UITableViewCellAccessoryNone;
    } else {
        NSIndexPath* previousSelectedIndexPath=[self.fetchedResultsController indexPathForObject:self.selectedTeacher];
        UITableViewCell* previousSelectedCell=[tableView cellForRowAtIndexPath:previousSelectedIndexPath];
        previousSelectedCell.accessoryType=UITableViewCellAccessoryNone;
        
        self.selectedTeacher=selectedObject;
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }

}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NVPerson *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //NSLog(@"all courses as teacher before %@",self.person.coursesAsTeacher);
    if ([self.course.teachers isEqual:object]) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        self.selectedTeacher=object;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",object.firstName,object.lastName];

}
@end
