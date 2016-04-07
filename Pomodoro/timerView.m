//
//  timerView.m
//  Pomodoro
//
//  Created by 王仕杰 on 4/7/16.
//  Copyright © 2016 王仕杰. All rights reserved.
//

#import "timerView.h"

@implementation timerView

- (void)drawRect:(CGRect)rect {
  NSLog(@"%f", self.angle / 180 * M_PI);
  const uint SPACE = 5;
  NSUInteger width = self.bounds.size.width - SPACE * 2;
  UIBezierPath* round = [[UIBezierPath alloc] init];
  [round addArcWithCenter:self.center
                                  radius:width / 2
                              startAngle:M_PI_2 * 3
                                endAngle:M_PI_2 * 3 - 0.0001 - self.angle / 180 * M_PI
                               clockwise:YES];
  [[UIColor redColor] setStroke];
  round.lineWidth = 3;
  [round stroke];
}


@end
