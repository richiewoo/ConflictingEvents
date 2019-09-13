//
//  EventListViewModel.h
//  Upcoming Events
//
//  Created by Xinbo Wu on 7/31/19.
//  Copyright © 2019 Xinbo Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventListViewModel : NSObject

- (instancetype)initWithDatabaseFilePath: (NSURL*)filePath;

- (void)loadEvents: (void (^)(NSError*))completion;

- (NSUInteger)numberOfDays;

- (NSUInteger)numberOfEventsIn: (NSUInteger)index;

- (NSString*)titleStringIn: (NSUInteger)section row:(NSUInteger)row;

- (NSString*)dayStringIn: (NSUInteger)section;

- (NSString*)startTimeStringIn: (NSUInteger)section row:(NSUInteger)row;

- (NSString*)endTimeStringIn: (NSUInteger)section row:(NSUInteger)row;

- (BOOL)eventOverlappedIn : (NSUInteger)section row:(NSUInteger)row;
@end

NS_ASSUME_NONNULL_END
