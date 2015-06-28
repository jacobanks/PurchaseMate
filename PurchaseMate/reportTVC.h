//
//  reportTVC.h
//  
//
//  Created by Jacob Banks on 6/26/15.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface reportTVC : UITableViewController

@property (nonatomic, strong) IBOutlet UITextField *productTextField;
@property (nonatomic, strong) IBOutlet UITextField *corpTextField;

- (IBAction)submitAction:(id)sender;

@end
