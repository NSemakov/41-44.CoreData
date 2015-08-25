//
//  NVPersonDetailViewController.m
//  41-44.CoreData
//
//  Created by Admin on 25.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "NVCourseDetailViewController.h"
#import "NVCourse.h"
#import "NVPerson.h"
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
@interface NVCourseDetailViewController ()

@end

@implementation NVCourseDetailViewController
@synthesize fetchedResultsController=_fetchedResultsController;
- (void)viewDidLoad {
    [super viewDidLoad];

    //self.fetchedResultsController;
    UIBarButtonItem* buttonDone=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone:)];
    UIBarButtonItem* buttonAddNew=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAddNew:)];
    self.navigationItem.rightBarButtonItems=@[buttonDone,buttonAddNew];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];


    //if exist, then it is editing. If not - new object.
    NSManagedObjectContext* context=[[NVDataManager sharedManager] managedObjectContext];
    NVCourse* newCourse=[NSEntityDescription insertNewObjectForEntityForName:@"NVCourse" inManagedObjectContext:context];
    self.course=newCourse;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.course.students) {
        //editing object
        //NSLog(@"asstudent %d asteacher %d",[self.person.coursesAsStudent count]>0,[self.person.coursesAsTeacher count]==0);
        return 1+([self.course.students count]>0)+([self.course.teachers count]>0);
        
    } else {
        //create new
        return 1;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    } else if (section==1) {
        return [self.course.students count];
    } else if (section==2) {
        return [self.course.teachers count];
    } else {
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell=nil;

    if (indexPath.section==0 && indexPath.row==0) {
        NVTableViewCellCustom* customCell=nil;

        static NSString* cellFirstName=@"cellName";
        customCell=[tableView dequeueReusableCellWithIdentifier:cellFirstName];

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
    
    if (([self.course.students count]>0) && ([self.course.teachers count]>0)) {
        if (indexPath.section==1) {
            cell.textLabel.text=[[[self.course.students allObjects] objectAtIndex:indexPath.row] firstName];
        } else if (indexPath.section==2){
            cell.textLabel.text=[[[self.course.teachers allObjects] objectAtIndex:indexPath.row] firstName];
        }
    } else if ([self.course.students count]>0){
        if (indexPath.section==1) {
            cell.textLabel.text=[[[self.course.students allObjects] objectAtIndex:indexPath.row] firstName];
        }
    } else if ([self.course.teachers count]>0){
        if (indexPath.section==2){
            cell.textLabel.text=[[[self.course.teachers allObjects] objectAtIndex:indexPath.row] firstName];
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
#pragma mark - Actions
- (IBAction)actionCancelButton:(UIBarButtonItem *)sender {
    [[[NVDataManager sharedManager] managedObjectContext] rollback];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) actionDone:(UIBarButtonItem *)sender {
    //NSLog(@"name %@, lastname %@",self.person.firstName,self.person.lastName);
    NSError* error=[NSError errorWithDomain:@"addCourseDetailVC" code:111 userInfo:nil];
    if (![[[NVDataManager sharedManager] managedObjectContext] save:&error]) {
        NSLog(@"error %@",[error description]);
    } else {
        NSLog(@"ok");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) actionAddNew:(UIBarButtonItem *)sender {
    UIAlertController* ac=[UIAlertController alertControllerWithTitle:@"Choose smth to add/edit" message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* asStudent=[UIAlertAction actionWithTitle:@"Add student" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self performSegueWithIdentifier:@"segueShowCourses" sender:nil];
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
/*
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
    }
}
 */
@end
