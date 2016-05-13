//
//  resultsVC.m
//  PurchaseMate
//
//  Created by Jacob Banks on 6/29/15.
//  Copyright (c) 2015 Jacobanks. All rights reserved.
//

#import "resultsVC.h"
#import "ViewController.h"
#import "PNChart.h"
#import "reviewVC.h"
#import "reportTVC.h"
#import "CorpInfo.h"
#import "MBProgressHUD.h"

@interface resultsVC ()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) IBOutlet UILabel *corpLabel;
@property (nonatomic, strong) IBOutlet UILabel *productLabel;

@property (nonatomic, strong) IBOutlet UILabel *republicanLabel;
@property (nonatomic, strong) IBOutlet UILabel *repubTitleLabel;

@property (nonatomic, strong) IBOutlet UILabel *democratLabel;
@property (nonatomic, strong) IBOutlet UILabel *demoTitleLabel;

@property (nonatomic, strong) IBOutlet UILabel *lobbyingLabel;
@property (nonatomic, strong) IBOutlet UILabel *lobbyTitleLabel;

@property (nonatomic, strong) IBOutlet UILabel *ethicsLabel;
@property (nonatomic, strong) IBOutlet UILabel *ethicsTitleLabel;

@property (nonatomic, strong) IBOutlet UILabel *indiTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *indiLabel;

@property (nonatomic, strong) UILabel *starsLabel;

@property (nonatomic, strong) UIView *starsView;
@property (nonatomic, strong) IBOutlet UIView *lobbyingView, *independentView, *equityView;

@property (nonatomic, strong) IBOutlet UITableViewCell *contributionsCell, *partyCell;
@property (nonatomic, strong) NSDictionary *corpData;

@end

@implementation resultsVC

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:6.0/255.0 green:181.0/255.0 blue:124.0/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // get corporation info
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        self.partyCell.hidden = YES;
        self.contributionsCell.hidden = YES;
        
        self.corpData = [[[CorpInfo alloc] init] getCorpDictionary];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.partyCell.hidden = NO;
            self.contributionsCell.hidden = NO;

            self.lobbyingView.backgroundColor = [UIColor whiteColor];
            self.lobbyingView.layer.borderColor = [UIColor colorWithRed:6.0/255.0 green:181.0/255.0 blue:124.0/255.0 alpha:1].CGColor;
            self.lobbyingView.layer.borderWidth = 2;
            self.lobbyingView.layer.cornerRadius = 5;
            
            self.independentView.backgroundColor = [UIColor whiteColor];
            self.independentView.layer.borderColor = [UIColor colorWithRed:6.0/255.0 green:181.0/255.0 blue:124.0/255.0 alpha:1].CGColor;
            self.independentView.layer.borderWidth = 2;
            self.independentView.layer.cornerRadius = 5;
            
            self.equityView.backgroundColor = [UIColor whiteColor];
            self.equityView.layer.borderColor = [UIColor colorWithRed:6.0/255.0 green:181.0/255.0 blue:124.0/255.0 alpha:1].CGColor;
            self.equityView.layer.borderWidth = 2;
            self.equityView.layer.cornerRadius = 5;
            
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            
            NSString *lobbyingString = [NSString stringWithFormat:@"%@", self.corpData[@"politicalInfo"][@"lobbying"]];
            NSString *repubString = [NSString stringWithFormat:@"%@", self.corpData[@"politicalInfo"][@"repubs"]];
            NSString *demString = [NSString stringWithFormat:@"%@", self.corpData[@"politicalInfo"][@"dems"]];
            NSString *indiString = [NSString stringWithFormat:@"%@", self.corpData[@"politicalInfo"][@"outside"]];
            NSString *ethicsString = [NSString stringWithFormat:@"%@", self.corpData[@"ethics"]];
            
            NSString *formattedLobbyingString = [formatter stringFromNumber:[NSNumber numberWithInteger:lobbyingString.integerValue]];
            NSString *formattedRepubsString = [formatter stringFromNumber:[NSNumber numberWithInteger:repubString.integerValue]];
            NSString *formattedDemsString = [formatter stringFromNumber:[NSNumber numberWithInteger:demString.integerValue]];
            NSString *formattedIndiString = [formatter stringFromNumber:[NSNumber numberWithInteger:indiString.integerValue]];
            
            
            self.lobbyingLabel.text = [NSString stringWithFormat:@"$%@", formattedLobbyingString];
            self.republicanLabel.text = [NSString stringWithFormat:@"$%@", formattedRepubsString];
            self.democratLabel.text = [NSString stringWithFormat:@"$%@", formattedDemsString];
            self.indiLabel.text = [NSString stringWithFormat:@"$%@", formattedIndiString];
            self.ethicsLabel.text = self.corpData[@"ethics"];
            
            self.productLabel.text = self.corpData[@"productName"];
            self.corpLabel.text = self.corpData[@"corpName"];
            
            // check if there is no data for ethics rating
            if (![ethicsString isEqual:@"(null)"]) {
                
                // if there is data setup the label
                if (ethicsString.intValue <= 50) {
                    self.ethicsLabel.textColor = [UIColor redColor];
                } else if (ethicsString.intValue > 50 && ethicsString.intValue <= 70) {
                    self.ethicsLabel.textColor = [UIColor colorWithRed:215/255.0 green:216/255.0 blue:25/255.0 alpha:1.0];
                } else {
                    self.ethicsLabel.textColor = [UIColor colorWithRed:0/255.0 green:216/255.0 blue:6/255.0 alpha:1.0];
                }
                
            } else {
                self.ethicsLabel.textColor = [UIColor lightGrayColor];
                self.ethicsLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:18];
                self.ethicsLabel.text = @"No Data";
            }
            
            int repubRandomINT = arc4random() %51 + 50;
            int demoRandomINT = arc4random() %51 + 50;
            
            if (repubString.intValue == 0 && demString.intValue == 0) {
                repubRandomINT = 1;
                demoRandomINT = 1;
            } else if (repubString.intValue == 0) {
                repubRandomINT = 1;
            } else if (demString.intValue == 0) {
                demoRandomINT = 1;
            } else if (repubString.intValue < demString.intValue) {
                repubRandomINT = demoRandomINT - 30;
            } else {
                demoRandomINT = repubRandomINT - 30;
            }
            
            // initial setup for graphs
            PNCircleChart *republicanChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 60.0, SCREEN_WIDTH / 2 + 6, 90.0) total:[NSNumber numberWithInt:100] current:[NSNumber numberWithInt:repubRandomINT] clockwise:NO];
            republicanChart.backgroundColor = [UIColor clearColor];
            [republicanChart setStrokeColor:PNRed];
            [republicanChart strokeChart];
            [self.partyCell addSubview:republicanChart];
            
            PNCircleChart *democratChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 60.0, SCREEN_WIDTH * 1.45, 90.0) total:[NSNumber numberWithInt:100] current:[NSNumber numberWithInt:demoRandomINT] clockwise:NO];
            democratChart.backgroundColor = [UIColor clearColor];
            [democratChart setStrokeColor:PNBlue];
            [democratChart strokeChart];
            [self.partyCell addSubview:democratChart];

            
            // set labels to be set at the center of the graphs
            self.republicanLabel.frame = CGRectMake(CGRectGetMinX(republicanChart.frame), CGRectGetMinY(republicanChart.frame), CGRectGetWidth(republicanChart.frame), CGRectGetHeight(republicanChart.frame));
            self.repubTitleLabel.frame = CGRectMake(CGRectGetMinX(republicanChart.frame),CGRectGetMinY(self.repubTitleLabel.frame), CGRectGetWidth(republicanChart.frame), CGRectGetHeight(self.repubTitleLabel.frame));
            
            self.democratLabel.frame = CGRectMake(CGRectGetMinX(democratChart.frame), CGRectGetMinY(democratChart.frame), CGRectGetWidth(democratChart.frame), CGRectGetHeight(democratChart.frame));
            self.demoTitleLabel.frame = CGRectMake(CGRectGetMinX(democratChart.frame), CGRectGetMinY(self.demoTitleLabel.frame), CGRectGetWidth(democratChart.frame), CGRectGetHeight(self.demoTitleLabel.frame));
            
            //        NSInteger stars = [[NSUserDefaults standardUserDefaults] integerForKey:@"stars"];
            //        if (stars != 0) {
            //            self.starsView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.viewframe) - 110, self.view.frame.size.width, 50)];
            //            [self.starsView setBackgroundColor:[UIColor colorWithRed:122/255.0 green:218/255.0 blue:255/255 alpha:1]];
            //
            //            self.starsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 375, 50)];
            //            self.starsLabel.textColor = [UIColor whiteColor];
            //            self.starsLabel.font = [UIFont systemFontOfSize:16];
            //            self.starsLabel.textAlignment = NSTextAlignmentCenter;
            //
            //            if (stars <= 1) {
            //                self.starsLabel.text = [NSString stringWithFormat:@"You have %ld star!", (long)stars];
            //            } else {
            //                self.starsLabel.text = [NSString stringWithFormat:@"You have %ld stars!", (long)stars];
            //            }
            //
            //            [self.starsView addSubview:self.starsLabel];
            //
            //            [self.view addSubview:self.starsView];
            //        }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.tabBarController.title = @"Results";
//    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissView)];
    
    UIButton *report = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 45)];
    [report setImage:[UIImage imageNamed:@"warningTriangle"] forState:UIControlStateNormal];
    [report addTarget:self action:@selector(openReportView) forControlEvents:UIControlEventTouchUpInside];
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:report];
    
    UIButton *done = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    done.tintColor = [UIColor whiteColor];
    UIImage *offImage = [[UIImage imageNamed:@"cross"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [done setImage:offImage forState:UIControlStateNormal];
    [done addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:done];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @""
                                   style: UIBarButtonItemStylePlain
                                   target: nil action: nil];
    
    [self.tabBarController.navigationItem setBackBarButtonItem: backButton];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)openReportView {
    [self performSegueWithIdentifier:@"report" sender:nil];
}

- (void)dismissView {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
