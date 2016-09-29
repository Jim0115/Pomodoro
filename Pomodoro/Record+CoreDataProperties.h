//
//  Record+CoreDataProperties.h
//  Pomodoro
//
//  Created by 王仕杰 on 29/09/2016.
//  Copyright © 2016 王仕杰. All rights reserved.
//

#import "Record+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Record (CoreDataProperties)

+ (NSFetchRequest<Record *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *endTime;
@property (nullable, nonatomic, copy) NSString *startTime;
@property (nullable, nonatomic, copy) NSString *dateKey;

@end

NS_ASSUME_NONNULL_END
