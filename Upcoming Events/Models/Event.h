//
//  Event.h
//  Upcoming Events
//
//  Created by Xinbo Wu on 7/31/19.
//  Copyright © 2019 Xinbo Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils+Category.h"

NS_ASSUME_NONNULL_BEGIN

@interface Event : NSObject

@property (nonatomic) NSString* title;
@property (nonatomic, getter=stTime) NSString* startTime;
@property (nonatomic, getter=enTime) NSString* endTime;
@property (nonatomic) BOOL overlapped;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
- (instancetype)initWithTile: (NSString*)title start: (NSString*)startDate end: (NSString*)endDate;

- (NSDate*)startDateInUTC;
- (NSDate*)startDayInUTC;
- (NSDate*)endDateInUTC;

- (BOOL)isOverlapWith:(Event*)event;

@end

NS_ASSUME_NONNULL_END
