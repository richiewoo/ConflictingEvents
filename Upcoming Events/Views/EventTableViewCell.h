//
//  EventTableViewCell.h
//  Upcoming Events
//
//  Created by Xinbo Wu on 8/1/19.
//  Copyright © 2019 Xinbo Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventTableViewCell : UITableViewCell

- (void)setTitle:(NSString*)title start:(NSString*) stTime end:(NSString*)enTime overlap:(BOOL) overlapped;

@end

NS_ASSUME_NONNULL_END
