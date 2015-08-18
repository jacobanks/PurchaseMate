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
    self.corpLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:25];
    [self.corpTitleView addSubview:self.corpLabel];
    
    self.productLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, self.corpTitleView.frame.size.width, 20)];
    self.productLabel.text = productName;
    self.productLabel.textAlignment = NSTextAlignmentCenter;
    self.productLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:20];
    self.productLabel.alpha = 0.7 ;
    [self.corpTitleView addSubview:self.productLabel];
    
    [self.view addSubview:self.corpTitleView];
    
    self.rateView = [[UIView alloc] initWithFrame:CGRectMake(0, 122, self.view.frame.size.width, 80)];
    [self addShadowtoView:self.rateView];
    
    self.rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, 100, 20)];
    self.rateLabel.text = @"Rate:";
    self.rateLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:20];
    self.rateLabel.alpha = 0.7;
    [self.rateView addSubview:self.rateLabel];
    
    [self.view addSubview:self.rateView];
    
    self.buyView = [[UIView alloc] initWithFrame:CGRectMake(0, 203, self.view.frame.size.width, 127)];
    [self addShadowtoView:self.buyView];
    
    self.buyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 25)];
    self.buyLabel.text = @"Would you buy this product?";
    self.buyLabel.textAlignment = NSTextAlignmentCenter;
    self.buyLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:20];
    self.buyLabel.alpha = 0.7;
    [self.buyView addSubview:self.buyLabel];
    
    self.yesButton = [[UIButton alloc] initWithFrame:CGRectMake(4, 45, self.view.frame.size.width / 2 - 6, 77)];
    [self.yesButton setTitle:@"Yes" forState:UIControlStateNormal];
    [self.yesButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.yesButton setTitleColor:[UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:0.3] forState:UIControlStateHighlighted];
    [self.yesButton addTarget:self action:@selector(yesClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.yesButton.backgroundColor = [UIColor whiteColor];
    self.yesButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.yesButton.layer.borderWidth = 2;
    self.yesButton.layer.cornerRadius = 5;
    [self.buyView addSubview:self.yesButton];
    
    self.noButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 + 2, 45, self.view.frame.size.width / 2 - 6, 77)];
    [self.noButton setTitle:@"No" forState:UIControlStateNormal];
    [self.noButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.noButton setTitleColor:[UIColor colorWithRed:255 green:0 blue:0 alpha:0.3] forState:UIControlStateHighlighted];
    [self.noButton addTarget:self action:@selector(noClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.noButton.backgroundColor = [UIColor whiteColor];
    self.noButton.layer.borderColor = [UIColor redColor].CGColor;
    self.noButton.layer.borderWidth = 2;
    self.noButton.layer.cornerRadius = 5;
    [self.buyView addSubview:self.noButton];

    [self.view addSubview:self.buyView];
    
    self.whyView = [[UIView alloc] initWithFrame:CGRectMake(0, 331, self.view.frame.size.width, 120)];
    [self addShadowtoView:self.whyView];
    
    self.whyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 25)];
    self.whyLabel.text = @"Why/Why not?";
    self.whyLabel.textAlignment = NSTextAlignmentCenter;
    self.whyLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:20];
    self.whyLabel.alpha = 0.7;
    [self.whyView addSubview:self.whyLabel];
    
    self.whyArray = [[NSMutableArray alloc] init];
    
    self.ethicsButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 35, 130, 35)];
    [self.ethicsButton setTitle:@"Ethics" forState:UIControlStateNormal];
    [self.ethicsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.ethicsButton setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] forState:UIControlStateHighlighted];
    self.ethicsButton.backgroundColor = [UIColor whiteColor];
    self.ethicsButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.ethicsButton.layer.borderWidth = 2;
    self.ethicsButton.layer.cornerRadius = 5;
    [self.ethicsButton addTarget:self action:@selector(whyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.whyView addSubview:self.ethicsButton];
    
    self.politicsButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 35, 130, 35)];
    [self.politicsButton setTitle:@"Politics" forState:UIControlStateNormal];
    [self.politicsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.politicsButton setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] forState:UIControlStateHighlighted];
    self.politicsButton.backgroundColor = [UIColor whiteColor];
    self.politicsButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.politicsButton.layer.borderWidth = 2;
    self.politicsButton.layer.cornerRadius = 5;
    [self.politicsButton addTarget:self action:@selector(whyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.whyView addSubview:self.politicsButton];
    
    self.gmoButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 80, 130, 35)];
    [self.gmoButton setTitle:@"GMO" forState:UIControlStateNormal];
    [self.gmoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.gmoButton setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] forState:UIControlStateHighlighted];
    self.gmoButton.backgroundColor = [UIColor whiteColor];
    self.gmoButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.gmoButton.layer.borderWidth = 2;
    self.gmoButton.layer.cornerRadius = 5;
    [self.gmoButton addTarget:self action:@selector(whyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.whyView addSubview:self.gmoButton];
    
    self.originButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 80, 130, 35)];
    [self.originButton setTitle:@"Origin" forState:UIControlStateNormal];
    [self.originButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.originButton setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] forState:UIControlStateHighlighted];
    self.originButton.backgroundColor = [UIColor whiteColor];
    self.originButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.originButton.layer.borderWidth = 2;
    self.originButton.layer.cornerRadius = 5;
    [self.originButton addTarget:self action:@selector(whyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.whyView addSubview:self.originButton];
    
    [self.view addSubview:self.whyView];
    
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitButton.frame = CGRectMake(7, 480, 360, 60);
    self.submitButton.backgroundColor = [UIColor whiteColor];
    [self.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor colorWithRed:6.0/255.0 green:181.0/255.0 blue:124.0/255.0 alpha:1] forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor colorWithRed:6.0/255.0 green:181.0/255.0 blue:124.0/255.0 alpha:0.3] forState:UIControlStateHighlighted];
    [self.submitButton addTarget:self action:@selector(submitClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.submitButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.submitButton.layer.shadowOpacity = 0.5;
    self.submitButton.layer.shadowRadius = 2;
    self.submitButton.layer.shadowOffset = CGSizeMake(0,0);
    self.submitButton.layer.cornerRadius = 15;
    [self.view addSubview:self.submitButton];
    
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

- (void)rateClicked:(id)sender {
    //Have Rate button logic here
}

- (void)yesClicked:(id)sender {
    self.buyQuestionString = @"Yes";
    self.yesButton.backgroundColor = [UIColor darkGrayColor];
    [self.yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.noButton.backgroundColor = [UIColor whiteColor];
    [self.noButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

}

- (void)noClicked:(id)sender {
    self.buyQuestionString = @"No";
    self.noButton.backgroundColor = [UIColor redColor];
    [self.noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.yesButton.backgroundColor = [UIColor whiteColor];
    [self.yesButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

}

- (void)whyButtonClicked:(UIButton *)button {
    
    [self.whyArray addObject:button.titleLabel.text];
    NSLog(@"%@", self.whyArray);
    
    if (button.backgroundColor == [UIColor whiteColor]) {
        button.backgroundColor = [UIColor blackColor];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (void)submitClicked:(id)sender {
    NSDictionary *userReview = @{
                                 @"corporation" : organizationName,
                                 @"product" : productName,
                                 @"buyQuestion" : self.buyQuestionString,
                                 @"why" : self.whyArray,
                                 @"rating" : @(5)
                                 };
//    NSData *data = [[userReview BSONDocument] dataValue];
//    NSDictionary *infoDecoded = [BSONDecoder decodeDictionaryWithData:data];
    
    NSError *error = nil;
    if (error) {
        NSLog(@"%@", error);
    }
    
    //Connect to MongoDB
    MongoConnection *dbConn = [MongoConnection connectionForServer:@"45.55.207.148" error:&error];
    MongoDBCollection *collection = [dbConn collectionWithName:@"reviewsDB.review"];
    [collection insertDictionary:userReview writeConcern:nil error:&error];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
