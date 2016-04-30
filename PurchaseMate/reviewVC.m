//
//  reviewVC.m
//  PurchaseMate
//
//  Created by Jacob Banks on 7/28/15.
//  Copyright (c) 2015 Jacobanks. All rights reserved.
//

#import "reviewVC.h"
#import "ViewController.h"
#import "MBProgressHUD.h"
#import "CorpInfo.h"

@interface reviewVC () <RateViewDelegate>

@property (strong, nonatomic) RateView *ratingView;
@property (strong, nonatomic) NSString *ratingString;


@property (strong, nonatomic) UIView *corpTitleView;
@property (strong, nonatomic) UIView *rateView;
@property (strong, nonatomic) UIView *buyView;
@property (strong, nonatomic) UIView *explainView;

@property (strong, nonatomic) UILabel *corpLabel;
@property (strong, nonatomic) UILabel *productLabel;
@property (strong, nonatomic) UILabel *rateLabel;
@property (strong, nonatomic) UILabel *buyLabel;
@property (strong, nonatomic) UILabel *whyLabel;
@property (strong, nonatomic) UILabel *explainTitleLabel;


@property (strong, nonatomic) UIButton *yesButton;
@property (strong, nonatomic) UIButton *noButton;

@property (strong, nonatomic) UITextView *explainTextView;

@property (strong, nonatomic) NSString *buyQuestionString;

@property (strong, nonatomic) NSDictionary *corpData;

@end

@implementation reviewVC

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Review";
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        CorpInfo *corpInfo = [[CorpInfo alloc] init];
        self.corpData = corpInfo.getCorpDictionary;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.view.frame))];
            scrollview.showsVerticalScrollIndicator = YES;
            scrollview.scrollEnabled = YES;
            scrollview.userInteractionEnabled = YES;
            [self.view addSubview:scrollview];
            scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.view.frame) + 20);
            
            self.corpTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, CGRectGetWidth(self.view.frame), 120)];
            [self addShadowtoView:self.corpTitleView];
            
            self.corpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.corpTitleView.frame), 40)];
            self.corpLabel.text = self.corpData[@"corpName"];
            self.corpLabel.textAlignment = NSTextAlignmentCenter;
            self.corpLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:25];
            [self.corpTitleView addSubview:self.corpLabel];
            
            self.productLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, CGRectGetWidth(self.corpTitleView.frame), 30)];
            self.productLabel.text = self.corpData[@"productName"];
            self.productLabel.textAlignment = NSTextAlignmentCenter;
            self.productLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:20];
            self.productLabel.alpha = 0.7 ;
            [self.corpTitleView addSubview:self.productLabel];
            
            [scrollview addSubview:self.corpTitleView];
            
            self.rateView = [[UIView alloc] initWithFrame:CGRectMake(0, 122, CGRectGetWidth(self.view.frame), 80)];
            [self addShadowtoView:self.rateView];
            
            self.rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, 100, 20)];
            self.rateLabel.text = @"Rate:";
            self.rateLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:20];
            self.rateLabel.alpha = 0.7;
            [self.rateView addSubview:self.rateLabel];
            
            self.ratingView = [[RateView alloc] initWithFrame:CGRectMake(100, 15, CGRectGetWidth(self.view.frame) / 2 + 60, 50)];
            self.ratingView.notSelectedImage = [UIImage imageNamed:@"starEmpty"];
            self.ratingView.fullSelectedImage = [UIImage imageNamed:@"starFull"];
            self.ratingView.rating = 0;
            self.ratingView.editable = YES;
            self.ratingView.maxRating = 5;
            self.ratingView.delegate = self;
            [self.rateView addSubview:self.ratingView];
            
            [scrollview addSubview:self.rateView];
            
            self.buyView = [[UIView alloc] initWithFrame:CGRectMake(0, 203, CGRectGetWidth(self.view.frame), 127)];
            [self addShadowtoView:self.buyView];
            
            self.buyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(self.view.frame), 25)];
            self.buyLabel.text = @"Would you buy this product?";
            self.buyLabel.textAlignment = NSTextAlignmentCenter;
            self.buyLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:20];
            self.buyLabel.alpha = 0.7;
            [self.buyView addSubview:self.buyLabel];
            
            self.yesButton = [[UIButton alloc] initWithFrame:CGRectMake(4, 45, CGRectGetWidth(self.view.frame) / 2 - 6, 77)];
            [self.yesButton setTitle:@"Yes" forState:UIControlStateNormal];
            [self.yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.yesButton.backgroundColor = [UIColor darkGrayColor];
            self.yesButton.alpha = 0.5;
            
            self.yesButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
            self.yesButton.layer.borderWidth = 2;
            self.yesButton.layer.cornerRadius = 5;
            
            [self.yesButton addTarget:self action:@selector(yesClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.buyView addSubview:self.yesButton];
            
            self.noButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2 + 2, 45, CGRectGetWidth(self.view.frame) / 2 - 6, 77)];
            [self.noButton setTitle:@"No" forState:UIControlStateNormal];
            [self.noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.noButton addTarget:self action:@selector(noClicked:) forControlEvents:UIControlEventTouchUpInside];
            self.noButton.backgroundColor = [UIColor redColor];
            self.noButton.alpha = 0.5;
            
            self.noButton.layer.borderColor = [UIColor redColor].CGColor;
            self.noButton.layer.borderWidth = 2;
            self.noButton.layer.cornerRadius = 5;
            [self.buyView addSubview:self.noButton];
            
            [scrollview addSubview:self.buyView];
            
            self.explainView = [[UIView alloc] initWithFrame:CGRectMake(0, 331, CGRectGetWidth(self.view.frame), 140)];
            [self addShadowtoView:self.explainView];
            
            self.explainTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(self.view.frame), 25)];
            self.explainTitleLabel.text = @"Further Review/Comments";
            self.explainTitleLabel.textAlignment = NSTextAlignmentCenter;
            self.explainTitleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:20];
            self.explainTitleLabel.alpha = 0.7;
            [self.explainView addSubview:self.explainTitleLabel];
            
            self.explainTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, self.explainTitleLabel.center.y + 15, CGRectGetWidth(self.explainView.frame), 100)];
            self.explainTextView.editable = YES;
            [self.explainView addSubview:self.explainTextView];
            
            [scrollview addSubview:self.explainView];
            
            [self.view addSubview:scrollview];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.title = @"Review";
    
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(submitClicked:)];
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

#pragma mark - Actions

- (void)yesClicked:(id)sender {
    self.buyQuestionString = @"Yes";
    self.yesButton.backgroundColor = [UIColor darkGrayColor];
    [self.yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.yesButton.alpha = 1.0;
    
    self.noButton.backgroundColor = [UIColor redColor];
    [self.noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.noButton.alpha = 0.5;
}

- (void)noClicked:(id)sender {
    self.buyQuestionString = @"No";
    self.noButton.backgroundColor = [UIColor redColor];
    [self.noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.noButton.alpha = 1.0;
    
    self.yesButton.backgroundColor = [UIColor darkGrayColor];
    [self.yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.yesButton.alpha = 0.5;
}

- (void)submitClicked:(id)sender {
    
    if (self.buyQuestionString == nil || self.ratingString == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                              message:@"You need to fill out all fields before continuing!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        
    } else {
            NSDictionary *userReview = @{
                                         @"corporation" : self.corpData[@"corpName"][@"orgname"],
                                         @"product" : self.corpData[@"productName"],
                                         @"buyQuestion" : self.buyQuestionString,
                                         @"rating" : self.ratingString,
                                         @"review" : self.explainTextView.text
                                         };
        
        NSError *error = nil;
        if (error) {
            NSLog(@"%@", error);
        }
        
        //Connect to MongoDB
        MongoConnection *dbConn = [MongoConnection connectionForServer:@"45.55.207.148" error:&error];
        MongoDBCollection *collection = [dbConn collectionWithName:@"reviewsDB.review"];
        [collection insertDictionary:userReview writeConcern:nil error:&error];
        
        self.tabBarController.selectedIndex = 0;
        
        NSInteger stars = [[NSUserDefaults standardUserDefaults] integerForKey:@"stars"];
        [[NSUserDefaults standardUserDefaults] setInteger:stars += 1 forKey:@"stars"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thank You!"
                                                        message:@"Thank you for reviewing this corporation!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - RateViewDelegate

- (void)rateView:(RateView *)rateView ratingDidChange:(int)rating {
    self.ratingString = [NSString stringWithFormat:@"%d", rating];
}

@end
