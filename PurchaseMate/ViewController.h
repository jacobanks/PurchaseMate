//
//  ViewController.h
//  PurchaseMate
//
//  Created by Jacob Banks on 6/13/15.
//  Copyright (c) 2015 PurchaseMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

extern NSString *barcodeID;

@interface ViewController : UIViewController <UIAlertViewDelegate>

- (void)scanProduct:(NSString *)barcode;

- (void)viewTapped:(UITapGestureRecognizer *)recognizer;
- (void)loadSearchView;

- (void)focus:(CGPoint)aPoint;
- (void)showAlert;

@end

