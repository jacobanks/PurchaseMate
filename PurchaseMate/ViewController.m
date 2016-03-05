//
//  ViewController.m
//  PurchaseMate
//
//  Created by Jacob Banks on 6/13/15.
//  Copyright (c) 2015 PurchaseMate. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    
    UIView *_highlightView;
    UILabel *_label;
    
    NSMutableArray *barcodeArray;
    NSUserDefaults *userDefaults;

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
    
    _highlightView = [[UIView alloc] init];
    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    _highlightView.layer.borderColor = [UIColor whiteColor].CGColor;
    _highlightView.layer.borderWidth = 3;
    
    _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(0, self.view.bounds.size.height - 80, self.view.bounds.size.width, 30);
    _label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _label.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.5];
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont fontWithName:@"Default" size:15];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"Scan a product to begin";
    [self.view addSubview:_label];
    
    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = self.view.bounds;
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_prevLayer];
    
    [self.view bringSubviewToFront:_highlightView];
    [self.view bringSubviewToFront:_label];
}

- (void)viewWillAppear:(BOOL)animated {
    _label.text = @"Scan a product to begin";
    self.tabBarController.title = @"Scan";
    
    UIButton *testScan = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 45)];
    [testScan setTitle:@"Test Scan" forState:UIControlStateNormal];
    [testScan addTarget:self action:@selector(scanProduct) forControlEvents:UIControlEventTouchUpInside];
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:testScan];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    [_session startRunning];
}

- (void)viewDidDisappear:(BOOL)animated {
    [_highlightView removeFromSuperview];
    [_session stopRunning];
}

- (void)scanProduct {

    barcodeID = @"605388716552";
    __block NSString *corpName;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        corpName = [[[CorpInfo alloc] init] checkForCorpWithBarcode:barcodeID];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (corpName != nil) {
                
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                resultsVC *vc = (resultsVC*)[mainStoryboard instantiateViewControllerWithIdentifier:@"results"];
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
                [self presentViewController:navController animated:YES completion:nil];
                
                barcodeArray = [NSMutableArray arrayWithArray:[userDefaults valueForKey:@"barcodes"]];
                if (![barcodeArray containsObject:barcodeID]) {
                    [barcodeArray insertObject:barcodeID atIndex:0];
                    [userDefaults setObject:barcodeArray forKey:@"barcodes"];
                    [userDefaults synchronize];
                } else {
                    [barcodeArray removeObject:barcodeID];
                    [barcodeArray insertObject:barcodeID atIndex:0];
                    [userDefaults setObject:barcodeArray forKey:@"barcodes"];
                    [userDefaults synchronize];
                }
                
            } else {
                [self showAlert];
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
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        
        if (detectionString != nil) {
            _label.text = @"Product Found!";
            __block NSString *corpName;
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"Loading...";
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                // Do something...
                corpName = [[[CorpInfo alloc] init] checkForCorpWithBarcode:detectionString];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (corpName != nil) {
                        barcodeID = detectionString;
                        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        resultsVC *vc = (resultsVC*)[mainStoryboard instantiateViewControllerWithIdentifier:@"results"];
                        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
                        [self presentViewController:navController animated:YES completion:nil];
                        
                        // add values to barcodeArray to display on scannedTVC
                        barcodeArray = [NSMutableArray arrayWithArray:[userDefaults valueForKey:@"barcodes"]];
                        if (![barcodeArray containsObject:detectionString]) {
                            [barcodeArray insertObject:detectionString atIndex:0];
                            [userDefaults setObject:barcodeArray forKey:@"barcodes"];
                            [userDefaults synchronize];
                        } else {
                            // delete the barcode from array and then readd it so it is at the top of tableview
                            [barcodeArray removeObject:detectionString];
                            [barcodeArray insertObject:detectionString atIndex:0];
                            [userDefaults setObject:barcodeArray forKey:@"barcodes"];
                            [userDefaults synchronize];
                        }
                        
                    } else {
                        [self showAlert];
                    }
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            });
            
            break;
        } else {
            _label.text = @"There was a problem!";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                            message:@"There was a problem scanning please try again."
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }
    
    [self.view addSubview:_highlightView];
    _highlightView.frame = highlightViewRect;
    
    [_session stopRunning];
}

- (void)showAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                    message:@"We have no data on this product! Submit a report to notify us about this, and we will add it to our database."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Report", nil];
    [alert show];
        
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    resultsVC *vc = (resultsVC*)[mainStoryboard instantiateViewControllerWithIdentifier:@"results"];
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self presentViewController:navController animated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        [_highlightView removeFromSuperview];
        [_session startRunning];
    } else {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        reportTVC *vc = (reportTVC *)[mainStoryboard instantiateViewControllerWithIdentifier:@"report"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navController animated:YES completion:nil];
    }
}

@end

NSString *barcodeID;
