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

@end

@implementation MainScreenViewController

 NSArray *tableData;

int parentWidth;
int parentHeight;

static NSString *pointCellIdentifier = @"PointTableViewCell";

- (NSManagedObjectContext *)managedObjectContext {
	NSManagedObjectContext *context = nil;
	id delegate = [[UIApplication sharedApplication] delegate];
	if ([delegate performSelector:@selector(managedObjectContext)]) {
		context = [delegate managedObjectContext];
	}
	return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	[self.tableView registerNib:[UINib nibWithNibName:@"PointTableViewCell" bundle:nil] forCellReuseIdentifier:pointCellIdentifier];

	self.context = [self managedObjectContext];

	parentWidth = [[UIScreen mainScreen] bounds].size.width;
	parentHeight = [[UIScreen mainScreen] bounds].size.height;

	NSLog(@"parent size: width - %d, height - %d",  parentWidth, parentHeight);

	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 0.26 * parentHeight;
//	tableData = [NSArray arrayWithObjects:@"Egg Benedict",
//				 @"Mushroom Risotto",
//				 @"Full Breakfast",
//				 @"Hamburger",
//				 @"Ham and Egg Sandwich",
//				 @"Creme Brelee",
//				 @"White Chocolate Donut",
//				 @"Starbucks Coffee",
//				 @"Vegetable Curry",
//				 @"Instant Noodle with Egg",
//				 @"Noodle with BBQ Pork",
//				 @"Japanese Noodle with Pork",
//				 @"Green Tea",
//				 @"Thai Shrimp Cake",
//				 @"Angry Birds Cake",
//				 @"Ham and Cheese Panini",
//				 nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	// Fetch the devices from persistent data store

	//	NSLog(@"ViewDidAppear");
	//	NSLog(@"%@",self.countries);
	//	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Country"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"WayPoint"];
	[fetchRequest setResultType:NSDictionaryResultType];
	[fetchRequest setReturnsDistinctResults:YES];
	if (self.points) {
		[self.points removeAllObjects];
	}
//	NSLog(@"Form coreData: \n%@\n", [self.context executeFetchRequest:fetchRequest error:nil]);
	self.points = [[self.context executeFetchRequest:fetchRequest error:nil] mutableCopy];
//	NSLog(@"From self.countryes: \n%@\n",self.points);

//	WayPoint *p = [self.points objectAtIndex:0];
//	NSLog(@"From waypoint: \n%@\n",p);

	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
//	return [indexPath row] * 20;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	//	NSManagedObjectContext *context = [self managedObjectContext];
//
//	if (editingStyle == UITableViewCellEditingStyleDelete) {
//		// Delete object from database
//		[self.myContext deleteObject:[self.countries objectAtIndex:indexPath.row]];
//		//		NSLog(@"%ld",indexPath.row);
//
//		NSError *error = nil;
//		if (![self.myContext save:&error]) {
//			NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
//			return;
//		}
//
//		// Remove device from table view
//		[self.countries removeObjectAtIndex:indexPath.row];
//		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//	}
//	static NSString *simpleTableIdentifier = @"SimpleTableItem";
//
//	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//
//	if (cell == nil) {
//		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//	}
//
//	cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
//	return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	PointTableViewCell *pointCell = [tableView dequeueReusableCellWithIdentifier:pointCellIdentifier];

	if (pointCell == nil) {
		pointCell = [[PointTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pointCellIdentifier];
	}

	[pointCell.toEditBtn addTarget:self
							action:@selector(toEditRecord:)
				  forControlEvents:UIControlEventTouchUpInside];

	NSLog(@"cell size: width - %f, height - %f",  pointCell.frame.size.width, pointCell.frame.size.height);

	WayPoint* pnt = [self.points objectAtIndex:indexPath.row];

//	NSString *title = [pnt title];
//	NSString *title1 = [pnt valueForKey:@"title"];
//	NSLog(@"TITLE: %@, %@",title, title1);
//	NSLog(@"%@",pnt);

//	pointCell.titleLabel.text = [[self.points objectAtIndex:indexPath.row] title];
	return pointCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//    return self.countries.count;
//	return [self.countries count];
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

- (IBAction)addAction:(id)sender {

	WayPoint *newPoint = [NSEntityDescription insertNewObjectForEntityForName:@"WayPoint" inManagedObjectContext:self.context];
	//	NSManagedObject *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.context];

	// If appropriate, configure the new managed object.
	// Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
	newPoint.sinceDate = [NSDate date];
	newPoint.upToDate = [NSDate date];

	newPoint.title = @"Some test Title";

	NSMutableArray *numbersArray = [NSMutableArray array];

	for (int i = 0; i < 5; i++)
	  {
		[numbersArray addObject:[NSNumber numberWithInteger:arc4random_uniform(100)]];
	  }

	newPoint.features = [NSArray arrayWithArray:numbersArray];
	newPoint.myWayPoint = [NSArray arrayWithArray:numbersArray];
	newPoint.weeksDays = [NSArray arrayWithArray:numbersArray];

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


-(IBAction)toEditRecord:(id)sender{

	if(!self.mvController){
		MainViewController *secondView = [[MainViewController alloc] init];
		self.mvController = secondView;
	}

	//	NSLog(@"[sender tag]: %ld",[sender tag]);
//	self.selectCountry = [self.countries objectAtIndex:[sender tag]];

//	[self.addCountryViewController replaceCountry:self.selectCountry];

	[self.navigationController pushViewController:self.mvController animated:YES];
	
}

@end
