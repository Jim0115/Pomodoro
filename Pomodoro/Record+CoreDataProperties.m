//
//  Record+CoreDataProperties.m
//  Pomodoro
//
//  Created by 王仕杰 on 29/09/2016.
//  Copyright © 2016 王仕杰. All rights reserved.
//

#import "Record+CoreDataProperties.h"

@implementation Record (CoreDataProperties)

+ (NSFetchRequest<Record *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Record"];
}

@dynamic date;
@dynamic endTime;
@dynamic startTime;
@dynamic dateKey;

@end
