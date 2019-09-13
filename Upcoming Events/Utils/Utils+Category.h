//
//  Utils+Category.h
//  Upcoming Events
//
//  Created by Xinbo Wu on 7/31/19.
//  Copyright © 2019 Xinbo Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (ConversionInUTC)

- (NSString *)stringInUTCForFormat:(NSString *)format;
- (BOOL)isEarlierDay:(NSDate*)anotherDate;
- (NSDate *)trimTime;

@end

@interface NSString (ConversionInUTC)

- (NSDate *)dateInUTCForFormat:(NSString *)format;

@end

NS_ASSUME_NONNULL_END
