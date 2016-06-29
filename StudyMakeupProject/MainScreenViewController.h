//
//  MainScreenViewController.h
//  StudyMakeupProject
//
//  Created by Rhinoda3 on 23.06.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainScreenViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)addAction:(id)sender;
- (IBAction)dellAction:(id)sender;
- (IBAction)addWayPoint:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end
