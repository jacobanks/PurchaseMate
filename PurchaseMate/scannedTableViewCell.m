//
//  scannedTableViewCell.m
//  PurchaseMate
//
//  Created by Jacob Banks on 2/15/16.
//  Copyright © 2016 Jacobanks. All rights reserved.
//

#import "scannedTableViewCell.h"

@implementation scannedTableViewCell
@synthesize titleLabel = _titleLabel;
@synthesize subtitleLabel = _subtitleLabel;
@synthesize barcodeLabel = _barcodeLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
