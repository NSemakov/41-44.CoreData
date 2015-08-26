//
//  NVAllPersonsViewController.h
//  41-44.CoreData
//
//  Created by Admin on 24.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "NVParentViewController.h"

@interface NVAllTeachersViewController : NVParentViewController 
- (IBAction)actionAddNewPerson:(UIBarButtonItem *)sender;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic) NSPredicate* predicate;
@end
