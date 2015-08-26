//
//  NVPersonDetailViewController.m
//  41-44.CoreData
//
//  Created by Admin on 25.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "NVPersonDetailViewController.h"
#import "NVDataManager.h"
#import "NVTableViewCellCustom.h"
#import "NVDatePickerController.h"
#import "NVCoursesToAddAsStudentViewController.h"
#import "NVCoursesToAddAsTeacherViewController.h"
//#import "NVPerson.h"
typedef NS_ENUM(NSInteger, textFieldType){
    textFieldTypeFirstName,
    textFieldTypeLastName,
    textFieldTypeDateOfBirth,
    textFieldTypeMail
};
@interface NVPersonDetailViewController ()

@end

@implementation NVPersonDetailViewController
@synthesize fetchedResultsController=_fetchedResultsController;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.formatter=[[NSDateFormatter alloc]init];
    [self.formatter setDateFormat:@"dd.MM.yyyy"];
    UIBarButtonItem* buttonDone=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone:)];
    UIBarButtonItem* buttonAddNew=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAddNew:)];
    self.navigationItem.rightBarButtonItems=@[buttonDone,buttonAddNew];
    
    //if editing, i.e. self.person was passed, then refetch with relationship prefetch.
    if (self.person) {
        self.person=[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        NSLog(@"array of courses students %@",self.person.coursesAsStudent);
    }
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    //if create new object, not editing.
    //ATTENTION! In viewDidAppear only, because if do it in viewDidLoad, then (NULL) will appear on screen, while new view controller is appearing.
    if (!self.person) {
        NSManagedObjectContext* context=[[NVDataManager sharedManager] managedObjectContext];
        NVPerson* newPerson=[NSEntityDescription insertNewObjectForEntityForName:@"NVPerson" inManagedObjectContext:context];
        self.person=newPerson;
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"NVPerson" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setRelationshipKeyPathsForPrefetching:@[@"coursesAsStudent",@"coursesAsTeacher"]];

    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    //NSManagedObjectID *moID=[self.person objectID];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"(SELF = %@)",self.person];
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
    NSLog(@"end of fetch");
    return _fetchedResultsController;
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        BOOL isLastItemAtSection=0;
        if (indexPath.section==1) {
            if (!([self.person.coursesAsStudent count]==0)) {
                NSArray* array=[self.person.coursesAsStudent allObjects];
                NVCourse* course=[array objectAtIndex:indexPath.row];
                [self.person removeCoursesAsStudent:[NSSet setWithObject:course]];
                isLastItemAtSection= ([self.person.coursesAsStudent count]==0) ? 1:0;
            } else {
                NSArray* array=[self.person.coursesAsTeacher allObjects];
                NVCourse* course=[array objectAtIndex:indexPath.row];
                [self.person removeCoursesAsTeacher:[NSSet setWithObject:course]];
                isLastItemAtSection= ([self.person.coursesAsTeacher count]==0) ? 1:0;
            }
        } else if (indexPath.section==2){
            NSArray* array=[self.person.coursesAsTeacher allObjects];
            NVCourse* course=[array objectAtIndex:indexPath.row];
            [self.person removeCoursesAsTeacher:[NSSet setWithObject:course]];
            isLastItemAtSection= ([self.person.coursesAsTeacher count]==0) ? 1:0;
        }
        [tableView beginUpdates];
        if (isLastItemAtSection) {
            NSIndexSet* indexSet=[NSIndexSet indexSetWithIndex:indexPath.section];
            [tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        
        [tableView endUpdates]; 
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1+([self.person.coursesAsStudent count]>0)+([self.person.coursesAsTeacher count]>0);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section==0) {
        return 4;
    } else if (section==1) {
        if (!([self.person.coursesAsStudent count]==0)) {
            return [self.person.coursesAsStudent count];
        } else {
            return [self.person.coursesAsTeacher count];
        }
    } else if (section==2){
        NSLog(@"%ld",[self.person.coursesAsTeacher count]);
        return [self.person.coursesAsTeacher count];
    } else {
        return 0;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    if (section==0) {
        return @"Person info";
    } else if (section==1) {
        if (!([self.person.coursesAsStudent count]==0)) {
            return @"Courses as student";
        } else {
            return @"Courses as teacher";
        }
    } else if (section==2){
        return @"Courses as teacher";
    } else {
        return nil;
    }

}
#pragma mark - cell for row at index path
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell=nil;

    if (indexPath.section==0) {
        NVTableViewCellCustom* customCell=nil;
        switch (indexPath.row) {
            case textFieldTypeFirstName:{
                static NSString* cellFirstName=@"cellFirstName";
                customCell=[tableView dequeueReusableCellWithIdentifier:cellFirstName];
                if (self.person.firstName) {
                    //if edit existing person
                    customCell.textfield.text=self.person.firstName;
                }
                if (self.fieldFirstName) {
                    //to save text if scrolling up&down
                    customCell.textfield.text=self.fieldFirstName.text;
                }
                self.fieldFirstName=customCell.textfield;
            } break;
            case textFieldTypeLastName:{
                static NSString* cellLastName=@"cellLastName";
                customCell=[tableView dequeueReusableCellWithIdentifier:cellLastName];
                if (self.person.lastName) {
                    //if edit existing person
                    customCell.textfield.text=self.person.lastName;
                }
                if (self.fieldLastName) {
                    customCell.textfield.text=self.fieldLastName.text;
                }
                self.fieldLastName=customCell.textfield;
            } break;
            case textFieldTypeDateOfBirth:{
                static NSString* cellDateOfBirth=@"cellDateOfBirth";
                customCell=[tableView dequeueReusableCellWithIdentifier:cellDateOfBirth];
                if (self.person.dateOfBirth) {
                    //if edit existing person
                    customCell.textfield.text=[self.formatter stringFromDate:self.person.dateOfBirth];
                }
                if (self.fieldDateOfBirth) {
                    customCell.textfield.text=self.fieldDateOfBirth.text;
                }
                self.fieldDateOfBirth=customCell.textfield;
            } break;
            case textFieldTypeMail:{
                static NSString* cellMail=@"cellMail";
                customCell=[tableView dequeueReusableCellWithIdentifier:cellMail];
                if (self.person.mail) {
                    //if edit existing person
                    customCell.textfield.text=self.person.mail;
                }

                if (self.fieldMail) {
                    customCell.textfield.text=self.fieldMail.text;
                }
                self.fieldMail=customCell.textfield;
            } break;
                
                
            default:
                break;
        }
        return customCell;
    } else if (!indexPath.section==0){
            //configure standard cell
        static NSString* standartCellIdentifier=@"standardCell";
        cell=[tableView dequeueReusableCellWithIdentifier:standartCellIdentifier];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:standartCellIdentifier];
        }
        
        //
        if (indexPath.section==1) {
            if (!([self.person.coursesAsStudent count]==0)) {
                cell.textLabel.text=[[[self.person.coursesAsStudent allObjects] objectAtIndex:indexPath.row] name];
            } else {
                cell.textLabel.text=[[[self.person.coursesAsTeacher allObjects] objectAtIndex:indexPath.row] name];
            }
        } else if (indexPath.section==2){
            cell.textLabel.text=[[[self.person.coursesAsTeacher allObjects] objectAtIndex:indexPath.row] name];
        }
        //
        
        return cell;
         
    } else {
        return nil;
    }
    
   
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
    if ([textField isEqual:self.fieldDateOfBirth]) {
        [self performSegueWithIdentifier:@"segueDatePicker" sender:nil];
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:self.fieldFirstName]) {
        [self.person setValue:[textField.text stringByAppendingString:string] forKey:@"firstName"];
        //self.person.firstName=textField.text;
    } else if ([textField isEqual:self.fieldLastName]){
        self.person.lastName=[textField.text stringByAppendingString:string];
    } else if ([textField isEqual:self.fieldMail]){
        self.person.mail=[textField.text stringByAppendingString:string];;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.fieldFirstName]) {
        [self.fieldLastName becomeFirstResponder];
    } else if ([textField isEqual:self.fieldLastName]){
        [self.fieldMail becomeFirstResponder];
    } else if ([textField isEqual:self.fieldMail]){
        [textField resignFirstResponder];
    }
    return YES;
}
#pragma mark - Actions
- (IBAction)actionCancelButton:(UIBarButtonItem *)sender {
    [[[NVDataManager sharedManager] managedObjectContext] rollback];
    [self.navigationController popViewControllerAnimated:YES];

}

- (void) actionDone:(UIBarButtonItem *)sender {
    //NSLog(@"name %@, lastname %@",self.person.firstName,self.person.lastName);
    NSError* error=[NSError errorWithDomain:@"nvpersonDetailVC" code:111 userInfo:nil];
    if (![[[NVDataManager sharedManager] managedObjectContext] save:&error]) {
        NSLog(@"error %@",[error description]);
        [[[NVDataManager sharedManager] managedObjectContext] rollback];
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}
- (void) actionAddNew:(UIBarButtonItem *)sender {
    UIAlertController* ac=[UIAlertController alertControllerWithTitle:@"Choose what to customize" message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* asStudent=[UIAlertAction actionWithTitle:@"Customize course for student" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self performSegueWithIdentifier:@"segueShowCourses" sender:nil];
    }];
    UIAlertAction* asTeacher=[UIAlertAction actionWithTitle:@"Customize course for teacher" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
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
#pragma mark - NVCoursesToAddAsStudentViewControllerDelegate
//NVCoursesToAddAsTeacherViewControllerDelegate
- (void) refreshTableView {
    [self.tableView reloadData];
}
#pragma mark - prepareForSegue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"segueDatePicker"]) {
        NVDatePickerController* vc=(NVDatePickerController*)[segue.destinationViewController topViewController];
        vc.formatter=self.formatter;
        vc.delegate=self;
        if ([self.fieldDateOfBirth.text length]>0) {
            vc.initialDate=self.fieldDateOfBirth.text;
        }
        
    } else if ([segue.identifier isEqualToString:@"segueShowCourses"]) {
        NVCoursesToAddAsStudentViewController* vc=(NVCoursesToAddAsStudentViewController*)[segue.destinationViewController topViewController];
        vc.person=self.person;
        vc.delegate=self;
        
    } else if ([segue.identifier isEqualToString:@"segueAddTeacher"]) {
        NVCoursesToAddAsTeacherViewController* vc=(NVCoursesToAddAsTeacherViewController*)[segue.destinationViewController topViewController];
        vc.person=self.person;
        vc.delegate=self;
        NSLog(@"all courses as teacher11111 %@",self.person.coursesAsTeacher);
    }
}
@end
