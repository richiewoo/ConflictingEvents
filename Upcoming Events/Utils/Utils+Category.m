//
//  Utils+Category.m
//  Upcoming Events
//
//  Created by Xinbo Wu on 7/31/19.
//  Copyright © 2019 Xinbo Wu. All rights reserved.
//

#import "Utils+Category.h"

static NSDateFormatter *dateFormatterInUTC = nil;

@interface NSDateFormatter (UTC)
+ (NSDateFormatter *)dateFormatterInUTC;
@end

@implementation NSDateFormatter (UTC)
+ (NSDateFormatter *)dateFormatterInUTC {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatterInUTC = [[NSDateFormatter alloc] init];
        [dateFormatterInUTC setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [dateFormatterInUTC setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    });
    
    return dateFormatterInUTC;
}
@end

#pragma mark - NSDate (ConversionInUTC)
@implementation NSDate  (ConversionInUTC)

//Date to UTC string
- (NSString *)stringInUTCForFormat:(NSString *)format {
    if (format == nil) {
        return nil;
    }
    [NSDateFormatter.dateFormatterInUTC setDateFormat:format];
    return [NSDateFormatter.dateFormatterInUTC stringFromDate:self];
}

//Compare date with another one
- (BOOL) isEarlierDay:(NSDate*)anotherDate
{
    return ([self compare:anotherDate] == NSOrderedAscending);
}

//Trim the time of date, just keep the year, month and day
-(NSDate *)trimTime {
    [NSDateFormatter.dateFormatterInUTC setDateFormat:@"MM/dd/yyyy"];
    NSString *datePortion = [NSDateFormatter.dateFormatterInUTC stringFromDate:self];
    
    return [NSDateFormatter.dateFormatterInUTC dateFromString:datePortion];
}

@end

#pragma mark - NSString (ConversionInUTC)
@implementation NSString (ConversionInUTC)

//UTC string to Date
- (NSDate *)dateInUTCForFormat:(NSString *)format{
    if (format == nil) {
        return nil;
    }
    
    [NSDateFormatter.dateFormatterInUTC setDateFormat:format];
    return [NSDateFormatter.dateFormatterInUTC dateFromString:self];
}

@end
