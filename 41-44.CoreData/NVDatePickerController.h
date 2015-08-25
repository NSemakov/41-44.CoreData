//
//  NVViewController.h
//  36. UIPopover
//
//  Created by Admin on 19.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NVPersonDetailViewController;
@interface NVDatePickerController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)actionValueChanged:(UIDatePicker *)sender;
- (IBAction)actionDone:(UIBarButtonItem *)sender;
@property (strong,nonatomic) NVPersonDetailViewController* delegate;
@property (strong,nonatomic) NSString* initialDate;
@property (strong,nonatomic) NSDateFormatter* formatter;
@end
