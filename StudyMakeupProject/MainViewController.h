//
//  MainViewController.h
//  StudyMakeupProject
//
//  Created by Rhinoda3 on 16.06.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "ViewController.h"
#import "WayPoint.h"

@interface MainViewController : UIViewController <popupDelegate> {

}

@property (weak, nonatomic) IBOutlet UITextField *infoLablEdit;

@property (weak, nonatomic) IBOutlet UILabel *sinceAMLbl;
@property (weak, nonatomic) IBOutlet UILabel *upToAMLbl;

@property (weak, nonatomic) IBOutlet UIButton *sinceDate;
@property (weak, nonatomic) IBOutlet UIButton *upToDate;

@property (weak, nonatomic) IBOutlet UIButton *vibroBtn;
@property (weak, nonatomic) IBOutlet UIButton *popupBtn;
@property (weak, nonatomic) IBOutlet UIButton *soundBtn;

@property (weak, nonatomic) IBOutlet UIButton *swithBtn;

@property (weak, nonatomic) IBOutlet UIButton *backBtnL;

@property (strong, nonatomic) ViewController *popupVC;

- (IBAction)dayPicker:(id)sender;
- (IBAction)setTime:(id)sender;
- (IBAction)activeSwitch:(id)sender;

- (IBAction)backAction:(id)sender;

@property (strong) WayPoint *wayPoint;

@property (strong) NSManagedObjectID *wayPointId;

- (void)replaceWayPoint:(WayPoint *)newWayPoint;
- (void)replaceWayPointID:(NSManagedObjectID *)newWayPointID;

@property NSManagedObjectContext *managedContext;

@end
