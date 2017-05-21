//
//  LTHMonthYearPickerView.m
//  LTHMonthYearPickerView Demo
//
//  Created by Roland Leth on 30/11/13.
//  Copyright (c) 2014 Roland Leth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VJMonthYearPickerView : UIView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *datePicker;

@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *month;


/**
 @brief				   Month / Year picker view, for those pesky Credit Card expiration dates and alike.
 @param date           set if you want the picker to be initialized with a specific month and year, otherwise it will be initialized with the current month and year.
 @param shortMonths    set to YES if you want months to be returned as Jan, Feb, etc, set to NO if you want months to be returned as January, February, etc.
 @param numberedMonths set to YES if you want months to be returned as 01, 02, etc. This takes precedence over shortMonths if set to YES.
 @return a container view which contains the UIPicker and toolbar
 */
- (id)initWithDate:(NSDate *)date
       shortMonths:(BOOL)shortMonths
    numberedMonths:(BOOL)numberedMonths;

/**
 @brief				   Month / Year picker view, for those pesky Credit Card expiration dates and alike.
 @param date           set if you want the picker to be initialized with a specific month and year, otherwise it will be initialized with the current month and year.
 @param shortMonths    set to YES if you want months to be returned as Jan, Feb, etc, set to NO if you want months to be returned as January, February, etc.
 @param numberedMonths set to YES if you want months to be returned as 01, 02, etc. This takes precedence over shortMonths if set to YES.
 @param minYear        set value for minimum year that is displayed in picker.
 @param maxYear        set value for maximum year that is displayed in picker.
 @return a container view which contains the UIPicker and toolbar
 */
- (id)initWithDate:(NSDate *)date
	   shortMonths:(BOOL)shortMonths
	numberedMonths:(BOOL)numberedMonths
		   minYear:(NSInteger)minYear
		andMaxYear:(NSInteger)maxYear;


/**
 @brief				   Month / Year picker view, for those pesky Credit Card expiration dates and alike.
 @param date           set if you want the picker to be initialized with a specific month and year, otherwise it will be initialized with the current month and year.
 @param shortMonths    set to YES if you want months to be returned as Jan, Feb, etc, set to NO if you want months to be returned as January, February, etc.
 @param numberedMonths set to YES if you want months to be returned as 01, 02, etc. This takes precedence over shortMonths if set to YES.
 @param minDate        set value for minimum date that is displayed in picker. Day 1 is default.
 @param maxDate        set value for maximum date that is displayed in picker. Day 1 is default.
 @return a container view which contains the UIPicker and toolbar
 */
- (id)initWithDate:(NSDate *)date
	   shortMonths:(BOOL)shortMonths
	numberedMonths:(BOOL)numberedMonths
		   minDate:(NSDate *)minDate
        andMaxDate:(NSDate *)maxDate;


- (void)showWithComplect:(void (^)(NSString * year, NSString * month))handleBlock;


@end
