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

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *lobbyingLabel;
@property (nonatomic, strong) UILabel *republicanLabel;
@property (nonatomic, strong) UILabel *democratLabel;
@property (nonatomic, strong) UILabel *indiLabel;
@property (nonatomic, strong) UILabel *repubTitleLabel;
@property (nonatomic, strong) UILabel *demoTitleLabel;
@property (nonatomic, strong) UILabel *lobbyTitleLabel;
@property (nonatomic, strong) UILabel *indiTitleLabel;
@property (nonatomic, strong) UILabel *noDataLabel;
@property (nonatomic, strong) UILabel *ethicsLabel;
@property (nonatomic, strong) UILabel *ethicsTitleLabel;
@property (nonatomic, strong) UIButton *reviewButton;
@property (nonatomic, strong) UIScrollView *scrollView;

@end
