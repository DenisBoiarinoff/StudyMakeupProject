//
//  PointTableViewCell.h
//  StudyMakeupProject
//
//  Created by Rhinoda3 on 23.06.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sinceTime;
@property (weak, nonatomic) IBOutlet UILabel *upToTime;
@property (weak, nonatomic) IBOutlet UILabel *weekDayLabel;

@property (weak, nonatomic) IBOutlet UIButton *toEditBtn;


@end
