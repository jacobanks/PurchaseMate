//
//  scannedTVC.m
//  PurchaseMate
//
//  Created by Jacob Banks on 2/3/16.
//  Copyright © 2016 Jacobanks. All rights reserved.
//

#import "scannedTVC.h"
#import "scannedTableViewCell.h"
#import "CorpInfo.h"
#import "MBProgressHUD.h"

@interface scannedTVC ()

@end

@implementation scannedTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
    
    [self loadTableView:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadTableView:)
                                                 name:@"loadTableView"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.title = @"Scanned Products";
    
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadTableView:(NSNotification *)notification {
    self.barcodeArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"barcodes"]];
    
    self.neededCorpInfo = [[NSMutableDictionary alloc] init];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.navigationController.view animated:YES];
    hud.labelText = @"Loading...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        for (int i = 0; i < self.barcodeArray.count; i++) {
            self.corpInfo = [[[CorpInfo alloc] init] getCorpInfoWithBarcode:self.barcodeArray[i]];
            [self.neededCorpInfo setValue:[NSArray arrayWithObjects:self.corpInfo[@"orgDict"][@"orgname"], self.corpInfo[@"productName"], nil] forKey:[NSString stringWithFormat:@"%i", i]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.tabBarController.navigationController.view animated:YES];
        });
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.neededCorpInfo count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    scannedTableViewCell *cell = (scannedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"scannedCell"];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", self.neededCorpInfo[[NSString stringWithFormat:@"%li", (long)indexPath.row]][1]];
    cell.subtitleLabel.text = [NSString stringWithFormat:@"%@", self.neededCorpInfo[[NSString stringWithFormat:@"%li", (long)indexPath.row]][0]];
    cell.barcodeLabel.text = [NSString stringWithFormat:@"%@", self.barcodeArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.navigationController.view animated:YES];
    hud.labelText = @"Loading...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        self.corpInfo = [[[CorpInfo alloc] init] getCorpInfoWithBarcode:self.barcodeArray[indexPath.row]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            barcodeID = self.barcodeArray[indexPath.row];
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            resultsVC *vc = (resultsVC *)[mainStoryboard instantiateViewControllerWithIdentifier:@"results"];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:navController animated:YES completion:nil];
            
            [MBProgressHUD hideHUDForView:self.tabBarController.navigationController.view animated:YES];
        });
    });
}

@end
