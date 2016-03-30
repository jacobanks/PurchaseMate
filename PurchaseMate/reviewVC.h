//
//  reviewVC.h
//  PurchaseMate
//
//  Created by Jacob Banks on 7/28/15.
//  Copyright (c) 2015 Jacobanks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "RateView.h"
#import "MBProgressHUD.h"
#import "CorpInfo.h"

@interface reviewVC : UIViewController <RateViewDelegate>

@property (strong, nonatomic) RateView *ratingView;
@property (strong, nonatomic) NSString *ratingString;


@property (strong, nonatomic) UIView *corpTitleView;
@property (strong, nonatomic) UIView *rateView;
@property (strong, nonatomic) UIView *buyView;
@property (strong, nonatomic) UIView *whyView;
@property (strong, nonatomic) UIView *explainView;

@property (strong, nonatomic) UILabel *corpLabel;
@property (strong, nonatomic) UILabel *productLabel;
@property (strong, nonatomic) UILabel *rateLabel;
@property (strong, nonatomic) UILabel *buyLabel;
@property (strong, nonatomic) UILabel *whyLabel;
@property (strong, nonatomic) UILabel *explainTitleLabel;


@property (strong, nonatomic) UIButton *yesButton;
@property (strong, nonatomic) UIButton *noButton;
@property (strong, nonatomic) UIButton *ethicsButton;
@property (strong, nonatomic) UIButton *gmoButton;
@property (strong, nonatomic) UIButton *politicsButton;
@property (strong, nonatomic) UIButton *originButton;
@property (strong, nonatomic) UIButton *submitButton;

@property (strong, nonatomic) UITextView *explainTextView;

@property (strong, nonatomic) NSString *buyQuestionString;
@property (strong, nonatomic) NSMutableArray *whyArray;

@property (strong, nonatomic) NSDictionary *corpData;

@end
