//
//  scannedTableViewCell.h
//  PurchaseMate
//
//  Created by Jacob Banks on 2/15/16.
//  Copyright © 2016 Jacobanks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface scannedTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *barcodeLabel;

@end
