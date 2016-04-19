//
//  scannedTVC.h
//  PurchaseMate
//
//  Created by Jacob Banks on 2/3/16.
//  Copyright © 2016 Jacobanks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface scannedTVC : UITableViewController

@property (strong, nonatomic) NSMutableArray *barcodeArray;
@property (strong, nonatomic) NSDictionary *corpInfo;

@property (strong, nonatomic) NSDictionary *neededCorpInfo;

- (void)loadTableView:(NSNotification *)notification;

@end
