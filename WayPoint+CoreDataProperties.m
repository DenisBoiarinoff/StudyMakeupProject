//
//  WayPoint+CoreDataProperties.m
//  StudyMakeupProject
//
//  Created by Rhinoda3 on 24.06.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "WayPoint+CoreDataProperties.h"

@implementation WayPoint (CoreDataProperties)

@dynamic title;
@dynamic sinceDate;
@dynamic upToDate;
@dynamic weeksDays;
@dynamic myWayPoint;
@dynamic features;

@end

@implementation WeeksDays

+ (Class)transformedValueClass
{
	return [NSArray class];
}

+ (BOOL)allowsReverseTransformation
{
	return YES;
}

- (id)transformedValue:(id)value
{
	return [NSKeyedArchiver archivedDataWithRootObject:value];
}

- (id)reverseTransformedValue:(id)value
{
	return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end

@implementation MyWayPoint

+ (Class)transformedValueClass
{
	return [NSArray class];
}

+ (BOOL)allowsReverseTransformation
{
	return YES;
}

- (id)transformedValue:(id)value
{
	return [NSKeyedArchiver archivedDataWithRootObject:value];
}

- (id)reverseTransformedValue:(id)value
{
	return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end

@implementation Features

+ (Class)transformedValueClass
{
	return [NSArray class];
}

+ (BOOL)allowsReverseTransformation
{
	return YES;
}

- (id)transformedValue:(id)value
{
	return [NSKeyedArchiver archivedDataWithRootObject:value];
}

- (id)reverseTransformedValue:(id)value
{
	return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end