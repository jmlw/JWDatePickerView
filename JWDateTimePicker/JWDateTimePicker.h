//
//  JWDateTimePicker.h
//  JWDateTimePicker
//
//  Created by Josh Wood on 5/17/14.
//  Copyright (c) 2014 joshmlwood. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JWDateTimePicker;
@protocol JWDateTimePickerProtocol <NSObject>

@optional

- (void) dateTimePicker:(JWDateTimePicker *)picker DidBeginScrollingFromDate:(NSDate *)startingDate;
- (void) dateTimePicker:(JWDateTimePicker *)picker DidEndScrollingToDate:(NSDate *)endingDate;

@end

@interface JWDateTimePicker : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>

typedef enum{
    JWDateTimePickerModeTime,
    JWDateTimePickerModeDate,
    JWDateTimePickerModeDateAndTime
} JWDateTimePickerMode;

@property (nonatomic,copy)      NSCalendar              * calendar;
@property (nonatomic,retain)    NSDate                  * date;
@property (nonatomic,retain)    NSLocale                * locale;
@property (nonatomic,retain)    NSTimeZone              * timezone;
@property (nonatomic)           JWDateTimePickerMode    dateTimePickerMode;
@property (nonatomic,retain)    NSDate                  * minimumDate;
@property (nonatomic,retain)    NSDate                  * maximumDate;
@property (nonatomic)           NSInteger               * minuteInterval;

- (void) setDate:(NSDate *)date animated:(BOOL)animated;
- (NSDate *) selectedDate;

@end
