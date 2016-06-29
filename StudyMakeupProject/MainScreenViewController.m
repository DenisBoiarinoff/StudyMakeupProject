//
//  MainScreenViewController.m
//  StudyMakeupProject
//
//  Created by Rhinoda3 on 23.06.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import "MainScreenViewController.h"
#import "MainViewController.h"
#import "PointTableViewCell.h"
#import "WayPoint.h"


@interface MainScreenViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong)  NSManagedObjectContext *context;

@property (strong) NSMutableArray *points;

@property (strong, nonatomic) MainViewController *mvController;

@property WayPoint *selectWayPoint;

@end

@implementation MainScreenViewController

NSArray *tableData;

NSArray *imgArray;

int parentWidth;
int parentHeight;

NSString *soundImgUrl = @"soundEventPad";
NSString *popupImgUrl = @"popupEventPad";
NSString *vibroImgUrl = @"vibroEventPad";

static NSString *pointCellIdentifier = @"PointTableViewCell";

- (NSManagedObjectContext *)managedObjectContext {
	NSManagedObjectContext *context = nil;
	id delegate = [[UIApplication sharedApplication] delegate];
	if ([delegate performSelector:@selector(managedObjectContext)]) {
		context = [delegate managedObjectContext];
	}
	return context;
}

#pragma mark - View Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

	[self.tableView registerNib:[UINib nibWithNibName:@"PointTableViewCell" bundle:nil] forCellReuseIdentifier:pointCellIdentifier];

	self.context = [self managedObjectContext];

	parentWidth = [[UIScreen mainScreen] bounds].size.width;
	parentHeight = [[UIScreen mainScreen] bounds].size.height;

//	NSLog(@"parent size: width - %d, height - %d",  parentWidth, parentHeight);

	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 0.26 * parentHeight;
	self.tableView.sectionHeaderHeight = 0.1 * parentHeight;

	[self.tableView setSeparatorColor:[UIColor grayColor]];
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];

	NSString *deviceType = [UIDevice currentDevice].model;

	self.addBtn.titleLabel.font = [UIFont systemFontOfSize: parentHeight * 0.035];
	if ([deviceType isEqualToString:@"iPhone"]) {
		self.backBtn.titleLabel.font = [UIFont systemFontOfSize: parentHeight * 0.035];
		float leftInsent = parentWidth * 0.07;
		self.backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, leftInsent, 0, 0);
	}

	imgArray = [[NSArray alloc] initWithObjects:vibroImgUrl, soundImgUrl, popupImgUrl, nil];

}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	// Fetch the devices from persistent data store
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"WayPoint"];
	[fetchRequest setResultType:NSManagedObjectResultType];
	[fetchRequest setReturnsDistinctResults:YES];
	[fetchRequest setIncludesPendingChanges:YES];

	if (self.points) {
		[self.points removeAllObjects];
	}
	self.points = [[self.context executeFetchRequest:fetchRequest error:nil] mutableCopy];

	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate/Data source

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Return NO if you do not want the specified item to be editable.
	return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 0.26 * parentHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	PointTableViewCell *pointCell = [tableView dequeueReusableCellWithIdentifier:pointCellIdentifier];

	if (pointCell == nil) {
		pointCell = [[PointTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pointCellIdentifier];
	}

	NSLog(@"constraint %f", pointCell.titleWidth.constant );
	NSLog(@"constraint %f", pointCell.titleWidth.multiplier );

//	pointCell.titleWidth.constant = -1 * 0.3 * [[UIScreen mainScreen] bounds].size.width;
//	pointCell.titleWidth.constant = - 1 * 0.1 * [[UIScreen mainScreen] bounds].size.width;
//	pointCell.titleWidth.constant = -1 * 0.1 * [[UIScreen mainScreen] bounds].size.width;
//	pointCell.titleWidth.constant = -1 * 1 * pointCell.titleLabel.frame.size.width;
//	pointCell.titleWidth.constant = -1 * 2 * [[UIScreen mainScreen] bounds].size.width;
//	pointCell.titleWidth.constant = +1 * 0.1 * [[UIScreen mainScreen] bounds].size.width;
//	pointCell.titleWidth.constant = - pointCell.titleWidth.constant;
	NSLog(@"constraint %f", pointCell.titleWidth.constant );





	[pointCell.toEditBtn setTag:indexPath.row];

	[pointCell.toEditBtn addTarget:self
							action:@selector(toEditRecord:)
				  forControlEvents:UIControlEventTouchUpInside];

	WayPoint* pnt = [self.points objectAtIndex:indexPath.row];

	NSString *title = [pnt valueForKey:@"title"];
	[pointCell.titleLabel setText:title];

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"hh : mm"];

	NSDate *sinceDate = [pnt valueForKey:@"sinceDate"];
	NSString *strDate = [dateFormatter stringFromDate:sinceDate];
	[pointCell.sinceTime setText:strDate];

	NSDate *upToDate = [pnt valueForKey:@"upToDate"];
	strDate = [dateFormatter stringFromDate:upToDate];
	[pointCell.upToTime setText:strDate];

	NSArray *weekDay = [pnt valueForKey:@"weeksDays"];
	for (int i = 21; i < 28; i++) {
		UILabel *dayLbl = [pointCell viewWithTag:i];
		BOOL b = [[weekDay objectAtIndex:i - 21] boolValue];
		if (b) {
			[dayLbl setTextColor:[UIColor blackColor]];
		} else {
			[dayLbl setTextColor:[UIColor grayColor]];
//			[dayLbl setTextColor:[UIColor colorWithRed:83 green:83 blue:83 alpha:1.]];
		}
	}

	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *dateComponents = [gregorian components:(NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:sinceDate];
	NSInteger hour = [dateComponents hour];
	if (hour >= 12) {
		[pointCell.sinceAMLabel setText:@"PM"];
	} else {
		[pointCell.sinceAMLabel setText:@"AM"];
	}

	dateComponents = [gregorian components:(NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:upToDate];
	hour = [dateComponents hour];
	if (hour >= 12) {
		[pointCell.upToAMLabel setText:@"PM"];
	} else {
		[pointCell.upToAMLabel setText:@"AM"];
	}

	NSArray *features = [pnt valueForKey:@"features"];
//	NSLog(@"%@", features);
	for (int i = 101; i < 104; i++) {
		UIImageView *imgView = [pointCell.titleView viewWithTag:i];
		[imgView setHidden:NO];
	}

	int tag = 101;
	for (int i = 0; i < 3; i++) {
		UIImageView *imgView = [pointCell viewWithTag:tag];
		BOOL b = [[features objectAtIndex:i] boolValue];
//		NSLog(@"tag - %d, i - %d", tag, i);
//		NSLog(@"b - %s",b ? "true" : "false");
		if (!b) {
			[imgView setHidden:YES];
			tag++;
		}
	}

	NSString *deviceType = [UIDevice currentDevice].model;

	float multiplier = 0.885;

	tag = 103;
	for (int i = 0; i < 3; i++) {
		BOOL b = [[features objectAtIndex:i] boolValue];
		if (b) {
			if ([deviceType isEqualToString:@"iPad"]) {
				multiplier = multiplier - 0.05;
			} else {
				multiplier = multiplier - 0.071;
			}

			[[pointCell viewWithTag:tag] setImage:[UIImage imageNamed:[imgArray objectAtIndex:i]]];
			tag--;
		}
	}

	[pointCell removeConstraint:pointCell.titleWidth];

	pointCell.titleWidth = [NSLayoutConstraint constraintWithItem:pointCell.titleLabel
														attribute:NSLayoutAttributeWidth
														relatedBy:NSLayoutRelationEqual
														   toItem:pointCell.titleView
														attribute:NSLayoutAttributeWidth
													   multiplier:multiplier
														 constant:0];

	NSLog(@"constraint %f", pointCell.titleWidth.constant );

	[pointCell addConstraint:pointCell.titleWidth];

	return pointCell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	parentWidth = [[UIScreen mainScreen] bounds].size.width;
	parentHeight = [[UIScreen mainScreen] bounds].size.height;

	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, parentHeight * 0.1)];
	/* Create custom view to display section header... */
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, parentHeight * 0.1)];
	[label setFont:[UIFont boldSystemFontOfSize:parentHeight * 0.03]];
	NSString *string = @"From work to home";
	/* Section header is in 0th index... */
	[label setText:string];
	[label setTextAlignment:NSTextAlignmentCenter];
	[view addSubview:label];
	[view setBackgroundColor:[UIColor whiteColor]]; //your background color...
	return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.points count];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

# pragma mark - Button Actions

- (IBAction)addAction:(id)sender {
	WayPoint *newPoint1 = [NSEntityDescription insertNewObjectForEntityForName:@"WayPoint" inManagedObjectContext:self.context];

	// If appropriate, configure the new managed object.
	// Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
	newPoint1.sinceDate = [NSDate date];
	newPoint1.upToDate = [NSDate date];
	newPoint1.title = @"On a bus stop just in time";

	NSArray *activeDay1 = [[NSArray alloc] initWithObjects:[NSNumber numberWithBool:YES],
						 [NSNumber numberWithBool:NO],
						 [NSNumber numberWithBool:YES],
						 [NSNumber numberWithBool:NO],
						 [NSNumber numberWithBool:NO],
						 [NSNumber numberWithBool:YES],
						 [NSNumber numberWithBool:YES],
						 nil];
	newPoint1.weeksDays = [NSArray arrayWithArray:activeDay1];


	NSMutableArray *numbersArray = [NSMutableArray array];
	for (int i = 0; i < 2; i++) {
		[numbersArray addObject:[NSNumber numberWithInteger:arc4random_uniform(100)]];
	}
	newPoint1.myWayPoint = [NSArray arrayWithArray:numbersArray];

	NSArray *activeFeatures1 = [[NSArray alloc] initWithObjects:[NSNumber numberWithBool:YES],
							   [NSNumber numberWithBool:NO],
							   [NSNumber numberWithBool:NO],
							   nil];
	newPoint1.features = [NSArray arrayWithArray:activeFeatures1];

	WayPoint *newPoint2 = [NSEntityDescription insertNewObjectForEntityForName:@"WayPoint" inManagedObjectContext:self.context];

	// If appropriate, configure the new managed object.
	// Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
	newPoint2.sinceDate = [NSDate date];
	newPoint2.upToDate = [NSDate date];
	newPoint2.title = @"Drink cofe with friends";

	NSArray *activeDay2 = [[NSArray alloc] initWithObjects:[NSNumber numberWithBool:YES],
						  [NSNumber numberWithBool:NO],
						  [NSNumber numberWithBool:YES],
						  [NSNumber numberWithBool:YES],
						  [NSNumber numberWithBool:NO],
						  [NSNumber numberWithBool:YES],
						  [NSNumber numberWithBool:YES],
						  nil];
	newPoint2.weeksDays = [NSArray arrayWithArray:activeDay2];

	newPoint2.myWayPoint = [NSArray arrayWithArray:numbersArray];

	NSArray *activeFeatures2 = [[NSArray alloc] initWithObjects:[NSNumber numberWithBool:NO],
							   [NSNumber numberWithBool:YES],
							   [NSNumber numberWithBool:NO],
							   nil];
	newPoint2.features = [NSArray arrayWithArray:activeFeatures2];

	// Save the context.
	NSError *error = nil;
	if (![self.context save:&error]) {
		// Replace this implementation with code to handle the error appropriately.
		// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	
	[self.tableView reloadData];
}

- (IBAction)dellAction:(id)sender {

	NSFetchRequest *allEntryes = [[NSFetchRequest alloc] init];
	[allEntryes setEntity:[NSEntityDescription entityForName:@"WayPoint" inManagedObjectContext:self.context]];
	[allEntryes setIncludesPropertyValues:NO]; //only fetch the managedObjectID

	NSError *error = nil;
	NSArray *entryes = [self.context executeFetchRequest:allEntryes error:&error];
	if (error) {
		NSLog(@"request rerror %@",error);
	}
	//error handling goes here
	for (NSManagedObject *entry in entryes) {
		[self.context deleteObject:entry];
	}
	NSError *saveError = nil;
	[self.context save:&saveError];
	if (saveError) {
		NSLog(@"save rerror %@",saveError);
	}
	//more error handling here
	[self.tableView reloadData];
}

- (IBAction)addWayPoint:(id)sender {

	if(!self.mvController) {
		MainViewController *secondView = [[MainViewController alloc] init];
		self.mvController = secondView;
	[self.mvController setManagedContext:self.context];
	}

	[self.mvController replaceWayPointID:nil];

	[self.navigationController pushViewController:self.mvController animated:YES];
}


-(IBAction)toEditRecord:(id)sender{

	if(!self.mvController) {
		MainViewController *secondView = [[MainViewController alloc] init];
		self.mvController = secondView;
		[self.mvController setManagedContext:self.context];
	}

//	NSLog(@"[sender tag]: %ld",[sender tag]);
	self.selectWayPoint = [self.points objectAtIndex:[sender tag]];

	[self.mvController replaceWayPointID:[self.selectWayPoint objectID]];
//	NSLog(@"[sender tag]: %@",[self.selectWayPoint objectID]);

	[self.navigationController pushViewController:self.mvController animated:YES];
	
}

@end
