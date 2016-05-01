//
//  RecordView.m
//  Pomodoro
//
//  Created by 王仕杰 on 5/1/16.
//  Copyright © 2016 王仕杰. All rights reserved.
//

#import "RecordView.h"

IB_DESIGNABLE
@implementation RecordView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
  static const CGFloat OFFSET = 10;
  static const CGFloat SPACE = 5;
  
//  CGFloat width = (self.bounds.size.width - OFFSET * 2 - SPACE * 5) / 5;
  CGFloat width = self.bounds.size.height / 2;
//  NSInteger nums = lround((self.bounds.size.width - OFFSET * 10) / width);
  NSInteger nums = 7;
  NSInteger times = self.times >= nums ? nums : self.times;
  [[UIColor redColor] set];
  NSMutableArray* paths = [NSMutableArray array];
  for (int i = 0; i < nums; i++) {
    UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(OFFSET + i * (width + SPACE), (self.bounds.size.height - width) / 2, width, width)];
    [path stroke];
    [paths addObject:path];
  }

  
  for (int i = 0; i < times; i++) {
    [((UIBezierPath *)paths[i]) fill];
  }
}


@end
