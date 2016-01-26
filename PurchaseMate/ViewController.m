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
}


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *testScan = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 45)];
    [testScan setTitle:@"Test Scan" forState:UIControlStateNormal];
    [testScan addTarget:self action:@selector(scanProduct) forControlEvents:UIControlEventTouchUpInside];
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:testScan];
    
    _highlightView = [[UIView alloc] initWithFrame:CGRectMake(62.5, self.view.center.y - 90, 250, 125)];
    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    _highlightView.layer.borderColor = [UIColor whiteColor].CGColor;
    _highlightView.layer.borderWidth = 3;
    [self.view addSubview:_highlightView];
    
    _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(0, self.view.bounds.size.height - 30, self.view.bounds.size.width, 30);
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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];

    [_session startRunning];
}

- (void)scanProduct {
    
//    NSDictionary *responseDictionary = [[[CorpInfo alloc] init] getDataFromOutPan:[NSString stringWithFormat:@"https://www.outpan.com/api/get-product.php?apikey=cbf4f07abd482df99358395a75b6340a&barcode=04976400"]];
//    NSDictionary *corpDictionary = [[[CorpInfo alloc] init] getDataFromMongoDBWithDictionary:responseDictionary];

//    barcodeID = @"04976400";
    
    NSString *string = [[[CorpInfo alloc] init] checkForCorpWithBarcode:@"04976400"];

    if (string != nil) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        resultsVC *vc = (resultsVC*)[mainStoryboard instantiateViewControllerWithIdentifier:@"results"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navController animated:YES completion:nil];
        
    } else {
        [self showAlert];
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
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
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        
        if (detectionString != nil) {
            _label.text = @"Product Found!";
//            [self getDataFromOutPan:[NSString stringWithFormat:@"https://www.outpan.com/api/get-product.php?apikey=cbf4f07abd482df99358395a75b6340a&barcode=%@", detectionString]];
            barcodeID = detectionString;
            break;
        } else {
            _label.text = @"(none)";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                            message:@"There was a problem scanning please try again."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    
    [_session stopRunning];
}

- (void)showAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                    message:@"We have no data on this product! Submit a report to notify us about this, and we will add it to our database."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    resultsVC *vc = (resultsVC*)[mainStoryboard instantiateViewControllerWithIdentifier:@"results"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navController animated:YES completion:nil];
}

@end

NSString *organizationName;
NSString *barcodeID;
NSString *ethicsString;
NSString *productName;
