//
//  ViewController.h
//  PurchaseMate
//
//  Created by Jacob Banks on 6/13/15.
//  Copyright (c) 2015 PurchaseMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ScanViewController : UIViewController

- (void)focus:(CGPoint)aPoint;
- (void)showAlert;
- (void)scanProduct:(NSString *)barcode;
- (void)toggleFlashlight:(id)sender;

@end
