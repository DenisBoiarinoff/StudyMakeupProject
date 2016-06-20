//
//  MainViewController.m
//  StudyMakeupProject
//
//  Created by Rhinoda3 on 16.06.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController () <UIGestureRecognizerDelegate, UIPopoverPresentationControllerDelegate>

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIColor *activeDayColor;
@property (nonatomic, strong) UIColor *pasiveDayColor;

@end

@implementation MainViewController

static NSString *btnBackImgUrl = @"backWhite";
static NSString *btnBackImgUrl2 = @"pack_05";



//- (id)init
//{
////	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
//////		self = [super initWithNibName:@"MainViewController~iphone" bundle:nil];
////		self = [super initWithNibName:@"MainViewController~ipad" bundle:nil];
////	} else {
//////		self = [super initWithNibName:@"MainViewController~iphone" bundle:nil];
////		self = [super initWithNibName:@"MainViewController~ipad" bundle:nil];
////	}
//	if (self) { /* initialize other ivars */ }
//	return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];

	int parentWidth = [[UIScreen mainScreen] bounds].size.width;
	int parentHeight = [[UIScreen mainScreen] bounds].size.height;

	NSLog(@"screen size: width - %d height - %d", parentWidth, parentHeight);

	self.activeDayColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:1.];
	self.pasiveDayColor = [UIColor colorWithRed:161. green:161. blue:161. alpha:1.];

	UIImage *backImage = [UIImage imageNamed:btnBackImgUrl];

	CGRect backBtnFrame = CGRectMake(self.weekView.frame.origin.x,
									 (parentHeight * 0.03)/2,
									 parentWidth * 0.17,
									 parentHeight * 0.06);

	self.backBtn = [[UIButton alloc] init];
	[self.backBtn setFrame:backBtnFrame];
	[self.backBtn setTitle:@"Back" forState:UIControlStateNormal];
	[self.backBtn.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:0.55 * self.backBtn.frame.size.height]];
	[self.backBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
	[self.backBtn setImage:backImage forState:UIControlStateNormal];
	[self.backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, self.backBtn.frame.size.width * 0.80)];

	self.backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

//	[self.backBtn.layer setBorderWidth:2];
//	[self.backBtn.layer setBorderColor:([UIColor blackColor]).CGColor];

	[self.navigationBar addSubview:self.backBtn];

	UIButton *btn = [self.view viewWithTag:31];
	[btn setTitle:@"00 : 00" forState:UIControlStateNormal];
	btn = [self.view viewWithTag:32];
	[btn setTitle:@"00 : 00" forState:UIControlStateNormal];

//	[self.infoLabel setFont:[UIFont fontWithName:@"Arial" size:0.2 * self.infoLabel.superview.frame.size.height]];
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



- (IBAction)dayPicker:(id)sender {
	UIButton *btn = (UIButton *)sender;
	[btn setSelected:![btn isSelected]];

}

- (IBAction)setTime:(id)sender {

	NSLog(@"setTime");
	UIViewController *viewController = [[UIViewController alloc]init];

	UIButton *source = (UIButton *)sender;

	self.datepicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 350, 400)];

	NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"NL"];
	[self.datepicker setLocale:locale];
	self.datepicker.datePickerMode = UIDatePickerModeTime;
	self.datepicker.hidden = NO;
	self.datepicker.date = [NSDate date];

	if ([source tag] == 31) {
		[self.datepicker addTarget:self action:@selector(result1:) forControlEvents:UIControlEventValueChanged];
	} else {
		[self.datepicker addTarget:self action:@selector(result2:) forControlEvents:UIControlEventValueChanged];
	}

	[viewController.view addSubview:self.datepicker];

	//	UIButton *btn = [[UIButton alloc] init];
	//	[btn setBackgroundColor:[UIColor redColor]];
	//	[btn setTitle:@"OK" forState:UIControlStateNormal];
	//	[btn setFrame:CGRectMake(0, 0, 50, 50)];
	//	[btn addTarget:self
	//			action:@selector(closePopup)
	//  forControlEvents:UIControlEventTouchUpInside];
	//
	//	[viewController.view addSubview:btn];

	viewController.modalPresentationStyle = UIModalPresentationPopover;
	[self presentViewController:viewController animated:YES completion:nil];

	UIPopoverPresentationController *popController = [viewController popoverPresentationController];
	popController.permittedArrowDirections = UIPopoverArrowDirectionAny;

	popController.sourceView = [self.view viewWithTag:30];
	popController.sourceRect = source.frame;

	popController.delegate = self;

}

- (IBAction)activeSwitch:(id)sender {
	UIButton *btn = (UIButton *)sender;
	[btn setSelected:![btn isSelected]];
}

- (void) result1:(id) sender {

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"HH : mm"];
	NSString *strDate = [dateFormatter stringFromDate:((UIDatePicker *) sender).date];

	UIButton *btn = [self.view viewWithTag:31];
	[btn setTitle:strDate forState:UIControlStateNormal];
}

- (void) result2:(id) sender {

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"HH : mm"];
	NSString *strDate = [dateFormatter stringFromDate:((UIDatePicker *) sender).date];

	UIButton *btn = [self.view viewWithTag:32];
	[btn setTitle:strDate forState:UIControlStateNormal];
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

@end
