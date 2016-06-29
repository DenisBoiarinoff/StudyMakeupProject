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
	for (int i = 101; i < 104; i++) {
		UIImageView *imgView = [pointCell.titleView viewWithTag:i];
		[imgView setHidden:NO];
	}

	int tag = 101;
	for (int i = 0; i < 3; i++) {
		UIImageView *imgView = [pointCell viewWithTag:tag];
		BOOL b = [[features objectAtIndex:i] boolValue];
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
													   multiplier:multiplier - 0.03
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
