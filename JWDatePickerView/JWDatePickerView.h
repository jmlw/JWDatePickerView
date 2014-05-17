//
//  JWDatePickerView.h
//  DreamSwapp
//
//  Created by Josh on 2/7/14.
//  Copyright (c) 2014 Joshua Wood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWDatePickerView : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong, readonly) NSDate *date;
-(void)selectToday;

@end
