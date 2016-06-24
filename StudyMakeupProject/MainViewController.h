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

@interface MainViewController : UIViewController <popupDelegate> {
	UIImagePickerController *ipc;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIView *switchView;
@property (weak, nonatomic) IBOutlet UIView *weekView;
@property (weak, nonatomic) IBOutlet UIView *navigationBar;

@property (weak, nonatomic) IBOutlet UILabel *sinceTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *upToTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *sinceAMLbl;
@property (weak, nonatomic) IBOutlet UILabel *upToAMLbl;

@property (weak, nonatomic) IBOutlet UIButton *sinceDate;
@property (weak, nonatomic) IBOutlet UIButton *upToDate;

@property (weak, nonatomic) IBOutlet UIButton *backBtnL;

@property (strong, nonatomic) ViewController *popupVC;

- (IBAction)dayPicker:(id)sender;
- (IBAction)setTime:(id)sender;
- (IBAction)activeSwitch:(id)sender;

- (IBAction)backAction:(id)sender;


@end
