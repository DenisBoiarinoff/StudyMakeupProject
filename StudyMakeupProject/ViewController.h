//
//  ViewController.h
//  StudyMakeupProject
//
//  Created by Rhinoda3 on 22.06.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol popupDelegate <NSObject>

@required
- (void) selectDate:(id) sender;
- (void) cancelDate:(id) sender;
@end

@interface ViewController : UIViewController {
	id <popupDelegate> _delegate;
}

@property (nonatomic,strong) id delegate;

@property (weak, nonatomic) IBOutlet UIDatePicker *viewDP;

@property (weak, nonatomic) IBOutlet UIButton *viewOkBtn;

@property (weak, nonatomic) IBOutlet UIButton *viewCancelBtn;

- (void)setDelegate:(id)delegate;

- (void)chooseDate:(NSDate *)date;

- (NSDate *)getDate;

@end
