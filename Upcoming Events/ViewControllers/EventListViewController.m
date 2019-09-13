//
//  EventListViewController.m
//  Upcoming Events
//
//  Created by Xinbo Wu on 7/31/19.
//  Copyright © 2019 Xinbo Wu. All rights reserved.
//

#import "EventListViewController.h"
#import "EventListViewModel.h"
#import "EventTableViewCell.h"

#import "Utils+Category.h"

static NSDateFormatter *dateFormatterInUTC = nil;

@interface EventListViewController ()

@property(nonatomic) EventListViewModel* viewModel;

@end

@implementation EventListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Upcoming events";

    _viewModel = [[EventListViewModel alloc] initWithDatabaseFilePath:[NSBundle.mainBundle URLForResource:@"mock" withExtension:@"json"]];
    
    [_viewModel loadEvents:^(NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel numberOfDays];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfEventsIn:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.viewModel dayStringIn:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reusedIdentifier" forIndexPath:indexPath];
    //Configure the cell...
    [cell setTitle:[self.viewModel titleStringIn:indexPath.section row:indexPath.row]
             start:[self.viewModel startTimeStringIn:indexPath.section row:indexPath.row]
               end:[self.viewModel endTimeStringIn:indexPath.section row:indexPath.row]
           overlap:[self.viewModel eventOverlappedIn:indexPath.section row:indexPath.row]];
    
    return cell;
}

@end
