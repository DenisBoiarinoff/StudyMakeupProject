//
//  WayPoint+CoreDataProperties.h
//  StudyMakeupProject
//
//  Created by Rhinoda3 on 24.06.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "WayPoint.h"

NS_ASSUME_NONNULL_BEGIN

@interface WayPoint (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSDate *sinceDate;
@property (nullable, nonatomic, retain) NSDate *upToDate;
@property (nullable, nonatomic, retain) id weeksDays;
@property (nullable, nonatomic, retain) id myWayPoint;
@property (nullable, nonatomic, retain) id features;

@end

NS_ASSUME_NONNULL_END

@interface WeeksDays : NSValueTransformer

@end

@interface MyWayPoint : NSValueTransformer

@end

@interface Features : NSValueTransformer

@end