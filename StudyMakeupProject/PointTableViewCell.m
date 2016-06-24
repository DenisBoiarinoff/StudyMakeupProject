//
//  PointTableViewCell.m
//  StudyMakeupProject
//
//  Created by Rhinoda3 on 23.06.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import "PointTableViewCell.h"

@implementation PointTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

	[self.titleLabel.layer setBorderWidth:2];
	[self.titleLabel.layer setBorderColor:[UIColor redColor].CGColor];

	[self.sinceTime.layer setBorderWidth:2];
	[self.sinceTime.layer setBorderColor:[UIColor redColor].CGColor];

	[self.upToTime.layer setBorderWidth:2];
	[self.upToTime.layer setBorderColor:[UIColor redColor].CGColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
