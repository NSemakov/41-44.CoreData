//
//  NVAllPersonsViewController.m
//  41-44.CoreData
//
//  Created by Admin on 24.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "NVAllPersonsViewController.h"
#import "NVPersonDetailViewController.h"
#import "NVPerson.h"
@interface NVAllPersonsViewController ()

@end

@implementation NVAllPersonsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
@synthesize fetchedResultsController=_fetchedResultsController;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NVPerson *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",object.firstName, object.lastName];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    // [object valueForKey:@"firstName"];
}
/*
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}
 */
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"NVPerson" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
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
#pragma mark - UITableViewDataSource
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"segueEditPerson" sender:indexPath];
    
}

#pragma mark - Actions
- (IBAction)actionAddNewPerson:(UIBarButtonItem *)sender {
    //show modal. made in story board
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"segueAddNewPerson"]) {
        //UINavigationController* nav=segue.destinationViewController;
        //NVPersonDetailViewController* pdvc=[nav topViewController];
        
    }
    if ([segue.identifier isEqualToString:@"segueEditPerson"]) {
        UINavigationController* nav=segue.destinationViewController;
        NVPersonDetailViewController* pdvc=(NVPersonDetailViewController*)[nav topViewController];
        pdvc.person=[self.fetchedResultsController objectAtIndexPath:(NSIndexPath *)sender];
    }
}
@end
