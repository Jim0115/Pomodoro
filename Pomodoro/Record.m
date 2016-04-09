//
//  Record.m
//  Pomodoro
//
//  Created by 王仕杰 on 4/8/16.
//  Copyright © 2016 王仕杰. All rights reserved.
//

#import "Record.h"

@implementation Record

-(NSString *)getMonthString {
//  NSArray* components = [self.date componentsSeparatedByString:@"-"];
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  formatter.dateFormat = @"yyyy MM";
  return [formatter stringFromDate:self.date];
}

@end
