//
//  NVAllPersonsViewController.m
//  41-44.CoreData
//
//  Created by Admin on 24.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "NVAllTeachersViewController.h"
#import "NVPersonDetailViewController.h"
#import "NVCourse.h"
#import "NVPerson.h"
@interface NVAllTeachersViewController ()

@end

@implementation NVAllTeachersViewController

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
    NVPerson *object = [[self.fetchedResultsController objectAtIndexPath:indexPath] teachers];
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"NVCourse" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setRelationshipKeyPathsForPrefetching:@[@"teachers"]];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"teachers!=%d",0];
    [fetchRequest setPredicate:predicate];
    self.predicate=predicate;
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"name" cacheName:nil];
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
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // Display the authors' names as section headings.
    return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     if (self.tableView.editing) {
     return UITableViewCellEditingStyleDelete;
     }
     */
    return UITableViewCellEditingStyleNone;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"segueShowDetail" sender:indexPath];
    
}
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text=@"";
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    [self matchTheSearchText:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //NSLog(@"%@ %@",searchBar.text,text);
    [self matchTheSearchText:searchText];
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return YES;
}
- (void) matchTheSearchText:(NSString*) searchText {
    NSPredicate *predicate=nil;
    if ([searchText length]>0) {
        predicate=[NSPredicate predicateWithFormat:@"teachers.firstName contains [cd] %@ OR teachers.lastName contains [cd] %@ ",searchText,searchText];
        [[self.fetchedResultsController fetchRequest] setPredicate:predicate];
    } else {
        [[self.fetchedResultsController fetchRequest] setPredicate:self.predicate];
    }
    
    //[self.fetchedResultsController fetchRequest];
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
}
#pragma mark - Actions
- (IBAction)actionAddNewPerson:(UIBarButtonItem *)sender {
    //show modal. made in story board
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"segueShowDetail"]) {
        NVPersonDetailViewController* pdvc=segue.destinationViewController;
        pdvc.person=[[self.fetchedResultsController objectAtIndexPath:(NSIndexPath *)sender] teachers];
    }
}
@end
