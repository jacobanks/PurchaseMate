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

@end

@implementation resultsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    AppDelegate *app =  (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (app.valuesArray.count != 0){
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        NSString *arrayString = app.valuesArray[1];
        NSString *array1String = app.valuesArray[4];
        NSString *array2String = app.valuesArray[8];
        NSString *array3String = app.valuesArray[6];
        
        NSString *formattedString = [formatter stringFromNumber:[NSNumber numberWithInteger:arrayString.integerValue]];
        NSString *formattedString1 = [formatter stringFromNumber:[NSNumber numberWithInteger:array1String.integerValue]];
        NSString *formattedString2 = [formatter stringFromNumber:[NSNumber numberWithInteger:array2String.integerValue]];
        NSString *formattedString3 = [formatter stringFromNumber:[NSNumber numberWithInteger:array3String.integerValue]];
        
        
        self.lobbyingLabel.text = [NSString stringWithFormat:@"$%@", formattedString];
        self.republicanLabel.text = [NSString stringWithFormat:@"$%@", formattedString1];
        self.democratLabel.text = [NSString stringWithFormat:@"$%@", formattedString2];
        self.indiLabel.text = [NSString stringWithFormat:@"$%@", formattedString3];
        self.ethicsLabel.text = ethicsString;
        
        if (ethicsString.intValue <= 50) {
            self.ethicsLabel.textColor = [UIColor redColor];
        } else if (ethicsString.intValue > 50 && ethicsString.intValue <= 70) {
            self.ethicsLabel.textColor = [UIColor yellowColor];
        } else {
            self.ethicsLabel.textColor = [UIColor greenColor];
        }
        
        int repubRandomINT = arc4random() %51 + 50;
        
        int demoRandomINT = arc4random() %51 + 50;
        
        if (array1String.intValue < array2String.intValue) {
            repubRandomINT = demoRandomINT - 30;
        } else {
            demoRandomINT = repubRandomINT - 30;
        }
        
        PNCircleChart *republicanChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 90.0, SCREEN_WIDTH / 2 + 6, 90.0) total:[NSNumber numberWithInt:100] current:[NSNumber numberWithInt:repubRandomINT] clockwise:NO];
        republicanChart.backgroundColor = [UIColor clearColor];
        [republicanChart setStrokeColor:PNRed];
        [republicanChart strokeChart];
        [self.view addSubview:republicanChart];
        
        PNCircleChart *democratChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 90.0, SCREEN_WIDTH * 1.45, 90.0) total:[NSNumber numberWithInt:100] current:[NSNumber numberWithInt:demoRandomINT] clockwise:NO];
        democratChart.backgroundColor = [UIColor clearColor];
        [democratChart setStrokeColor:PNBlue];
        [democratChart strokeChart];
        [self.view addSubview:democratChart];
        
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
        self.ethicsTitleLabel.hidden =YES;
        
        self.noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 190, SCREEN_WIDTH, 100)];
        self.noDataLabel.text = @"No Data";
        self.noDataLabel.adjustsFontSizeToFitWidth = NO;
        self.noDataLabel.font = [UIFont systemFontOfSize:25];
        self.noDataLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.noDataLabel];
    }
    
    self.title = organizationName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
