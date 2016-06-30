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
@property (weak, nonatomic) IBOutlet UILabel *sinceAMLabel;
@property (weak, nonatomic) IBOutlet UILabel *upToAMLabel;

@property (weak, nonatomic) IBOutlet UIButton *toEditBtn;

@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWidth;

//@property (weak, nonatomic) IBOutlet UIImageView *firstImg;
//@property (weak, nonatomic) IBOutlet UIImageView *secondImg;
//@property (weak, nonatomic) IBOutlet UIImageView *thirdImg;

@end
