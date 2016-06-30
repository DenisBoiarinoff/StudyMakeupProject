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

//	[self.layer setBorderWidth:2];
//	[self.layer setBorderColor:[UIColor blackColor].CGColor];

	int parentWidth = [[UIScreen mainScreen] bounds].size.width;
	int parentHeight = [[UIScreen mainScreen] bounds].size.height;

	NSString *deviceType = [UIDevice currentDevice].model;

	for (int i = 21; i < 28; i++) {
		UILabel *lbl = [self viewWithTag:i];
		if([deviceType isEqualToString:@"iPad"]) {
			lbl.font = [UIFont systemFontOfSize: parentHeight * 0.03];
			self.titleLabel.font = [UIFont systemFontOfSize: parentHeight * 0.04];
			self.sinceTime.font  = [UIFont systemFontOfSize: parentHeight * 0.05];
			self.upToTime.font  = [UIFont systemFontOfSize: parentHeight * 0.05];
		}
		if ([deviceType isEqualToString:@"iPhone"]) {
			lbl.font = [UIFont systemFontOfSize: parentHeight * 0.026];
			self.titleLabel.font = [UIFont systemFontOfSize: parentHeight * 0.04];
			self.sinceTime.font  = [UIFont systemFontOfSize: parentHeight * 0.05];
			self.upToTime.font  = [UIFont systemFontOfSize: parentHeight * 0.05];
		}

	}

	CALayer *titleBottomBorder = [CALayer layer];

	float borderY = parentHeight * 0.1;
	titleBottomBorder.frame = CGRectMake(0, borderY, parentWidth, 1.0f);
	titleBottomBorder.backgroundColor = [UIColor grayColor].CGColor;
	[self.layer addSublayer:titleBottomBorder];

	CALayer *cellBottomBorder = [CALayer layer];
	borderY = parentHeight * 0.2555;
	cellBottomBorder.frame = CGRectMake(0, borderY, parentWidth, 1.0f);
	cellBottomBorder.backgroundColor = [UIColor grayColor].CGColor;
	[self.layer addSublayer:cellBottomBorder];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
