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

@property (nonatomic, strong) IBOutlet UILabel *titleLabel, *corpLabel, *productLabel, *lobbyingLabel, *republicanLabel, *democratLabel, *indiLabel, *repubTitleLabel,
*demoTitleLabel, *lobbyTitleLabel, *indiTitleLabel, *ethicsLabel, *ethicsTitleLabel;
@property (nonatomic, strong) UILabel *starsLabel;
@property (nonatomic, strong) UIView *starsView;
@property (nonatomic, strong) IBOutlet UIView *lobbyingView, *independentView, *equityView;
@property (nonatomic, strong) IBOutlet UITableViewCell *contributionsCell, *partyCell;
@property (nonatomic, strong) NSDictionary *corpData;

@end

@implementation resultsVC

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

        CorpInfo *corpInfo = [[CorpInfo alloc] init];
        self.corpData = corpInfo.getCorpDictionary;

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
            self.corpLabel.text = self.corpData[@"orgDict"][@"orgname"];
            
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
            
            if (repubString.intValue < demString.intValue) {
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
            self.republicanLabel.frame = CGRectMake(republicanChart.frame.origin.x, republicanChart.frame.origin.y, republicanChart.frame.size.width, republicanChart.frame.size.height);
            self.repubTitleLabel.frame = CGRectMake(republicanChart.frame.origin.x, self.repubTitleLabel.frame.origin.y, republicanChart.frame.size.width, self.repubTitleLabel.frame.size.height);
            
            self.democratLabel.frame = CGRectMake(democratChart.frame.origin.x, democratChart.frame.origin.y, democratChart.frame.size.width, democratChart.frame.size.height);
            self.demoTitleLabel.frame = CGRectMake(democratChart.frame.origin.x, self.demoTitleLabel.frame.origin.y, democratChart.frame.size.width, self.demoTitleLabel.frame.size.height);
            
            //        NSInteger stars = [[NSUserDefaults standardUserDefaults] integerForKey:@"stars"];
            //        if (stars != 0) {
            //            self.starsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 110, self.view.frame.size.width, 50)];
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

            UIButton *report = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 45)];
            [report setImage:[UIImage imageNamed:@"warningTriangle"] forState:UIControlStateNormal];
            [report addTarget:self action:@selector(openReportView) forControlEvents:UIControlEventTouchUpInside];
            self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:report];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.tabBarController.title = @"Results";
//    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissView)];
    
    UIButton *done = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    done.tintColor = [UIColor whiteColor];
    UIImage *offImage = [[UIImage imageNamed:@"cross"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [done setImage:offImage forState:UIControlStateNormal];
    [done addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:done];
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

- (void)openReportView {
    [self performSegueWithIdentifier:@"report" sender:nil];
}

- (void)dismissView {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
