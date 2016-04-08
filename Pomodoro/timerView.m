//
//  TimerView.m
//  Pomodoro
//
//  Created by 王仕杰 on 4/7/16.
//  Copyright © 2016 王仕杰. All rights reserved.
//

#import "TimerView.h"

IB_DESIGNABLE
@interface TimerView ()

@end

@implementation TimerView

const uint SPACE = 5;

- (void)drawRect:(CGRect)rect {
  
  NSUInteger width;
  
  if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]) {
    width = self.bounds.size.width / 4;
  } else {
    width = self.bounds.size.width / 2 - SPACE * 2;
  }

  UIBezierPath* round = [[UIBezierPath alloc] init];
  [round addArcWithCenter:self.center
                   radius:width
               startAngle:-M_PI_2
                 endAngle:-M_PI_2 + M_PI * 2 * self.percentage
                clockwise:YES];
  [[UIColor redColor] setStroke];
  round.lineWidth = 3;
  [round stroke];
}


@end
