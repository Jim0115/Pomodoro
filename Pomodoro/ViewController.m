//
//  ViewController.m
//  Pomodoro
//
//  Created by 王仕杰 on 4/5/16.
//  Copyright © 2016 王仕杰. All rights reserved.
//

#import "ViewController.h"
#import "TimerView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (nonatomic) NSUInteger time;

@property (nonatomic, readonly) UILocalNotification* finishNotification;

@end

@implementation ViewController

const uint DEFAULT_TIME = 25 * 60;

- (void)viewDidLoad {
  [super viewDidLoad];
  self.timeLabel.hidden = YES;
  self.timeLabel.text = @"";
  self.time = DEFAULT_TIME;

  
  ((TimerView *)self.view).percentage = 1;
  
  [self.view setNeedsDisplay];
}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.title = @"hahaha";
}

- (UILocalNotification *)finishNotification { // lazt 
  UILocalNotification* noti = [[UILocalNotification alloc] init];
  
  noti.alertTitle = @"Pomodoro";
  noti.alertBody = @"Pomodoro Time Up!";
  
  return noti;
}

- (IBAction)startTimer:(UIButton *)sender {
  sender.hidden = YES;
  self.timeLabel.hidden = NO;
  [self countdown:nil];
  NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown:) userInfo:nil repeats:true];
  timer.tolerance = 0.1;
//  [self postNotification:self.finishNotification after:DEFAULT_TIME];
}

- (void)countdown:(NSTimer*)timer {
  self.timeLabel.text = [self toTimeStringWith: --self.time];
  if (self.time % 3 == 0) {
    ((TimerView *)self.view).percentage = (double)self.time / (double)DEFAULT_TIME;
    [self.view setNeedsDisplay];
  }
  if (self.time == 0) {
    [timer invalidate];
    [self countdownDidFinish];
  }
}

- (void)countdownDidFinish {
  self.time = DEFAULT_TIME;
  self.startButton.hidden = NO;
  self.timeLabel.hidden = YES;
  ((TimerView *)self.view).percentage = 1;
  [self.view setNeedsDisplay];
}

- (void)postNotification:(UILocalNotification *)notification after: (NSUInteger)time {
  [notification setFireDate:[NSDate dateWithTimeIntervalSinceNow:time]];
  [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (NSString *)toTimeStringWith:(NSUInteger)timeUInt {
  
  NSUInteger second = timeUInt % 60;
  NSUInteger minute = timeUInt / 60;
  
  NSString* string;
  
  if (minute < 10) {
    string = [NSString stringWithFormat:@"0%lu:", minute];
  } else {
    string = [NSString stringWithFormat:@"%lu:", minute];
  }
  
  if (second < 10) {
    string = [NSString stringWithFormat:@"%@0%lu", string, second];
  } else {
    string = [NSString stringWithFormat:@"%@%lu", string, second];
  }
  
  return string;
}

@end
