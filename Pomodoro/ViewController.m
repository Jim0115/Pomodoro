//
//  ViewController.m
//  Pomodoro
//
//  Created by 王仕杰 on 4/5/16.
//  Copyright © 2016 王仕杰. All rights reserved.
//

#import "ViewController.h"
#import "TimerView.h"
#import "Record+CoreDataClass.h"
#import "AppDelegate.h"

@import Social;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet TimerView *timerView;

@property (nonatomic) NSInteger time;
@property (nonatomic) NSInteger today;

@property (nonatomic, readonly) UILocalNotification* finishNotification;

@property (nonatomic) NSDateFormatter* minAndSecFormatter;

@property (nonatomic, readonly) NSManagedObjectContext* context;
@property (nonatomic, readonly, copy) NSArray* records;
@property (nonatomic) NSTimer* timer;

@property (nonatomic) NSDate* startDate;
@property (nonatomic) NSDate* finishDate;

@property (weak, nonatomic) UIViewController* popover;

@end

@implementation ViewController

static const NSUInteger DEFAULT_TIME = 10; //25 * 60;

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.timeLabel.hidden = YES;
  self.timeLabel.backgroundColor = [UIColor whiteColor];
  self.time = DEFAULT_TIME;
  
  self.timerView.percentage = 1;
  
  __weak ViewController* weakSelf = self;
  
  [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                    object:[UIApplication sharedApplication]
                                                     queue:[NSOperationQueue mainQueue]
                                                usingBlock:^(NSNotification * _Nonnull note) {
                                                  NSLog(@"%@", note.name);
                                                  
                                                  if (weakSelf.time < 0 || weakSelf.time > DEFAULT_TIME) {
                                                    //finished
                                                    [weakSelf resetStatus];
                                                    [weakSelf updateTitle];
                                                    [weakSelf appendCurrentNewRecord];
                                                  } else {
                                                    // not finish
                                                    weakSelf.time = [weakSelf.finishDate timeIntervalSinceNow];
                                                    [weakSelf.timerView setNeedsDisplay];
                                                  }
                                                }];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self updateTitle];
  
}
#pragma mark - UI

- (void)updateTitle {
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  formatter.dateFormat = @"yyyyMMdd";
  
  NSInteger today = 0;
  for (Record* record in self.records) {
    if ([[formatter stringFromDate:record.date] isEqualToString:[formatter stringFromDate:[NSDate date]]]) {
      today++;
    }
  }
  _today = today;
  
  if ([[NSBundle mainBundle].preferredLocalizations[0] containsString:@"en"]) {
    self.title = [NSString stringWithFormat:@"Today: %ld", (long)today];
  } else {
    self.title = [NSString stringWithFormat:@"今日: %ld", (long)today];
  }
}

- (void)resetStatus {
  [self appendCurrentNewRecord];
  [self updateTitle];
  
  self.time = DEFAULT_TIME;
  self.startButton.hidden = NO;
  self.timeLabel.hidden = YES;
  self.timerView.percentage = 1;
  self.finishDate = nil;
  
  NSNotification* noti = [NSNotification notificationWithName:@"count down finished" object:nil];
  [[NSNotificationCenter defaultCenter] postNotification:noti];
}

#pragma mark - LocalNotifiacation

- (UILocalNotification *)finishNotification { // factory
  
  UILocalNotification* noti = [[UILocalNotification alloc] init];
  
  noti.alertTitle = @"Pomodoro";
  noti.alertBody = @"Pomodoro Time Up!";
  
  return noti;
}



#pragma mark - Timer


- (IBAction)startTimer:(UIButton *)sender {
  // UI
  sender.hidden = YES;
  self.timeLabel.hidden = NO;
  
  // count down
  self.time = DEFAULT_TIME;
  [self countdown:nil];
  self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown:) userInfo:nil repeats:true];
  self.timer.tolerance = 0.1;
  
  // set date
  self.startDate = [NSDate date];
  self.finishDate = [NSDate dateWithTimeIntervalSinceNow:DEFAULT_TIME];
  
  // local notification
  NSLog(@"curr:%@ fin:%@", self.startDate, self.finishDate);
  UILocalNotification* noti = [self.finishNotification copy];
  noti.fireDate = _finishDate;
  [[UIApplication sharedApplication] scheduleLocalNotification:noti];
  
}

- (void)countdown:(NSTimer*)timer {
  self.timeLabel.text = [ViewController timeStringWith: --self.time];
  //  if (self.time % 3 == 0) {
  self.timerView.percentage = (double)self.time / (double)DEFAULT_TIME;
  //  }
  NSLog(@"time: %ld", (long)_time);
  if (self.time <= 0) {
    [timer invalidate];
    [self resetStatus];
  }
}

#pragma mark - Deal with strings

+ (NSString *)timeStringWith:(NSUInteger)timeUInt {
  
  NSUInteger second = timeUInt % 60;
  NSUInteger minute = timeUInt / 60;
  
  NSString* string;
  
  if (minute < 10) {
    string = [NSString stringWithFormat:@"0%lu:", (long)minute];
  } else {
    string = [NSString stringWithFormat:@"%lu:", (long)minute];
  }
  
  if (second < 10) {
    string = [NSString stringWithFormat:@"%@0%lu", string, (long)second];
  } else {
    string = [NSString stringWithFormat:@"%@%lu", string, (long)second];
  }
  
  return string;
}

#pragma mark - Core Data

- (void)appendCurrentNewRecord {
  Record* r = [NSEntityDescription insertNewObjectForEntityForName:@"Record"
                                            inManagedObjectContext:self.context];
  r.startTime = [self.minAndSecFormatter stringFromDate:self.startDate];
  r.endTime = [self.minAndSecFormatter stringFromDate:self.finishDate];
  r.date = [NSDate date];
  
  NSDateFormatter* formatter = [NSDateFormatter new];
  formatter.dateFormat = @"yyyyMMdd";
  
  r.dateKey = [formatter stringFromDate:[NSDate date]];
  
  [((AppDelegate *)[UIApplication sharedApplication].delegate) saveContext];
}

- (NSManagedObjectContext *)context {
  return ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
}

- (NSDateFormatter *)minAndSecFormatter {
  
  if (!_minAndSecFormatter) {
    _minAndSecFormatter = [[NSDateFormatter alloc] init];
  }
  
  _minAndSecFormatter.dateFormat = @"HH:mm";
  
  return _minAndSecFormatter;
}

- (NSArray *)records {
  NSArray* array;
  
  NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Record"];
  array = [self.context executeFetchRequest:request error:nil];
  
  return array;
}

#pragma mark - Share

- (IBAction)share:(UIBarButtonItem *)sender {
  if (self.popover) { return; }
  UIAlertController* alert;
  if ([[NSBundle mainBundle].preferredLocalizations[0] containsString:@"zh"]) {
    alert = [UIAlertController alertControllerWithTitle:@"分享到..."
                                        message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
  } else {
    alert = [UIAlertController alertControllerWithTitle:@"Share to..."
                                                message:nil
                                         preferredStyle:UIAlertControllerStyleActionSheet];
  }
  self.popover = alert;
  
  __weak ViewController* weakSelf = self;
  [alert addAction:[UIAlertAction actionWithTitle:@"Twitter"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction* action){ [weakSelf postShareMsgWithType:SLServiceTypeTwitter]; }]];
  [alert addAction:[UIAlertAction actionWithTitle:@"Facebook"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction* action){ [weakSelf postShareMsgWithType:SLServiceTypeFacebook]; }]];
  
  if ([[NSBundle mainBundle].preferredLocalizations[0] containsString:@"zh"]) {
    [alert addAction:[UIAlertAction actionWithTitle:@"新浪微博"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction* action){ [weakSelf postShareMsgWithType:SLServiceTypeSinaWeibo]; }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"腾讯微博"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction* action){ [weakSelf postShareMsgWithType:SLServiceTypeTencentWeibo]; }]];
  }
  if ([[NSBundle mainBundle].preferredLocalizations[0] containsString:@"zh"]) {
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
  } else {
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
  }
  
  alert.popoverPresentationController.barButtonItem = self.navigationItem.leftBarButtonItem;

  [self presentViewController:alert
                     animated:false
                   completion:nil];
}

- (void)postShareMsgWithType:(NSString *)type {
  SLComposeViewController* composeVC = [SLComposeViewController composeViewControllerForServiceType:type];
  [composeVC setInitialText:[NSString stringWithFormat:@"I've finished %ld Pomodoro today!\n#Pomodoro", _today]];
  [self presentViewController:composeVC
                     animated:YES
                   completion:nil];
}


#pragma mark - Gesture

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
  if (sender.state == UIGestureRecognizerStateRecognized) {
    if ([[UIDevice currentDevice].model isEqualToString:@"iPhone"]) {
      [self performSegueWithIdentifier:@"show history" sender:self];
    }
  }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  self.popover = segue.destinationViewController;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
  return !self.popover;
}

@end
