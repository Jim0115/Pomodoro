//
//  Record+CoreDataProperties.h
//  Pomodoro
//
//  Created by 王仕杰 on 5/2/16.
//  Copyright © 2016 王仕杰. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Record.h"
@class User;

NS_ASSUME_NONNULL_BEGIN

@interface Record (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *endtime;
@property (nullable, nonatomic, retain) NSString *starttime;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
