//
//  scannedTVC.m
//  PurchaseMate
//
//  Created by Jacob Banks on 2/3/16.
//  Copyright © 2016 Jacobanks. All rights reserved.
//

#import "scannedTVC.h"
#import "scannedTableViewCell.h"

@interface scannedTVC ()

@end

@implementation scannedTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];

}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.title = @"Scanned Products";
    
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    
    self.barcodeArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"barcodes"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.barcodeArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    scannedTableViewCell *cell = (scannedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"scannedCell"];
    
    self.corpInfo = [[[CorpInfo alloc] init] getCorpInfoWithBarcode:self.barcodeArray[indexPath.row]];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", self.corpInfo[@"orgDict"][@"orgname"]];
    cell.subtitleLabel.text = [NSString stringWithFormat:@"%@", self.corpInfo[@"productName"]];
    cell.barcodeLabel.text = [NSString stringWithFormat:@"%@", self.barcodeArray[indexPath.row]];
    
    return cell;
}

@end
