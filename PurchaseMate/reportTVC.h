//
//  reportTVC.h
//  
//
//  Created by Jacob Banks on 6/26/15.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ViewController.h"

@interface reportTVC : UITableViewController <UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UITextView *reportTextView;
@property (nonatomic, strong) IBOutlet UILabel *corpLabel;
@property (nonatomic, strong) IBOutlet UILabel *productLabel;

- (IBAction)submitAction:(id)sender;

@end
