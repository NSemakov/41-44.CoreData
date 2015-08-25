//
//  NVCoursesToAddViewController.m
//  41-44.CoreData
//
//  Created by Admin on 25.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "NVCoursesToAddAsStudentViewController.h"
#import "NVPerson.h"
#import "NVCourse.h"
@interface NVCoursesToAddAsStudentViewController ()

@end

@implementation NVCoursesToAddAsStudentViewController
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
    NSError* error=[NSError errorWithDomain:@"NVCoursesVC" code:111 userInfo:nil];
    if ([self.person.managedObjectContext hasChanges]) {
        [self.person.managedObjectContext save:&error];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) actionCancel: (UIBarButtonItem*) sender {
    [self.person.managedObjectContext rollback];
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"NVCourse" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    //[fetchRequest setRelationshipKeyPathsForPrefetching:@[@"coursesAsStudent",@"coursesAsTeacher"]];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
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
    self.person=[self.fetchedResultsController sections][0];
    return _fetchedResultsController;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType==UITableViewCellAccessoryCheckmark) {
        [self.person removeCoursesAsStudentObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        cell.accessoryType=UITableViewCellAccessoryNone;
    } else {
        [self.person addCoursesAsStudentObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
         cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NVCourse *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([self.person.coursesAsStudent containsObject:object]) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    cell.textLabel.text = object.name;

}
@end
