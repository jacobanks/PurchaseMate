//
//  reportTVC.h
//  
//
//  Created by Jacob Banks on 6/26/15.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "ViewController.h"
#import "CorpInfo.h"

@interface reportTVC : UITableViewController <UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UITextView *reportTextView;
@property (nonatomic, strong) IBOutlet UILabel *corpLabel;
@property (nonatomic, strong) IBOutlet UILabel *productLabel;
@property (nonatomic, strong) IBOutlet UILabel *barcodeLabel;

@property (nonatomic, strong) IBOutlet UITextField *corpTextField;
@property (nonatomic, strong) IBOutlet UITextField *productTextField;

@property (nonatomic, strong) IBOutlet UIView *labelsView;
@property (nonatomic, strong) IBOutlet UIView *textFieldView;

- (IBAction)submitAction:(id)sender;
- (void)cancelButtonAction:(id)sender;

@end
