//
//  ViewController.m
//  PurchaseMate
//
//  Created by Jacob Banks on 6/13/15.
//  Copyright (c) 2015 PurchaseMate. All rights reserved.
//

#import "ViewController.h"
#import "XMLReader.h"
#import "resultsVC.h"
#import "CorpInfo.h"
#import "MBProgressHUD.h"
#import "CameraFocusSquare.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioServices.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *session;
    AVCaptureDevice *device;
    AVCaptureDeviceInput *input;
    AVCaptureMetadataOutput *output;
    AVCaptureVideoPreviewLayer *prevLayer;
    
    UIView *highlightView;
    UILabel *label;
    
    NSMutableArray *barcodeArray;
    NSUserDefaults *userDefaults;

    UIVisualEffectView *searchView;
    UITextField *barcodeTextField;
}


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:6.0/255.0 green:181.0/255.0 blue:124.0/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    // initialize array of barcodes to display on scannedTVC
    userDefaults = [NSUserDefaults standardUserDefaults];
    barcodeArray = [[NSMutableArray alloc] init];
    
    highlightView = [[UIView alloc] init];
    highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    highlightView.layer.borderColor = [UIColor whiteColor].CGColor;
    highlightView.layer.borderWidth = 3;
    
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, self.view.bounds.size.height - 80, self.view.bounds.size.width, 30);
    label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    label.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.5];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Default" size:15];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    session = [[AVCaptureSession alloc] init];
    device = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
    NSError *error = nil;
    
    input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (input) {
        [session addInput:input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [session addOutput:output];
    
    output.metadataObjectTypes = [output availableMetadataObjectTypes];
    
    prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    prevLayer.frame = self.view.bounds;
    prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:prevLayer];
    
    [self.view bringSubviewToFront:highlightView];
    [self.view bringSubviewToFront:label];

}

- (void)viewWillAppear:(BOOL)animated {
    
    label.text = @"Scan a product to begin";
    self.tabBarController.title = @"Scan";
    
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(loadSearchView)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    [session startRunning];
}

- (void)viewDidDisappear:(BOOL)animated {
    [highlightView removeFromSuperview];
    [session stopRunning];
}

- (void)loadSearchView {
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    searchView = [[UIVisualEffectView alloc] init];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        searchView.effect = blurEffect;
    } completion:nil];
    
    CGSize viewSize = [[UIScreen mainScreen] bounds].size;
    searchView.frame = CGRectMake(0, 0, self.view.frame.size.width, viewSize.height);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(viewTapped:)];
    tap.numberOfTapsRequired = 1;
    [searchView addGestureRecognizer:tap];
    
    [[UIApplication sharedApplication].keyWindow addSubview:searchView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, searchView.center.y - 120, searchView.frame.size.width, 30)];
    [titleLabel setText:@"Enter a barcode number below"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [searchView addSubview:titleLabel];
    
    barcodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(searchView.frame.origin.x + 10, searchView.center.y - 60, searchView.frame.size.width - 20, 40)];
    [barcodeTextField setPlaceholder:@"Barcode Number"];
    [barcodeTextField setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.4]];
    [barcodeTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [barcodeTextField setUserInteractionEnabled:YES];
    [barcodeTextField setTintColor:[UIColor whiteColor]];
    [barcodeTextField setTextColor:[UIColor whiteColor]];
    [barcodeTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [searchView addSubview:barcodeTextField];
   
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(searchView.frame.size.width - 120, 30, 100, 30)];
    [searchButton setTitle:@"Search" forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchButton.layer.borderColor = [UIColor whiteColor].CGColor;
    searchButton.layer.borderWidth = 2;
    searchButton.layer.cornerRadius = 5;
    [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchButton];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 100, 30)];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.layer.borderColor = [UIColor whiteColor].CGColor;
    cancelButton.layer.borderWidth = 2;
    cancelButton.layer.cornerRadius = 5;
    [cancelButton addTarget:self action:@selector(viewTapped:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:cancelButton];
}

- (void)searchAction {
    if ([barcodeTextField.text length] > 0 || barcodeTextField.text != nil || [barcodeTextField.text isEqual:@""] == FALSE) {
        [self viewTapped:nil];
        [self scanProduct:barcodeTextField.text];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                        message:@"You need to fill out the barcode field first!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)scanProduct:(NSString *)barcode {
    // 04976400
    
    __block NSString *corpName;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        corpName = [[[CorpInfo alloc] init] checkForCorpWithBarcode:barcode];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (corpName != nil) {
                barcodeID = barcode;
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                resultsVC *vc = (resultsVC *)[mainStoryboard instantiateViewControllerWithIdentifier:@"results"];
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
                [self presentViewController:navController animated:YES completion:nil];
                
                // add values to barcodeArray to display on scannedTVC
                barcodeArray = [NSMutableArray arrayWithArray:[userDefaults valueForKey:@"barcodes"]];
                if (![barcodeArray containsObject:barcode]) {
                    [barcodeArray insertObject:barcode atIndex:0];
                    [userDefaults setObject:barcodeArray forKey:@"barcodes"];
                    [userDefaults synchronize];
                } else {
                    // delete the barcode from array and then re-add it so it is at the top of tableview
                    [barcodeArray removeObject:barcode];
                    [barcodeArray insertObject:barcode atIndex:0];
                    [userDefaults setObject:barcodeArray forKey:@"barcodes"];
                    [userDefaults synchronize];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loadTableView" object:self];
                
            } else {
                [self showAlert];
                barcodeID = barcode;
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        
        if (!detectionString) {
            label.text = @"There was a problem!";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                            message:@"There was a problem scanning please try again."
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
            
        } else {
            label.text = @"Product Found!";
            [self scanProduct:detectionString];
        }
    }
    
    [self.view addSubview:highlightView];
    highlightView.frame = highlightViewRect;
    
    [session stopRunning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:touch.view];
    [self focus:touchPoint];
    
    CameraFocusSquare *camFocus = [[CameraFocusSquare alloc] init];
    
    if (camFocus) {
        [camFocus removeFromSuperview];
    }

    camFocus = [[CameraFocusSquare alloc] initWithFrame:CGRectMake(touchPoint.x - 40, touchPoint.y - 40, 80, 80)];
    [camFocus setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:camFocus];
    [camFocus setNeedsDisplay];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.5];
    [camFocus setAlpha:0.0];
    [UIView commitAnimations];
}

- (void)focus:(CGPoint)aPoint {
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *localDevice = [captureDeviceClass defaultDeviceWithMediaType:AVMediaTypeVideo];
        if([localDevice isFocusPointOfInterestSupported] &&
           [localDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            double screenWidth = screenRect.size.width;
            double screenHeight = screenRect.size.height;
            double focus_x = aPoint.x/screenWidth;
            double focus_y = aPoint.y/screenHeight;
            if([localDevice lockForConfiguration:nil]) {
                [localDevice setFocusPointOfInterest:CGPointMake(focus_x,focus_y)];
                [localDevice setFocusMode:AVCaptureFocusModeAutoFocus];
                if ([localDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]){
                    [localDevice setExposureMode:AVCaptureExposureModeAutoExpose];
                }
                [localDevice unlockForConfiguration];
            }
        }
    }
}

- (void)showAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                    message:@"We have no data on this product! Submit a report to notify us about this, and we will add it to our database."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Report", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        [highlightView removeFromSuperview];
        [session startRunning];
    } else {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        reportTVC *vc = (reportTVC *)[mainStoryboard instantiateViewControllerWithIdentifier:@"report"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navController animated:YES completion:nil];
    }
}

- (void)viewTapped:(UITapGestureRecognizer *)recognizer {

    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        searchView.alpha = 0;
    }completion:^(BOOL isFinished){
        [searchView removeFromSuperview];
    }];
}

@end

NSString *barcodeID;
