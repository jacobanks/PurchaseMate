//
//  reviewVC.h
//  PurchaseMate
//
//  Created by Jacob Banks on 7/28/15.
//  Copyright (c) 2015 Jacobanks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface reviewVC : UIViewController

@property (strong, nonatomic) UIView *corpTitleView;
@property (strong, nonatomic) UIView *rateView;
@property (strong, nonatomic) UIView *buyView;
@property (strong, nonatomic) UIView *whyView;

@property (strong, nonatomic) UILabel *corpLabel;
@property (strong, nonatomic) UILabel *productLabel;
@property (strong, nonatomic) UILabel *rateLabel;
@property (strong, nonatomic) UILabel *buyLabel;

@end
