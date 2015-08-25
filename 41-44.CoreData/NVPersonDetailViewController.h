//
//  NVPersonDetailViewController.h
//  41-44.CoreData
//
//  Created by Admin on 25.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NVPerson.h"
#import <CoreData/CoreData.h>
@interface NVPersonDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
- (IBAction)actionDone:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NVPerson* person;

@property (strong,nonatomic) UITextField* fieldFirstName;
@property (strong,nonatomic) UITextField*  fieldLastName;
@property (strong,nonatomic) UITextField*  fieldDateOfBirth;
@property (strong,nonatomic) UITextField*  fieldMail;
@property (strong,nonatomic) NSDateFormatter* formatter;
@end
