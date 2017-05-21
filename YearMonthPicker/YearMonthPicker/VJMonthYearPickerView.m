//
//  LTHMonthYearPickerView.m
//  LTHMonthYearPickerView Demo
//
//  Created by Roland Leth on 30/11/13.
//  Copyright (c) 2014 Roland Leth. All rights reserved.
//

#import "VJMonthYearPickerView.h"

#define kMonthFont  [UIFont systemFontOfSize: 22.0]
#define kYearFont   [UIFont systemFontOfSize: 22.0]
#define kWinSize    [UIScreen mainScreen].bounds.size


const CGFloat k_CONTENT_HEIGHT = 226;

const NSUInteger kMonthComponent = 1;
const NSUInteger kYearComponent = 0;
const NSUInteger kMinYear = 1950;
const NSUInteger kMaxYear = 2080;
const CGFloat    kRowHeight = 30.0;

@interface VJMonthYearPickerView ()

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UIView * toolBar;
@property (nonatomic, copy)void (^block)(NSString * year, NSString * month);


@property (readwrite) NSInteger yearIndex;
@property (readwrite) NSInteger monthIndex;

@property (nonatomic, strong) NSArray *months;
@property (nonatomic, strong) NSMutableArray *years;
@property (nonatomic, strong) NSDateComponents *minComponents;
@property (nonatomic, strong) NSDateComponents *maxComponents;

@end


@implementation VJMonthYearPickerView


#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSUInteger (^month)() = ^NSUInteger() {
        return [pickerView selectedRowInComponent: kMonthComponent];
    };
    NSUInteger (^year)() = ^NSUInteger() {
        return [pickerView selectedRowInComponent: kYearComponent];
    };
    
    if (year() == 0 && month() < _minComponents.month) {
        row = _minComponents.month - 1;
        [pickerView selectRow:row inComponent:kMonthComponent animated:YES];
    }
    else if (year() == _years.count - 1 && month() > _maxComponents.month)
    {
        row = _maxComponents.month - 1;
        [pickerView selectRow:row inComponent:kMonthComponent animated:YES];
    }
    if (component == kYearComponent) {
        _yearIndex = row;
    }else {
        _monthIndex = row;
    }
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = kMonthFont;
    if (component == kMonthComponent)
    {
        label.text = [NSString stringWithFormat: @"%@", _months[row]];
        label.frame = CGRectMake(0, 0, kWinSize.width * 0.5, kRowHeight);
    }
    else
    {
        label.text = [NSString stringWithFormat: @"%@", _years[row]];
        label.frame = CGRectMake(kWinSize.width * 0.5, 0, kWinSize.width * 0.5, kRowHeight);
    }
    return label;
}

#pragma mark - UIPickerView dataSource -
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 100;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return kRowHeight;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == kMonthComponent)
    {
        return _months.count;
    }
    return _years.count;
}

#pragma mark - Actions
- (void)_done
{
    if (self.block) {
        self.block(_years[_yearIndex], _months[_monthIndex]);
    }
    _year = _years[_yearIndex];
    _month = _months[_monthIndex];
    [self _hidden];
}

- (void)_cancel
{
    _year = _years[_yearIndex];
    _month = _months[_monthIndex];
    [self _hidden];
}

#pragma mark - Init

- (void)_setupComponentsFromDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents =
    [calendar components: NSCalendarUnitMonth | NSCalendarUnitYear
                fromDate: date];
    
    NSInteger currentYear = MAX(_minComponents.year, MIN(_maxComponents.year, dateComponents.year));
    
    _yearIndex = [_years indexOfObject: [NSString stringWithFormat: @"%zd", currentYear]];
    _monthIndex = dateComponents.month - 1;
    
    [_datePicker selectRow: _monthIndex
               inComponent: kMonthComponent
                  animated: YES];
    [_datePicker selectRow: _yearIndex
               inComponent: kYearComponent
                  animated: YES];
    [self performSelector: @selector(_sendFirstPickerValues) withObject: nil afterDelay: 0.1];
}

- (void)_sendFirstPickerValues
{
    _year = _years[_yearIndex];
    _month = _months[_monthIndex];
}


#pragma mark - Init
- (id)initWithDate:(NSDate *)date shortMonths:(BOOL)shortMonths numberedMonths:(BOOL)numberedMonths
{
    return [self initWithDate:date shortMonths:shortMonths numberedMonths:numberedMonths minYear:kMinYear andMaxYear:kMaxYear];
}

- (id)initWithDate:(NSDate *)date shortMonths:(BOOL)shortMonths numberedMonths:(BOOL)numberedMonths minDate:(NSDate *)minDate andMaxDate:(NSDate *)maxDate
{
    self = [super initWithFrame:CGRectMake(0, 0, kWinSize.width, kWinSize.height)];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(_hidden)];
    [self addGestureRecognizer:tap];
    
    if (self != nil) {
        if ([date compare:minDate] == NSOrderedAscending) {
            date = minDate;
        }
        else if ([date compare:maxDate] == NSOrderedDescending) {
            date = maxDate;
        }
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        _minComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth
                                     fromDate:minDate];
        _maxComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth
                                     fromDate:maxDate];
        
        NSString * format = @"MMMM";
        if (numberedMonths) { format = @"MM"; }
        else if (shortMonths) { format = @"MMM"; }
        
        [self initYearAndMonthWithDate:date dayFormat:format];

        [self initSubViews];
        
        [self _setupComponentsFromDate: date];
    }
    
    return self;
}

- (void)initYearAndMonthWithDate:(NSDate *)date dayFormat:(NSString *)format
{
    NSMutableArray *months = [NSMutableArray new];
    for (NSInteger i = 1; i <= 12; i++)
    {
        [months addObject:[NSString stringWithFormat:@"%ld", i]];
    }
    
    _months = [months copy];
    _years = [NSMutableArray new];
    
    for (NSInteger year = _minComponents.year; year <= _maxComponents.year; year++) {
        [_years addObject: [NSString stringWithFormat: @"%zd", year]];
    }
}

- (void)initSubViews
{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.datePicker];
    [self.contentView addSubview:self.toolBar];
}

- (id)initWithDate:(NSDate *)date shortMonths:(BOOL)shortMonths numberedMonths:(BOOL)numberedMonths minYear:(NSInteger)minYear andMaxYear:(NSInteger)maxYear
{
    NSDate *current = [NSDate date];
    
    NSDateComponents *minComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth
                                                                      fromDate:current];
    minComponents.year = minYear;
    minComponents.month = 1;
    NSDate *minDate = [[NSCalendar currentCalendar] dateFromComponents:minComponents];

    NSDate *maxFromCurrent = [[NSCalendar currentCalendar] dateBySettingUnit:NSCalendarUnitYear
                                                                       value:maxYear + 1
                                                                      ofDate:current
                                                                     options:NSCalendarMatchLast];
    NSDate *maxDate = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                               value:-1
                                                              toDate:maxFromCurrent
                                                             options:NSCalendarMatchLast];
    
    return [self initWithDate:date shortMonths:shortMonths numberedMonths:numberedMonths minDate:minDate andMaxDate:maxDate];
}

- (void)showWithComplect:(void (^)(NSString * year, NSString * month))handleBlock
{
    self.block = handleBlock;
    [self show];
}

- (void)show
{
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    [window bringSubviewToFront:self];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.contentView.frame;
        frame.origin.y = kWinSize.height - frame.size.height;
        self.contentView.frame = frame;
    }];
}

- (void)_hidden
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.contentView.frame;
        frame.origin.y = kWinSize.height;
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - Setters

- (void)setMonth:(NSString *)month
{
    _monthIndex = [_months indexOfObject:month];
    [_datePicker selectRow:_monthIndex inComponent:0 animated:NO];
}

- (void)setYear:(NSString *)year
{
    _yearIndex = [_years indexOfObject:year];
    [_datePicker selectRow:_yearIndex inComponent:1 animated:NO];
}


#pragma mark - getter -
- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kWinSize.height, kWinSize.width, k_CONTENT_HEIGHT)];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UIView *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kWinSize.width, 40)];
        _toolBar.backgroundColor = [UIColor whiteColor];
        
        __weak typeof(self)weakSelf = self;
        UIButton * (^initButton)(NSString * title, SEL selector, CGFloat x) = ^UIButton *(NSString * title, SEL selector, CGFloat x) {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn addTarget:weakSelf action:selector forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.frame = CGRectMake(x, 0, 60, 40);
            return btn;
        };
        
        UIButton * cancelButton = initButton(@"取消",@selector(_cancel), 10);
        UIButton * sureButton = initButton(@"确定",@selector(_done), kWinSize.width-70);

        [_toolBar addSubview:cancelButton];
        [_toolBar addSubview:sureButton];
        
        UIView * botomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 39, kWinSize.width, 1.0/[[UIScreen mainScreen] scale])];
        botomLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
        [_toolBar addSubview:botomLine];
        
        UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWinSize.width, 1.0/[[UIScreen mainScreen] scale])];
        topLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
        [_toolBar addSubview:topLine];
    }
    return _toolBar;
}

- (UIPickerView *)datePicker
{
    if (_datePicker == nil) {
        _datePicker = [[UIPickerView alloc] initWithFrame: CGRectMake(0, 30, kWinSize.width, 216)];
        _datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.dataSource = self;
        _datePicker.delegate = self;
    }
    return _datePicker;
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
