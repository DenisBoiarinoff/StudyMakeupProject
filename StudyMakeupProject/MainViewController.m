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

- (void)viewDidLoad {
    [super viewDidLoad];

	if (!self.popupVC) {
		self.popupVC = [[ViewController alloc] init];

		self.popupVC.delegate = self;

		self.popupVC.modalPresentationStyle = UIModalPresentationPopover;
	}

	int parentWidth = [[UIScreen mainScreen] bounds].size.width;
	int parentHeight = [[UIScreen mainScreen] bounds].size.height;

	NSLog(@"screen size: width - %d height - %d", parentWidth, parentHeight);

	NSString *deviceType = [UIDevice currentDevice].model;
	NSLog(@"%@",deviceType);


	if([deviceType isEqualToString:@"iPad"]) {
		self.infoLabel.font = [UIFont systemFontOfSize: parentHeight * 0.04	];
	}

	[self.sinceDate setTitle:@"00 : 00" forState:UIControlStateNormal];
	[self.sinceDate setDate:[NSDate date]];
	self.sinceDate.titleLabel.font = [UIFont systemFontOfSize: parentHeight * 0.06];
	self.sinceDate.titleLabel.adjustsFontSizeToFitWidth = true;
//	[self.sinceDate.layer setBorderWidth:1];
//	[self.sinceDate.layer setBorderColor:([UIColor blackColor]).CGColor];


	[self.upToDate setTitle:@"00 : 00" forState:UIControlStateNormal];
	[self.upToDate setDate:[NSDate date]];
	self.upToDate.titleLabel.font = [UIFont systemFontOfSize: parentHeight * 0.06];
	self.upToDate.titleLabel.adjustsFontSizeToFitWidth = true;

	NSString *platform = [self platformRawString];

	NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
	NSLog(@"%@",iOSVersion);
	NSLog(@"%@",[self platformRawString]);

	for (int i = 51; i < 58; i++) {
		UIButton *btn = [self.view viewWithTag:i];
		btn.titleLabel.font = [UIFont systemFontOfSize: parentHeight * 0.03];

		if ([platform isEqualToString:@"iPhone4,1"]) {
			NSLog(@"iPhone 4S");
			btn.titleLabel.font = [UIFont systemFontOfSize: parentHeight * 0.035];
		}

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
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Popup protocol delegate

- (void) cancelDate:(id) sender {
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
