//
//  NVPersonDetailViewController.m
//  41-44.CoreData
//
//  Created by Admin on 25.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "NVCourseDetailViewController.h"
//#import "NVCourse.h"
#import "NVPerson.h"
#import "NVDataManager.h"
#import "NVTableViewCellCustom.h"
#import "NVDatePickerController.h"
#import "NVStudentsToAddForCourseViewController.h"
#import "NVTeacherToAddForCourseViewController.h"
#import "NVCoursesToAddAsStudentViewController.h"
typedef NS_ENUM(NSInteger, textFieldType){
    textFieldTypeFirstName,
    textFieldTypeLastName,
    textFieldTypeDateOfBirth,
    textFieldTypeMail
};
@interface NVCourseDetailViewController ()

@end

@implementation NVCourseDetailViewController
@synthesize fetchedResultsController=_fetchedResultsController;


- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem* buttonDone=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone:)];
    UIBarButtonItem* buttonAddNew=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAddNew:)];
    self.navigationItem.rightBarButtonItems=@[buttonDone,buttonAddNew];
    
    //if editing, i.e. self.person was passed, then refetch with relationship prefetch.
    if (self.course) {
        self.course=[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    }
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    //if create new object, not editing.
    //ATTENTION! In viewDidAppear only, because if do it in viewDidLoad, then (NULL) will appear on screen, while new view controller is appearing.
    if (!self.course) {
        NSManagedObjectContext* context=[[NVDataManager sharedManager] managedObjectContext];
        NVCourse* newCourse=[NSEntityDescription insertNewObjectForEntityForName:@"NVCourse" inManagedObjectContext:context];
        self.course=newCourse;
    }
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
    [fetchRequest setRelationshipKeyPathsForPrefetching:@[@"students",@"teachers"]];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    //NSManagedObjectID *moID=[self.person objectID];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"(SELF = %@)",self.course];
    //NSPredicate* predicate=[NSPredicate predicateWithFormat:@"(SELF = %@)",moID];
    [fetchRequest setPredicate:predicate];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.course.name length]>0) {
        //editing object
        //NSLog(@"asstudent %d asteacher %d",[self.person.coursesAsStudent count]>0,[self.person.coursesAsTeacher count]==0);
        
        return 1+([self.course.students count]>0)+(![self.course.teachers isEqual:nil]);
        
    } else {
        //create new
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        return 1;
    } else if (section==1) {
        if (!([self.course.students count]==0)) {
            return [self.course.students count];
        } else {
            return 1;//course might have only one teacher
        }
    } else if (section==2){
        return 1;//course might have only one teacher
    } else {
        return 0;
    }
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return @"Course info";
    } else if (section==1) {
        if (!([self.course.students count]==0)) {
            return @"students at course";
        } else {
            return @"teacher of course";//course might have only one teacher
        }
    } else if (section==2){
        return @"teacher of course";//course might have only one teacher
    } else {
        return nil;
    }
    
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell=nil;
    
    if (indexPath.section==0 && indexPath.row==0) {
        NVTableViewCellCustom* customCell=nil;
        
        static NSString* cellFirstName=@"cellName";
        customCell=[tableView dequeueReusableCellWithIdentifier:cellFirstName];
        if (self.course.name) {
            //if edit existing person
            customCell.textfield.text=self.course.name;
        }
        if (self.fieldName) {
            //to save text if scrolling up&down
            customCell.textfield.text=self.fieldName.text;
        }
        self.fieldName=customCell.textfield;
        return customCell;
    }
    
    //configure standard cell
    static NSString* standartCellIdentifier=@"standardCell";
    cell=[tableView dequeueReusableCellWithIdentifier:standartCellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:standartCellIdentifier];
    }
    
    //
    if (indexPath.section==1) {
        if (!([self.course.students count]==0)) {
            cell.textLabel.text=[[[self.course.students allObjects] objectAtIndex:indexPath.row] firstName];
        } else {
            cell.textLabel.text=[self.course.teachers firstName];
        }
    } else if (indexPath.section==2){
        cell.textLabel.text=[self.course.teachers firstName];
    }
    //

    return cell;
    
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //cell.textLabel.text = [[object valueForKey:@"timeStamp"] description];
    
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

        return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:self.fieldName]) {
        [self.course setValue:[textField.text stringByAppendingString:string] forKey:@"name"];
        //self.person.firstName=textField.text;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}


#pragma mark - NVCoursesToAddAsStudentViewControllerDelegate
//NVCoursesToAddAsTeacherViewControllerDelegate
- (void) refreshTableView {
    [self.tableView reloadData];
}

#pragma mark - Actions
- (IBAction)actionCancelButton:(UIBarButtonItem *)sender {
    [[[NVDataManager sharedManager] managedObjectContext] rollback];
    [self.navigationController popViewControllerAnimated:YES];

}

- (void) actionDone:(UIBarButtonItem *)sender {
    //NSLog(@"name %@, lastname %@",self.person.firstName,self.person.lastName);
    NSError* error=[NSError errorWithDomain:@"addCourseDetailVC" code:111 userInfo:nil];
    if (![[[NVDataManager sharedManager] managedObjectContext] save:&error]) {
        NSLog(@"error %@",[error description]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) actionAddNew:(UIBarButtonItem *)sender {
    UIAlertController* ac=[UIAlertController alertControllerWithTitle:@"Choose smth to add/edit" message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* asStudent=[UIAlertAction actionWithTitle:@"Add student" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self performSegueWithIdentifier:@"segueAddStudents" sender:nil];
    }];
    UIAlertAction* asTeacher=[UIAlertAction actionWithTitle:@"Add teacher" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self performSegueWithIdentifier:@"segueAddTeacher" sender:nil];
    }];
    UIAlertAction* cancel=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //[self dismissViewControllerAnimated:YES completion:nil];
    }];
    [ac addAction:asStudent];
    [ac addAction:asTeacher];
    [ac addAction:cancel];
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark - prepareForSegue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"segueAddStudents"]) {
        NVStudentsToAddForCourseViewController* vc=(NVStudentsToAddForCourseViewController*)[segue.destinationViewController topViewController];
        vc.course=self.course;
        vc.delegate=self;
    } else if ([segue.identifier isEqualToString:@"segueAddTeacher"]) {
        NVTeacherToAddForCourseViewController* vc=(NVTeacherToAddForCourseViewController*)[segue.destinationViewController topViewController];
        vc.course=self.course;
        vc.delegate=self;
    }
}

@end
