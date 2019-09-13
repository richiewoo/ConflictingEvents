//
//  Event.m
//  Upcoming Events
//
//  Created by Xinbo Wu on 7/31/19.
//  Copyright © 2019 Xinbo Wu. All rights reserved.
//

#import "Event.h"

#define  event_date_format @"MMMM dd, yy hh:mm a"
#define  event_date_time_format @"hh:mm a"

@interface Event ()

@property (nonatomic) NSString* start;
@property (nonatomic) NSString* end;

@end

@implementation Event

// Init
- (instancetype)initWithDictionary:(NSDictionary*)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (instancetype)initWithTile: (NSString*)title start: (NSString*)startDate end: (NSString*)endDate {
    self = [super init];
    if (self) {
        _title = title;
        _start = startDate;
        _end   = endDate;
    }
    
    return self;
}

//data accesser
- (BOOL)isOverlapWith:(Event*)event {
    return [self.startDateInUTC isEarlierDay:event.endDateInUTC] && [event.startDateInUTC isEarlierDay:self.endDateInUTC];
}

- (NSString*)stTime {
    return [[self startDateInUTC] stringInUTCForFormat:event_date_time_format];
}

- (NSString*)enTime {
    return [[self endDateInUTC] stringInUTCForFormat:event_date_time_format];
}

- (NSDate*) startDateInUTC {
    return [_start dateInUTCForFormat:event_date_format];
}

- (NSDate*) endDateInUTC {
    return [_end dateInUTCForFormat:event_date_format];
}

- (NSDate*) startDayInUTC
{
    return [[self startDateInUTC] trimTime];
}

@end
