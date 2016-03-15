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
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:6.0/255.0 green:181.0/255.0 blue:124.0/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        self.labelsView.hidden = YES;
        self.textFieldView.hidden = YES;
        
        self.barcodeLabel.text = [NSString stringWithFormat:@"Barcode: %@", barcodeID];
        
        NSString *corpName = [[[CorpInfo alloc] init] checkForCorpWithBarcode:barcodeID];
        if (corpName != nil) {
            corpInfo = [[[CorpInfo alloc] init] getCorpInfoWithBarcode:barcodeID];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (corpName != nil) {
                self.labelsView.hidden = NO;
                self.textFieldView.hidden = YES;
                
                self.corpLabel.text = corpInfo[@"orgDict"][@"orgname"];
                self.productLabel.text = corpInfo[@"productName"];
            } else {
                self.labelsView.hidden = YES;
                self.textFieldView.hidden = NO;
                
                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonAction:)];
            }
            
            self.reportTextView.delegate = self;
            self.reportTextView.textColor = [UIColor lightGrayColor];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });

}

- (void)viewWillAppear:(BOOL)animated {
    self.title = @"Report";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitAction:(id)sender {
    
    if (self.reportTextView.text != nil) {
        PFObject *reportObject = [PFObject objectWithClassName:@"Reports"];
        reportObject[@"Product_Name"] = ![self.productLabel.text isEqualToString:@"Label"] ? self.productLabel.text : self.productTextField.text;
        reportObject[@"Company_Name"] = ![self.corpLabel.text isEqualToString:@"Label"] ? self.corpLabel.text : self.corpTextField.text;
        reportObject[@"barcode"] = barcodeID != nil ? barcodeID : @"No barcode";
        reportObject[@"report"] = self.reportTextView.text;
        [reportObject saveInBackground];
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Thank You!"
                                                          message:@"Thank you for submitting a report! We will review this and fix the problem."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        
        barcodeID = nil;
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                        message:@"You need to fill out the report field first!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)cancelButtonAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@"Report any missing information or problems here..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Report any missing information or problems here...";
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

@end
