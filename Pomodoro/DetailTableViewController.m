//
//  DetailTableViewController.m
//  Pomodoro
//
//  Created by 王仕杰 on 5/1/16.
//  Copyright © 2016 王仕杰. All rights reserved.
//

#import "DetailTableViewController.h"
#import "Record+CoreDataClass.h"

#import "AppDelegate.h"

@interface DetailTableViewController ()

@property (nonatomic, readonly) NSFetchedResultsController* fetchResultController;

@end

@implementation DetailTableViewController

@synthesize fetchResultController = _fetchResultController;

- (NSFetchedResultsController *)fetchResultController {
  if (!_fetchResultController) {
    NSFetchRequest* request = [Record fetchRequest];
    request.predicate = [NSPredicate predicateWithFormat:@"dateKey = %@", _dateKey];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    _fetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                 managedObjectContext:((AppDelegate *)([UIApplication sharedApplication].delegate)).managedObjectContext
                                                                   sectionNameKeyPath:nil
                                                                            cacheName:nil];
    
    [_fetchResultController performFetch:nil];
  }
  return _fetchResultController;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.fetchResultController.sections[section] numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath:indexPath];
  
  Record* record = [self.fetchResultController objectAtIndexPath:indexPath];
  
  cell.textLabel.text = [NSString stringWithFormat:@"%@ -- %@", record.startTime, record.endTime];
  
  return cell;
}

@end
