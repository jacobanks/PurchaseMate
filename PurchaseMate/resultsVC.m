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
    
    AppDelegate *app =  (AppDelegate*)[[UIApplication sharedApplication] delegate];

    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *arrayString = app.valuesArray[1];
    NSString *array1String = app.valuesArray[4];
    NSString *array2String = app.valuesArray[8];
    NSString *array3String = app.valuesArray[6];
    NSString *array4String = app.valuesArray[9];

    NSString *formattedString = [formatter stringFromNumber:[NSNumber numberWithInteger:arrayString.integerValue]];
    NSString *formattedString1 = [formatter stringFromNumber:[NSNumber numberWithInteger:array1String.integerValue]];
    NSString *formattedString2 = [formatter stringFromNumber:[NSNumber numberWithInteger:array2String.integerValue]];
    NSString *formattedString3 = [formatter stringFromNumber:[NSNumber numberWithInteger:array3String.integerValue]];
    NSString *formattedString4 = [formatter stringFromNumber:[NSNumber numberWithInteger:array4String.integerValue]];


    self.lobbyingLabel.text = [NSString stringWithFormat:@"$%@", formattedString];
    self.republicanLabel.text = [NSString stringWithFormat:@"$%@", formattedString1];
    self.totalLabel.text = [NSString stringWithFormat:@"Total Contributions: $%@", formattedString4];
    self.democratLabel.text = [NSString stringWithFormat:@"$%@", formattedString2];
    self.indiLabel.text = [NSString stringWithFormat:@"$%@", formattedString3];
    
    PNCircleChart *republicanChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 90.0, SCREEN_WIDTH / 2 + 6, 90.0) total:[NSNumber numberWithInt:100] current:[NSNumber numberWithInt:60] clockwise:NO];
    republicanChart.backgroundColor = [UIColor clearColor];
    [republicanChart setStrokeColor:PNRed];
    [republicanChart strokeChart];
    [self.view addSubview:republicanChart];
    
    PNCircleChart *democratChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 90.0, SCREEN_WIDTH * 1.45, 90.0) total:[NSNumber numberWithInt:100] current:[NSNumber numberWithInt:75] clockwise:NO];
    democratChart.backgroundColor = [UIColor clearColor];
    [democratChart setStrokeColor:PNBlue];
    [democratChart strokeChart];
    [self.view addSubview:democratChart];
}

- (void)viewWillAppear:(BOOL)animated {
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
