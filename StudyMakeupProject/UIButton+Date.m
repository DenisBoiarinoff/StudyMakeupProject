//
//  UIButton+Date.m
//  StudyMakeupProject
//
//  Created by Rhinoda3 on 23.06.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import "UIButton+Date.h"

#import <objc/runtime.h>

static const void *dateKey = &dateKey;

@implementation UIButton (Date)

- (void) setDate:(NSDate *)date
{
	objc_setAssociatedObject(self, dateKey, date, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDate *)date
{
	return objc_getAssociatedObject(self, dateKey);
}

@end
