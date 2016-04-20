//
//  searchView.m
//  PurchaseMate
//
//  Created by Jacob Banks on 3/31/16.
//  Copyright © 2016 Jacobanks. All rights reserved.
//

#import "searchView.h"
#import "ViewController.h"

@interface searchView ()

@property(strong, nonatomic) UIVisualEffectView *searchEffectView;
@property(strong, nonatomic) UITextField *barcodeTextField;

@end

@implementation searchView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        self.searchEffectView = [[UIVisualEffectView alloc] init];
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.searchEffectView.effect = blurEffect;
        } completion:nil];
        
        self.searchEffectView.frame = frame;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(viewTapped:)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
        
        [self addSubview:self.searchEffectView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.searchEffectView.center.y - 120, CGRectGetWidth(self.searchEffectView.frame), 30)];
        titleLabel.text = @"Enter a barcode number below";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        titleLabel.textColor = [UIColor whiteColor];
        [self.searchEffectView addSubview:titleLabel];
        
        self.barcodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.searchEffectView.frame) + 10, self.searchEffectView.center.y - 60, CGRectGetWidth(self.searchEffectView.frame) - 20, 40)];
        self.barcodeTextField.placeholder = @"Barcode Number";
        self.barcodeTextField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        self.barcodeTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.barcodeTextField.userInteractionEnabled = YES;
        self.barcodeTextField.tintColor = [UIColor whiteColor];
        self.barcodeTextField.textColor = [UIColor whiteColor];
        self.barcodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        [self.searchEffectView addSubview:self.barcodeTextField];
        
        UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.searchEffectView.frame) - 120, 30, 100, 30)];
        [searchButton setTitle:@"Search" forState:UIControlStateNormal];
        [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        searchButton.layer.borderColor = [UIColor whiteColor].CGColor;
        searchButton.layer.borderWidth = 2;
        searchButton.layer.cornerRadius = 5;
        [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
        [self.searchEffectView addSubview:searchButton];
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 100, 30)];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancelButton.layer.borderColor = [UIColor whiteColor].CGColor;
        cancelButton.layer.borderWidth = 2;
        cancelButton.layer.cornerRadius = 5;
        [cancelButton addTarget:self action:@selector(viewTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.searchEffectView addSubview:cancelButton];
    }
    return self;
}

- (void)searchAction {
    if ([self.barcodeTextField.text length] > 0 && self.barcodeTextField.text != nil && [self.barcodeTextField.text isEqual:@""] == FALSE) {
        [self viewTapped:nil];
        
        [_delegate scanProduct:self.barcodeTextField.text];

    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                        message:@"You need to fill out the barcode field first!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)viewTapped:(UITapGestureRecognizer *)recognizer {
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 0;
    }completion:^(BOOL isFinished){
        [self removeFromSuperview];
    }];
}

@end
