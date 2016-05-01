//
//  RecordCell.m
//  Pomodoro
//
//  Created by 王仕杰 on 5/1/16.
//  Copyright © 2016 王仕杰. All rights reserved.
//

#import "RecordCell.h"
#import "RecordView.h"

@interface RecordCell ()

@property (weak, nonatomic) IBOutlet RecordView *recordView;

@end

@implementation RecordCell

- (void)setTimes:(NSInteger)times {
  _times = times;
  self.recordView.times = times;
  [self.recordView setNeedsDisplay];
}

@end
