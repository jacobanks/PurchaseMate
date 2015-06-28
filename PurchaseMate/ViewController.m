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
    
    [self getDataFromOutPan:[NSString stringWithFormat:@"https://www.outpan.com/api/get-product.php?apikey=cbf4f07abd482df99358395a75b6340a&barcode=9781118692288"]];

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
    _label.font = [UIFont fontWithName:nil size:15];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"Scanning...";
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
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:12.0/255.0 green:181.0/255.0 blue:123.0/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.title = @"PurchaseMate";
    _label.text = @"Scanning...";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;

    [_session startRunning];
}

- (NSString *)getDataFromOutPan:(NSString *)urlString{
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];

    NSError *err;
    NSURLResponse *response;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request   returningResponse:&response error:&err];
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options: NSJSONReadingMutableContainers error: &err];
    
    //Sort JSON from OutPan
    id attributes = [jsonArray objectForKey:@"attributes"];
    NSDictionary *responseDictionary = attributes;
    
    if ([responseDictionary objectForKey:@"Brand"] != nil) {
        //Has Brand Attribute
        id brandName = [responseDictionary objectForKey:@"Brand"];
        NSDictionary *brandDictionary = brandName;
        
        NSError *error = nil;
        if (error) {
            NSLog(@"%@", error);
        }
        MongoConnection *dbConn = [MongoConnection connectionForServer:@"45.55.207.148" error:&error];
        MongoDBCollection *collection = [dbConn collectionWithName:@"productDB.product"];
        
        MongoKeyedPredicate *predicate = [MongoKeyedPredicate predicate];
        [predicate keyPath:@"Name" matches:brandDictionary];
        BSONDocument *resultDoc = [collection findOneWithPredicate:predicate
                                                             error:&error];
        NSDictionary *result = [BSONDecoder decodeDictionaryWithDocument:resultDoc];
        id corp = [result objectForKey:@"Corp"];
        NSDictionary *corpDictionary = corp;
        
        NSLog(@"json result %@, brand: %@", jsonArray, brandDictionary);
        
        [self getOrgIDWithURL:[NSString stringWithFormat:@"http://www.opensecrets.org/api/?method=getOrgs&org=%@&apikey=0c8623858008df89e64bb8b1d7e4ca3d", corpDictionary]];
        
    } else {
        //Doesn't have Brand Attribute
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                        message:@"We have no data on this product! Submit a report to notify us about this and add it to our database."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

        [self performSegueWithIdentifier:@"Results" sender:self];

    }
    
    return [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
}

- (NSString *)getOrgIDWithURL:(NSString *)urlstring{
    
    NSURL *URL = [[NSURL alloc] initWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSData *data = [[NSData alloc] initWithContentsOfURL:URL];
    NSError *error = nil;
    
    NSDictionary *dictionary = [XMLReader dictionaryForXMLData:data error:&error];

    id response = [dictionary objectForKey:@"response"];
    NSDictionary *responseDictionary = response;
    id organization = [responseDictionary objectForKey:@"organization"];
    NSDictionary *orgIDDict = organization;
    
    id orgID = [orgIDDict objectForKey:@"orgid"];
    id orgName = [orgIDDict objectForKey:@"orgname"];
    
    organizationName = orgName;

    [self getSummaryWithOrgName:[NSString stringWithFormat:@"http://www.opensecrets.org/api/?method=orgSummary&id=%@&apikey=0c8623858008df89e64bb8b1d7e4ca3d", orgID]];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)getSummaryWithOrgName:(NSString *)urlString {
    
    NSURL *URL = [[NSURL alloc] initWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSData *data = [[NSData alloc] initWithContentsOfURL:URL];
    NSError *error = nil;
    
    NSDictionary *dictionary = [XMLReader dictionaryForXMLData:data error:&error];

    AppDelegate *app =  (AppDelegate*)[[UIApplication sharedApplication] delegate];

    id response = [dictionary objectForKey:@"response"];
    NSDictionary *responseDictionary = response;
    id organization = [responseDictionary objectForKey:@"organization"];
    NSDictionary *summaryDict = organization;

    
    app.valuesArray = [[NSMutableArray alloc] initWithArray:[summaryDict allValues]];
    app.keysArray = [[NSMutableArray alloc] initWithArray:[summaryDict allKeys]];

    [self performSegueWithIdentifier:@"Results" sender:self];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
        
        
        if (detectionString != nil)
        {
            _label.text = @"Product Found!";
            [self getDataFromOutPan:[NSString stringWithFormat:@"https://www.outpan.com/api/get-product.php?apikey=cbf4f07abd482df99358395a75b6340a&barcode=%@", detectionString]];

            break;
        }
        else
            _label.text = @"(none)";
            NSLog(@"Didn't Scan Properly!");
        }
    
    [_session stopRunning];
}

@end

NSString *organizationName;
