//
//  ViewController.m
//  Pomodoro
//
//  Created by 王仕杰 on 4/5/16.
//  Copyright © 2016 王仕杰. All rights reserved.
//

#import "ViewController.h"
#import "TimerView.h"
#import "Record.h"
#import "AppDelegate.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet TimerView *timerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginButton;

@property (nonatomic) NSInteger time;

@property (nonatomic, readonly) UILocalNotification* finishNotification;

@property (nonatomic) NSDateFormatter* minAndSecFormatter;

@property (nonatomic, readonly) NSManagedObjectContext* context;
@property (nonatomic, readonly, copy) NSArray* records;
@property (nonatomic) NSTimer* timer;

@property (nonatomic) NSDate* startDate;
@property (nonatomic) NSDate* finishDate;

@end

@implementation ViewController

static const NSUInteger DEFAULT_TIME = 2; // 25 * 60;

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSUserDefaults* standard = [NSUserDefaults standardUserDefaults];
  NSLog(@"%@", [standard valueForKey:@"current username"]);
  
  if ([(NSString *)[standard valueForKey:@"current username"] isEqualToString:@""]) {
    self.loginButton.title = @"Login";
  } else {
    [self.loginButton setTitle:(NSString *)[standard valueForKey:@"current username"]];
  }

  self.timeLabel.hidden = YES;
  self.timeLabel.backgroundColor = [UIColor whiteColor];
  self.time = DEFAULT_TIME;
  
  self.timerView.percentage = 1;
  
  __weak ViewController* weakSelf = self;
  
  [[NSNotificationCenter defaultCenter] addObserverForName:@"resign active"
                                                    object:[UIApplication sharedApplication].delegate
                                                     queue:[NSOperationQueue mainQueue]
                                                usingBlock:^(NSNotification * _Nonnull note) {
                                                  NSLog(@"%@", note.name);
                                                }];
  
  [[NSNotificationCenter defaultCenter] addObserverForName:@"become active"
                                                    object:[UIApplication sharedApplication].delegate
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
                                                  NSLog(@"interval = %f", [weakSelf.finishDate timeIntervalSinceNow]);
                                                }];
  [[NSNotificationCenter defaultCenter] addObserverForName:@"login"
                                                    object:nil
                                                     queue:[NSOperationQueue mainQueue]
                                                usingBlock:^(NSNotification * _Nonnull noti) {
//                                                  NSLog(@"%@", noti.object[@"username"]);
//                                                  NSLog(@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"current username"]);
                                                  [self.loginButton setTitle:noti.object[@"username"]];
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

- (IBAction)showLogin:(UIBarButtonItem *)sender {
  if (![sender.title isEqualToString:@"Login"]) {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Log out?"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Conform"
                                             style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * _Nonnull action) {
                                             sender.title = @"Login";
                                             [[NSUserDefaults standardUserDefaults] setObject:@""
                                                                                       forKey:@"current username"];
                                           }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                             style:UIAlertActionStyleCancel
                                            handler:nil]];
    [self presentViewController:alert
                       animated:true
                     completion:nil];
  } else {
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"]
                       animated:true
                     completion:nil];
  }
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
  
//  Record* entity = [NSEntityDescription entityForName:@"Record"
//                                            inManagedObjectContext:self.context];
  
//  Record* r = [[Record alloc] initWithEntity:entity
//              insertIntoManagedObjectContext:self.context];
  Record* r = [NSEntityDescription insertNewObjectForEntityForName:@"Record"
                                            inManagedObjectContext:self.context];
  r.starttime = [self.minAndSecFormatter stringFromDate:self.startDate];
  r.endtime = [self.minAndSecFormatter stringFromDate:self.finishDate];
  r.date = [NSDate date];
//  r.user.name = [[NSUserDefaults standardUserDefaults] stringForKey:@"current username"];
#warning TODO
  
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

#pragma mark - Gesture

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
  if (sender.state == UIGestureRecognizerStateRecognized) {
    if ([[UIDevice currentDevice].model isEqualToString:@"iPhone"]) {
      [self performSegueWithIdentifier:@"show history" sender:self];
    }
  }
}

@end
