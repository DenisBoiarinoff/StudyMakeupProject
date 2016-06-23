//
//  ViewController.m
//  StudyMakeupProject
//
//  Created by Rhinoda3 on 22.06.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize delegate = _delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)okBtnCall:(id)sender {

	[self.delegate selectDate:sender];

}

- (IBAction)cancelBtnCall:(id)sender {

	[self.delegate cancelDate:sender];

}

- (void) chooseDate:(NSDate *)date {
	self.viewDP.date = date;
}

- (NSDate *)getDate {
	return self.viewDP.date;
}

/*
#pragma			 mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
