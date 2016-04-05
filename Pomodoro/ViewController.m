//
//  ViewController.m
//  Pomodoro
//
//  Created by 王仕杰 on 4/5/16.
//  Copyright © 2016 王仕杰. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (nonatomic) NSUInteger time;

@end

@implementation ViewController

const uint DEFAULT_TIME = 10;
int count = 0;

- (void)viewDidLoad {
  [super viewDidLoad];
  self.timeLabel.hidden = YES;
  self.timeLabel.text = @"";
  self.time = DEFAULT_TIME;
  // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)startTimer:(UIButton *)sender {
  sender.hidden = YES;
  self.timeLabel.hidden = NO;
  [self countdown:nil];
  self.timeLabel.text = [NSString stringWithFormat:@"%lu", self.time];
  NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown:) userInfo:nil repeats:true];
  timer.tolerance = 0.1;
}

- (void)countdown:(NSTimer*)timer {
//  NSLog(@"%d", count++);
  self.timeLabel.text = [NSString stringWithFormat:@"%lu", self.time - 1];
  self.time--;
  NSLog(@"%lu", self.time);
  if (self.time == 0) {
    [timer invalidate];
    [self countdownDidFinish];
  }
}

- (void)countdownDidFinish {
  self.time = DEFAULT_TIME;
  self.startButton.hidden = NO;
  self.timeLabel.hidden = YES;
}

@end
