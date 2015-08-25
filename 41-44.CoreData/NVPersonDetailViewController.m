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
    //self.fetchedResultsController;
    UIBarButtonItem* buttonDone=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone:)];
    UIBarButtonItem* buttonAddNew=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAddNew:)];
    self.navigationItem.rightBarButtonItems=@[buttonDone,buttonAddNew];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];

    if (!self.person) {
        //if exist, then it is editing. If not - new object.
        NSManagedObjectContext* context=[[NVDataManager sharedManager] managedObjectContext];
        NVPerson* newPerson=[NSEntityDescription insertNewObjectForEntityForName:@"NVPerson" inManagedObjectContext:context];
        self.person=newPerson;
    } else{
       // self.person=[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
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
    
    return _fetchedResultsController;
}
*/
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.person.firstName length]>0) {
        //editing object
        //NSLog(@"asstudent %d asteacher %d",[self.person.coursesAsStudent count]>0,[self.person.coursesAsTeacher count]==0);
        return 1+([self.person.coursesAsStudent count]>0)+([self.person.coursesAsTeacher count]>0);
        
    } else {
        //create new
        return 1;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 4;
    } else if (section==1) {
        return [self.person.coursesAsStudent count];
    } else if (section==2) {
        return [self.person.coursesAsTeacher count];
    } else {
        return 0;
    }
    
}

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
                    customCell.textfield.text=self.fieldFirstName.text;
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
                    customCell.textfield.text=self.fieldFirstName.text;
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
                    customCell.textfield.text=self.fieldFirstName.text;
                }
                self.fieldMail=customCell.textfield;
            } break;
                
                
            default:
                break;
        }
        return customCell;
    }
    
    //configure standard cell
    static NSString* standartCellIdentifier=@"standardCell";
    cell=[tableView dequeueReusableCellWithIdentifier:standartCellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:standartCellIdentifier];
    }
    
    if (([self.person.coursesAsStudent count]>0) && ([self.person.coursesAsTeacher count]>0)) {
        if (indexPath.section==1) {
            cell.textLabel.text=[[[self.person.coursesAsStudent allObjects] objectAtIndex:indexPath.row] name];
        } else if (indexPath.section==2){
            cell.textLabel.text=[[[self.person.coursesAsTeacher allObjects] objectAtIndex:indexPath.row] name];
        }
    } else if ([self.person.coursesAsStudent count]>0){
        if (indexPath.section==1) {
            cell.textLabel.text=[[[self.person.coursesAsStudent allObjects] objectAtIndex:indexPath.row] name];
        }
    } else if ([self.person.coursesAsTeacher count]>0){
        if (indexPath.section==2){
            cell.textLabel.text=[[[self.person.coursesAsTeacher allObjects] objectAtIndex:indexPath.row] name];
        }

    }
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) actionDone:(UIBarButtonItem *)sender {
    //NSLog(@"name %@, lastname %@",self.person.firstName,self.person.lastName);
    NSError* error=[NSError errorWithDomain:@"nvpersonDetailVC" code:111 userInfo:nil];
    if (![[[NVDataManager sharedManager] managedObjectContext] save:&error]) {
        NSLog(@"error %@",[error description]);
    } else {
        NSLog(@"ok");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) actionAddNew:(UIBarButtonItem *)sender {
    UIAlertController* ac=[UIAlertController alertControllerWithTitle:@"Choose smth to add/edit" message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* asStudent=[UIAlertAction actionWithTitle:@"Add course for student" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self performSegueWithIdentifier:@"segueShowCourses" sender:nil];
    }];
    UIAlertAction* asTeacher=[UIAlertAction actionWithTitle:@"Add course for teacher" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
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
    } else if ([segue.identifier isEqualToString:@"segueAddTeacher"]) {
        NVCoursesToAddAsTeacherViewController* vc=(NVCoursesToAddAsTeacherViewController*)[segue.destinationViewController topViewController];
        vc.person=self.person;
        vc.delegate=self;
    }
}
@end
