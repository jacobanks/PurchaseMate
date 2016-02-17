//
//  reportTVC.m
//  
//
//  Created by Jacob Banks on 6/26/15.
//
//

#import "reportTVC.h"

@interface reportTVC () {
    NSDictionary *corpInfo;
}

@end

@implementation reportTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    corpInfo = [[[CorpInfo alloc] init] getCorpInfoWithBarcode:barcodeID];
    self.corpLabel.text = corpInfo[@"orgDict"][@"orgname"];
    self.productLabel.text = corpInfo[@"productName"];
    
    self.reportTextView.delegate = self;
    self.reportTextView.textColor = [UIColor lightGrayColor];
}

- (void)submitAction:(id)sender {
    
    if (self.reportTextView.text != nil) {
        PFObject *reportObject = [PFObject objectWithClassName:@"Reports"];
        reportObject[@"Product_Name"] = self.productLabel.text;
        reportObject[@"Company_Name"] = self.corpLabel.text;
        reportObject[@"barcode"] = barcodeID;
        reportObject[@"report"] = self.reportTextView.text;
        [reportObject saveInBackground];
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Thank You!"
                                                          message:@"Thank you for submitting a report! We will review this and fix the problem."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];

        [self.navigationController popViewControllerAnimated:YES];
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                        message:@"You need to fill out the report field first!"
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

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Report any missing information or problems here..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Report any missing information or problems here...";
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

@end
