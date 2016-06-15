//
//  ViewController.m
//  PurchaseMate
//
//  Created by Jacob Banks on 6/13/15.
//  Copyright (c) 2015 PurchaseMate. All rights reserved.
//

#import "ScanViewController.h"
#import "XMLReader.h"
#import "ResultsViewController.h"
#import "CorpInfo.h"
#import "MBProgressHUD.h"
#import "CameraFocusSquare.h"
#import "ReportTableViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioServices.h>
#import <QuartzCore/QuartzCore.h>

@interface ScanViewController () <AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate, UITextFieldDelegate>

    @property (strong, nonatomic) AVCaptureSession *session;
    @property (strong, nonatomic) AVCaptureDevice *device;
    @property (strong, nonatomic) AVCaptureDeviceInput *input;
    @property (strong, nonatomic) AVCaptureMetadataOutput *output;
    @property (strong, nonatomic) AVCaptureVideoPreviewLayer *prevLayer;
    
    @property (strong, nonatomic) UIView *highlightView;
    @property (strong, nonatomic) UIView *bottomView;
    @property (strong, nonatomic) UILabel *bottomLabel;
    @property (strong, nonatomic) UITextField *barcodeTextField;

    @property (strong, nonatomic) NSMutableArray *barcodeArray;
    @property (strong, nonatomic) NSUserDefaults *userDefaults;

@end

@implementation ScanViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:6.0/255.0 green:181.0/255.0 blue:124.0/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    // initialize array of barcodes to display on scannedTVC
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.barcodeArray = [[NSMutableArray alloc] init];
    
    self.highlightView = [[UIView alloc] init];
    self.highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.highlightView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.highlightView.layer.borderWidth = 3;
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 200, CGRectGetWidth(self.view.frame), 100)];
    self.bottomView.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.7];
    [self.view addSubview:self.bottomView];
    
    self.bottomLabel = [[UILabel alloc] init];
    self.bottomLabel.frame = CGRectMake(0, 2, self.view.bounds.size.width, 30);
    self.bottomLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.bottomLabel.textColor = [UIColor whiteColor];
    self.bottomLabel.font = [UIFont fontWithName:@"Default" size:15];
    self.bottomLabel.textAlignment = NSTextAlignmentCenter;
    [self.bottomView addSubview:self.bottomLabel];
    
    self.barcodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.bottomView.frame) + 10, 35, CGRectGetWidth(self.bottomView.frame) - 20, 40)];
    self.barcodeTextField.placeholder = @"Barcode Number";
    self.barcodeTextField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    self.barcodeTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.barcodeTextField.userInteractionEnabled = YES;
    self.barcodeTextField.tintColor = [UIColor whiteColor];
    self.barcodeTextField.textColor = [UIColor whiteColor];
    self.barcodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.bottomView addSubview:self.barcodeTextField];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(keyboardWillHide:)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Search" style:UIBarButtonItemStyleDone target:self action:@selector(searchFromKeyboard)],
                           nil];
    [numberToolbar sizeToFit];
    self.barcodeTextField.inputAccessoryView = numberToolbar;
    
    self.session = [[AVCaptureSession alloc] init];
    self.device = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
    NSError *error = nil;
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (self.input) {
        [self.session addInput:self.input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    self. output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.session addOutput:self.output];
    
    self.output.metadataObjectTypes = [self.output availableMetadataObjectTypes];
    
    self.prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.prevLayer.frame = self.view.bounds;
    self.prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.prevLayer];
    
    [self.view bringSubviewToFront:self.highlightView];
    [self.view bringSubviewToFront:self.bottomView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.bottomLabel.text = @"Scan or enter a barcode to begin";
    self.title = @"Scan";
        
    UIButton *flash = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 25)];
    flash.tintColor = [UIColor whiteColor];
    UIImage *offImage = [[UIImage imageNamed:@"lightningBoltOff"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [flash setImage:offImage forState:UIControlStateNormal];
    [flash addTarget:self action:@selector(toggleFlashlight:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:flash];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.session startRunning];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.highlightView removeFromSuperview];
    [self.session stopRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - Keyboard Movements

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.frame = CGRectMake(0, self.bottomView.frame.origin.y - keyboardSize.height + 45, CGRectGetWidth(self.view.frame), 100);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.frame = CGRectMake(0, self.view.bounds.size.height - 140, CGRectGetWidth(self.view.frame), 100);
    }];
    
    [self.barcodeTextField resignFirstResponder];
}

- (void)searchFromKeyboard {
    
    if ([self.barcodeTextField.text length] > 0 && self.barcodeTextField.text != nil && ![self.barcodeTextField.text isEqual:@""]) {
        [self scanProduct:self.barcodeTextField.text];
    }
    
    self.barcodeTextField.text = @"";
    [self keyboardWillHide:nil];
}

#pragma mark - Actions

- (void)scanProduct:(NSString *)barcode {
    // 04976400
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    if (delegate.isReachable) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something...
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            
            NSDictionary *corpData = [[[CorpInfo alloc] init] getPoliticalInfoWithBarcode:barcode];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (corpData != nil) {
                    [[NSUserDefaults standardUserDefaults] setObject:barcode forKey:@"barcode"];
                    
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    ResultsViewController *vc = (ResultsViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"results"];
                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
                    [self presentViewController:navController animated:YES completion:nil];
                    
                    // add values to barcodeArray to display on scannedTVC
                    self.barcodeArray = [NSMutableArray arrayWithArray:[self.userDefaults valueForKey:@"barcodes"]];
                    if (![self.barcodeArray containsObject:barcode]) {
                        [self.barcodeArray insertObject:barcode atIndex:0];
                        [self.userDefaults setObject:self.barcodeArray forKey:@"barcodes"];
                        [self.userDefaults synchronize];
                    } else {
                        // delete the barcode from array and then re-add it so it is at the top of tableview
                        [self.barcodeArray removeObject:barcode];
                        [self.barcodeArray insertObject:barcode atIndex:0];
                        [self.userDefaults setObject:self.barcodeArray forKey:@"barcodes"];
                        [self.userDefaults synchronize];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadTableView" object:self];
                    
                } else {
                    [self showAlert];
                    [[NSUserDefaults standardUserDefaults] setInteger:barcode.intValue forKey:@"barcode"];
                }
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
        
    }
    
}

- (void)toggleFlashlight:(id)sender {
    
    if ([sender isSelected]) {
        UIImage *offImage = [[UIImage imageNamed:@"lightningBoltOff"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [sender setImage:offImage forState:UIControlStateNormal];
        [sender setSelected:NO];
    } else {
        UIImage *onImage = [[UIImage imageNamed:@"lightningBoltOn"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [sender setImage:onImage forState:UIControlStateSelected];
        [sender setSelected:YES];
    }
    
    // check if flashlight available
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        if ([self.device hasTorch] && [self.device hasFlash]) {
            
            [self.device lockForConfiguration:nil];
            
            if (self.device.torchMode == AVCaptureTorchModeOff) {
                [self.device setTorchMode:AVCaptureTorchModeOn];
                [self.device setFlashMode:AVCaptureFlashModeOn];
            } else {
                [self.device setTorchMode:AVCaptureTorchModeOff];
                [self.device setFlashMode:AVCaptureFlashModeOff];
            }
            
            [self.device unlockForConfiguration];
        }
    }
}

#pragma mark - UIAlertViewDelegate

- (void)showAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                    message:@"We have no data on this product! Submit a report to notify us about this, and we will add it to our database."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Report", nil];
    [alert show];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type]) {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[self.prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        
        if (!detectionString) {
            self.bottomLabel.text = @"There was a problem!";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                            message:@"There was a problem scanning please try again."
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            self.bottomLabel.text = @"Product Found!";
            [self scanProduct:detectionString];
        }
    }
    
    [self.view addSubview:self.highlightView];
    self.highlightView.frame = highlightViewRect;
    
    [self.session stopRunning];
}

#pragma mark - Camera View Actions

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:touch.view];
    [self focus:touchPoint];
    
    CameraFocusSquare *camFocus = [[CameraFocusSquare alloc] initWithFrame:CGRectMake(touchPoint.x - 40, touchPoint.y - 40, 80, 80)];
    camFocus.backgroundColor = [UIColor clearColor];
    [self.view addSubview:camFocus];
    [camFocus setNeedsDisplay];
    
    [UIView animateWithDuration:1.5 animations:^{
        camFocus.alpha = 0;
    } completion:^(BOOL finished) {
        [camFocus removeFromSuperview];
    }];
    
    [self.barcodeTextField resignFirstResponder];
}

- (void)focus:(CGPoint)aPoint {
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *localDevice = [captureDeviceClass defaultDeviceWithMediaType:AVMediaTypeVideo];
        if([localDevice isFocusPointOfInterestSupported] && [localDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            double screenWidth = screenRect.size.width;
            double screenHeight = screenRect.size.height;
            double focus_x = aPoint.x/screenWidth;
            double focus_y = aPoint.y/screenHeight;
            
            if ([localDevice lockForConfiguration:nil]) {
                [localDevice setFocusPointOfInterest:CGPointMake(focus_x,focus_y)];
                [localDevice setFocusMode:AVCaptureFocusModeAutoFocus];
                
                if ([localDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
                    [localDevice setExposureMode:AVCaptureExposureModeAutoExpose];
                }
                
                [localDevice unlockForConfiguration];
            }
        }
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        [self.highlightView removeFromSuperview];
        [self.session startRunning];
    } else {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ReportTableViewController *vc = (ReportTableViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"report"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navController animated:YES completion:nil];
    }
}

@end
