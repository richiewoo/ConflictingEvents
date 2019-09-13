//
//  EventTableViewCell.m
//  Upcoming Events
//
//  Created by Xinbo Wu on 8/1/19.
//  Copyright © 2019 Xinbo Wu. All rights reserved.
//

#import "EventTableViewCell.h"

@interface EventTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *conflictLabel;

@end

@implementation EventTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString*)title start:(NSString*) stTime end:(NSString*)enTime overlap:(BOOL) overlapped {
    self.titleLabel.text = title;
    self.startTimeLabel.text = stTime;
    self.endTimeLabel.text = enTime;
    self.conflictLabel.hidden = !overlapped;
}

@end
