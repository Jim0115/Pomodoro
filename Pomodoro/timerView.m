//
//  timerView.m
//  Pomodoro
//
//  Created by 王仕杰 on 4/7/16.
//  Copyright © 2016 王仕杰. All rights reserved.
//

#import "timerView.h"

IB_DESIGNABLE
@interface timerView ()

@end

@implementation timerView

- (void)drawRect:(CGRect)rect {
  NSLog(@"%f", self.percentage);
  const uint SPACE = 5;
  NSUInteger width = self.bounds.size.width - SPACE * 2;
  UIBezierPath* round = [[UIBezierPath alloc] init];
  [round addArcWithCenter:self.center
                   radius:width / 2
               startAngle:-M_PI_2
                 endAngle:M_PI * 2 * self.percentage - M_PI_2
                clockwise:YES];
  [[UIColor redColor] setStroke];
  round.lineWidth = 3;
  [round stroke];
}


@end
