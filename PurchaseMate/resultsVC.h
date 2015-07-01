//
//  resultsVC.h
//  PurchaseMate
//
//  Created by Jacob Banks on 6/29/15.
//  Copyright (c) 2015 Jacobanks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChart.h"

@interface resultsVC : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *lobbyingLabel;
@property (nonatomic, strong) IBOutlet UILabel *republicanLabel;
@property (nonatomic, strong) IBOutlet UILabel *democratLabel;
@property (nonatomic, strong) IBOutlet UILabel *indiLabel;
@property (nonatomic, strong) IBOutlet UILabel *totalLabel;

@end
