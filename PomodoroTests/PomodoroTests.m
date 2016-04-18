//
//  PomodoroTests.m
//  PomodoroTests
//
//  Created by 王仕杰 on 4/18/16.
//  Copyright © 2016 王仕杰. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface PomodoroTests : XCTestCase

@end

@implementation PomodoroTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testExample {
  XCTAssertTrue([@"00:10" isEqualToString:[ViewController timeStringWith:10]], @"timeStringWith method error");
  XCTAssertTrue([@"00:00" isEqualToString:[ViewController timeStringWith:0]], @"timeStringWith method error");
  XCTAssertTrue([@"01:00" isEqualToString:[ViewController timeStringWith:60]], @"timeStringWith method error");
  XCTAssertTrue([@"10:00" isEqualToString:[ViewController timeStringWith:600]], @"timeStringWith method error");
  // This is an example of a functional test case.
  // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
  // This is an example of a performance test case.
  [self measureBlock:^{
    // Put the code you want to measure the time of here.
  }];
}

@end
