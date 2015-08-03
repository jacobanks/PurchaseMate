//
//  reviewVC.h
//  PurchaseMate
//
//  Created by Jacob Banks on 7/28/15.
//  Copyright (c) 2015 Jacobanks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface reviewVC : UIViewController

@property (strong, nonatomic) UIView *corpTitleView;
@property (strong, nonatomic) UIView *rateView;
@property (strong, nonatomic) UIView *buyView;
@property (strong, nonatomic) UIView *whyView;

@property (strong, nonatomic) UILabel *corpLabel;
@property (strong, nonatomic) UILabel *productLabel;
@property (strong, nonatomic) UILabel *rateLabel;
@property (strong, nonatomic) UILabel *buyLabel;
@property (strong, nonatomic) UILabel *whyLabel;

@property (strong, nonatomic) UIButton *yesButton;
@property (strong, nonatomic) UIButton *noButton;
@property (strong, nonatomic) UIButton *ethicsButton;
@property (strong, nonatomic) UIButton *gmoButton;
@property (strong, nonatomic) UIButton *politicsButton;
@property (strong, nonatomic) UIButton *originButton;

@end
