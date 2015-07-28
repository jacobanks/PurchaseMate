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

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *lobbyingLabel;
@property (nonatomic, strong) IBOutlet UILabel *republicanLabel;
@property (nonatomic, strong) IBOutlet UILabel *democratLabel;
@property (nonatomic, strong) IBOutlet UILabel *indiLabel;
@property (nonatomic, strong) IBOutlet UILabel *repubTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *demoTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *lobbyTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *indiTitleLabel;
@property (nonatomic, strong) UILabel *noDataLabel;
@property (nonatomic, strong) IBOutlet UILabel *ethicsLabel;
@property (nonatomic, strong) IBOutlet UILabel *ethicsTitleLabel;
@property (nonatomic, strong) IBOutlet UIButton *reviewButton;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@end
