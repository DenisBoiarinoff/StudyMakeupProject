//
//  MainViewController.m
//  StudyMakeupProject
//
//  Created by Rhinoda3 on 16.06.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import <sys/sysctl.h>
#include <sys/types.h>

#import "MainViewController.h"
#import "UIButton+Date.h"

@interface MainViewController () <UIPopoverPresentationControllerDelegate>

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) NSDate *curentDate;

@end

@implementation MainViewController

int activeBtnTag;

@synthesize wayPoint;
@synthesize wayPointId;

- (NSManagedObjectContext *)managedObjectContext {
	NSManagedObjectContext *context = nil;
	id delegate = [[UIApplication sharedApplication] delegate];
	if ([delegate performSelector:@selector(managedObjectContext)]) {
		context = [delegate managedObjectContext];
	}
	return context;
}

- (void) replaceWayPoint:(WayPoint *)newWayPoint {
	if (wayPoint) {
		[self.wayPoint setValue:[newWayPoint valueForKey:@"title"] forKey:@"title"];
		[self.wayPoint setValue:[newWayPoint valueForKey:@"sinceDate"] forKey:@"sinceDate"];
		[self.wayPoint setValue:[newWayPoint valueForKey:@"upToDate"] forKey:@"upToDate"];
		[self.wayPoint setValue:[newWayPoint valueForKey:@"weeksDays"] forKey:@"weeksDays"];
		[self.wayPoint setValue:[newWayPoint valueForKey:@"myWayPoint"] forKey:@"myWayPoint"];
		[self.wayPoint setValue:[newWayPoint valueForKey:@"features"] forKey:@"features"];
	} else {
		[self setWayPoint:newWayPoint];
	}
}

- (void) replaceWayPointID:(NSManagedObjectID *)newWayPointID {
	[self setWayPointId:newWayPointID];
}

#pragma mark - View Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

	NSLog(@"viewDidLoad");

	if (!self.popupVC) {
		self.popupVC = [[ViewController alloc] init];

		self.popupVC.delegate = self;

		self.popupVC.modalPresentationStyle = UIModalPresentationPopover;
	}
	int parentHeight = [[UIScreen mainScreen] bounds].size.height;
	int parentWidth = [[UIScreen mainScreen] bounds].size.width;

	NSString *deviceType = [UIDevice currentDevice].model;

	self.vibroBtn.titleLabel.font = [UIFont systemFontOfSize: parentHeight * 0.035];
	self.popupBtn.titleLabel.font = [UIFont systemFontOfSize: parentHeight * 0.035];
	self.soundBtn.titleLabel.font = [UIFont systemFontOfSize: parentHeight * 0.035];
	if ([deviceType isEqualToString:@"iPad"]) {
		NSLog(@"IPAD!!!");
		self.infoLablEdit.font = [UIFont systemFontOfSize: parentHeight * 0.04];
		self.backBtnL.titleLabel.font = [UIFont systemFontOfSize: parentHeight * 0.035];
		float leftInsent = parentWidth * 0.06;
		self.backBtnL.titleEdgeInsets = UIEdgeInsetsMake(0, leftInsent, 0, 0);


	}
	if ([deviceType isEqualToString:@"iPhone"]) {
		self.infoLablEdit.font = [UIFont systemFontOfSize: parentHeight * 0.03];
		self.backBtnL.titleLabel.font = [UIFont systemFontOfSize: parentHeight * 0.035];
		float leftInsent = parentWidth * 0.07;
		self.backBtnL.titleEdgeInsets = UIEdgeInsetsMake(0, leftInsent, 0, 0);
	} else {

	}

	self.infoLablEdit.adjustsFontSizeToFitWidth = true;

	[self.sinceDate setTitle:@"00 : 00" forState:UIControlStateNormal];
	NSLog(@"sinceDate text %@", [self.sinceDate.titleLabel text]);
	[self.sinceDate setDate:[NSDate date]];
	self.sinceDate.titleLabel.font = [UIFont systemFontOfSize: parentHeight * 0.06];
	self.sinceDate.titleLabel.adjustsFontSizeToFitWidth = true;

	[self.upToDate setTitle:@"00 : 00" forState:UIControlStateNormal];

	[self.upToDate setDate:[NSDate date]];
	self.upToDate.titleLabel.font = [UIFont systemFontOfSize: parentHeight * 0.06];
	self.upToDate.titleLabel.adjustsFontSizeToFitWidth = true;

	NSString *platform = [self platformRawString];

	for (int i = 51; i < 58; i++) {
		UIButton *btn = [self.view viewWithTag:i];
		btn.titleLabel.font = [UIFont systemFontOfSize: parentHeight * 0.03];

		if ([platform isEqualToString:@"iPhone4,1"]) {
			NSLog(@"iPhone 4S");
			btn.titleLabel.font = [UIFont systemFontOfSize: parentHeight * 0.035];
		}

	}

}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	NSLog(@"viewWillAppear");

	if (wayPointId) {
		[self prepareViewForEdit];
	} else {
		[self prepareViewForCreating];
	}

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Button Actions

- (IBAction)dayPicker:(id)sender {
	UIButton *btn = (UIButton *)sender;
	[btn setSelected:![btn isSelected]];

}

- (IBAction)setTime:(id)sender {

	UIButton *source = (UIButton *)sender;

	activeBtnTag = (int)[source tag];

	[self.popupVC chooseDate:source.date];

	[self presentViewController:self.popupVC animated:YES completion:nil];

	UIPopoverPresentationController *popController = [self.popupVC popoverPresentationController];
	popController.permittedArrowDirections = UIPopoverArrowDirectionAny;

	popController.sourceView = [self.view viewWithTag:30];
	popController.sourceRect = source.frame;

	popController.delegate = self;

}

- (IBAction)activeSwitch:(id)sender {
	UIButton *btn = (UIButton *)sender;
	[btn setSelected:![btn isSelected]];
}

- (IBAction)eventBtnAction:(id)sender {
	UIButton *btn = (UIButton *)sender;
	[btn setSelected:![btn isSelected]];
}

- (IBAction)backAction:(id)sender {

	[self backAndSaveRecord];

}

#pragma mark - Popup protocol delegate

- (void) cancelDate:(id) sender {
	[self saveRecord];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void) selectDate:(id) sender {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"hh : mm"];
	self.curentDate = self.popupVC.getDate;
	NSString *strDate = [dateFormatter stringFromDate:self.curentDate];
	NSLog(@"%@", strDate);

	UIButton *btn = [self.view viewWithTag:activeBtnTag];
	[btn setDate:self.curentDate];

	[self saveRecord];

	[btn setTitle:strDate forState:UIControlStateNormal];

	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *dateComponents = [gregorian components:(NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:self.curentDate];
	NSInteger hour = [dateComponents hour];
	NSLog(@"%ld", (long)hour);

	if ([btn tag] == 31) {
		if (hour >= 12) {
			[self.sinceAMLbl setText:@"PM"];
		} else {
			[self.sinceAMLbl setText:@"AM"];
		}
	}
	if ([btn tag] == 32){
		if (hour >= 12) {
			[self.upToAMLbl setText:@"PM"];
		} else {
			[self.upToAMLbl setText:@"AM"];
		}
	}

	[self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - Popover Presentation Controller Delegate

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
	// called when a Popover is dismissed
	NSLog(@"Popover was dismissed with external tap. Have a nice day!");
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
	// return YES if the Popover should be dismissed
	// return NO if the Popover should not be dismissed
	return YES;
}

- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController
		  willRepositionPopoverToRect:(inout CGRect *)rect
							   inView:(inout UIView *__autoreleasing  _Nonnull *)view
{
	// called when the Popover changes positon
}

# pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	[theTextField resignFirstResponder];
	return YES;
}

- (void) prepareViewForEdit {
	NSError *fetchError = nil;
	[self setWayPoint:[self.managedContext existingObjectWithID:wayPointId error:&fetchError]];

	[self.infoLablEdit setText:[self.wayPoint valueForKey:@"title"]];

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"hh : mm"];

	NSDate *sinceDate = [self.wayPoint valueForKey:@"sinceDate"];
	NSString *strDate = [dateFormatter stringFromDate:sinceDate];
	[self.sinceDate setTitle:strDate forState:UIControlStateNormal];
	//	[self.sinceDate.titleLabel setText:strDate];
	NSLog(@"sinceDate text %@", [self.sinceDate.titleLabel text]);
	[self.sinceDate setDate:sinceDate];

	NSDate *upToDate = [self.wayPoint valueForKey:@"upToDate"];
	strDate = [dateFormatter stringFromDate:upToDate];
	[self.upToDate setTitle:strDate forState:UIControlStateNormal];
	//	[self.upToDate.titleLabel setText:strDate];
	[self.upToDate setDate:upToDate];

	NSArray *weekDay = [self.wayPoint valueForKey:@"weeksDays"];
	for (int i = 51; i < 58; i++) {
		UIButton *dayBtn = [self.view viewWithTag:i];
		BOOL isSelected = [[weekDay objectAtIndex:i - 51] boolValue];
		[dayBtn setSelected:isSelected];
	}

	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *dateComponents = [gregorian components:(NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:sinceDate];
	NSInteger hour = [dateComponents hour];
	if (hour >= 12) {
		[self.sinceAMLbl setText:@"PM"];
	} else {
		[self.sinceAMLbl setText:@"AM"];
	}

	dateComponents = [gregorian components:(NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:upToDate];
	hour = [dateComponents hour];
	if (hour >= 12) {
		[self.upToAMLbl setText:@"PM"];
	} else {
		[self.upToAMLbl setText:@"AM"];
	}

	NSArray *features = [self.wayPoint valueForKey:@"features"];
//	NSLog(@"%@", features);
	for (int i = 71; i < 74; i++) {
		UIButton *dayBtn = [self.view viewWithTag:i];
		BOOL isSelected = [[features objectAtIndex:i - 71] boolValue];
		[dayBtn setSelected:isSelected];
	}

}

- (void) prepareViewForCreating {

	NSManagedObject *newWayPoint = [NSEntityDescription insertNewObjectForEntityForName:@"WayPoint" inManagedObjectContext:self.managedContext];
	[newWayPoint setValue:[NSDate date] forKey:@"sinceDate"];
	[newWayPoint setValue:[NSDate date] forKey:@"upToDate"];
	[newWayPoint setValue:@"" forKey:@"title"];

	NSMutableArray *weekArray = [[NSMutableArray alloc] init];
	for (int i = 1; i < 8; i++) {
		[weekArray addObject:[NSNumber numberWithBool:false]];
	}
	[newWayPoint setValue:weekArray forKey:@"weeksDays"];

	NSMutableArray *features = [[NSMutableArray alloc] init];
	for (int i = 1; i < 4; i++) {
		[features addObject:[NSNumber numberWithBool:false]];
	}
	[newWayPoint setValue:features forKey:@"features"];

	NSError *error = nil;
	// Save the object to persistent store
	if (![self.managedContext save:&error]) {
		NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
	}

	[self replaceWayPointID:[newWayPoint objectID]];

	[self prepareViewForEdit];
}

- (void) saveRecord {

	if (self.managedContext) {
		[wayPoint setValue:self.sinceDate.date forKey:@"sinceDate"];
		[wayPoint setValue:self.upToDate.date forKey:@"upToDate"];
		[wayPoint setValue:self.infoLablEdit.text forKey:@"title"];

		NSMutableArray *weekArray = [[NSMutableArray alloc] init];

		for (int i = 51; i < 58; i++) {
			UIButton *btn = [self.view viewWithTag:i];
			[weekArray addObject:[NSNumber numberWithBool:[btn isSelected]]];
		}
		[wayPoint setValue:weekArray forKey:@"weeksDays"];

		NSMutableArray *features = [[NSMutableArray alloc] init];

		for (int i = 71; i < 74; i++) {
			UIButton *btn = [self.view viewWithTag:i];
			[features addObject:[NSNumber numberWithBool:[btn isSelected]]];
		}
		[wayPoint setValue:features forKey:@"features"];
	} else {
		NSLog(@"!CONTEXT");
	}

	NSError *error = nil;
	// Save the object to persistent store
	if (![self.managedContext save:&error]) {
		NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
	}

}

- (void) backAndSaveRecord {

	NSString *value = [self.infoLablEdit.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if ([value isEqualToString:@""]) {
		UIAlertController *alertController = [UIAlertController
											  alertControllerWithTitle:@"Sorry but title is empty"
											  message:@"We can not save record with emti title, please enter title."
											  preferredStyle:UIAlertControllerStyleAlert];

		UIAlertAction *notAvaliable = [UIAlertAction actionWithTitle:@"Okay"
															   style:UIAlertActionStyleDefault
															 handler:^(UIAlertAction * action) {
															 }]; // 1
		[alertController addAction:notAvaliable];

		[self presentViewController:alertController animated:YES completion:nil];
		return;
	}

	[self saveRecord];

	[self.navigationController popViewControllerAnimated:YES];

}

- (NSString *)platformRawString {
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *platform = [NSString stringWithUTF8String:machine];
	free(machine);
	NSLog(@"%@",platform);
	return platform;
}

- (NSString *)platformNiceString {
	NSString *platform = [self platformRawString];
	if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
	if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
	if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
	if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
	if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
	if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
	if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
	if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
	if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
	if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
	if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
	if ([platform isEqualToString:@"iPad1,1"])      return @"iPad 1";
	if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
	if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
	if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
	if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
	if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (4G,2)";
	if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (4G,3)";
	if ([platform isEqualToString:@"i386"])         return @"Simulator";
	if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
	return platform;
}

@end
