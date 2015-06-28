//
//  reportTVC.m
//  
//
//  Created by Jacob Banks on 6/26/15.
//
//

#import "reportTVC.h"

@interface reportTVC ()

@end

@implementation reportTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)submitAction:(id)sender {
    
    if (![self.productTextField.text isEqualToString:@""] && ![self.productTextField.text isEqualToString:@" "]) {
        PFObject *reportObject = [PFObject objectWithClassName:@"Reports"];
        reportObject[@"Product_Name"] = self.productTextField.text;
        reportObject[@"Company_Name"] = self.corpTextField.text;
        [reportObject saveInBackground];
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Thank You!"
                                                          message:@"Thank you for submitting a report! We will add this to our database as soon as possible."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];

        [self.navigationController popViewControllerAnimated:YES];
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                        message:@"You need to fill out the product name first!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.title = @"Report";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
