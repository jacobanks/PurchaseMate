//
//  reviewVC.m
//  PurchaseMate
//
//  Created by Jacob Banks on 7/28/15.
//  Copyright (c) 2015 Jacobanks. All rights reserved.
//

#import "reviewVC.h"

@interface reviewVC ()

@end

@implementation reviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.corpTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, self.view.frame.size.width, 120)];
    [self addShadowtoView:self.corpTitleView];
    
    self.corpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.corpTitleView.frame.size.width, 30)];
    self.corpLabel.text = organizationName;
    self.corpLabel.textAlignment = NSTextAlignmentCenter;
    self.corpLabel.font = [UIFont fontWithName:nil size:25];
    [self.corpTitleView addSubview:self.corpLabel];
    
    self.productLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, self.corpTitleView.frame.size.width, 20)];
    self.productLabel.text = productName;
    self.productLabel.textAlignment = NSTextAlignmentCenter;
    self.productLabel.font = [UIFont fontWithName:nil size:20];
    self.productLabel.alpha = 0.7 ;
    [self.corpTitleView addSubview:self.productLabel];
    
    [self.view addSubview:self.corpTitleView];
    
    self.rateView = [[UIView alloc] initWithFrame:CGRectMake(0, 122, self.view.frame.size.width, 80)];
    [self addShadowtoView:self.rateView];
    
    self.rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, 100, 20)];
    self.rateLabel.text = @"Rate:";
    self.rateLabel.font = [UIFont fontWithName:nil size:20];
    self.rateLabel.alpha = 0.7;
    [self.rateView addSubview:self.rateLabel];
    
    [self.view addSubview:self.rateView];
    
    self.buyView = [[UIView alloc] initWithFrame:CGRectMake(0, 203, self.view.frame.size.width, 127)];
    [self addShadowtoView:self.buyView];
    
    self.buyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 25)];
    self.buyLabel.text = @"Would you buy this product?";
    self.buyLabel.textAlignment = NSTextAlignmentCenter;
    self.buyLabel.font = [UIFont fontWithName:nil size:20];
    self.buyLabel.alpha = 0.7;
    [self.buyView addSubview:self.buyLabel];
    
    self.yesButton = [[UIButton alloc] initWithFrame:CGRectMake(4, 45, self.view.frame.size.width / 2 - 6, 77)];
    [self.yesButton setTitle:@"Yes" forState:UIControlStateNormal];
    [self.yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.yesButton.backgroundColor = [UIColor darkGrayColor];
    [self.buyView addSubview:self.yesButton];
    
    self.noButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 + 2, 45, self.view.frame.size.width / 2 - 6, 77)];
    [self.noButton setTitle:@"No" forState:UIControlStateNormal];
    [self.noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.noButton.backgroundColor = [UIColor redColor];
    [self.buyView addSubview:self.noButton];

    [self.view addSubview:self.buyView];
    
    self.whyView = [[UIView alloc] initWithFrame:CGRectMake(0, 331, self.view.frame.size.width, 120)];
    [self addShadowtoView:self.whyView];
    
    self.whyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 25)];
    self.whyLabel.text = @"Why/Why not?";
    self.whyLabel.textAlignment = NSTextAlignmentCenter;
    self.whyLabel.font = [UIFont fontWithName:nil size:20];
    self.whyLabel.alpha = 0.7;
    [self.whyView addSubview:self.whyLabel];
    
    self.ethicsButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 35, 130, 35)];
    [self.ethicsButton setTitle:@"Ethics" forState:UIControlStateNormal];
    [self.ethicsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.ethicsButton.backgroundColor = [UIColor whiteColor];
    self.ethicsButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.ethicsButton.layer.borderWidth = 2;
    self.ethicsButton.layer.cornerRadius = 5;
    [self.whyView addSubview:self.ethicsButton];
    
    self.politicsButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 35, 130, 35)];
    [self.politicsButton setTitle:@"Politics" forState:UIControlStateNormal];
    [self.politicsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.politicsButton.backgroundColor = [UIColor whiteColor];
    self.politicsButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.politicsButton.layer.borderWidth = 2;
    self.politicsButton.layer.cornerRadius = 5;
    [self.whyView addSubview:self.politicsButton];
    
    self.gmoButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 80, 130, 35)];
    [self.gmoButton setTitle:@"GMO" forState:UIControlStateNormal];
    [self.gmoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.gmoButton.backgroundColor = [UIColor whiteColor];
    self.gmoButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.gmoButton.layer.borderWidth = 2;
    self.gmoButton.layer.cornerRadius = 5;
    [self.whyView addSubview:self.gmoButton];
    
    self.originButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 80, 130, 35)];
    [self.originButton setTitle:@"Origin" forState:UIControlStateNormal];
    [self.originButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.originButton.backgroundColor = [UIColor whiteColor];
    self.originButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.originButton.layer.borderWidth = 2;
    self.originButton.layer.cornerRadius = 5;
    [self.whyView addSubview:self.originButton];
    
    [self.view addSubview:self.whyView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addShadowtoView:(UIView *)view {
    view.backgroundColor = [UIColor whiteColor];
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 0.2;
    view.layer.shadowRadius = 2;
    view.layer.shadowOffset = CGSizeMake(0,0);
    view.layer.cornerRadius = 5;
}

@end
