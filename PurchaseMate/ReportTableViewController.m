//
//  reportTVC.m
//  
//
//  Created by Jacob Banks on 6/26/15.
//
//

#import "ReportTableViewController.h"
#import "MBProgressHUD.h"
#import "ScanViewController.h"
#import "CorpInfo.h"

@interface ReportTableViewController () <UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UITextView *reportTextView;
@property (nonatomic, strong) IBOutlet UILabel *corpLabel;
@property (nonatomic, strong) IBOutlet UILabel *productLabel;
@property (nonatomic, strong) IBOutlet UILabel *barcodeLabel;

@property (nonatomic, strong) IBOutlet UITextField *corpTextField;
@property (nonatomic, strong) IBOutlet UITextField *productTextField;

@property (nonatomic, strong) IBOutlet UIView *labelsView;
@property (nonatomic, strong) IBOutlet UIView *textFieldView;

@end

@implementation ReportTableViewController

#pragma mark - Lifecycle

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
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    if (delegate.isReachable) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something...
            self.labelsView.hidden = YES;
            self.textFieldView.hidden = YES;
            
            if (barcodeID != nil) {
                self.barcodeLabel.text = [NSString stringWithFormat:@"Barcode: %@", barcodeID];
            } else {
                self.barcodeLabel.text = @"No Barcode";
            }
            
            NSDictionary *corpData = [[[CorpInfo alloc] init] getCorpDictionary];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (corpData != nil) {
                    self.labelsView.hidden = NO;
                    self.textFieldView.hidden = YES;
                    
                    self.corpLabel.text = corpData[@"corpName"];
                    self.productLabel.text = corpData[@"productName"];
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

#pragma mark - Actions

- (void)submitAction:(id)sender {
    
    if (![self.reportTextView.text isEqual:@"Report any missing information or problems here..."]) {
        
        NSDictionary *reportInfo = @{ @"productName" : ![self.productLabel.text isEqualToString:@"Label"] ? self.productLabel.text : self.productTextField.text,
                                      @"corpName" : ![self.corpLabel.text isEqualToString:@"Label"] ? self.corpLabel.text : self.corpTextField.text,
                                      @"barcode" : barcodeID != nil ? barcodeID : @"No barcode",
                                      @"report"  : self.reportTextView.text
                                     };
        
        NSError *error = nil;
        MongoConnection *dbConn = [MongoConnection connectionForServer:@"45.55.207.148" error:&error];
        MongoDBCollection *collection = [dbConn collectionWithName:@"reportDB.reports"];
        [collection insertDictionary:reportInfo writeConcern:nil error:&error];
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Thank You!"
                                                          message:@"Thank you for submitting a report! We will review this and fix the problem."
                                                         delegate:nil
                                                cancelButtonTitle:@"Ok"
                                                otherButtonTitles:nil];
        
        [message show];
        
        barcodeID = nil;
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                        message:@"You need to fill out the report field first!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)cancelButtonAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextViewDelegate

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
