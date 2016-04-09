//
//  Record+CoreDataProperties.h
//  Pomodoro
//
//  Created by 王仕杰 on 4/8/16.
//  Copyright © 2016 王仕杰. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Record.h"

NS_ASSUME_NONNULL_BEGIN

@interface Record (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *endtime;
@property (nullable, nonatomic, retain) NSString *starttime;

@end

NS_ASSUME_NONNULL_END
