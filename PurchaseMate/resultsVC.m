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

    NSString *formattedString = [formatter stringFromNumber:[NSNumber numberWithInteger:arrayString.integerValue]];
    NSString *formattedString1 = [formatter stringFromNumber:[NSNumber numberWithInteger:array1String.integerValue]];
    NSString *formattedString2 = [formatter stringFromNumber:[NSNumber numberWithInteger:array2String.integerValue]];
    NSString *formattedString3 = [formatter stringFromNumber:[NSNumber numberWithInteger:array3String.integerValue]];

    self.lobbyingLabel.text = [NSString stringWithFormat:@"$%@", formattedString];
    self.republicanLabel.text = [NSString stringWithFormat:@"$%@", formattedString1];
    self.democratLabel.text = [NSString stringWithFormat:@"$%@", formattedString2];
    self.indiLabel.text = [NSString stringWithFormat:@"$%@", formattedString3];
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
