//
//  resultsVC.m
//  PurchaseMate
//
//  Created by Jacob Banks on 6/29/15.
//  Copyright (c) 2015 Jacobanks. All rights reserved.
//

#import "resultsVC.h"
#import "ViewController.h"

@interface resultsVC ()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel, *corpLabel, *lobbyingLabel, *republicanLabel, *democratLabel, *indiLabel, *repubTitleLabel,
*demoTitleLabel, *lobbyTitleLabel, *indiTitleLabel, *ethicsLabel, *ethicsTitleLabel;
@property (nonatomic, strong) UILabel *noDataLabel, *starsLabel;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIView *starsView;

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
    
/*    self.tabBarController.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil]; */
    
    // set scrollview content size
    self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height);
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 700);
    
    // get corporation info
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        self.republicanLabel.hidden = YES;
        self.democratLabel.hidden = YES;
        self.lobbyingLabel.hidden = YES;
        self.indiLabel.hidden = YES;
        self.titleLabel.hidden = YES;
        self.repubTitleLabel.hidden = YES;
        self.demoTitleLabel.hidden = YES;
        self.lobbyTitleLabel.hidden = YES;
        self.indiTitleLabel.hidden = YES;
        self.noDataLabel.hidden = NO;
        self.ethicsLabel.hidden = YES;
        self.ethicsTitleLabel.hidden = YES;
        self.corpLabel.hidden = YES;
        
        self.noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 190, SCREEN_WIDTH, 100)];
        self.noDataLabel.text = @"No Data";
        self.noDataLabel.adjustsFontSizeToFitWidth = NO;
        self.noDataLabel.font = [UIFont systemFontOfSize:25];
        self.noDataLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.noDataLabel];

        corpInfo = [[[CorpInfo alloc] init] getCorpInfoWithBarcode:barcodeID];
        
        dispatch_async(dispatch_get_main_queue(), ^{
    
            if ([corpInfo[@"politicalInfo"] count] != 0){
                
                self.republicanLabel.hidden = NO;
                self.democratLabel.hidden = NO;
                self.lobbyingLabel.hidden = NO;
                self.indiLabel.hidden = NO;
                self.titleLabel.hidden = NO;
                self.repubTitleLabel.hidden = NO;
                self.demoTitleLabel.hidden = NO;
                self.lobbyTitleLabel.hidden = NO;
                self.indiTitleLabel.hidden = NO;
                self.noDataLabel.hidden = YES;
                self.ethicsLabel.hidden = NO;
                self.ethicsTitleLabel.hidden = NO;
                self.corpLabel.hidden = NO;

                self.title = corpInfo[@"orgDict"][@"orgname"];
                
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
                
                NSString *lobbyingString = [NSString stringWithFormat:@"%@", corpInfo[@"politicalInfo"][@"lobbying"]];
                NSString *repubString = [NSString stringWithFormat:@"%@", corpInfo[@"politicalInfo"][@"repubs"]];
                NSString *demString = [NSString stringWithFormat:@"%@", corpInfo[@"politicalInfo"][@"dems"]];
                NSString *indiString = [NSString stringWithFormat:@"%@", corpInfo[@"politicalInfo"][@"outside"]];
                NSString *ethicsString = [NSString stringWithFormat:@"%@", corpInfo[@"ethics"]];
                
                NSString *formattedLobbyingString = [formatter stringFromNumber:[NSNumber numberWithInteger:lobbyingString.integerValue]];
                NSString *formattedRepubsString = [formatter stringFromNumber:[NSNumber numberWithInteger:repubString.integerValue]];
                NSString *formattedDemsString = [formatter stringFromNumber:[NSNumber numberWithInteger:demString.integerValue]];
                NSString *formattedIndiString = [formatter stringFromNumber:[NSNumber numberWithInteger:indiString.integerValue]];
                
                
                self.lobbyingLabel.text = [NSString stringWithFormat:@"$%@", formattedLobbyingString];
                self.republicanLabel.text = [NSString stringWithFormat:@"$%@", formattedRepubsString];
                self.democratLabel.text = [NSString stringWithFormat:@"$%@", formattedDemsString];
                self.indiLabel.text = [NSString stringWithFormat:@"$%@", formattedIndiString];
                self.ethicsLabel.text = corpInfo[@"ethics"];
                
                self.corpLabel.text = corpInfo[@"orgDict"][@"orgname"];
                
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
                
                self.titleLabel.frame = CGRectMake(self.scrollView.frame.origin.x, self.titleLabel.frame.origin.y, self.scrollView.frame.size.width, self.titleLabel.frame.size.height);
                self.corpLabel.frame = CGRectMake(self.scrollView.frame.origin.x, self.corpLabel.frame.origin.y, self.scrollView.frame.size.width, self.corpLabel.frame.size.height);

                self.lobbyTitleLabel.frame = CGRectMake(self.scrollView.frame.origin.x, self.lobbyTitleLabel.frame.origin.y, self.scrollView.frame.size.width, self.lobbyTitleLabel.frame.size.height);
                self.lobbyingLabel.frame = CGRectMake(self.scrollView.frame.origin.x, self.lobbyingLabel.frame.origin.y, self.scrollView.frame.size.width, self.lobbyingLabel.frame.size.height);
                
                self.indiTitleLabel.frame = CGRectMake(self.scrollView.frame.origin.x, self.indiTitleLabel.frame.origin.y, self.scrollView.frame.size.width, self.indiTitleLabel.frame.size.height);
                self.indiLabel.frame = CGRectMake(self.scrollView.frame.origin.x, self.indiLabel.frame.origin.y, self.scrollView.frame.size.width, self.indiLabel.frame.size.height);
                
                self.ethicsTitleLabel.frame = CGRectMake(self.scrollView.frame.origin.x, self.ethicsTitleLabel.frame.origin.y, self.scrollView.frame.size.width, self.ethicsTitleLabel.frame.size.height);
                self.ethicsLabel.frame = CGRectMake(self.scrollView.frame.origin.x, self.ethicsLabel.frame.origin.y, self.scrollView.frame.size.width, self.ethicsLabel.frame.size.height);
                
                int repubRandomINT = arc4random() %51 + 50;
                int demoRandomINT = arc4random() %51 + 50;
                
                if (repubString.intValue < demString.intValue) {
                    repubRandomINT = demoRandomINT - 30;
                } else {
                    demoRandomINT = repubRandomINT - 30;
                }
                
                // initial setup for graphs
                PNCircleChart *republicanChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 120.0, SCREEN_WIDTH / 2 + 6, 90.0) total:[NSNumber numberWithInt:100] current:[NSNumber numberWithInt:repubRandomINT] clockwise:NO];
                republicanChart.backgroundColor = [UIColor clearColor];
                [republicanChart setStrokeColor:PNRed];
                [republicanChart strokeChart];
                [self.scrollView addSubview:republicanChart];
                
                PNCircleChart *democratChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 120.0, SCREEN_WIDTH * 1.45, 90.0) total:[NSNumber numberWithInt:100] current:[NSNumber numberWithInt:demoRandomINT] clockwise:NO];
                democratChart.backgroundColor = [UIColor clearColor];
                [democratChart setStrokeColor:PNBlue];
                [democratChart strokeChart];
                [self.scrollView addSubview:democratChart];
                
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
                
                
                self.noDataLabel.hidden = YES;
            } else {
                self.republicanLabel.hidden = YES;
                self.democratLabel.hidden = YES;
                self.lobbyingLabel.hidden = YES;
                self.indiLabel.hidden = YES;
                self.titleLabel.hidden = YES;
                self.repubTitleLabel.hidden = YES;
                self.demoTitleLabel.hidden = YES;
                self.lobbyTitleLabel.hidden = YES;
                self.indiTitleLabel.hidden = YES;
                self.noDataLabel.hidden = NO;
                self.ethicsLabel.hidden = YES;
                self.ethicsTitleLabel.hidden = YES;
                self.corpLabel.hidden = YES;

                self.noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 190, SCREEN_WIDTH, 100)];
                self.noDataLabel.text = @"No Data";
                self.noDataLabel.adjustsFontSizeToFitWidth = NO;
                self.noDataLabel.font = [UIFont systemFontOfSize:25];
                self.noDataLabel.textAlignment = NSTextAlignmentCenter;
                [self.view addSubview:self.noDataLabel];
            }
            
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
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissView)];
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
