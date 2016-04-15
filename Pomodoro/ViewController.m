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

@property (nonatomic) NSInteger time;

@property (nonatomic, readonly) UILocalNotification* finishNotification;

@property (nonatomic) NSDateFormatter* minAndSecFormatter;

@property (nonatomic, readonly) NSManagedObjectContext* context;
@property (nonatomic, readonly, copy) NSArray* records;
@property (nonatomic) NSTimer* timer;

@property (nonatomic) NSDate* finishDate;

@end

@implementation ViewController

static const uint DEFAULT_TIME = 30;//25 * 60;

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.timeLabel.hidden = YES;
  self.time = DEFAULT_TIME;
  
  self.timerView.percentage = 1;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self updateTitle];
  
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
                                                  } else {
                                                    // not finish
                                                    weakSelf.time = [weakSelf.finishDate timeIntervalSinceNow];
                                                    [weakSelf.timerView setNeedsDisplay];
                                                  }
                                                  NSLog(@"interval = %f", [weakSelf.finishDate timeIntervalSinceNow]);
                                                }];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:@"resign active"];
  [[NSNotificationCenter defaultCenter] removeObserver:@"become active"];
}

- (void)updateTitle {
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  formatter.dateFormat = @"yyyyMMdd";
  
  NSInteger today = 0;
  for (Record* record in self.records) {
    if ([[formatter stringFromDate:record.date] isEqualToString:[formatter stringFromDate:[NSDate date]]]) {
      today++;
    }
  }
  
  if ([[NSBundle mainBundle].preferredLocalizations[0] isEqualToString:@"en"]) {
    self.title = [NSString stringWithFormat:@"Today: %ld", (long)today];
  } else {
    self.title = [NSString stringWithFormat:@"今日: %ld", (long)today];
  }
}

- (UILocalNotification *)finishNotification { // factory
  
  UILocalNotification* noti = [[UILocalNotification alloc] init];
  
  noti.alertTitle = @"Pomodoro";
  noti.alertBody = @"Pomodoro Time Up!";
  
  return noti;
}
/*
 
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
 }*/

- (IBAction)startTimer:(UIButton *)sender {
  // UI
  sender.hidden = YES;
  self.timeLabel.hidden = NO;
  
  // count down
  self.time = DEFAULT_TIME;
  [self countdown:nil];
  self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown:) userInfo:nil repeats:true];
  self.timer.tolerance = 0.1;
  
  // set finish date
  self.finishDate = [NSDate dateWithTimeIntervalSinceNow:DEFAULT_TIME];
  
  // local notification
  NSLog(@"curr:%@ fin:%@", [NSDate date], self.finishDate);
  UILocalNotification* noti = [self.finishNotification copy];
  noti.fireDate = _finishDate;
  [[UIApplication sharedApplication] scheduleLocalNotification:noti];
  
}

- (void)countdown:(NSTimer*)timer {
  self.timeLabel.text = [self timeStringWith: --self.time];
  //  if (self.time % 3 == 0) {
  self.timerView.percentage = (double)self.time / (double)DEFAULT_TIME;
  //  }
  NSLog(@"%lu", _time);
  if (self.time <= 0) {
    [timer invalidate];
    [self resetStatus];
  }
}

- (void)resetStatus {
  self.time = DEFAULT_TIME;
  self.startButton.hidden = NO;
  self.timeLabel.hidden = YES;
  self.timerView.percentage = 1;
  self.finishDate = nil;
  
  //  [self appendCurrentNewRecord];
  [self updateTitle];
}

/*
 - (void)appendCurrentNewRecord {
 
 NSEntityDescription* entity = [NSEntityDescription entityForName:@"Record"
 inManagedObjectContext:self.context];
 
 Record* r = [[Record alloc] initWithEntity:entity
 insertIntoManagedObjectContext:self.context];
 r.starttime = [self.minAndSecFormatter stringFromDate:[NSDate date]];
 r.endtime = [self.minAndSecFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:DEFAULT_TIME]];
 r.date = [NSDate date];
 
 [((AppDelegate *)[UIApplication sharedApplication].delegate) saveContext];
 }
 */

- (IBAction)showNoti:(id)sender {
  NSLog(@"%@", [[UIApplication sharedApplication] scheduledLocalNotifications]);
  UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Notificaitions"
                                                                  message:[NSString stringWithFormat:@"%@", [[UIApplication sharedApplication] scheduledLocalNotifications]] preferredStyle:UIAlertControllerStyleAlert];
  [alert addAction:[UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleCancel handler:nil]];
  [self presentViewController:alert animated:YES completion:nil];
}


- (NSString *)timeStringWith:(NSUInteger)timeUInt {
  
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

@end
