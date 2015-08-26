//
//  NVParentViewController.h
//  41-44.CoreData
//
//  Created by Admin on 24.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@interface NVParentViewController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDataSource,UITableViewDelegate ,UISearchBarDelegate>
@property (strong,nonatomic) NSFetchedResultsController*  fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak,nonatomic) IBOutlet UITableView* tableView;
@end
