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
    self.corpTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, self.view.frame.size.width, 100)];
    [self addShadowtoView:self.corpTitleView];
    [self.view addSubview:self.corpTitleView];
    
    self.rateView = [[UIView alloc] initWithFrame:CGRectMake(0, 102, self.view.frame.size.width, 80)];
    [self addShadowtoView:self.rateView];
    [self.view addSubview:self.rateView];
    
    self.buyView = [[UIView alloc] initWithFrame:CGRectMake(0, 183, self.view.frame.size.width, 110)];
    [self addShadowtoView:self.buyView];
    [self.view addSubview:self.buyView];
    
    self.whyView = [[UIView alloc] initWithFrame:CGRectMake(0, 294, self.view.frame.size.width, 96)];
    [self addShadowtoView:self.whyView];
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
