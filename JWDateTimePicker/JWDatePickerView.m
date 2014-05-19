//
//  JWDatePickerView.m
//  DreamSwapp
//
//  Created by Josh on 2/7/14.
//  Copyright (c) 2014 Joshua Wood. All rights reserved.
//

#import "JWDatePickerView.h"

// Identifiers of components
//#define MONTH ( 0 )
//#define YEAR ( 1 )
#define DAY_MONTH_DATE ( 0 )
#define HOUR ( 1 )
#define MINUTE ( 2 )
#define AMPM ( 3 )

// Identifies for component views
#define LABEL_TAG 43


@interface JWDatePickerView()

@property (nonatomic, strong) NSIndexPath *todayIndexPath;
@property (nonatomic, strong) NSArray *months;
@property (nonatomic, strong) NSArray *years;
//@property (nonatomic, strong) NSArray *dayMonthDate;
@property (nonatomic, strong) NSArray *hour;
@property (nonatomic, strong) NSArray *minute;
@property (nonatomic, strong) NSArray *ampm;
@property (nonatomic, strong) NSArray *dateStringArray;
@property (nonatomic, strong) NSArray *dateMapperArray;
@property (nonatomic, strong) NSMutableArray *todayIndexPathArray;

-(NSArray *)nameOfYears;
-(NSArray *)nameOfMonths;
//-(CGFloat)componentWidth;

-(UILabel *)labelForComponent:(NSInteger)component selected:(BOOL)selected;
-(NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component;
//-(NSIndexPath *)todayPath;
-(NSInteger)bigRowMonthCount;
-(NSInteger)bigRowYearCount;
-(NSString *)currentMonthName;
-(NSString *)currentYearName;

@end



@implementation JWDatePickerView

const NSInteger bigRowCount = 1000;
const NSInteger minYear = 2014;
const NSInteger maxYear = 2015;
const CGFloat rowHeight = 44.f;
const NSInteger numberOfComponents = 4;

@synthesize todayIndexPath;
@synthesize months;
@synthesize years = _years;
@synthesize hour, minute, ampm, dateMapperArray, dateStringArray, todayIndexPathArray;

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.todayIndexPathArray = [[NSMutableArray alloc] init];
    
    self.months = [self nameOfMonths];
    self.years = [self nameOfYears];
    [self generateDayMonthDateArrays];
    self.hour = [self nameOfHour];
    self.minute = [self nameOfMinute];
    self.ampm = @[@"AM", @"PM"];
    self.todayIndexPathArray[1] = [self currentHourIndexPath];
    self.todayIndexPathArray[2] = [self currentMinuteIndexPath];
    self.todayIndexPathArray[3] = [self currentAMPMIndexPath];
    
    self.delegate = self;
    self.dataSource = self;
    
    [self selectToday];
}

//-(NSDate *)date
//{
//    NSInteger monthCount = [self.months count];
//    NSString *month = [self.months objectAtIndex:([self selectedRowInComponent:MONTH] % monthCount)];
//    
//    NSInteger yearCount = [self.years count];
//    NSString *year = [self.years objectAtIndex:([self selectedRowInComponent:YEAR] % yearCount)];
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init]; [formatter setDateFormat:@"MMMM:yyyy"];
//    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@:%@", month, year]];
//    return date;
//}

#pragma mark - UIPickerViewDelegate
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [self componentWidthForComponent:component];
}

-(UIView *)pickerView: (UIPickerView *)pickerView viewForRow: (NSInteger)row forComponent: (NSInteger)component reusingView: (UIView *)view
{
    BOOL selected = NO;
    if(component == DAY_MONTH_DATE)
    {
        NSInteger dayMonthDateCount = [dateStringArray count];
        NSString *dayMonthDateString = [dateStringArray objectAtIndex:(row % dayMonthDateCount)];
        NSString *currentDayMonthDate = @"Today";
        if([dayMonthDateString isEqualToString:currentDayMonthDate] == YES)
        {
            selected = YES;
        }
    }
    else if ( component == HOUR )
    {
        NSInteger hourCount = [hour count];
        NSString *hourString = [hour objectAtIndex:(row % hourCount)];
        NSString *currentHour = [self currentHour];
        if([hourString isEqualToString:currentHour] == YES)
        {
            selected = YES;
        }
    }
    else if ( component == MINUTE )
    {
        NSInteger minuteCount = [hour count];
        NSString *minuteString = [minute objectAtIndex:(row % minuteCount)];
        NSString *currentMinute = [self currentMinute];
        if([minuteString isEqualToString:currentMinute] == YES)
        {
            selected = YES;
        }
    }
    else
    {
        NSInteger periodCount = [ampm count];
        NSString *periodString = [ampm objectAtIndex:(row % periodCount)];
        NSString *currentPeriod = [self currentAMPM];
        if([periodString isEqualToString:currentPeriod] == YES)
        {
            selected = YES;
        }
    }
    
    UILabel *returnView = nil;
    if(view.tag == LABEL_TAG)
    {
        returnView = (UILabel *)view;
    }
    else
    {
        returnView = [self labelForComponent: component selected: selected];
    }
    
    returnView.textColor = selected ? [UIColor blueColor] : [UIColor whiteColor];
    returnView.text = [self titleForRow:row forComponent:component];
    return returnView;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return rowHeight;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return numberOfComponents;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ( component == DAY_MONTH_DATE )
    {
        NSInteger temp = dateStringArray.count;
        return temp;
    }
    else if ( component == HOUR )
    {
        NSInteger temp = hour.count;
        return temp;
    }
    else if ( component == MINUTE )
    {
        NSInteger temp = minute.count;
        return temp;
    }
    else
    {
        NSInteger temp = ampm.count;
        return temp;
    }
}

#pragma mark - Util
-(NSInteger)bigRowMonthCount
{
    return [self.months count]  * bigRowCount;
}

-(NSInteger)bigRowYearCount
{
    return [self.years count]  * bigRowCount;
}

-(CGFloat)componentWidthForComponent:(NSInteger)component
{
    double componentWidthPercentage;
    if ( component == DAY_MONTH_DATE )
    {
        componentWidthPercentage = 0.4;
    }
    else if ( component == HOUR )
    {
        componentWidthPercentage = 0.15;
    }
    else if ( component == MINUTE )
    {
        componentWidthPercentage = 0.15;
    }
    else
    {
        componentWidthPercentage = 0.3;
    }
    return self.bounds.size.width * componentWidthPercentage;
}

-(NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ( component == DAY_MONTH_DATE )
    {
        return dateStringArray[row];
    }
    else if ( component == HOUR )
    {
        return hour[row];
    }
    else if ( component == MINUTE )
    {
        return minute[row];
    }
    else
    {
        return ampm[row];
    }
}

-(UILabel *)labelForComponent:(NSInteger)component selected:(BOOL)selected
{
    CGRect frame = CGRectMake(0.f, 0.f, [self componentWidthForComponent:component],rowHeight);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = selected ? [UIColor blueColor] : [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:18.f];
    label.userInteractionEnabled = NO;
    
    label.tag = LABEL_TAG;
    
    return label;
}

-(NSArray *)nameOfMonths
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSMutableArray *monthNamesArray = [NSMutableArray arrayWithArray:[dateFormatter monthSymbols]];
    for(int current = 0; current < monthNamesArray.count; current++)
    {
        monthNamesArray[current] = [monthNamesArray[current] substringToIndex:3];
    }
    return monthNamesArray;
}

-(NSArray *)nameOfYears
{
    NSMutableArray *years = [NSMutableArray array];
    
    for(NSInteger year = minYear; year <= maxYear; year++)
    {
        NSString *yearStr = [NSString stringWithFormat:@"%i", year];
        [years addObject:yearStr];
    }
    return years;
}

-(void)generateDayMonthDateArrays
{
    NSMutableArray *builderDateStringArray = [[NSMutableArray alloc] init];
    NSMutableArray *builderDateMapperArray = [[NSMutableArray alloc] init];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:1];
    
    //find start and end date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-mm-dd HH:mm:ss"];
    NSDate *startDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%d-01-01 00:00:00",minYear]];
    NSDate *endDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%d-01-01 00:00:00",maxYear]];
    
    NSDateFormatter *dateStringFormatter = [[NSDateFormatter alloc] init];
    [dateStringFormatter setDateFormat:@"E MMM d"];
    
    [builderDateMapperArray addObject:startDate];
    [builderDateStringArray addObject:[dateStringFormatter stringFromDate:startDate]];
    
    NSDate *currentDate = startDate;
    currentDate = [currentCalendar dateByAddingComponents:dateComponents toDate:currentDate  options:0];
    
    NSDateComponents *todaysCompnents = [currentCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    NSDate *todaysDate = [currentCalendar dateFromComponents:todaysCompnents];
    NSLog(@"\nstart date - %@ \n current date - %@ \n end date - %@ \n today's date - %@ \n",startDate,currentDate,endDate,todaysDate);
    while ( [endDate compare: currentDate] != NSOrderedAscending) {
        if ( [currentDate compare: todaysDate] == NSOrderedSame)
        {
            [builderDateStringArray addObject:@"Today"];
            todayIndexPathArray[0] = [NSIndexPath indexPathForRow:[builderDateStringArray count] inSection:1];
        } else {
            [builderDateStringArray addObject:(NSString *)[dateStringFormatter stringFromDate:currentDate]];
        }
        [builderDateMapperArray addObject:(NSDate *)currentDate];
        
        currentDate = (NSDate *)[currentCalendar dateByAddingComponents:dateComponents toDate:currentDate  options:0];
    }
    
    dateStringArray = builderDateStringArray;
    dateMapperArray = builderDateMapperArray;
}

-(NSArray *)nameOfHour
{
    NSMutableArray *theHours = [[NSMutableArray alloc] init];
    for (int theHour = 1; theHour <= 12; theHour++) {
        [theHours addObject:[NSString stringWithFormat:@"%i", theHour]];
    }
    return theHours;
}

-(NSArray *)nameOfMinute
{
    NSMutableArray *theMinutes = [[NSMutableArray alloc] init];
    for (int theMinute = 0; theMinute <= 59; theMinute++) {
        [theMinutes addObject:[NSString stringWithFormat:@"%02d", theMinute]];
    }
    return theMinutes;
}

-(void)selectToday
{   // TODO: today selects next day, hour selects next hour, minute not blue
    int dayMonthDateRow = [self.todayIndexPathArray[0] row] -1;
    int hourRow = [self.todayIndexPathArray[1] row] - 1;
    int minuteRow = [self.todayIndexPathArray[2] row];
    int ampmRow = [self.todayIndexPathArray[3] row];
    
    [self selectRow: dayMonthDateRow
        inComponent: DAY_MONTH_DATE
           animated: NO];
    
    [self selectRow: hourRow
        inComponent: HOUR
           animated: NO];
    
    [self selectRow: minuteRow
        inComponent: MINUTE
           animated: NO];
    
    [self selectRow: ampmRow
        inComponent: AMPM
           animated: NO];
}

//-(NSIndexPath *)todayPath // row - month ; section - year
//{
//    CGFloat row = 0.f;
//    CGFloat section = 0.f;
//    
//    NSString *month = [self currentMonthName];
//    NSString *year  = [self currentYearName];
//    
//    //set table on the middle
//    for(NSString *cellMonth in self.months)
//    {
//        if([cellMonth isEqualToString:month])
//        {
//            row = [self.months indexOfObject:cellMonth];
//            row = row + [self bigRowMonthCount] / 2;
//            break;
//        }
//    }
//    
//    for(NSString *cellYear in self.years)
//    {
//        if([cellYear isEqualToString:year])
//        {
//            section = [self.years indexOfObject:cellYear];
//            section = section + [self bigRowYearCount] / 2;
//            break;
//        }
//    }
//    
//    return [NSIndexPath indexPathForRow:row inSection:section];
//}

-(NSString *)currentMonthName
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    return [formatter stringFromDate:[NSDate date]];
}

-(NSString *)currentYearName
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    return [formatter stringFromDate:[NSDate date]];
}

-(NSString *)currentHour
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h"];
    return [formatter stringFromDate:[NSDate date]];
}

-(NSIndexPath *)currentHourIndexPath
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h"];
    NSString *hourString = [formatter stringFromDate:[NSDate date]];
    NSInteger hourInteger = [hourString intValue];
    return [NSIndexPath indexPathForRow:hourInteger inSection:1];
}

-(NSString *)currentMinute
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init]; // highlighting more than one TODO :
    [formatter setDateFormat:@"mm"];
    return [formatter stringFromDate:[NSDate date]];
}

-(NSIndexPath *)currentMinuteIndexPath
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm"];
    NSString *minuteString = [formatter stringFromDate:[NSDate date]];
    NSInteger minuteInteger = [minuteString intValue];
    return [NSIndexPath indexPathForRow:minuteInteger inSection:1];
}

-(NSString *)currentAMPM
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"a"];
    return [formatter stringFromDate:[NSDate date]];
}

-(NSIndexPath *)currentAMPMIndexPath
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"a"];
    NSString *period =  [formatter stringFromDate:[NSDate date]];
    NSInteger periodInteger = -1;
    if ( [period isEqualToString:@"AM"] )
    {
        periodInteger = 0;
    } else {
        periodInteger = 1;
    }
    return [NSIndexPath indexPathForRow:periodInteger inSection:1];
}

@end
