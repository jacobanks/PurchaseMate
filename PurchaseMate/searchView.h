//
//  searchView.h
//  PurchaseMate
//
//  Created by Jacob Banks on 3/31/16.
//  Copyright © 2016 Jacobanks. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol searchViewDelegate <NSObject>

- (void)scanProduct:(NSString *)barcode;

@end

@interface searchView : UIView

@property(weak, nonatomic) id <searchViewDelegate> delegate;

- (void)viewTapped:(UITapGestureRecognizer *)recognizer;
- (void)searchAction;

@end
