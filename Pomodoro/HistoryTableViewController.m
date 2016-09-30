//
//  HistoryTableViewController.m
//  Pomodoro
//
//  Created by 王仕杰 on 4/8/16.
//  Copyright © 2016 王仕杰. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "AppDelegate.h"
#import "RecordView.h"
#import "RecordCell.h"
#import "Record+CoreDataClass.h"
#import "DetailTableViewController.h"

@import CoreData;

@interface HistoryTableViewController ()

@property (nonatomic, readonly) NSManagedObjectContext* context;
//@property (nonatomic, readonly, copy) NSArray* records;
//@property (nonatomic, copy) NSArray* processedByDate;

@property (nonatomic, readonly) NSFetchedResultsController* fetchedResultController;

@property (nonatomic) id observer;

@end

@implementation HistoryTableViewController

#pragma mark - properties

@synthesize fetchedResultController = _fetchedResultController;

- (NSFetchedResultsController *)fetchedResultController {
  if (!_fetchedResultController) {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Record"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date"
                                                            ascending:YES]];
    
    _fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                   managedObjectContext:self.context
                                                                     sectionNameKeyPath:@"dateKey"
                                                                              cacheName:@"HISTORY_CACHE"];
    
    [_fetchedResultController performFetch:nil];
    
    
  }
  return _fetchedResultController;
}

#pragma mark - vc life cycle

- (void)viewDidLoad {
  [super viewDidLoad];
  if ([[NSBundle mainBundle].preferredLocalizations[0] containsString:@"en"]) {
    self.title = @"History";
  } else {
    self.title = @"历史";
  }
  
  __weak UITableView* weakView = self.tableView;
  
  self.observer = [[NSNotificationCenter defaultCenter] addObserverForName:@"count down finished"
                                                                    object:nil
                                                                     queue:[NSOperationQueue mainQueue]
                                                                usingBlock:^(NSNotification * _Nonnull note) {
                                                                  NSLog(@"%@", note.name);
                                                                  [weakView reloadData];
                                                                }];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:@"count down finished"
                                                object:nil];
}

#pragma mark - core date RW

- (NSManagedObjectContext *)context {
  return ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
}

//- (NSArray *)records {
//  NSArray* array;
//  
//  NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Record"];
//  request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date"
//                                                            ascending:false
//                                                             selector:@selector(compare:)]];
//  array = [self.context executeFetchRequest:request error:nil];
//  
//  //  return [[array reverseObjectEnumerator] allObjects];
//  return array;
//}

//- (NSArray *)processedByDate {
//  NSMutableArray* dates = [[NSMutableArray alloc] init];
//  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//  formatter.locale = [NSLocale autoupdatingCurrentLocale];
//  NSArray* records = self.records;
//  NSMutableArray* processed = [[NSMutableArray alloc] init];
//  formatter.dateFormat = @"yyyy MM dd";
//  for (id obj in records) {
//    if ([obj isKindOfClass: [Record class]]) {
//      Record* r = (Record *)obj;
//      NSString* s = [formatter stringFromDate:r.date];
//      NSUInteger index = [dates indexOfObject:s];
//      if (index > NSIntegerMax - 10) {
//        [dates addObject:s];
//        [processed addObject:[[NSMutableArray alloc] initWithObjects:r, nil]];
//      } else {
//        [((NSMutableArray *)processed[index]) addObject:r];
//      }
//    }
//  }
//  return processed;
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//  return self.processedByDate.count;
  return self.fetchedResultController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  //  return ((NSArray *)self.processedByDate[section]).count;
  return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recordCell"
                                                     forIndexPath:indexPath];
  
  //  Record* record = self.records[indexPath.row];
  
  //  NSString* info = [NSString stringWithFormat:@"%@ -- %@", record.starttime, record.endtime];
  //
  //  cell.textLabel.text = info;
  
  //  cell.times = self.records.count;
  //  cell.times = [self.tableView numberOfRowsInSection:indexPath.section]
  
//  cell.times = ((NSArray *)self.processedByDate[indexPath.section]).count;
  
//  cell.times = [self.fetchedResultController objectAtIndexPath:indexPath];
  
  cell.times = self.fetchedResultController.sections.count;
  
  return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//  return @"Title";
//  return self.fetchedResultController.sectionIndexTitles[section];
  return self.fetchedResultController.sections[section].name;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//  UILabel* header = [[UILabel alloc] init];
//  NSArray* currentMonthArray = (NSArray *)self.processedByDate[section];
//  Record* record = (Record *)currentMonthArray.firstObject;
//  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//  formatter.locale = [NSLocale autoupdatingCurrentLocale];
//  //  formatter.dateFormat = @"   MMM dd, yyyy";
//  formatter.dateStyle = NSDateFormatterMediumStyle;
//  header.text = [formatter stringFromDate:record.date];
//  header.backgroundColor = [UIColor whiteColor];
//  return header;
//}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//  if ([segue.destinationViewController isKindOfClass:[DetailTableViewController class]]) {
//    DetailTableViewController* destination = segue.destinationViewController;
//    destination.daily = self.processedByDate[[self.tableView indexPathForCell:sender].section];
//  }
//}


@end
