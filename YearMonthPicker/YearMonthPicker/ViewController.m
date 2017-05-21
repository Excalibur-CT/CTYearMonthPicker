//
//  ViewController.m
//  YearMonthPicker
//
//  Created by Admin on 2017/4/12.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import "ViewController.h"
#import "VJMonthYearPickerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)showPicker:(UIButton *)sender
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM / yyyy"];
    NSDate *minDate = [dateFormatter dateFromString:[NSString stringWithFormat: @"%i / %i", 3, 2015]];
    NSDate *maxDate = [dateFormatter dateFromString:[NSString stringWithFormat: @"%i / %i", 3, 2115]];
    
    VJMonthYearPickerView * monthYearPicker = [[VJMonthYearPickerView alloc] initWithDate: [NSDate date]
                                                                              shortMonths: NO
                                                                           numberedMonths: NO
                                                                                  minDate: minDate
                                                                               andMaxDate: maxDate];
    [monthYearPicker showWithComplect:^(NSString *year, NSString *month) {
        NSLog(@"%@%@", year, month);
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
