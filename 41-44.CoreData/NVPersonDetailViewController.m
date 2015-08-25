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
typedef NS_ENUM(NSInteger, textFieldType){
    textFieldTypeFirstName,
    textFieldTypeLastName,
    textFieldTypeDateOfBirth,
    textFieldTypeMail
};
@interface NVPersonDetailViewController ()

@end

@implementation NVPersonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.formatter=[[NSDateFormatter alloc]init];
    [self.formatter setDateFormat:@"dd.MM.yyyy"];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    NSManagedObjectContext* context=[[NVDataManager sharedManager] managedObjectContext];
    NVPerson* newPerson=[NSEntityDescription insertNewObjectForEntityForName:@"NVPerson" inManagedObjectContext:context];
    self.person=newPerson;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
#warning dlfj
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell=nil;

    if (indexPath.section==0) {
        NVTableViewCellCustom* customCell=nil;
        switch (indexPath.row) {
            case textFieldTypeFirstName:{
                static NSString* cellFirstName=@"cellFirstName";
                customCell=[tableView dequeueReusableCellWithIdentifier:cellFirstName];
                if (self.fieldFirstName) {
                    customCell.textfield.text=self.fieldFirstName.text;
                }
                self.fieldFirstName=customCell.textfield;
                
            } break;
            case textFieldTypeLastName:{
                static NSString* cellLastName=@"cellLastName";
                customCell=[tableView dequeueReusableCellWithIdentifier:cellLastName];
                if (self.fieldLastName) {
                    customCell.textfield.text=self.fieldFirstName.text;
                }
                self.fieldLastName=customCell.textfield;
            } break;
            case textFieldTypeDateOfBirth:{
                static NSString* cellDateOfBirth=@"cellDateOfBirth";
                customCell=[tableView dequeueReusableCellWithIdentifier:cellDateOfBirth];
                if (self.fieldDateOfBirth) {
                    customCell.textfield.text=self.fieldFirstName.text;
                }
                self.fieldDateOfBirth=customCell.textfield;
            } break;
            case textFieldTypeMail:{
                static NSString* cellMail=@"cellMail";
                customCell=[tableView dequeueReusableCellWithIdentifier:cellMail];
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
    
    //configure standart cell
    static NSString* standartCellIdentifier=@"standartCell";
    cell=[tableView dequeueReusableCellWithIdentifier:standartCellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:standartCellIdentifier];
    }
    return cell;
    
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isEqual:self.fieldMail]) {
        
        return NO;
    } else {
        return YES;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:self.fieldFirstName]) {
        [self.person setValue:string forKey:@"firstName"];
        //self.person.firstName=textField.text;
    } else if ([textField isEqual:self.fieldLastName]){
        self.person.lastName=string;
    } else if ([textField isEqual:self.fieldDateOfBirth]){
        self.person.dateOfBirth=[self.formatter dateFromString:string];
    } else if ([textField isEqual:self.fieldMail]){
        self.person.mail=string;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.fieldFirstName]) {
        [self.fieldLastName becomeFirstResponder];
    } else if ([textField isEqual:self.fieldLastName]){
        [self.fieldDateOfBirth becomeFirstResponder];
    } else if ([textField isEqual:self.fieldDateOfBirth]){
        [self.fieldMail becomeFirstResponder];
    } else if ([textField isEqual:self.fieldMail]){
        [textField resignFirstResponder];
    }
    return YES;
}
#pragma mark - Actions
- (IBAction)actionDone:(UIBarButtonItem *)sender {
    NSLog(@"name %@, lastname %@",self.person.firstName,self.person.lastName);
    NSError* error=[NSError errorWithDomain:@"nvpersonDetailVC" code:111 userInfo:nil];
    if (![[[NVDataManager sharedManager] managedObjectContext] save:&error]) {
        NSLog(@"error %@",[error description]);
    } else {
        NSLog(@"ok");
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
