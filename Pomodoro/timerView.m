//
//  TimerView.m
//  Pomodoro
//
//  Created by 王仕杰 on 4/7/16.
//  Copyright © 2016 王仕杰. All rights reserved.
//

#import "TimerView.h"

IB_DESIGNABLE
@implementation TimerView

const uint SPACE = 5;

- (void)setPercentage:(double)percentage {
  _percentage = percentage;
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
  
  NSUInteger radius = self.bounds.size.width / 2 - SPACE;

  UIBezierPath* round = [[UIBezierPath alloc] init];
  [round addArcWithCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
                                    // NOT self.center    self.center is the center of self.frame
                   radius:radius
               startAngle:-M_PI_2
                 endAngle:-M_PI_2 + M_PI * 2 * self.percentage
                clockwise:YES];
  [[UIColor redColor] setStroke];
  round.lineWidth = 3;
  [round stroke];
}


@end
