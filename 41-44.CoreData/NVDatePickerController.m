//
//  NVViewController.m
//  36. UIPopover
//
//  Created by Admin on 19.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "NVDatePickerController.h"
#import "NVPersonDetailViewController.h"
@interface NVDatePickerController ()

@end

@implementation NVDatePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.datePicker.datePickerMode=UIDatePickerModeDate;
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    if (self.initialDate) {
        [self.datePicker setDate:[formatter dateFromString:self.initialDate]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)actionValueChanged:(UIDatePicker *)sender {
    
    if (self.delegate) {
        self.delegate.fieldDateOfBirth.text=[self.formatter stringFromDate:sender.date];
        NSLog(@"sender:%@ text in textField %@",[self.formatter stringFromDate:sender.date],self.delegate.fieldDateOfBirth.text);
        self.delegate.person.dateOfBirth=sender.date;
    }
}

- (IBAction)actionDone:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
