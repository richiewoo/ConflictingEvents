//
//  EventListViewModel.m
//  Upcoming Events
//
//  Created by Xinbo Wu on 7/31/19.
//  Copyright © 2019 Xinbo Wu. All rights reserved.
//

#import "EventListViewModel.h"
#import "Event.h"

@interface EventListViewModel ()

@property (nonatomic) NSURL *databaseFileUrl;
@property (nonatomic) NSArray<NSDate*>* sortedEventsInDay;
@property (nonatomic) NSMutableDictionary<NSDate*, NSMutableArray<Event*>*>* eventsByDay;

@end

@implementation EventListViewModel

- (instancetype)initWithDatabaseFilePath: (NSURL*)filePath; {
    self = [super init];
    if (self) {
        _databaseFileUrl = filePath;
    }
    
    return self;
}

#pragma mark - data loading and parsing

- (void)loadEvents: (void (^)(NSError*))completion {
    __weak EventListViewModel* wself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *eventJsonData = [NSData dataWithContentsOfURL:wself.databaseFileUrl];
        if (eventJsonData == nil) {
            completion([NSError errorWithDomain:@"EventListViewModel" code:0 userInfo:nil]);
            return;
        }
        
        // Read JSON data into array
        NSError * error = nil;
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:eventJsonData options:NSJSONReadingMutableContainers error:&error];
        if(error == nil && [jsonObjects isKindOfClass:[NSArray class]]){
            [self parseAndSortEventsFromJsonObjects:jsonObjects];
        }
        completion(error);
    });
}

/*
 * Parsing events from json objects, sorting them in chronological order and checking its conflict on fly in place.
 *
 * As a trade-off, create a dictionary eventsByDay to group events by day, and create a array sortedEventsInDay to cached all days sorcted in chronological order.
 * To do so, every time to get any event is constant cost just accessing array with index or dictionary with key.
 */
- (void) parseAndSortEventsFromJsonObjects: (NSArray*) jsonObjects {
    self.eventsByDay = [[NSMutableDictionary alloc] init];
    for (NSDictionary *dict in jsonObjects) {
        Event *event = [[Event alloc] initWithDictionary:dict];
        if (self.eventsByDay[event.startDayInUTC] == nil) {
            //get first event on this day
            NSMutableArray* events = [[NSMutableArray alloc] init];
            [events addObject:event];
            self.eventsByDay[event.startDayInUTC] = events;
        } else {
            //there are events on this day
            NSMutableArray<Event*>* events = self.eventsByDay[event.startDayInUTC];
            // check conflict before insterting
            [events enumerateObjectsUsingBlock:^(Event *e, NSUInteger idx, BOOL *stop) {
                if ([event isOverlapWith:e]) {
                    if ([event.startDateInUTC isEarlierDay:e.startDateInUTC]) {
                        e.overlapped = YES;
                    } else {
                        event.overlapped = YES;
                    }
                }
            }];
            
            // insert the event in chronological order
            [events enumerateObjectsUsingBlock:^(Event *e, NSUInteger idx, BOOL *stop) {
                if ([event.startDateInUTC isEarlierDay:e.startDateInUTC]) {
                    *stop = YES;
                    [events insertObject:event atIndex:idx];
                }
                else if(idx == events.count - 1) {
                    // reach the last, append event
                    *stop = YES;
                    [events addObject:event];
                }
            }];
        }
    }
    // sort the event in day
    self.sortedEventsInDay = [self.eventsByDay.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSDate* e1, NSDate* e2) {
        return ![e1 isEarlierDay: e2];
    }];
}

- (BOOL)isOverlapEvent:(Event*)event with:(Event*)another {
    if (event.startDateInUTC < another.endDateInUTC && another.startDateInUTC < event.endDateInUTC  ) {
        return YES;
    }
    return NO;
}

#pragma mark - presenter interfaces

- (NSUInteger)numberOfDays {
    return self.sortedEventsInDay.count;
}

- (NSUInteger)numberOfEventsIn: (NSUInteger)section {
    if (self.sortedEventsInDay.count < section) {
        return 0;
    }
    return self.eventsByDay[self.sortedEventsInDay[section]].count;
}

- (NSString*)dayStringIn: (NSUInteger)section {
    if (self.sortedEventsInDay.count < section) {
        return nil;
    }
    
    return [self.sortedEventsInDay[section] stringInUTCForFormat:@"MM/dd/yyyy"];
}

- (NSString*)titleStringIn: (NSUInteger)section row:(NSUInteger)row {
    if (self.sortedEventsInDay.count < section) {
        return nil;
    }
    if (self.eventsByDay[self.sortedEventsInDay[section]].count < row) {
        return nil;
    }
    
    return self.eventsByDay[self.sortedEventsInDay[section]][row].title;
}

- (NSString*)startTimeStringIn: (NSUInteger)section row:(NSUInteger)row {
    if (self.sortedEventsInDay.count < section) {
        return nil;
    }
    if (self.eventsByDay[self.sortedEventsInDay[section]].count < row) {
        return nil;
    }
    
    return self.eventsByDay[self.sortedEventsInDay[section]][row].stTime;
}

- (NSString*)endTimeStringIn: (NSUInteger)section row:(NSUInteger)row {
    if (self.sortedEventsInDay.count < section) {
        return nil;
    }
    if (self.eventsByDay[self.sortedEventsInDay[section]].count < row) {
        return nil;
    }
    
    return self.eventsByDay[self.sortedEventsInDay[section]][row].endTime;
}

- (BOOL)eventOverlappedIn : (NSUInteger)section row:(NSUInteger)row {
    if (self.sortedEventsInDay.count < section) {
        return nil;
    }
    if (self.eventsByDay[self.sortedEventsInDay[section]].count < row) {
        return nil;
    }
    
    return self.eventsByDay[self.sortedEventsInDay[section]][row].overlapped;
}

@end
