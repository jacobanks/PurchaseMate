//
//  ResultsTVC.m
//  PurchaseMate
//
//  Created by Jacob Banks on 6/14/15.
//  Copyright (c) 2015 PurchaseMate. All rights reserved.
//

#import "ResultsTVC.h"

@interface ResultsTVC ()

@end

@implementation ResultsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    self.title = organizationName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    AppDelegate *app =  (AppDelegate*)[[UIApplication sharedApplication] delegate];

    return app.keysArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    AppDelegate *app =  (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSArray *titlesArray = [[NSArray alloc] initWithObjects:@"Gave to 527", @"Spent Lobbying", @"Cycle", @"Total from 527", @"Given to Republicans", @"Soft", @"Total from Individuals", @"Company Name", @"Given to Democrats", @"Total Contributions", @"Organization ID", @"Total From PACs", @"Members Invested", @"Total given to PACs", @"Given to Party Committees", @"Given to Candidates", @"Spent on Independent", @"Source", nil];
    
    // Configure the cell...
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *arrayString = [app.valuesArray objectAtIndex:indexPath.row];
   
    NSString *formattedString = [formatter stringFromNumber:[NSNumber numberWithInteger:arrayString.integerValue]];
    
    cell.textLabel.text = [titlesArray objectAtIndex:indexPath.row];
    
    if (indexPath.row <= 1) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"$%@", formattedString];
    } else if (indexPath.row <= 6 && indexPath.row >= 3){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"$%@", formattedString];
    } else if (indexPath.row >= 8 && indexPath.row <= 9) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"$%@", formattedString];
    } else if (indexPath.row == 11) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"$%@", formattedString];
    } else if (indexPath.row > 12 && indexPath.row <= 16) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"$%@", formattedString];
    } else {
        cell.detailTextLabel.text = [app.valuesArray objectAtIndex:indexPath.row];
    }
    
    return cell;
}

@end
